function [] = script_trigger_psth_amplitude_distribution()
%SCRIPT_TRIGGER_PSTH_AMPLITUDE_DISTRIBUTION �ű�������̼�Trigger���Spikeͳ����Ϣ
%   1����������ʱҪ������һ��MCD�ļ���SPIKE��
%   2�����ж��Trigger���������ڣ�����Ҫ���û�ѡ��
%   ���������������ֶ����� -_-!...
%
%   �ѽ��� - 2009��5��22��
%   �ѽ��� - 2009��5��31��
%       ����ͳһ��util_load_spike_trigger_mcdstream_whold_length()��������ȡspif/trigger
%       ��Ϣ��
%   �ѽ��� - 2009��7��3��
%       Bug Fix: �޸�����û����Ӧʱ��psth_yΪ�յ�Bug��

% ���ļ�����ȡmcd������
[D spif triggerif] = util_load_spike_trigger_mcdstream();

% ��ȡͨ����
chid = input('������ͨ���ţ�');

% Bin�Ĵ�С������ʱ���BinҲ�Ƿ��ȵ���ԾBin����Ȼ�����Լ��ģ�
binsize = 5;

% ��ȡTrigger������Ŀ
trigger_total_counts = size(triggerif.times,2);
disp(['�ܹ��� ' num2str(trigger_total_counts) '��Trigger']);

% ����ÿ����������Ҫ������ٸ�Trigger
trigger_step_counts = 20;

% ����PSTH���ǵ�ʱ�䷶Χ
psth_range = [-50 450];

% ����PSTH��PS���ȷֲ�

for i = 1:trigger_step_counts:trigger_total_counts
    trigger_end = i + trigger_step_counts - 1;
    disp(['���ڴ����' num2str(i) '��' num2str(trigger_end) '��Trigger����Ϣ']);
    
    [psth_x psth_y] = util_psth_by_trigger( triggerif, spif, chid, binsize, psth_range, [i trigger_end], 1, 1 );
%     [psAMP_x psAMP_y] = util_psth_amplitude_by_trigger( triggerif, spif, D, chid, binsize, psth_range, [i trigger_end], 1, 1, 2 );
    
%     if isempty(psth_y)
%         psth_y = zeros(1, size(psth_x, 2));
%     end
%     
%     figure, bar(psth_x, psth_y), title(['PSTH' num2str(i) '-' num2str(trigger_end)]),xlabel('Time(ms)'),ylabel('Probability');
%     
%     if ~isempty(psAMP_y)
%         figure, bar(psAMP_x, psAMP_y), title(['AMPLITUDE - PSTH' num2str(i) '-' num2str(trigger_end)]),xlabel('Amplitude(uV)'),ylabel('Probability');
%     end
        
    
    
end


end

