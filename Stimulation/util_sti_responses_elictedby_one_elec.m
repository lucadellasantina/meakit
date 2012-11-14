function [ result num ] = util_sti_responses_elictedby_one_elec( varargin )
%UTIL_STI_RESPONSES_ELICTEDBY_ONE_ELEC ���ߺ�������ĳһ���ض��Ĵ̼��缫�̼����ȫͨ����Ӧ
%   �Ӵ̼���Ӧ�У���ѡ���ɸ����缫�̼����ȫ������������ͨ���ϸ��Ե���Ӧ��
%   
%   ���������
%       responses������ͨ������Ӧ��
%       amplitudes������ͨ������Ӧ��Ӧ�ķ���ֵ��һ���Ƿ��ֵ����
%       elecs����Ӧresponses�ϣ�ͨ����ChID��
%       stipro���̼�������
%       sti_id��ָ���Ĵ̼�ͨ���ţ�
%
%   ���������
%       result���������
%       num����ָ��STI_ID�����̼���Trigger����Ŀ
%
%   Eg��
%   [result num] = util_sti_responses_elictedby_one_elec('responses',
%   responses, 'elecs', elecs, 'stipro', stimulation, 'sti_id', 47, 'amplitudes', amplitudes)
%
%   �ѽ��� 2010��5��4��

pvpmod(varargin);

% ������

if ~exist('responses', 'var')
    error('RESPONSES must be provided.');
end

if ~exist('amplitudes', 'var')
    error('AMPLITUDES must be provided.');
end

if ~exist('elecs', 'var')
    error('ELECS must be provided.');
end

if ~exist('stipro', 'var')
    error('STIMULATION PROTOCOL must be provided.');
end

if ~exist('sti_id', 'var')
    error('STI_ID must be provided.');
end

h = waitbar(0, 'Please wait...');
set(h, 'Name', 'Please wait...');

num_trigger = length(responses{1});

% ������ָ���缫�̼�ʱ���ܹ��ж����ֱ仯
[ ~, variation_electrodes variation_duration variation_amplitude variation_shapes variation_isi, ~ ] = util_parse_para_fromstimulation(stipro);
%
% TEMPLATE Put your code here �ɸ��ݲ�ͬ�仯�����ʼ���������
%
% TEMPLATE Init result arrays here
for i=1:length(variation_amplitude)
    for j = 1:64
        % TIMING
        result.(['amp' num2str(variation_amplitude(i))]).timing.(['ch' num2str(util_convert_hw2ch(j))]).all = {};
        % AMPLITUDE
        result.(['amp' num2str(variation_amplitude(i))]).amplitude.(['ch' num2str(util_convert_hw2ch(j))]).all = {};
        
        % NUMBER OF RESPONSES
        
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).all = [];
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.mean = 0;
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.std = 0;
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.sem = 0;
        % �ù۲�缫����ָ���̼��缫��ָ���̼���ѹ�µ�Trigger����
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.num = 0;
        % �ù۲�缫����ָ���̼��缫��ָ���̼���ѹ�µģ���Response��Trigger����
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.num_response = 0;
        
        % FIRST RESPONSE DELAY
        
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).all = [];
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.mean = 0;
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.std = 0;
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.sem = 0;
        % �ù۲�缫����ָ���̼��缫��ָ���̼���ѹ�µ�Trigger����
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.num = 0;
        % �ù۲�缫����ָ���̼��缫��ָ���̼���ѹ�µģ���Response��Trigger����
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.num_response = 0;
        
        % FIRST RESPONSE AMPLITUDE
        
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).all = [];
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.mean = 0;
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.std = 0;
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.sem = 0;
        % �ù۲�缫����ָ���̼��缫��ָ���̼���ѹ�µ�Trigger����
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.num = 0;
        % �ù۲�缫����ָ���̼��缫��ָ���̼���ѹ�µģ���Response��Trigger����
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.num_response = 0;
    end
end

% ������Trigger�б����������Trigger����ָ���缫����Ĵ̼������������
num = 0;    % ��Ӧ�缫�Ĵ̼�����

for trigger = 1:num_trigger
    if (util_check_trigger_belongs_elec(stipro,trigger,sti_id))
        % ����Trigger����ָ���Ĵ̼��缫�����Ĵ̼�
        num = num + 1;
        
        % �ڹ۲�缫��ѭ��
        for hwid = 1:64
            % �������ͳ����
            % TEMPLATE Put your code here
            %
            % �жϱ���ѹ
            i = find(variation_amplitude==stipro(trigger).pulse_amplitude);
            
            % ����ѹ�±��۲�缫�µ�Trigger��++
            result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num = result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num + 1;
            result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num = result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num + 1;
            result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num = result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num + 1;

            % �жϱ���Trigger����response
            if (isempty(responses{hwid}{trigger}))
                hasResponse = false;
            else
                hasResponse = true;
                % ����ѹ�±��۲�缫�µ��շ���Response��Trigger��++
                result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num_response = result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num_response + 1;
                result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num_response = result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num_response + 1;
                result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num_response = result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num_response + 1;
            end
            
            % NUMBER OF RESPONSE
            first_response = responses{hwid}{trigger};
            result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).all length(first_response)];
            
            % TIMING(��������������ȫ����Trial)
            result.(['amp' num2str(variation_amplitude(i))]).timing.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).timing.(['ch' num2str(util_convert_hw2ch(hwid))]).all {first_response}];
            
            % FIRST RESPONSE DELAY
            if (~hasResponse)
                % no response = not count
                % result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).all 0];
            else
                result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(hwid))]).all first_response(1)];
                % TIMING(����������������response��Trial)
                % result.(['amp' num2str(variation_amplitude(i))]).timing.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).timing.(['ch' num2str(util_convert_hw2ch(hwid))]).all {first_response}];
            end
            
            first_response = amplitudes{hwid}{trigger};

            % AMPLITUDE(��������������ȫ����Trial)
            result.(['amp' num2str(variation_amplitude(i))]).amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all {first_response}];
            
            % FIRST RESPONSE AMPLITUDE
            if (~hasResponse)
                % no response = not count
                % result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all 0];
            else
                result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all first_response(1)];
                % AMPLITUDE(����������������response��Trial)
                % result.(['amp' num2str(variation_amplitude(i))]).amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all = [result.(['amp' num2str(variation_amplitude(i))]).amplitude.(['ch' num2str(util_convert_hw2ch(hwid))]).all {first_response}];
            end
        end
    end
    waitbar(trigger/num_trigger, h, ['Triggers ' num2str(trigger) ' / ' num2str(num_trigger)]);
end
result.total_num = num;
result.description = 'amp(mV), all time in ms';
% �������ͳ����
% TEMPLATE Put your code here
for i=1:length(variation_amplitude)
    for j = 1:64
        % NUMBER OF RESPONSES
        
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.mean = mean(result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).all);
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.std = std(result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).all);
        result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.sem = result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.std / sqrt(result.(['amp' num2str(variation_amplitude(i))]).num_response.(['ch' num2str(util_convert_hw2ch(j))]).stat.num);
        
        % FIRST RESPONSE DELAY

        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.mean = mean(result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).all);
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.std = std(result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).all);
        result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.sem = result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.std / sqrt(result.(['amp' num2str(variation_amplitude(i))]).first_response_delay.(['ch' num2str(util_convert_hw2ch(j))]).stat.num_response);
        
        % FIRST RESPONSE AMPLITUDE
        
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.mean = mean(result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).all);
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.std = std(result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).all);
        result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.sem = result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.std / sqrt(result.(['amp' num2str(variation_amplitude(i))]).first_response_amplitude.(['ch' num2str(util_convert_hw2ch(j))]).stat.num_response);
    end
end
close(h);
end