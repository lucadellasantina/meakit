function [ isMatched ] = util_check_trigger_belongs_elec(stimulation, n, sti_id)
% UTIL_CHECK_TRIGGER_BELONGS_ELEC ���ߺ�������鱾��Trigger�Ƿ���ָ���缫�ϸ�����
%   ���ݴ̼�������stimulation������鱾�Σ����̼������еĵ�n�Σ�trigger�Ƿ�
%   ����ָ���缫�ϣ�sti_id�������ġ�
%
%   �ѽ��� 2010��5��4��

id_in_trigger = stimulation(n).elec;

if (id_in_trigger == sti_id)
    isMatched = true;
else
    isMatched = false;
end

end
