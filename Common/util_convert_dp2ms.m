function [ timems ] = util_convert_dp2ms( number_of_datapoints, MicrosecondsPerTick )
%UTIL_CONVERT_DP2MS ���ߺ���������������ݵ������ǵ�ʱ�䳤��
%   ���������
%       number_of_datapoints�����ݵ�ĸ���
%       MicrosecondsPerTick��ÿ��Indexλ���ǵ�ʱ�䡣���磬25000 Hz��������ÿ��Index��40 us
%   �����
%       timems��ʱ�䳤��
%
%   �ѽ��� 2010��5��21��

timems = MicrosecondsPerTick * number_of_datapoints / 1000;

end

