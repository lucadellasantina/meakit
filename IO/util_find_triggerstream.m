function [ number trigger_stream ] = util_find_triggerstream( D )
%UTIL_FIND_TRIGGERSTREAM ���ߺ������ҵ�MCD�ļ��е�Trigger������
%   ����Trigger�������ĸ���������������
%   �������:
%       D = datastrm���ص����ݶ���
%   �������:
%       number = TRIGGER����������
%       spike_stream = TRIGGER����������CELL��
%   
%   �ѽ��� 2009��5��22��

streamCount = getfield(D, 'StreamCount');
streamInfo = getfield(D, 'StreamInfo');

number = 0;
trigger_stream = {};


for i = 1:streamCount
    if strcmp( streamInfo{i}.DataType, 'trigger' )
        number = number + 1;
        trigger_stream{number} = streamInfo{i}.StreamName;
    end
end


end

