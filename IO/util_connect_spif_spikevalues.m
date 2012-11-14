function [ connected ] = util_connect_spif_spikevalues( spv1, spv2 )
%UTIL_CONNECT_SPIF_SPIKEVALUES ���ߺ�����������Spikevalues���ӳ�һ��
%   ������Spikevalues���ӳ�һ��Spikevalues�����������ʵ���ǽ�����һ����С��Cell
%   �������ӳ�һ��Cell����(����)��
%
%   �ѽ��� - 2009��6��17��

if size(spv1) ~= size(spv2)
    error('Two arguments must have the same size.');
end

[rows columns] = size(spv1);
connected = cell(rows,columns);

% �����е�������Cell������ÿ��Ԫ�ص�ֵ��column����
for i = 1:rows
    connected{i} = [spv1{i}, spv2{i}];
end

end
