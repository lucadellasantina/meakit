function [ connected ] = util_connect_spif_spiketimes( spt1, spt2, varargin )
%UTIL_CONNECT_SPIF_SPIKETIMES ���ߺ�����������Spiketimes���ӳ�һ��
%   ������Spiketimes���ӳ�һ��Spiketimes�����������ʵ���ǽ�����һ����С��Cell
%   �������ӳ�һ��Cell����(����)��
%
%   'auto_extend'���������Ӽ�������ʱ�ã���spt2�е�spiketimeֵͳһ�ļ���һ��auto_extendָ��������ms��
%
%   �ѽ��� - 2009��6��17��
%   �ѽ��� - 2009��7��3��
%       ����auto_extend����������ܹ�������spiketimes����ʱ����������(�����spiketimesͳһ�ļ���һ����׼ֵ��ǰ����ļ��ĳ���)

pvpmod(varargin);

if size(spt1) ~= size(spt2)
    error('Two arguments must have the same size.');
end

[rows columns] = size(spt1);
connected = cell(rows,columns);

% �����е�������Cell������ÿ��Ԫ�ص�ֵ��row����
if exist('auto_extend', 'var')
    for i = 1:rows
        connected{i} = [spt1{i}; spt2{i} + auto_extend];
    end
else
    for i = 1:rows
        connected{i} = [spt1{i}; spt2{i}];
    end
end

end

