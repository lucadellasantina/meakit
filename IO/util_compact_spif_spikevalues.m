function [ compacted ] = util_compact_spif_spikevalues( spv )
%UTIL_COMPACT_SPIF_SPIKEVALUES ���ߺ�������SPIF��SPIKEVALUE��Ϣѹ��
%   ��SPIF��SPIKEVALUE���У�ÿһ��SPIKE����Ϣ����Ϊֻ�������ֵ����Сֵ��
%   �����ڴ���ϴ�SPIKE�ļ��������ǳ�ʱ���¼�ļ���ʱ�����Բ������ڴ汨��
%
%   �ѽ��� 2009��6��17��

compacted = cell(64,1);
for i = 1:64
    compacted{i} = [max( spv{i} ); min( spv{i} )];
end

end

