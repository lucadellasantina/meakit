function [ number raw_stream ] = util_find_rawstream( D )
%UTIL_FIND_SPIKESTREAM ���ߺ������ҵ�MCD�ļ��е�Raw������
%   ����Raw�������ĸ���������������
%   �������:
%       D = datastrm���ص����ݶ���
%   �������:
%       number = RAW����������
%       spike_stream = RAW����������CELL��
%   
%   �ѽ��� 2010��5��21��

streamCount = getfield(D, 'StreamCount');
streamInfo = getfield(D, 'StreamInfo');

number = 0;
raw_stream = {};


for i = 1:streamCount
    if strcmp( streamInfo{i}.DataType, 'analog' )
        number = number + 1;
        raw_stream{number} = streamInfo{i}.StreamName;
    end
end


end

