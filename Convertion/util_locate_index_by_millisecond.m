function [ indexer ] = util_locate_index_by_millisecond( timems, MicrosecondsPerTick, startms )
%UTIL_LOCATE_INDEX_BY_MILLISECOND ���ߺ�������ʱ�䣨ms�����Ƹ�ʱ���Ӧ�ź��ڼ�¼�����е�λ��
%   ���������
%       timems��ʱ�䡣
%       MicrosecondsPerTick��ÿ��Indexλ���ǵ�ʱ�䡣���磬25000 Hz��������ÿ��Index��40 us
%       start��index = 1���Ǹ����ʱ�䣨ms�����������е�һ�����λ�á�
%   �����
%       indexer���ڽ�������е�λ��
%
%   �ѽ��� 2010��5��18��
%   �ѽ��� 2010��5��21��
%       ����startms���������޸�ԭ������ʹ֮����UTIL_CONVERT_MS2DP��

indexer = util_convert_ms2dp( (timems - startms), MicrosecondsPerTick);


end

