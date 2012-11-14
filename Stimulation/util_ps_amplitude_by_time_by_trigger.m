function [ ax_x spike_number_in_each_bin spike_amplitude_mean spike_amplitude_std] = util_ps_amplitude_by_time_by_trigger( triggerif, ...
    spif, ...
    D, ...
    chid, ...
    binsize, ...
    timescope, ...
    trigger_range, ...
    isManualTrigger, ...
    peakType)
%UTIL_PS_AMPLITUDE_BY_TIME_BY_TRIGGER ���ߺ���������MCS����Ϣ������PS�ķ�����ʱ����ķֲ�
%   ����������ķ��ȷֲ���Ϣ������ʱ��ֲ��������Ǹ��ʷֲ������ʷֲ��ĺ�����util_psth_amplitude_by_trigger
%   triggerif = trigger information from mcd file
%   spif = spike information from mcd file
%   D = datastrm��õĶ���
%   binsize = bin width of each histogram in millisecond
%   timescope = [start end], of the time scope of counting spikes
%   trigger_range = [start end], triggers counts into the psth
%   isManualTrigger = �Ƿ����ֶ����Trigger���ֶ�Trigger���ܻ����Trigger����ΪSpike
%   peakType = �����Ǽ�¼��Сֵ(0)�����ֵ(1)����-��ֵ(2)��
%
%   ax_x = X������
%   spike_number_in_each_bin = ÿ��bin�ڵ�Spike������Ŀ���ۼӣ�
%   spike_amplitude_mean = ÿ��bin�ڵ�Spike���ȵľ�ֵ
%   spike_amplitude_std = ÿ��bin��Spike���ȵ�STDEV
%   
%   ʾ����
%   [ ax_x spike_number_in_each_bin spike_amplitude_mean spike_amplitude_std] = util_ps_amplitude_by_time_by_trigger(triggerif,spif,D,34,5,[-50 450],[81 100],1,2);
%   �Ǽ���ͨ��34�ϣ�Triggerǰ��-50,450ms���Spike�ķ�����ʱ��ķֲ�������Trigger�ķ�Χ
%   �ǵ�81-100��Trigger������Triggerǰ��0.5 ms���ֶ���Trigger��α��Ϣ��
%   ����Ϣ������һ�������ʱ��ÿ5 msһ��bin
%
%   �ѽ��� - 2009��5��30��
%   �ѽ��� - 2009��5��31��
%       Bug fix:ͳ��Spike����ֵ��ԶΪ75.

% ͨ�����ת��
hwid = util_convert_ch2hw(chid);

% ����˼·
% ��ָ����Trigger��Χ��ѭ�����������е�Spike����Binsize��Ϊһ��ʱ��Σ���������timescope[].
% ÿ��Binsize�ڵ�Spike Amplitude��ƽ�������������Ǹ�ʱ����ڵ�Response�ķ��ȡ�

% Ϊ��������ٶȣ�Ԥ�ȴ���FORѭ���з����õı���
this_spif_spiketime = spif.spiketimes{hwid}; % ����PSTHͨ����SPIF��Ϣ���Ʊ�
this_spif_spikevalue = ad2muvolt( D, spif.spikevalues{hwid} ); % SPIKETIME��Ϣ����

% ������ж��ٸ�Bin������Ԥ��ÿ������Ľ��
if mod(timescope(2) - timescope(1), binsize)
    error('binsize����Ҫ���Ա�timescope�ķ�Χ������.');
end
bin_number = (timescope(2) - timescope(1)) / binsize + 1;

% ÿ��Bin�ڵ�Spike����Ŀ
spike_number_in_each_bin = zeros(1, bin_number);

% ÿ��Bin�ڵ�Spike�ķ��ȵĶ���
spike_amplitude_in_each_bin = cell(1, bin_number);

% ÿ��Bin�ڵ�Spike�ķ��ȵ�ƽ��ֵ
spike_amplitude_mean = zeros(1, bin_number);

% ÿ��Bin�ڵ�Spike�ķ��ȵ�STD
spike_amplitude_std = zeros(1, bin_number);

% ����X��
ax_x = timescope(1):binsize:timescope(2);

% ��Trigger�б���
for i = trigger_range(1):trigger_range(2)
    % ��¼ÿ��Trigger�ľ���ʱ��
    this_trigger_time = triggerif.times(i);
    % ȷ����һ��Bin�Ŀ�ʼ�����һ��Bin�Ľ���
    first_bin_start = timescope(1) + this_trigger_time;
    last_bin_start = timescope(2) - binsize + this_trigger_time;
    
    % ��SPIF��Ѱ�Ҹ�����Triggerʱ��Timescope[]��Χ�ڵ�Spike
    % ��������
    % ����Trigger��ʱ����SPIF.spiketime�в�ѯÿ��Bin��Χ�ڵ�Spike����������
    % Ȼ���������������ȥ�ҵ�spikevalue�ڵ�spikevalue,ƽ��֮�����ڽ����
    % Ȼ�����bin��Χ������timescope�����е�ʱ���
    
    % ȷ���Ƿ����㣬���ֶ���Trigger��������̷�Χ(0.5ms)
    % �����Χ��ͨ�õģ�����ķ��������н���ͻ��isManualTrigger������
    if isManualTrigger
        if first_bin_start < this_trigger_time
            before_trigger = this_trigger_time - 0.5 - binsize;
        else
            before_trigger = NaN;
        end
        after_trigger = this_trigger_time + 0.5;
    else
        if first_bin_start < this_trigger_time
            before_trigger = this_trigger_time;
        else
            before_trigger = NaN;
            after_trigger = this_trigger_time;
        end
    end
    
    % ���մ̼�ʱ�̵㽫ʱ�䷶Χ�ֳ�����
    % ��ÿ�ε�ѭ���У���[last next)�ڵ�spike�������з���Cell������б���
    
    % ����ǰ��Σ�����еĻ����̼�ʱ��ǰ�Ĳ��֣�
    % ���������ǰ��Σ���before_trigger��NaN�������ѭ���������
    
    bin_counter = 1; % ѭ���±�
    if ~isnan(before_trigger)
        for j = first_bin_start:binsize:before_trigger
            % ��ÿ��Bin�ڵ�Spike�ķ��ȵ�ֵ�������б��У���ѭ�������е�Trigger�����д���
            
            % ����peakTypeȷ��Ҫ���ȵļ��㷽��(0:min, 1:max, 2:max-min)
            % spike_amplitude��һ����ʱ�ı��������ڴ��ĳ��Bin��Χ�ڵ�Spike�ķ���ֵ
            switch(peakType)
                case 0
                    spike_amplitude = min( this_spif_spikevalue( :, ...
                        this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) );
                case 1
                    spike_amplitude = max( this_spif_spikevalue( :, ...
                        this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) );
                case 2
                    spike_amplitude = max( this_spif_spikevalue( :, ...
                        this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) ) - ...
                        min( this_spif_spikevalue( :, ...
                        this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) );
            end
            spike_amplitude_in_each_bin{1,bin_counter} = ...
                [ spike_amplitude_in_each_bin{1,bin_counter} spike_amplitude ];
           
            bin_counter = bin_counter + 1;
        end
    end
   
    % �������
    % bin_counter��Ŀǰ����Ҫ�����Bin��Index�����ܸı�
    for j = after_trigger:binsize:last_bin_start
        switch(peakType)
            case 0
                spike_amplitude = min( this_spif_spikevalue( :, ...
                    this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) );
            case 1
                spike_amplitude = max( this_spif_spikevalue( :, ...
                    this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) );
            case 2
                spike_amplitude = max( this_spif_spikevalue( :, ...
                    this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) ) - ...
                    min( this_spif_spikevalue( :, ...
                    this_spif_spiketime >= j & this_spif_spiketime < j+binsize ) );
        end
        spike_amplitude_in_each_bin{1,bin_counter} = ...
            [ spike_amplitude_in_each_bin{1,bin_counter} spike_amplitude ];

        bin_counter = bin_counter + 1;
    end
end

% ������
% spike_amplitude_in_each_bin��������˸���Bin��Spike���ȵ�ֵ��min/max/p2p����
for i=1:bin_number
    spike_number_in_each_bin(1,i) = length( spike_amplitude_in_each_bin{1,i} );
    spike_amplitude_mean(1,i) = mean( spike_amplitude_in_each_bin{1,i} );
    spike_amplitude_std(1,i) = std( spike_amplitude_in_each_bin{1,i} );
end

end

