function [ the_frame ] = util_plot_8s_into_dotsgraph( varargin )
%UTIL_PLOT_8S_INTO_DOTSGRAPH ���ߺ�������һ��8*8�ľ�����Ƴ�Բ��ͼ
%   ��plot_mea_dotsgraph�����������汾��
%   �ܹ���һ��8*8�ľ��󣬻��Ƴɸ�����ֵ��С�任ֱ������ɫ��Բ��ͼ
%
%   ���������
%       the_matrix��8*8���������
%       haveAxes���Ƿ�Ҫ�������ᣨĬ���У�������������������Զ�������ܵ缫
%       haveGrid���Ƿ�Ҫ������Ĭ��û�У�
%       haveIndicator���Ƿ���ʾ���ֵ�㣨Ĭ��û�У�
%       isFigureWindowStayedOpen����ͼ��ɺ��Ƿ񱣳ִ��ڴ򿪣�Ĭ�ϴ򿪣���Ҳ�ɲ��򿪣���Ϊ�Ѿ�������the_frame��
%       the_title����Ŀ��Ĭ����ֵ��
%   ���������
%       the_frame�������1֡
%
%   See also plot_mea_dotsgraph
%
%   �ѽ��� 2009��11��24��

pvpmod(varargin);

% ��������

if ~exist('the_matrix', 'var')
    error('THE_MATRIX must be provided.');
end

if ~exist('haveAxes', 'var')
    haveAxes = 1;
end

if ~exist('haveGrid', 'var')
    haveGrid = 0;
end

if ~exist('haveIndicator', 'var')
    haveIndicator = 0;
end

if ~exist('isFigureWindowStayedOpen', 'var')
    isFigureWindowStayedOpen = 1;
end

if ~exist('the_title', 'var')
    the_title = 'Network Status';
end

% ȡ�þ���Ĵ�С����������ʵ�ϼ��ݸ������Ļ��ƣ�
networksize = length(the_matrix);
s = 0;

% ��ͼ������
scatterX = zeros(networksize^2,1);
scatterY = zeros(networksize^2,1);
scatterS = zeros(networksize^2,1);

% ��ɫ
scatterC = zeros(networksize^2,3);
value_max = max( max(the_matrix) );
value_min = min(min(the_matrix));
colorscaling = value_max - value_min + 0.001;

% ���Ƶ缫Բ��
multiply_factor = 300;

for i = 1:networksize
    for j = 1:networksize
        s = s+1;
        scatterX(s,1) = i;
        scatterY(s,1) = j;
        scatterS(s,1) = the_matrix(i,j) / value_max * multiply_factor + 0.001;
        
        if i==1&&j==1 || i==1&&j==8 || i==8&&j==1 || i==8&&j==8
            scatterC(s,:) = [1 1 1];
        else
            scatterC(s,:) = [(the_matrix(i,j) - value_min) / colorscaling 0 0];
        end
    end
end

% ʵ�ʻ�ͼ���
scatter(scatterX,scatterY,scatterS, scatterC, 'filled');

% ����BAR������value_max,min��ǣ�
if haveIndicator
    size_max = max( scatterS );
    size_min = min( scatterS );

    color_max = [(value_max - value_min) / colorscaling 0 0];
    color_min = [0 0 0];

    bar_location_x = 9;
    bar_location_ymax = 7;
    bar_location_ymin = 8;

    hold on
    scatter(bar_location_x, bar_location_ymax, size_max, color_max, 'filled');
    
    label_max = num2str( fix( value_max ) );
    if length( label_max ) == 3
        label_location_fix = 0.2;
    elseif length( label_max ) == 2
        label_location_fix = 0.12;
    elseif length( label_max ) == 1
        label_location_fix = 0.1;
    else
        label_location_fix = 0;
    end
    text(bar_location_x - label_location_fix, bar_location_ymax, label_max);
    hold off
end

% ����������
xlabel('MEA Columns');
ylabel('MEA Rows');
axis([0 (networksize+2) 0 (networksize+1)]);
set(gca,'YDir','reverse')

if haveAxes
    set(gca, 'XColor', [0 0 0]);
    set(gca, 'YColor', [0 0 0]);
else
    set(gca, 'XColor', [1 1 1]);
    set(gca, 'YColor', [1 1 1]);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    % ������ܵ缫
    text(0.9, 1, '11');
    text(0.9, 8, '18');
    text(7.85, 1, '81');
    text(7.85, 8, '88');
end

title(the_title,'fontsize',12,'fontweight','bold');

if haveGrid
    grid on;
end

% �����ͼ���
the_frame = getframe;

if ~isFigureWindowStayedOpen
    close(gcf);
end
   
end

