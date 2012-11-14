function [ timing timing_std timing_all amp amp_std amp_all ] = util_ps_first_response_spike_profile( triggerif, ...
    spif, ...
    D, ...
    chid, ...
    trigger_range, ...
    isManualTrigger, ...
    peakType)
%UTIL_PS_FIRST_RESPONSE_SPIKE_PROFILE ���ߺ���������̼����һ����ӦSpike��λ�úͷ���
%   �ڸ���trigger_range�У���ȡ��Ӧ���һ��Spike��Timing/Amplitude�����ؾ�ֵ��STD
%   triggerif = trigger information from mcd file
%   spif = spike information from mcd file
%   D = datastrm��õĶ���
%   chid = 11-88ͨ����
%   trigger_range = [start end] Trigger˳��ķ�Χ
%   isManualTrigger = �Ƿ����ֶ����Trigger���ֶ�Trigger���ܻ����Trigger����ΪSpike��+/- 0.5 ms��
%   peakType = �����Ǽ�¼��Сֵ(0)�����ֵ(1)����-��ֵ(2)��

%   timing = ��Trigger����Ϊ0��������һ��Spike�ķ���ʱ��ľ�ֵ��ʱ�䵥λΪms
%   timing_std = STDEV of timing
%   timing_all = ȫ���ĵ�һ��Spike�ķ���ʱ��Ķ���
%   amp = Trigger���һ��Spike�ķ��ȵľ�ֵ
%   amp_std = STDEV of amplitude
%   amp_all = ȫ���ĵ�һ��Spike�ķ���ֵ�Ķ���

%   ʾ����
%   [timing timstd timall amp ampstd ampall] = util_ps_first_response_spike_profile(triggerif,spif,D,34,[1 200],1,2);
%   �����1-200��Trigger��Trigger���һ��Spike��ͳ����Ϣ��ͨ��34����ֻ����Trigger��0.5ms������Spike�����ֵ����
%   
%   �ѽ��� 2009��6��1��


% ͨ�����ת��
hwid = util_convert_ch2hw(chid);

% ����˼·
% ��ָ����Trigger��Χ��ѭ�����ҵ�ÿ��Trigger��ĵ�һ��Spike
% ������ЩSpike��Timging��Amplitude�ľ�ֵ�ͱ�׼��

% Ϊ��������ٶȣ�Ԥ�ȴ���FORѭ���з����õı���
this_spif_spiketime = spif.spiketimes{hwid}; % ����PSTHͨ����SPIF��Ϣ���Ʊ�
this_spif_spikevalue = ad2muvolt( D, spif.spikevalues{hwid} ); % SPIKETIME��Ϣ����

timing_all = [];
amp_all = [];

% ��Trigger�б���
for i = trigger_range(1):trigger_range(2)
    % ���ÿ��Trigger�ľ���ʱ��
    this_trigger_time = triggerif.times(i);
    
    % ��Ϊ�ֶ����Trigger��������Ҫһ���ӳٵ������
    % �򽫿�ʼɨ���ʱ���ӳ�0.5 ms
    if isManualTrigger
        start_point = this_trigger_time + 0.5;
    else
        start_point = this_trigger_time;
    end
    
    % ��start_point����ĵ�һ��spiketime���ǵ�һ��spike������ʱ��
    % �����ҵ�һ����start_point������spike��timing
    first_spike_timing = this_spif_spiketime( this_spif_spiketime > start_point );
    % ֻȡ��һ��
    first_spike_timing = first_spike_timing(1);
    % find���ص�һ�������������±꣬�������������
    indexer = find( this_spif_spiketime > start_point, 1 );
    
    % ����Spike����ֵ
    switch(peakType)
        case 0
            % MIN
            first_spike_amplitude = min( this_spif_spikevalue( :,indexer ) );
        case 1
            % MAX
            first_spike_amplitude = max( this_spif_spikevalue( :,indexer ) );
        case 2
            % Peak to Peak
            first_spike_amplitude = max( this_spif_spikevalue( :,indexer ) ) -...
                min( this_spif_spikevalue(indexer) );
    end
    
    % ������Trigger����Ϣ������Ϣ��(����Timing����Ϣ��Ҫ��ȥTrigger������ʱ��)
    timing_all = [timing_all (first_spike_timing - this_trigger_time)];
    amp_all = [amp_all first_spike_amplitude];
end

timing = mean( timing_all );
timing_std = std( timing_all );
amp = mean( amp_all );
amp_std = std( amp_all );

end

