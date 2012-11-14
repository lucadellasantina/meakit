function results = util_find_maxlength_of_chs( SPT )
%UTIL_FIND_MAXLENGTH_OF_CHS ���ߺ���������MCS��Ϣ���ҵ�Spike Table�����ͨ��
% ����Spike Train��Spike��Ŀ����ͨ��
% �������hwid��������Ҫת��
% 
% �ѽ��� 2008�� (ΪGap Junction Paper��д�Ĺ��ߺ���)


max_length_of_channels = 0;

for i = 1:64
    if max_length_of_channels < length( SPT{i} )
        max_length_of_channels = length( SPT{i} );
    end
end

results = max_length_of_channels;

end