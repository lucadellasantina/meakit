function [ number_of_datapoints ] = util_convert_ms2dp( timems, MicrosecondsPerTick )
%UTIL_CONVERT_MS2DP ���ߺ������������ʱ�䳤�Ȱ������ٸ����ݵ�
%   ���������
%       timems��ʱ�䳤��
%       MicrosecondsPerTick��ÿ��Indexλ���ǵ�ʱ�䡣���磬25000 Hz��������ÿ��Index��40 us
%   �����
%       number_of_datapoints�����ݵ�ĸ���
%
%   �ѽ��� 2010��5��21��

number_of_datapoints = timems * 1000 / MicrosecondsPerTick;

end

