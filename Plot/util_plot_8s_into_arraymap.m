function [ handle ] = util_plot_8s_into_arraymap( data, closed )
%UTIL_PLOT_8S_INTO_ARRAYMAP ���ߺ����������ݻ��Ƴ�8*8��ͼ������Daniel���£�
%   ����������ݰ���ָ��Ҫ����Ƴ�8*8�Ų�������ͼ
%
%   ���������
%       closed���ӵص缫������������ʾ�ĵ缫����[15 33]��
%       data����������ڻ�ͼ�����ݣ���������Ҫ��ѭһ���ĸ�ʽ
%           ��data.ch11.x,y����Ҫ��ͼ������
%       
%   ���������
%       handle��ͼ����
%
%   �ѽ��� 2010��5��6��

figure('Name','MEA Plot')
axis off;
set(gca,'xtick',[],'ytick',[]);

% ��ʼ���������ֵ
max_X = -Inf;
min_X = Inf;
max_Y = -Inf;
min_Y = Inf;

for hwid = 1:64
    % �жϵ�ǰsubplotλ��
    if ~(util_convert_hw2ch(hwid) == 11 || ...
         util_convert_hw2ch(hwid) == 18 || ...
         util_convert_hw2ch(hwid) == 81 || ...
         util_convert_hw2ch(hwid) == 88 || ...
         ~isempty(find(closed == util_convert_hw2ch(hwid), 1)))
        % ������
        subplot(8,8,getpos(util_convert_hw2ch(hwid)));
        try
            errorbar(data.(['ch' num2str(util_convert_hw2ch(hwid))]).x, data.(['ch' num2str(util_convert_hw2ch(hwid))]).y, data.(['ch' num2str(util_convert_hw2ch(hwid))]).e,'k');
        catch
            % �����ݣ��򽫴˵缫�Զ����뵽closed�б�
            closed = [closed util_convert_hw2ch(hwid)];
        end
        if (isempty(find(closed==util_convert_hw2ch(hwid), 1)))
            % ��ȡ������ֵ
            max_X = getbigger(max_X, max(data.(['ch' num2str(util_convert_hw2ch(hwid))]).x));
            max_Y = getbigger(max_Y, max(data.(['ch' num2str(util_convert_hw2ch(hwid))]).y));
            min_X = getsmaller(min_X, min(data.(['ch' num2str(util_convert_hw2ch(hwid))]).x));
            min_Y = getsmaller(min_Y, min(data.(['ch' num2str(util_convert_hw2ch(hwid))]).y));
        end
        
        set(gca,'xtick',[],'ytick',[])
        axis off;
        drawnow;
    end
end

% �ٴ�ѭ��ͳһ������
for hwid = 1:64
    % �жϵ�ǰsubplotλ��
    if (util_convert_hw2ch(hwid) == 88)
        % ��������
        subplot(8,8,getpos(util_convert_hw2ch(hwid)));
        plot([max_X max_X], [min_Y max_Y],'k');
        hold on;
        plot([min_X max_X], [min_Y min_Y],'k');
        hold off;
        text(max_X,max_Y,num2str(max_Y));
        text(max_X,min_Y,['(' num2str(max_X) ',' num2str(min_Y) ')']);
        text(min_X,min_Y,num2str(min_X));
    elseif (find(closed == util_convert_hw2ch(hwid)))
        % ��X
        subplot(8,8,getpos(util_convert_hw2ch(hwid)));
        plot([min_X max_X],[max_Y min_Y],'k');
        hold on;
        plot([min_X max_X],[min_Y max_Y],'k');
        hold off;
    end
    
    subplot(8,8,getpos(util_convert_hw2ch(hwid)));
    set(gca,'xtick',[],'ytick',[])
    if (util_convert_hw2ch(hwid) == 11 || ...
        util_convert_hw2ch(hwid) == 18 || ...
        util_convert_hw2ch(hwid) == 81 || ...
        util_convert_hw2ch(hwid) == 88)
        axis off;
    else
        axis on;
        box off;
        set(gca,'XColor',[1 1 1], 'YColor', [1 1 1]);
    end
    % ͳһ���������Сֵ
    xlim([min_X max_X]);
    ylim([min_Y max_Y]);
    drawnow;
end


handle = gcf;

end


function [pos] = getpos(channelID)
%GETPOS ��������������ĳͨ����8*8ͼ�ϵ�indexλ��
%   �ѽ��� 2010��5��6��

chID = num2str(channelID);
colID = str2num(chID(1));
rowID = str2num(chID(2));

pos = (rowID - 1) * 8 + colID;

end

function [val] = getbigger(a,b)
%GETBIGGER ��������������a,b�нϴ����
%   �ѽ��� 2010��5��6��

if (a>b)
    val = a;
else
    val = b;
end

end

function [val] = getsmaller(a,b)
%GETBIGGER ��������������a,b�н�С����
%   �ѽ��� 2010��5��6��

if (a<b)
    val = a;
else
    val = b;
end

end