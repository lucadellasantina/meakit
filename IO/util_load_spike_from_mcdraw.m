function [ D spif raw] = util_load_spike_from_mcdraw ( varargin )
%UTIL_LOAD_SPIKE_FROM_MCDRAW ���ߺ�������mcd�ļ��м��Spike
%   ���������
%       filename = Ҫ������ļ�����Ĭ����
%       segment_size = ���Ҫ�ֶδ���ÿ�εĳ��ȣ�ms����Ĭ��60000
%       startend = [start end] ��ֹʱ�䣬Ĭ����ȫ�̣���λ��ms
%       gnd = [15 16 ...]���ӵص缫���룬Ĭ����15
%       threshold = n��n��STD��Spike��ȡ����ֵ��Ĭ���ǣ�
%       threshold_sample_startend = [start end] ms������STD��ʱ�䷶Χ��Ĭ����segment_size
%       PLP = n ms��Spike�ķ��Ĭ����2 ms
%       RP = n ms��Spike��ȡ�Ĳ�Ӧ�ڣ�Ĭ����1 ms
%       NPA����ѡ����壬����ѡ��������ֵ�壨�����������򣩣�Ĭ��true��ѡ�����
%   ���������
%       D���ļ�����
%       spif��Spike��Ϣ�ṹ��
%       raw����ѡ������Ҫraw����ʱ�ɷ��ء�ע�⣬���ݹ���ʱ��Out of Memory.
%
%   �ѽ��� - 2010��5��21��

pvpmod(varargin);

% ��������

if nargout == 3
    needraw = true;
end

if exist('filename', 'var')
    [~] = evalc('D = datastrm(filename)');
else
    [~] = evalc('D = datastrm(''open'')');
end

if isempty(D)
    error('A MCD file must be selected.');
end

if exist('segment_size', 'var')
    limited_size = segment_size;
else
    limited_size = 60000; % 1min
end

if ~exist('gnd', 'var')
    gnd = 15;
end

if ~exist('threshold', 'var')
    threshold = 10;
end

if ~exist('PLP', 'var')
    PLP = 2;
end

if ~exist('RP', 'var')
    RP = 1;
end

if ~exist('NPA', 'var')
    NPA = true;
end

% ��ֹʱ��
if exist('startend', 'var')
    start_time = startend(1); % *1000
    stop_time = startend(2); % *1000
    if start_time < getfield(D, 'sweepStartTime')
        warning('UTIL:SPIKEDET', 'Start time must be bigger than sweepStartTime, is automatically set to sweepStartTime.');
        start_time = getfield(D, 'sweepStartTime');
    end
    if stop_time > getfield(D, 'sweepStopTime');
        warning('UTIL:SPIKEDET', 'Stop time must be smaller than sweepStopTime, is automatically set to sweepStopTime.');
        stop_time = getfield(D, 'sweepStopTime');
    end
else
    start_time = getfield(D, 'sweepStartTime');
    stop_time = getfield(D, 'sweepStopTime');
end

% STD������ֹʱ��
if exist('threshold_sample_startend', 'var')
    thsample_start_time = threshold_sample_startend(1);
    thsample_end_time = threshold_sample_startend(2);
    if thsample_start_time < start_time
        warning('UTIL:SPIKEDET', 'Threshold sampling start time must be bigger than start time, is automatically set to start time.');
        thsample_start_time = start_time;
    end
    if thsample_end_time > end_time
        warning('UTIL:SPIKEDET', 'Threshold sampling end time must be smaller than start time, is automatically set to end time.');
        thsample_end_time = end_time;
    end
else
    thsample_start_time = start_time;
    thsample_end_time = end_time;
end

% ��ʾ�ļ���Ϣ
disp(['Start:' datestr(getfield(D, 'recordingdate')) ', Stop: '  datestr(getfield(D, 'recordingdate')) ', Length: ' num2str(getfield(D, 'sweepStopTime')) ' ms.']);

% ��ʾ��ȡSpike�Ĳ�����Ϣ
disp(['Threshold = ' num2str(threshold) ' * STD; STD Sampling = [' num2str(thsample_start_time) ' ' num2str(thsample_start_time) '] ms.' ]);
disp(['PLP = ' num2str(PLP) 'ms, RP = ' num2str(RP) 'ms.']);
if NPA
    disp('Only negative peak is detected.');
else
    disp('Both positive and negative peak can be detected.');
end

% ����ʵ�ʴ�����
% ��ȡʱ��ֱ���
timeres = getfield(d,'MicrosecondsPerTick');

% ��ʱ���msת��Ϊ���ݵ�
PLP = util_convert_ms2dp(PLP, timeres);
RP = util_convert_ms2dp(RP, timeres);

% ��������ֹʱ���ms��ʱ��λ��ת��Ϊ���ݵ�λ��
thsample_start_time = util_locate_index_by_millisecond(thsample_start_time, timeres, 0);
thsample_end_time = util_locate_index_by_millisecond(thsample_end_time, timeres, 0);

% ��ȡ������
% �ҵ�Raw������
[stream_number raw_streamname] = util_find_rawstream(D);
if stream_number < 1
    error('û��Raw������');
elseif stream_number > 1
    % �ж���һ����Raw������
    % �г�Raw�����������ƣ����û�ѡ��
    for i = 1:stream_number
        disp(raw_streamname{i});
    end
    user_entry = input('��������Ҫ�������ţ�');
    
    raw_streamname_selected = raw_streamname{user_entry};
else
    raw_streamname_selected = raw_streamname{1};
end

% ���ˣ������Raw�����������֣�������raw_streamname_selected��

% ��ȡRaw��Ϣ

if (stop_time - start_time) > limited_size;
    % ̫�����ֶζ�ȡ��ƴ��
    
    % ����RAW����������
    h = waitbar(100, 'Processing RAW data...');
    
    % �������ڴ�����ս����SPIF�ṹ�壬cell����Χ��{}����Ҫ��ȥ�������
    spif = struct('spiketimes', {cell(64,1)}, 'spikevalues', {cell(64,1)}, 'startend', [start_time stop_time]);
    
    % ����ѭ��������������limited_size�����ģ�
    for i = start_time:limited_size:stop_time
        spif_segment = nextdata(D, 'streamname', spike_streamname_selected, 'startend', [i i+limited_size]);
        spif.spiketimes = util_connect_spif_spiketimes(spif.spiketimes, spif_segment.spiketimes);
        % ���ָ����compact���������ѹ��spikevalue��        
        if (isCompact)
            spif_segment.spikevalues = util_compact_spif_spikevalues(spif_segment.spikevalues);
        end
        spif.spikevalues = util_connect_spif_spikevalues(spif.spikevalues, spif_segment.spikevalues);
        
        waitbar(i/(stop_time - start_time), h, ['Processed SPIF: ' num2str(fix(i/1000/60)) ' minutes']);
        clear spif_segment;
    end
    close(h);
    
    % BUGFIX
    % ����Ҫ����ʣ�ಿ�ֵģ���Ϊ�����һ��i���棬��Ȼi+limited_size��>stop_time�ģ�����nextdata���Զ���
    % ��stoptimeΪֹ��������ʣ�ಿ����һ������
    % �������Ĳ���
    % spif_segment = nextdata(D, 'streamname', spike_streamname_selected, 'startend', [i stop_time]);
    % spif.spiketimes = util_connect_spif_spiketimes(spif.spiketimes, spif_segment.spiketimes);
    % ���ָ����compact���������ѹ��spikevalue�����ಿ�֣�        
    % if (isCompact)
    %    spif_segment.spikevalues = util_compact_spif_spikevalues(spif_segment.spikevalues);
    % end
    % spif.spikevalues = util_connect_spif_spikevalues(spif.spikevalues, spif_segment.spikevalues);
else
    % ������ȡ
    
    % ���RAW��Ϣ
    rawif = nextdata(D,'streamname', raw_streamname_selected,'startend',[start_time stop_time]);

    % ѭ��ÿ��ͨ��
    for hwid = 1:64
        % �ж��Ƿ����ڲ���Ҫ����ĵ缫
        if ~util_find_a_in_b( util_convert_hw2ch(hwid), [11 18 81 88 gnd] )
            % ��ȡSPIKE
            [spv, spt]= SpkDet_PTSD_SA(rawif.data(hwid,:)', threshold * std(y(thsample_start_time:thsample_end_time)), PLP, RP, NPA);
        
        end
    end
    
    
end

% ��ʾSpike�ĸ���
disp(['Total Spikes']);

end

