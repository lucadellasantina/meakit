%PROCESS_STI_RESULT_BY_STIID_BY_DELAYS_RESPONSE_PER
%���ߺ�������ȡ�̼������У�ĳ���缫����TBS�̼�����£�ȫ�����ͨ����ͳ�ƽ��
%   ���������
%       paraname��Ҫͳ�ƵĲ�����������'num_response'����Ӧresult����Ľṹ��
%       sti_id���̼��缫��
%
%   ���������
%       analysis���������
%
% �ѽ��� 2010��5��17��

% ������ָ���缫�̼�ʱ���ܹ��ж����ֱ仯
variation_delays = {'control' '50ms' '10ms' '5ms'};
amplitude = '200';
paraname = 'num_response';
sti_id = 54;


for hwid = 1:64
    % �����̼��缫
    if (sti_id == util_convert_hw2ch(hwid))
        continue;
    end
    
    %��������ṹ��
    analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).x = [1:length(variation_delays)];
    analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).y = [];
    analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).e = [];
    
    % �ڲ�ͬdelay��ѭ������ȡ�������������ṹ��
    for j=1:length(variation_delays)
        temp_str = strcat('may14_result_', variation_delays(j), '_sti', num2str(sti_id));
        result = eval(temp_str{1});
        analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).y = [analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).y ...
            result.(['amp' amplitude]).(paraname).(['ch' num2str(util_convert_hw2ch(hwid))]).stat.mean];
        analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).e = [analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).e ...
            result.(['amp' amplitude]).(paraname).(['ch' num2str(util_convert_hw2ch(hwid))]).stat.sem];
    end
end

util_plot_8s_into_arraymap(analysis,[15 sti_id])
clear variation_delays amplitude paraname hwid j temp_str;


clear analysis
variation_rate = {'baseline' 'finished'};
gnd = 15;

for j = 1:length(variation_rate)
    temp_str = strcat('may14_', variation_rate(j), '_spif');
    [~, avg, ~, ~, avg_sem] = util_calc_spb_avg_elec( 'spif', eval(temp_str{1}), 'gnd', gnd);

    for hwid = 1:64
        % �����ӵص缫
        if (util_convert_hw2ch(hwid) == 15)
            continue;
        end
        
        % ��������ṹ��
        analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).x = [1:length(variation_rate)];
        
        % �ֱ����Baseline/Finished�Ĳ���
        analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).y(j) = avg(hwid);
        analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).e(j) = avg_sem(hwid);
    end
end

util_plot_8s_into_arraymap_bar(analysis,[gnd],1);
clear variation_rate gnd temp_str hwid j;






