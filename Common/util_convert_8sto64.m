function [results] = util_convert_8sto64(inp)
%UTIL_CONVERT_8STO64 ���ߺ�������8*8������1��64������
%
%   �ѽ��� 2008��Ϊ������϶�������ݣ�
%   �ѽ��� 2009��6��1��
%   �޸�ע��

    results = reshape(inp, 1, 64);
end