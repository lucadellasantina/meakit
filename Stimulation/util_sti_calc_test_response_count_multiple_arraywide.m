function [ varargout ] = util_sti_calc_test_response_count_multiple_arraywide( varargin )
%UTIL_STI_CALC_RESPONSE_COUNT_MULTIPLE_ARRAYWIDE ����ÿ���缫�ڴ̼��ڼ����ӦSpike��Ŀ
%   ר���ڴ������Դ̼�Test Positive/Negative��Score����
%
%   ���������
%       stimulating_chid��һ�����У���[11 22 33
%       88]������һ��test�̼���11�缫�����ĸ�test�̼���88�缫���ݴˣ������ش̼��ڼ䣬�ֱ�������4����ͬ�缫�Ĳ��Գɼ���
%       
%       calculating_range��һ��ֵ������200(ms)������̼���೤ʱ���ڵ�score
%       isManualTrigger = �Ƿ����ֶ����Trigger���ֶ�Trigger���ܻ����Trigger����ΪSpike��+/-
%       0.5 ms��
%       filename��һ���ļ�������ѡ���������ṩ��
%
%   ����������ɱ䣩
%       ��һ����Ӧ��һ���缫���ڶ�����Ӧ�ڶ����缫���Դ����ƣ�����util_calc_sti_test_score_arraywide��
%       ������2���缫����v1, v2, v3, v4�ֱ��ǵ�1��2���缫���̼�ʱȫ����缫�ĸ��Ե�ƽ���ɼ����Լ�ÿ�εĸ��缫�ɼ���v3��ÿ���缫�ɼ��ľ�ֵ����v1��ÿ���缫��ֵ��
%   
%   See also UTIL_STI_CALC_TEST_SCORE_ARRAYWIDE
%   
%   �ѽ��� 2009��11��23��
%   �ѽ��� 2009��11��24��
%          ������ɣ�����ͨ��

pvpmod(varargin);

% ��������

if ~exist('stimulating_chid', 'var')
    error('STIMULATING_CHID must be provided.');
else
    number_of_sti_elec = length( stimulating_chid );
    disp(['STIMULATING ELEC: ' num2str(stimulating_chid)]);
end

if ~exist('calculating_range', 'var')
    error('CALCULATING_RANGE must be provided');
end

if ~exist('isManualTrigger', 'var')
    isManualTrigger = 1;
end

if isManualTrigger
    disp('Delayed detecting is ON.');
else
    disp('Delayed detecting is OFF.');
end

if ~exist('filename', 'var')
    [D spif trif] = util_load_spike_trigger_mcdstream();
else
    [D spif trif] = util_load_spike_trigger_mcdstream('filename', filename);
    disp(filename);
end

% Trigger���ܸ���
number_of_triggers = size( trif.times, 2 );
disp(['TRIGGERS: ' num2str( number_of_triggers )]);

% ��ͨ����ת��ΪӲ����ţ���Ϊ�����������׼��
stimulating_elec_hwid = zeros(1, number_of_sti_elec);
score = zeros(1, number_of_sti_elec);
nargout = 2 * number_of_sti_elec;
for i = 1:number_of_sti_elec
    stimulating_elec_hwid(i) = util_convert_ch2hw(stimulating_chid(i));
    % ��ʼ��������: varargout(1) - (n)��ƽ��
    varargout(i) = {zeros(1,64)};
end
for i = (number_of_sti_elec + 1):(2 * number_of_sti_elec)
    % ��ʼ����������varargout(n+1) - (2n)����ϸ��ÿ�εĳɼ�
    varargout{i} = cell(64,1);
end

% �����е缫�ϱ�����������������ڿɱ�������������
% ����Ļ���˼·��
% ��trigger�¼���ѭ�������ν������̼��缫��Ӧ���¼��Ʒֲ��������Դ̼��缫Ϊ˳���������ɵĽ��������


% ����Ȩֵ����
% ����1:100����1����0-1 ms���Σ�2����1-2 ms����
weights = 100:-(99/(calculating_range-1)):1;
edges = 1:1:calculating_range;

% �̼��缫������
serial_of_sti_elec = 1;

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
    
    % ����Ĳ��ֳ���κͼ���UTIL_STI_CALC_TEST_SCORE�е��缫����һ��
    % ����ĳ����רΪ�����缫�Ż�
    
    % ��ñ���Trigger��Ӧ�ĵ缫(Ӳ�����)
    this_sti_elec = stimulating_elec_hwid(serial_of_sti_elec);
    
    hwID = 1;
    while hwID < 65
        % �ų��Ľǵ缫�ʹ̼��缫
        if hwID == 1 || hwID == 8 || hwID == 57 || hwID == 64 || hwID == this_sti_elec
            hwID = hwID + 1;
            continue;
        end
        
        % ���㱾�缫���δ̼�ʱ���÷��� <== begin
        
        % ���缫��spiketime��
        this_spif_spiketime = spif.spiketimes{ hwID };
        
        % ��scan_start_point����ĵ�һ��spiketime���ǵ�һ��spike������ʱ��
        % �ҵ���ָ��ʱ�䷶Χ�ڵ�spikes        
        candidate_spikes = this_spif_spiketime( this_spif_spiketime > scan_start_point ...
        & this_spif_spiketime < scan_start_point + calculating_range);
    
        % ����ѡspike����Calculating_Range���зֲ�
        candidate_spikes = candidate_spikes - scan_start_point;
        % ����histc�õ�ÿ�����ε�spike������Խ���ڵ�ȨֵԽ�ߣ�Խĩ�ڵ�ȨֵԽ��
        sorted_candidate_spikes = histc(candidate_spikes, edges);

        % ���㱾�δ̼��ɼ�����׷�������缫�Ʒ�ʸ����
        tmp_varargout = varargout{serial_of_sti_elec + number_of_sti_elec};
        if size(sorted_candidate_spikes,1) == size(weights,1)
            tmp_varargout{hwID, :} = [tmp_varargout{hwID, :} sum(sorted_candidate_spikes .* weights)];
        elseif size(sorted_candidate_spikes,1) == size(weights,2)
            tmp_varargout{hwID, :} = [tmp_varargout{hwID, :} sum(sorted_candidate_spikes .* weights')];
        end
        varargout{serial_of_sti_elec + number_of_sti_elec} = tmp_varargout;
        
        % ���㱾�缫���δ̼�ʱ���÷��� ==> end
        
        hwID = hwID + 1;
    end
    
    % ������һ���̼��缫
    if serial_of_sti_elec == number_of_sti_elec
        % ���Ѿ�ѭ�������һ���̼��缫����ԭ
        serial_of_sti_elec = 1;
    else
        % ��������һ���̼��缫
        serial_of_sti_elec = serial_of_sti_elec + 1;
    end
end

% �����ܽ��
for i = 1:number_of_sti_elec
    tmp_varargout_input = varargout{i+number_of_sti_elec};
    tmp_varargout_output = varargout{i};
    
    for hwID = 1:64
        % �����δ̼��Ľ��ƽ��
        tmp_varargout_output(hwID) = mean(tmp_varargout_input{hwID});
        
        % Ԥ�Ƚ�NAN��EMPTY��0�����ӳ������������ȶ���
        if isnan( tmp_varargout_output(hwID) )
            tmp_varargout_output(hwID) = 0;
        elseif isempty( tmp_varargout_output(hwID) )
            tmp_varargout_output(hwID) = 0;
        end
            
    end
    varargout{i} = tmp_varargout_output;
end

end

