function [ lags cch peak] = util_calc_raw_spont_cch( varargin )
%UTIL_CALC_RAW_SPONT_CCH ���ߺ�������SPIF�м����Է�������ֱ��ͼ��Raw��
%   �Ӹ���SPIF�ṹ���м��������缫֮�������ԣ�����ʱû��ʹ�ø���correct��������rawֱ��ͼ��
%   ���������
%               'spif'  spif�ṹ�壬�������
%               'ref'   �ο��缫���������
%               'obs'   �۲�缫���������
%               'bin'   bin�ĳ��ȣ���λms��Ĭ��10 ms
%               'nlag'  ʹ��histc����ʱ���������򳤶ȣ���λms��Ĭ��500 ms������Գƣ�
%               'startend'      Ҫ������źż�¼ʱ�䷶Χ����λms��Ĭ��ȫ��
%               'verbose'       �Ƿ���ʾ���������ϸ����Ϣ��Ĭ�ϲ���ʾ
%               'findpeakw'     �Ƿ񷵻ط�ֵ��ȣ�Ĭ�Ϸ��أ����������򷵻�0��������Լ���bin���ر���10ms bin�ȽϿɿ���
%               'normalization' ʹ��histc����ʱ�Ĺ�һ������Ĭ��Ϊ���ʣ�'prob'����prob���ܵ��²��Գ�����
%                   'counts_bin'    ÿ��bin���ж���count
%                   'prob'          counts_bin����ref��counts����ִ�������Ĺ�һ������[0 1]��
%               'method'        ���㷽����
%                   'histc'     ʹ��histc����[default]��ע�⣬ʹ���������ʱ����һ��֮��ᵼ��ʧȥ�ϸ�ĶԳ��ԣ�46/47��peakֵ��47/46�Ĳ�һ������������״��һ���ģ�
%                   'xcorr'     ʹ��xcorr���㣬��ʱnormalization�Զ���һ����[0 1]������������������ٶȽ�����
%                   'migram'    ʹ��migram���㻥��Ϣ����ʱnormalization�Զ���һ����[0 1]���������������Ҳ���ٶ�����
%                   'corrgram'  ʹ��corrgram���㻥��أ���ʱ��һ�����������һ�������[0 1]���ٶ�����
%                   'mi'        ʹ��nmi���㻥��Ϣ����ֱ��ͼ��ֻ��һ��ֵ������ѡ���һ��[0 1]���ٶȿ졣
%                   �ٶȣ�mi > histc > xcorr > corrgram > migram
%   ���ز�����
%               'lags'  x�ᣬbin�ֲ�
%               'cch'   y�ᣬֱ��ͼ
%               'peak'  ��ֵ�ṹ��
%                       .value Peakֵ
%                       .position ��ֵ��λ�ã���λms��
%                       .width ��Ŀ�ȣ���λms��
%                       �������в���ԭ����ο�findpeaks��������С������Ϸ���
%
% Eg.
% [d spif trif] = util_load_spike_trigger_mcdstream('isCompact',1);
% list = [ 12 13 14 15 16 17 ];
% for i = 1:length(list)
%     [lags cch] = util_calc_raw_spont_cch('spif',spif,'ref',21,'obs',list(i),'bin',10);
%     subplot(1,length(list)+1,i),plot(lags,cch),ylim([0 1]),axis off;
% end
% subplot(1,length(list)+1,length(list)+1),plot((-500:500:500),0),hold on,stem(0,1),ylim([0 1]);axis off
%
%   �ѽ��� 2010��3��22��
%       ��ɼ��㻥��صĻ����߼���startendδʵ�֣�
%   �ѽ��� 2010��3��23��
%       ���Startend�����ı�д����ɷ�ֵ.value,.position�ı�д�������δʵ�֣�
%   �ѽ��� 2010��3��24��
%       ʵ�ֶԻ���ط��׼ȷ���㣨����findpeaks���������޸���ʾ�������ã��޸����������п��ܳ��ֵ�Bug
%   �ѽ��� 2011��3��27��
%       ������ʹ��xcorr����ķ�ʽ��ȫ����������������߼����Ľ���peak
%       width�������߼����޸��˸���Bug���ر���ʵ���˶ԳƵĻ��������
%   �ѽ��� 2011��3��28��
%       ������ʹ��migram/corrgram����.
%       �޸�window_max/minΪnlag��ʹ��������������ʽͳһ��

% �����������
pvpmod(varargin);

if ~exist('spif', 'var')
    error('SPIF must be provided.');
end

if ~exist('ref', 'var')
    error('Reference Electrode # must be provided.');
end

if ~exist('obs', 'var')
    error('Observing Electrode # must be provided.');
end

if ~exist('bin', 'var')
    bin = 10;
end

if ~exist('nlag', 'var')
    nlag = 500;
end

if ~exist('startend', 'var')
    start_time = spif.startend(1);
    stop_time = spif.startend(2);
else
    if startend(1) < spif.startend(1) || startend(1) >= startend(2)
        start_time = spif.startend(1);
    end
    if startend(2) > spif.startend(2) || startend(2) <= startend(1)
        stop_time = spif.startend(2);
    end
end

if ~exist('verbose', 'var')
    verbose = 0;
end

if ~exist('findpeakw', 'var')
    findpeakw = 1;
end

if ~exist('normalization', 'var')
    normalization = 'prob';
end

if ~exist('method', 'var')
    method = 'histc';
end

% ��ʾ��������
if verbose
    cprintf('Comments', ['Bin width = ' num2str(bin) ' ms\n']);
    cprintf('Comments', ['Reference electrode# = ' num2str(ref) '\n']);
    cprintf('Comments', ['Observing electrode# = ' num2str(obs) '\n']);
    cprintf('Comments', ['Range from ' num2str(-1*nlag) ' to ' num2str(nlag) ' ms\n']);
end

% ����Spiketime Table�ĸ���
ref_times = spif.spiketimes{util_convert_ch2hw(ref)};
obs_times = spif.spiketimes{util_convert_ch2hw(obs)};

% ����ָ����ʱ�䳤�ȴ���Spiketime Table���Ѳ���ָ��ʱ�䳤�ȷ�Χ�ڵ�ɾ����
ref_times(ref_times < start_time | ref_times > stop_time) = [];
obs_times(obs_times < start_time | obs_times > stop_time) = [];

% ��ȡ�������еĳ���
ref_num = size(ref_times,1);
obs_num = size(obs_times,1);

if strcmpi(method, 'histc')
    % ��ʼ�������ֱ��ͼ���ս������
    % ��ʼ��lags
    lags = -1 * nlag : bin : nlag;
    
    if isempty(find(lags==0, 1))
        error('You may want to choose another bin or window range to correctly place 0.');
    end
    
    % ��ʼ��cch
    cch = zeros(length(lags),1);
    
    % ����
    for i = 1:ref_num
        % �ù۲�缫ÿ��spike������ʱ�̼�ȥ��i���ο��缫spike
        difference = obs_times - ref_times(i);      % in ms
        
        % ����ֵ���㵽ÿ��bin��
        i_bin = histc(difference, lags);
        
        % �ۼ�
        try
            cch = cch + i_bin;
        catch ME
            if obs_num == 1
                cch = cch + i_bin';
            else
                rethrow(ME)
            end
            
        end
    end
    
    % ����������
    if strcmp(normalization,'prob')
        cch = cch / ref_num;
    end
elseif strcmpi(method, 'xcorr')
    % In this mode:
    % Bin is set by histc
    % Normalization is performed by xcorr 'coeff'
    % ע�⣬xcorr�����Ƚ�����~7��������������Ĳ����Ǵ������Ƶģ�bin=10����maxֵ��ͬ
    
    % ��ʼ��lags
    lags = -1 * nlag : bin : nlag;
   
    if isempty(find(lags==0, 1))
        error('You may want to choose another bin or window range to correctly place 0.');
    end
    
    if ref ~= obs
        % �����
        [cch lags] = xcorr(histc(obs_times, start_time:bin:stop_time), histc(ref_times, start_time:bin:stop_time), nlag/bin, 'coeff');
    else
        % �����
        [cch lags] = xcorr(histc(obs_times, start_time:bin:stop_time), nlag/bin, 'coeff');
    end
    % ����lags
    lags = lags * bin;
elseif strcmpi(method, 'migram')
    % In this mode:
    % Bin is set by histc
    % Normalization is performed by migram 'norm'
    % ע�⣬mi����Ҳ�Ƚ�������xcorr������Ҳ�ǶԳƵġ�
    
    % ��ʼ��lags
    lags = -1 * nlag : bin : nlag;
    num_bins = length(lags);
    window_length = length(start_time:bin:stop_time);
    
    if isempty(find(lags==0, 1))
        error('You may want to choose another bin or window range to correctly place 0.');
    end
    
    [cch lags] = migram(histc(obs_times, start_time:bin:stop_time), histc(ref_times, start_time:bin:stop_time), nlag/bin, window_length, 0, num_bins/bin, 'norm');
    % ����lags
    lags = lags * bin;
elseif strcmpi(method, 'corrgram')
    % In this mode:
    % Bin is set by histc
    % Normalization is performed by migram 'norm'
    % ע�⣬mi����Ҳ�Ƚ�������xcorr������Ҳ�ǶԳƵġ�
    
    % ��ʼ��lags
    lags = -1 * nlag : bin : nlag;
    window_length = length(start_time:bin:stop_time);
    
    if isempty(find(lags==0, 1))
        error('You may want to choose another bin or window range to correctly place 0.');
    end
    
    [cch lags] = corrgram(histc(obs_times, start_time:bin:stop_time), histc(ref_times, start_time:bin:stop_time), nlag/bin, window_length, 0);
    % ����lags
    lags = lags * bin;
elseif strcmpi(method, 'mi')
    % In this mode:
    % Bin is set by histc
    % Normalization is performed by default.(you can use MI.m for non-normalized result)
    % ע�⣬û��ֱ��ͼ�Ľ�������Բ��ܲ���peakλ�úͿ��
    
    if strcmp(normalization,'prob')
        cch = nmi(histc(obs_times, start_time:bin:stop_time), histc(ref_times, start_time:bin:stop_time));
    else
        cch = MI(histc(obs_times, start_time:bin:stop_time), histc(ref_times, start_time:bin:stop_time));
    end
    
    lags = 0;
    % ��֧��peak width
    findpeakw = 0;
else
    error('wrong input: method');
end


% ��ֵ����
% ��ֵ
peak.value = max(cch);

% ��ֵλ��
peak.position = lags(cch == peak.value);
if length(peak.position) > 1
    if verbose
        cprintf('Red', '>= 2 peaks deteced, please recheck the result if needed.\n');
    end
    peak.width = 0;
    return;
end

% �������

% ���û�ָ�������ҷ��ȣ��������Ӻ�ʱ������ֱ�ӷ���
if ~findpeakw
    peak.width = 0;
    return;
end

fitwidth = 3;

while 1
    % ����Ѱ�Һ��ʵķ�ֵ
    P = findpeaks(lags, cch, 0, max(cch) / 10, 3, fitwidth);
    if (isnan(P(1)) || P(1) == 0 || isempty(P))
        % fitwidthȡֵ������
        if fitwidth <= window_max - window_min
            fitwidth = fitwidth + 1;
            continue;
        else
            if verbose
                cprintf('Red', 'Peak width error. Set to 0. \n');
            end
            peak.width = 0;
            break;
        end
    else
        % ��P��������P�������Ƿ����֮ǰ���ֵ�peak��ֵλ��
        p = find(P(:,2) == peak.position);
        if p
            % ����һ�µ�peakλ�ã��򷵻ض�Ӧ�ķ��
            r = P(:,4);
            if isnan(r(p)) || r(p) <= 0
                % ��Ȼλ�öԣ������ҵķ����
                % ������
                if fitwidth <= window_max - window_min
                    fitwidth = fitwidth + 1;
                    continue;
                else
                    if verbose
                        cprintf('Red', 'Peak width error. Set to 0. \n');
                    end
                    peak.width = 0;
                    break;
                end
            else
                % �������ֵ
                peak.width = r(p);
                break;
            end
        else
            % û��׼ȷһ�µ�peak��ֵλ��
            if fitwidth <= window_max - window_min
                fitwidth = fitwidth + 1;
                continue;
            else
                if verbose
                    cprintf('Red', 'Peak width error. Set to 0. \n');
                end
                peak.width = 0;
                break;
            end
        end
    end
end

end

