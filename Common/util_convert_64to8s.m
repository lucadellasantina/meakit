function [results] = util_convert_64to8s(inp)
%UTIL_CONVERT_64TO8S ��1:64���������8*8����
%
%   �ѽ��� 2008�꣨Ϊ������϶�������ݣ�
%   �ѽ��� 2009��6��1��
%   �޸�ע��

    % �Ϸ���
    %{
    results = zeros(8,8);
    tmpname = [];
    for i = 1:64
        tmpname = ceil(i/8)*2 + i + 8;
        tmpname = num2str(tmpname);
        results(str2num(tmpname(1)),str2num(tmpname(2))) = inp(i);
    end
    %}
    
    % �·���
    results = reshape(inp, 8, 8);
end