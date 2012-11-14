function [ ax_x result ] = util_psth_amplitude_by_trigger( triggerif, ...
                                            spif, ...
                                            D, ...
                                            chid, ...
                                            binsize, ...
                                            timescope, ...
                                            trigger_range, ...
                                            isManualTrigger, ...
                                            isNormalized, ...
                                            peakType)
%UTIL_PSTH_AMPLITUDE_BY_TRIGGER ���ߺ���������MCS����Ϣ������PS��Spike���ȷֲ�
%   triggerif = trigger information from mcd file
%   spif = spike information from mcd file
%   D = datastrm��õĶ���
%   binsize = bin width of each histogram in millisecond
%   timescope = [start end], of the time scope of counting spikes
%   trigger_range = [start end], triggers counts into the psth
%   isManualTrigger = �Ƿ����ֶ����Trigger���ֶ�Trigger���ܻ����Trigger����ΪSpike
%   isNormalized = �Ƿ��һ�����������һ��������Counts/Bin�����������һ���Ļ���
%                  �õ��㷨��NEX��һ���ģ�Nex�ǳ���Trigger����Ŀ����һ�ġ�
%   peakType = �����Ǽ�¼��Сֵ(0)�����ֵ(1)����-��ֵ(2)��
%   ax_x = X������
%   result = Yֵ
%   
%   ʾ����
%   [a b] = util_psth_amplitude_by_trigger( triggerif,spif,D,34,5,[-50 450],[41 60],1,1,0 )
%   �Ǽ���ͨ��34�ϣ�Triggerǰ��-50,450���Spike�ķ��ȷֲ�������Trigger�ķ�Χ
%   �ǵ�1-20��Trigger������Triggerǰ��0.5 ms���ֶ���Trigger��α��Ϣ��
%   ����Ϣ������һ�������ʱ��ÿ5 uVһ��bin
%
%   �ѽ��� - 2009��5��20��

% ͨ�����ת��
hwid = util_convert_ch2hw(chid);

% Ϊ��������ٶȣ�Ԥ�ȴ���FORѭ���з����õı���
this_spif_spiketime = spif.spiketimes{hwid}; % ����PSTHͨ����SPIF��Ϣ���Ʊ�
this_spif_spikevalue = ad2muvolt( D, spif.spikevalues{hwid} ); % SPIKETIME��Ϣ����
result_pre = []; % ���ڽ�����Trigger����Ϣ�����ӡ�

for i = trigger_range(1):trigger_range(2)
    % �ڸ�����Trigger�б���
    this_trigger_time = triggerif.times(i); % ÿ��Trigger�ľ���ʱ��
    
    % ��SPIF��Ѱ���ڸ���Trigger��Χtimescope��Χ�ڵ�Spike�ķ��ȣ�����ֱ��ͼͳ��
        
    % �����ҵ���Trigger��Χ(timescope)�ڵ�ʱ���
    this_before = this_trigger_time + timescope(1); % Triggerǰ���ʵ��ʱ��λ��
    this_after = this_trigger_time + timescope(2);
    
    if isManualTrigger
        % ��Spike�����ھ���Trigger�ܽ���ʱ��Σ���Ϊ�Ǽ��ź�(0.5 ms�ڶ�����)
        Condition_Manual_Trigger_Before = this_trigger_time - 0.5;
        Condition_Manual_Trigger_After = this_trigger_time + 0.5;
    else
        Condition_Manual_Trigger_Before = this_trigger_time;
        Condition_Manual_Trigger_After = this_trigger_time;
    end
    
    % ����SpikeTime�У���Trigger��Χ�ڵ�Spikeʱ�̵��λ�ã���������
    % SpikeValue�Ķ�Ӧ��Spikeʱ���ڵķ��ȵ��ƶ�ֵ
    
    switch(peakType)
        case 0
            % ���㷢����Trigger��Χ�ڵĸ���Spike����Сֵ
            amplitudes = min( ...
                this_spif_spikevalue( :, ...
                (this_spif_spiketime >= this_before & this_spif_spiketime < Condition_Manual_Trigger_Before) ...
                | (this_spif_spiketime <= this_after & this_spif_spiketime > Condition_Manual_Trigger_After) ) ...
            );
        case 1
            % ���㷢����Trigger��Χ�ڵĸ���Spike�����ֵ
            amplitudes = max( ...
                this_spif_spikevalue( :, ...
                (this_spif_spiketime >= this_before & this_spif_spiketime < Condition_Manual_Trigger_Before) ...
                | (this_spif_spiketime <= this_after & this_spif_spiketime > Condition_Manual_Trigger_After) ) ...
            );
        case 2
            % ���㷢����Trigger��Χ�ڵĸ���Spike�����ֵ-��Сֵ(���ֵ)
            amplitudes = max( ...
                this_spif_spikevalue( :, ...
                (this_spif_spiketime >= this_before & this_spif_spiketime < Condition_Manual_Trigger_Before) ...
                | (this_spif_spiketime <= this_after & this_spif_spiketime > Condition_Manual_Trigger_After) ) ...
            ) - min( ...
                this_spif_spikevalue( :, ...
                (this_spif_spiketime >= this_before & this_spif_spiketime < Condition_Manual_Trigger_Before) ...
                | (this_spif_spiketime <= this_after & this_spif_spiketime > Condition_Manual_Trigger_After) ) ...
            );
    end
    
    if ~isempty(amplitudes)
        % ��������ӳ�һ������
        if size(amplitudes,1) <= size(amplitudes,2)
            result_pre = [result_pre amplitudes];
        else
            result_pre = [result_pre amplitudes'];
        end
    end
end

% ���㿪ʼ����ֹͳ�Ƶķ�������
edges = min(result_pre) : binsize : max(result_pre);

% ����ax_x����X�������ϵ
ax_x = edges;

result = histc(result_pre,edges);

% �Ƿ��һ��
if isNormalized
    result = result / (trigger_range(2) - trigger_range(1) + 1);
end

end

