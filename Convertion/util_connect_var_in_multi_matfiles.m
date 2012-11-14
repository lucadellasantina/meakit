function [result] = util_connect_var_in_multi_matfiles(the_varname)
%UTIL_CONNECT_VAR_IN_MULTI_MATFILES ���ߺ����������MAT�ļ��е�ĳ���������е�������������
%   ��һ������.mat�ļ��п��ܶ�������ͬһ�����ֵı���var���������ܹ������û�
%   ѡ���.mat�ļ�˳�򣬽����еı��������������������ء�
%
%   the_var_name = ��������
%
%   �ѽ��� 2008�� (ΪGap Junction�������ݴ����д��Ŀ�������Ӷ���ļ��е�SPSA)
%   �ѽ��� 2009��
%   ��дע��

[filename, pathname] = uigetfile('*.mat','MultiSelect','ON');
% ��ʾ�ļ�˳��
disp(char(filename));

% �ж��Ƕ���ļ����ǵ����ļ�
if iscell(filename)
    % ����ļ�
    for i = 1:length(filename)
        tmp_filename = [pathname char(filename(i))];
        load(tmp_filename, the_varname);

        if (i == 1)
            tmp_var = eval(the_varname);
        else
            tmp_var = [tmp_var eval(the_varname)];
        end
    end        
else
    % �����ļ�
    tmp_filename = [pathname filename];
    load(tmp_filename, the_varname);
    tmp_var = eval(the_varname);
end

result = tmp_var;
end