function [ analysis ] = process_sti_result_by_stiID_by_amplitudes_for_some_electrodes( paraname, result, sti_id, stipro, list, isSort, sort_by_n )
%PROCESS_STI_RESULT_BY_STIID_BY_AMPLITUDES_FOR_SOME_ELECTRODES ���ߺ�������ȡ����ͨ������Ӧ����
% ��ȡ�̼������У�ĳ���缫������ͬ��ѹ�̼��£�ָ��ͨ����ͳ�ƽ��
%���ɰ��յ�sort_by_n����ѹʱ��������Ӧ�Ĵ�С���������˳����analysis�ĵ缫�б���
%   ���������
%       paraname��Ҫͳ�ƵĲ���������result�ṹ���ж�Ӧ
%       result��Ԥ�ȴ���õĴ̼��������
%       sti_id���̼��缫
%       stipro���̼�����
%       list��Ҫͳ�Ƶĵ缫�б���[34 68]
%       isSort���Ƿ�Ҫ���ݵ�n����ѹ��������
%       sort_by_n����n����ѹ
%   ���������
%       analysis�����
%
% �ѽ��� 2010��5��6��

% ������ָ���缫�̼�ʱ���ܹ��ж����ֱ仯
[ ~, ~, ~, variation_amplitude,~ , ~, ~ ] = util_parse_para_fromstimulation(stipro);

% Remove STI
list(list==sti_id) = [];

if isSort
    % Get sort value (by n)
    firstval = [];
    for i=1:length(list);
        firstval = [firstval; result.(['amp' num2str(variation_amplitude(sort_by_n))]).num_response.(['ch' num2str(list(i))]).stat.mean list(i)];
    end
    % Show for checking
    firstval
    % Sort
    [~, index]=sort(firstval,1);
    list = firstval(index(:,1),2);
end



for i=1:length(list);
    analysis.(['ch' num2str(list(i))]).mean = [];
    analysis.(['ch' num2str(list(i))]).sem = [];
    for j=1:length(variation_amplitude)
        analysis.(['ch' num2str(list(i))]).mean = [analysis.(['ch' num2str(list(i))]).mean result.(['amp' num2str(variation_amplitude(j))]).(paraname).(['ch' num2str(list(i))]).stat.mean];
        analysis.(['ch' num2str(list(i))]).sem = [analysis.(['ch' num2str(list(i))]).sem result.(['amp' num2str(variation_amplitude(j))]).(paraname).(['ch' num2str(list(i))]).stat.sem];
    end
end


end

