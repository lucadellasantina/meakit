function [ bi ] = util_calc_burstiness_index( varargin )
%UTIL_CALC_BURSTINESS_INDEX ���ߺ���������������ݵ�BIֵ
%   ����Daniel Wagenaar��Controlling Burst���¶��壬����BIֵ
%   This program is derived from Jon Newman's bindex function
%   BI = BINDEX(ASDR) calculates the burstiness index of a given ASDR by
%   finding the percent of total spikes that are accounted for by the highest 15%
%   of bins in the ASDR series. If BI = 1, all spikes occur in bursts, if
%   BI = 0 then there is perfect tonic firing with no variation in firing
%
%   BI = BINDEX(ASDR,TOP) provide a top-end ASRD percentage to define
%   burstiness. If not defined, top = 15%.
%
%   ���������
%       spb��SPSA��Ӧָ��bin = 1000ms��
%       top��ָ���İٷֱȣ�Ĭ��Ϊ15��15%��
%   ���������
%       bi��Burstiness Index
%
%   �ѽ��� 2010��5��20��

% �βη���
pvpmod(varargin);

if ~exist('spb', 'var')
    error('SPB must be provided.');
end

if ~exist('top', 'var')
    top = 15;
end

% ת��Ϊ�ٷֱ�
top = 15 / 100;

% ����SPB�У����е�Spike����
total_spikes = sum(spb);

% ��SPB���򣨸�->�ͣ�
sorted_list = sort(spb, 'descend');

% F15 or F-top
f15 = sum(sorted_list(1:round(top*length(spb))))/total_spikes;

% BI
bi = (f15 - top) / (1 - top);

end

