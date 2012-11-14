function [ score avg_score max_score min_score median_score] = util_sti_calc_test_score ( spif, ...
    trif, ...
    obs_chid, ...
    calculating_range, ...
    isManualTrigger, ...
    isPrintInfo)
%UTIL_STI_CALC_TEST_SCORE ���ߺ�����������Ե缫�ɼ�
%   ����spif��triggerif������ÿ��trigger������ʱ�䣬�жϹ۲�缫(obs_chid)
%   ����ָ����ʱ�䷶Χ(calculating_range)�ϵĲ��Գɼ�(score)��
%   ���㷽�����磬ָ��100ms�ڣ����0-1ms������Spike�Ʒ�100�֣���99-100ms������Spike�Ʒ�0��
%
%   ������
%   spif,trif = spike time table and trigger table read from a mcd file
%   obs_chid = �۲�缫�ţ�Ҳ����Ҫ����ɼ��ĵ缫��(11-88)
%   calculating_range = �۲췶Χ����ms�ƣ�����100����Ҫע�ⲻ�ܴ������δ̼���ʱ������������ʾ���������Զ����û��趨��
%   isManualTrigger = �Ƿ����ֶ����Trigger���ֶ�Trigger���ܻ����Trigger����ΪSpike��+/- 0.5 ms��
%   isPrintInfo = �Ƿ���Ϣ���������̨
%
%   ���������
%   score = �ɼ�����
%   avg,max,min,median = ƽ���֣������С����λ��
%
%   �ѽ��� 2009��11��20��
%   �ѽ��� 2009��11��21��
%       ���isPrintInfo��������߳��������

% ��������
if isPrintInfo
    disp([char(10) char(10) '=== Calculating Test Score ===']);
    disp(['Observation Elec# ' num2str(obs_chid)]);
    disp(['Time Range: ' num2str(calculating_range)]);
    if isManualTrigger
        disp('Delayed detecting is ON.');
    else
        disp('Delayed detecting is OFF.');
    end
end

% ͨ�����ת��
obs_hwid = util_convert_ch2hw(obs_chid);

% ����Ļ���˼·
% ��trigger�¼���ѭ�����ҵ���obs_hwid�У�ÿ��trigger��ָ����Χ�ڵ�Spike��������Ʒ�

% Ϊ��������ٶȣ�Ԥ�ȴ���FORѭ���з����õı���
this_spif_spiketime = spif.spiketimes{ obs_hwid }; % ����ͨ����SPIF��Ϣ���Ʊ�

% ����Trigger���ܸ���
number_of_triggers = size( trif.times, 2 );
if isPrintInfo
    disp(['Number of Triggers: ' num2str(number_of_triggers)]);
end

score = [];
number_of_candidate_spikes = 0;

% ����Ȩֵ����
% ����1:100����1����0-1 ms���Σ�2����1-2 ms����
weights = 100:-(99/(calculating_range-1)):1;
edges = 1:1:calculating_range;

% ��Trigger�б���
for i = 1:number_of_triggers
    % ��ñ���trigger����ʱ��
    this_trigger_time = trif.times(i);
    
    % ����´�trigger����ʱ��
    if i < (number_of_triggers - 1)
        next_trigger_time = trif.times(i+1);
    else
        % û���´�trigger�����ʱ������Ϊ���ʱ��
        next_trigger_time = trif.startend(2);
    end
    
    % ��Ϊ�ֶ����Trigger��������Ҫһ���ӳٵ������
    % �򽫿�ʼɨ���ʱ���ӳ�0.5 ms
    if isManualTrigger
        scan_start_point = this_trigger_time + 0.5;
        scan_end_point = next_trigger_time - 0.5;
    else
        scan_start_point = this_trigger_time;
        scan_end_point = next_trigger_time - 0.5;
    end

    % �жϼ��㷶Χ�Ƿ���������ں������´�trigger�ķ���ʱ��
    if scan_end_point <= scan_start_point + calculating_range
        error(['Wrong CALCULATING_RANGE' char(10) 'Current setting makes it includes the next trigger.' char(10) 'Possible reason: The trigger is not so precisely timed as we thought.']);
    end
    
    % ��scan_start_point����ĵ�һ��spiketime���ǵ�һ��spike������ʱ��
    % �ҵ���ָ��ʱ�䷶Χ�ڵ�spikes
    candidate_spikes = this_spif_spiketime( this_spif_spiketime > scan_start_point ...
        & this_spif_spiketime < scan_start_point + calculating_range);
    
    % �������ʱ�䷶Χ�ڵĲ��Գɼ� <=== begin
    
    % ��ѡspike������Ŀ
    number_of_candidate_spikes = number_of_candidate_spikes + length( candidate_spikes );
    % disp(['Number of Candidate Spikes: ' num2str(number_of_candidate_spikes)]);
    
    % ����ѡspike����Calculating_Range���зֲ�
    candidate_spikes = candidate_spikes - scan_start_point;
    % ����histc�õ�ÿ�����ε�spike������Խ���ڵ�ȨֵԽ�ߣ�Խĩ�ڵ�ȨֵԽ��
    sorted_candidate_spikes = histc(candidate_spikes, edges);
    
    % ����ɼ�
    if size(sorted_candidate_spikes,1) == size(weights,1)
        score = [score sum(sorted_candidate_spikes .* weights)];
    elseif size(sorted_candidate_spikes,1) == size(weights,2)
        score = [score sum(sorted_candidate_spikes .* weights')];
    end
    
    % �������ʱ�䷶Χ�ڵĲ��Գɼ� ===> end
end

avg_score = mean( score );
max_score = max( score );
min_score = min( score );
median_score = median( score );

if isPrintInfo
    disp(['Total Candidate Spikes: ' num2str(number_of_candidate_spikes)]);
    disp(['Mean Score: ' num2str(avg_score)]);
end
%disp(['Max Score: ' num2str(max_score)]);
%disp(['Min Score: ' num2str(min_score)]);
%disp(['Median Score: ' num2str(median_score)]);

end
