function [ isMatched ] = util_check_trigger_belongs_amp(stimulation, n, amp)
% UTIL_CHECK_TRIGGER_BELONGS_AMP ���ߺ�������鱾��Trigger�Ƿ���ָ���̼���ѹ
%   ���ݴ̼�������stimulation������鱾�Σ����̼������еĵ�n�Σ�trigger�Ƿ�
%   ����ָ����ѹ�ϣ�amp�������ġ�
%
%   �ѽ��� 2010��5��5��

id_in_trigger = stimulation(n).pulse_amplitude;

if (id_in_trigger == amp)
    isMatched = true;
else
    isMatched = false;
end

end
