function [ score_vector ] = util_sti_calc_test_score_arraywide( varargin )
%UTIL_STI_CALC_TEST_SCORE_ARRAYWIDE ����һ�����ڵĴ̼���Ӧ�ɼ�
%   ����һ�����ڵĴ̼���Ӧ�ɼ���������������util_sti_calc_test_score.m
%   ͬʱ�������ṩspif��trif�ĺ���util_load_spike_trigger_mcdstream.m(������ļ��汾)
%
%   ���������
%       stimulating_chid��ʩ�Ӵ̼��ĵ缫������12,87)����ѡ�������������̼��缫���Ա�֤Ϊ0��
%                         ������Ϊα���Ĵ��ڣ���һ����0��
%       calculating_range�������ʱ�䣬msΪ��λ���ò������ݸ�util_sti_calc_test_score
%       filename��Ҫ�򿪵��ļ��������ṩ�������ʾ�Ի���
%
%   ����������
%       score_vector����util_sti_calc_test_score���ص�ƽ���ɼ��г�һ�����С�
%       ���������ͬ��������Щһ��û���źŵĵ缫��������util_convert64to8s���8*8��Ȼ��������ͼ
%       e.g. util_convert_64to8s(s)
%
%   �ѽ��� 2009��11��21��
%    

pvpmod(varargin);

% ��������

if ~exist('calculating_range', 'var')
    % ��ָ��calculating_range����������˳�
    error('The CALCULATING_RANGE must be set.');
end

if ~exist('stimulating_chid', 'var')
    disp('Stimulting Elec: NOT SET');
    have_set_stimulating_elec = 0;
else
    disp(['Stimulating Elec: ' num2str(stimulating_chid)]);
    have_set_stimulating_elec = 1;
end

% ���ļ�
if ~exist('filename', 'var')
    [D spif trif] = util_load_spike_trigger_mcdstream();
else
    [D spif trif] = util_load_spike_trigger_mcdstream('filename', filename);
end

% �����е缫�б�������ÿ���缫�ϵĳɼ����ܵ�һ����������
hwID = 1;
score_vector = zeros( 1,64 );
while hwID < 65
    % �ų��缫
    if hwID == 1 || hwID == 8 || hwID == 57 || hwID == 64
        hwID = hwID + 1;
        continue;
    end
    
    % �ų��̼��缫�����ų��Ļ������ܻ��б������еĳɼ���
    if have_set_stimulating_elec
        if hwID == util_convert_ch2hw(stimulating_chid)
            continue;
        end
    end
    
    % ���㱾�缫����
    [s a ma mi mid] = util_sti_calc_test_score(spif, trif, util_convert_hw2ch(hwID), calculating_range, 1, 0);
    score_vector(hwID) = a;
    
    hwID = hwID + 1;
end

end

