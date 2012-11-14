function [ analysis ] = process_sti_result_by_stiID_by_amplitudes_response_per( result, sti_id, stipro)
%PROCESS_STI_RESULT_BY_STIID_BY_AMPLITUDES
%���ߺ�������ȡ�̼������У�ĳ���缫������ͬ��ѹ�̼��£�ȫ�����ͨ����ͳ�ƽ��
%   ���������
%       paraname��Ҫͳ�ƵĲ�����������'num_response'����Ӧresult����Ľṹ��
%       result��Ԥ�ȴ���Ĵ̼�������
%       sti_id���̼��缫��
%       stipro���̼�������
%
%   ���������
%       analysis���������
%
% �ѽ��� 2010��5��6��

% ������ָ���缫�̼�ʱ���ܹ��ж����ֱ仯
[ ~, ~, ~, variation_amplitude,~ , ~, ~ ] = util_parse_para_fromstimulation(stipro);


for hwid = 1:64
    % �����̼��缫
    if (sti_id == util_convert_hw2ch(hwid))
        continue;
    end
    
    %��������ṹ��
    analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).x = [1:length(variation_amplitude)];
    analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).y = [];
    analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).e = [];
    
    % �ڲ�ͬ��ѹ��ѭ������ȡ�������������ṹ��
    for j=1:length(variation_amplitude)
        analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).y = [analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).y result.(['amp' num2str(variation_amplitude(j))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num_response/result.(['amp' num2str(variation_amplitude(j))]).num_response.(['ch' num2str(util_convert_hw2ch(hwid))]).stat.num];
        analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).e = [analysis.(['ch' num2str(util_convert_hw2ch(hwid))]).e 0];
    end
end


end

