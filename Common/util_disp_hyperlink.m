function [] = util_disp_hyperlink( text, varargin )
%UTIL_DISP_HYPERLINK ���ߺ��������������ʾ��ɫ�ĳ���������
%   text = Ҫ��ʾ������
%   ��ѡ��links = ����λ��
%
%   �ѽ��� - 2009��6��27��

pvpmod(varargin);

if ~exist('links', 'var')
    links = '';
end

disp(['<a href="' links '">' text '</a>']);

end

