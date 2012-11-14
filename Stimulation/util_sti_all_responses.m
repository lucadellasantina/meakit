function [ elecs responses_timing responses_amplitude ] = util_sti_all_responses( varargin )
%UTIL_STI_ALL_RESPONSES ���ߺ�������ȡ�̼���ָ��ʱ�䴰�����е缫����Ӧ
%   ��ȡ�̼���ȫ�����ͨ����ָ��ʱ�䴰�ڵ���Ӧʱ���
%
%   ���������
%       d, mcd�ļ���
%       spif��trif MCD�ļ���Ϣ��by mcsfile loader��
%       window��Ĭ����[5 20] ms
%       stipro���̼���������һ��Ҫ������û�У��򲻻���֤�̼�������MCD�ļ�Trigger����һ���ԣ�
%       isManualTrigger���Ƿ��ֶ���ȡ��Trigger(Triggerʱ�̵�+/- 0.5 ms�Ĳ���)��Ĭ��0
%   ���������
%       elec����Ӧ�����response����ĵ缫�ֲ�
%       responses������ͨ����ÿ��ĳchid�缫�̼������ӦSpike���ֵ�ʱ���(timing)�ͷ��ֵ��amplitude��
%       ���磬elec = [11 22 33]����response cell����ĵ�1����11�缫�ϵ���Ӧ��
%
%   Eg��
%   [elecs responses amplitudes] = util_sti_all_responses('spif', spif,
%   'trif', trif, 'window', [5 200],'isManualTrigger', 0, 'd',d);
%
%   �ѽ��� 2010��5��4��

pvpmod(varargin);

% ������

if ~exist('d', 'var')
    error('D - MCD fileobject must be provided.');
end

if ~exist('spif', 'var')
    error('SPIF must be provided.');
end

if ~exist('trif', 'var')
    error('TRIF must be provided.');
end

if ~exist('stipro', 'var')
    disp('STIPRO not provided.');
    stipro = [];
end

% ����windowĬ��
if ~exist('window', 'var')
    window = [5 20];
end

% ����ManualTriggerĬ��
if ~exist('isManualTrigger', 'var')
    isManualTrigger = 0;
end

% ��ȡTrigger��Ŀ
num_trigger = length(trif.times);

if (~isempty(stipro))
    % ���̼������еĴ̼�������Trigger��Ŀ�����ϣ����������
    [num_sti, ~, ~, ~, ~, ~, time_s] = util_parse_para_fromstimulation(stipro);
    if(num_sti ~= num_trigger)
        warning('NUM_STI ~= NUM_TRIGGER!');
    end
end

h = waitbar(0, 'Please wait...');
set(h, 'Name', 'Please wait while processing triggers')

% ��Trigger��ѭ�������̼����ָ��ʱ�䴰���ڵ���Ӧʱ�̵��¼������Trigger������ͨ����
elecs = zeros(1,64);
responses_timing = cell(1,64);
responses_amplitude = cell(1,64);
for channel = 1:64
    elecs(channel) = util_convert_hw2ch(channel);
    % Ϊ��������ٶȣ�Ԥ�ȴ���FORѭ���з����õı���
    this_spiketime = spif.spiketimes{channel};
    this_spikevalue = ad2muvolt(d, spif.spikevalues{channel});
    % ��ʼ���������
    responses_timing{channel} = cell(1,num_trigger);
    responses_amplitude{channel} = cell(1,num_trigger);
    for trigger = 1:num_trigger
        % ÿ��Trigger�ľ���ʱ��
        this_trigger_time = trif.times(trigger);
        
        % ��SPIF���ڸ���Triggerʱ�䷶Χ�ڵ�Spike��Timing��ת������Trigger��Ϊ�ο�ϵ��ʱ���
        % �����ҵ���Trigger��Χ(timescope)�ڵ�ʱ���
        this_before = this_trigger_time + window(1);
        this_after = this_trigger_time + window(2);
        
        % ����ɨ������
        this_scanrange = this_spiketime(this_spiketime >= this_before & this_spiketime <= this_after);
        this_scanrange_amplitude = ...
            max(this_spikevalue(:,this_spiketime >= this_before & this_spiketime <= this_after)) ...
            - ...
            min(this_spikevalue(:,this_spiketime >= this_before & this_spiketime <= this_after));

        % ��ʱ��ת��Ϊ��Trigger����ʱ��Ϊԭ���ʱ��
        this_scanrange = this_scanrange - this_trigger_time;
        
        % �ų�Manual Trigger(+/- 0.5 ms)
        if (isManualTrigger)
            this_scanrange(abs(this_scanrange) <= 0.5) = [];
            this_scanrange_amplitude(abs(this_scanrange) <= 0.5) = [];
        end
        
        % ��������浽�ܱ�
        % ����timing��Ϣ
        responses_timing{channel}{trigger} = this_scanrange;
        % ����amplitude��Ϣ
        responses_amplitude{channel}{trigger} = this_scanrange_amplitude;
    end
    waitbar(channel/64, h, ['Channel ' num2str(channel) ' (#' num2str(elecs(channel)) ') of 64 finished.']);
end

close(h);

end


