function [ ax_x result ] = util_psth_by_trigger( triggerif, ...
                                            spif, ...
                                            chid, ...
                                            binsize, ...
                                            timescope, ...
                                            trigger_range, ...
                                            isManualTrigger, ...
                                            isNormalized)
%UTIL_PSTH_BY_TRIGGER ���ߺ���������MCS����Ϣ������PSTH
%   triggerif = trigger information from mcd file
%   spif = spike information from mcd file
%   binsize = bin width of each histogram in millisecond
%   timescope = [start end], of the time scope of counting spikes
%   trigger_range = [start end], triggers counts into the psth
%   isManualTrigger = �Ƿ����ֶ����Trigger���ֶ�Trigger���ܻ����Trigger����ΪSpike
%   isNormalized = �Ƿ��һ�����������һ��������Counts/Bin�����������һ���Ļ���
%                  �õ��㷨��NEX��һ���ģ�Nex�ǳ���Trigger����Ŀ����һ�ġ�
%   ax_x = X������
%   result = Yֵ
%   
%   ʾ����
%   [x y] = util_psth_by_trigger(triggerif,spif,87,5,[-50 450],[1 20],1,1)
%   �Ǽ���ͨ��87�ϣ�ÿ5msһ��bin��Triggerǰ��-50,450���psth������Trigger�ķ�Χ
%   �ǵ�1-20��Trigger�����Trigger�Ǻ���Triggerǰ��0.5 ms���ֶ���Trigger��α��Ϣ��
%   ����Ϣ������һ����
%
%   �ѽ��� 2009��5��

% ͨ�����ת��
hwid = util_convert_ch2hw(chid);

% ���㿪ʼ����ֹͳ�Ƶ�ʱ�����䣬Ҫע�⣬������ʱ������������ܹ�����0���
firstbin = timescope(1);
lastbin = timescope(2);
edges = firstbin : binsize : lastbin;

% ����ax_x����X�������ϵ
ax_x = edges;

% ���ʱ���������Ƿ����0��
if isempty(find(edges==0, 1))
    error('Zero must be contained in the time scope.');
end

% Ϊ��������ٶȣ�Ԥ�ȴ���FORѭ���з����õı���
this_spif_spiketime = spif.spiketimes{hwid}; % ����PSTHͨ����SPIF��Ϣ���Ʊ�
result_pre = []; % ���ڽ�����Trigger����Ϣ�����ӡ�

for i = trigger_range(1):trigger_range(2)
    % �ڸ�����Trigger�б���
    this_trigger_time = triggerif.times(i); % ÿ��Trigger�ľ���ʱ��
    
    % ��SPIF��Ѱ���ڸ���Trigger��Χtimescope��Χ�ڵ�Spike������ֱ��ͼͳ��
        
    % ��SPIF���ڸ���Triggerʱ�䷶Χ�ڵ�Spike��Timing��ת������Trigger��Ϊ�ο�ϵ��ʱ���
    % �����ҵ���Trigger��Χ(timescope)�ڵ�ʱ���
    this_before = this_trigger_time + timescope(1); % Triggerǰ���ʵ��ʱ��λ��
    this_after = this_trigger_time + timescope(2);
    
    % ����ɨ������
    this_scanned_range = this_spif_spiketime( ...
        this_spif_spiketime >= this_before & this_spif_spiketime <= this_after);
   
    % Ȼ�����Щʱ���ת������TriggerΪ�ο�ϵ��ʱ��ֵ
    this_scanned_range = this_scanned_range - this_trigger_time;
    
    % ��Spike�����ھ���Trigger�ܽ���ʱ��Σ���Ϊ�Ǽ��ź�(0.5 ms�ڶ�����)
    if isManualTrigger
        this_scanned_range(abs(this_scanned_range) <= 0.5) = [];
    end
    
    if ~isempty(this_scanned_range)
        % ��������ӳ�һ������
        if size(this_scanned_range,1) <= size(this_scanned_range,2)
            result_pre = [result_pre this_scanned_range];
        else
            result_pre = [result_pre this_scanned_range'];
        end
    end
end

result = histc(result_pre,edges);

% �Ƿ��һ��
if isNormalized
    result = result / (trigger_range(2) - trigger_range(1) + 1);
end

end

