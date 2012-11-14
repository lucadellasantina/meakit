function [ spif ] = util_convert_ptsd_result2spif( spt, spv, startend )
%UTIL_CONVERT_PTSD_RESULT2SPIF ���ߺ�������PTSD���λ��ȡ�㷨�Ľ��ת��ΪSPIF�ṹ��
%   ���������
%       spt��spv������PTSD���λ��ȡ�㷨�Ľ����Timing, Values��
%       startend��[start end] ms��SPIF���ǵ���ֹʱ��
%   ���������
%       spif
%
%   �ѽ��� 2010��5��24��

% �����������
spif.spiketimes = cell(64,1);
spif.spikevalues = cell(64,1);

spif.startend = startend;

% ת�������SPIF
for hwid = 1:64
    spif.spiketimes{hwid} = spt{ hwid,: };
    spif.spikevalues{hwid} = spv{ hwid,: };
end

end

