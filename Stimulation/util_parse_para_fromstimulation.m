function [ n e d a s i t ] = util_parse_para_fromstimulation( stimulation )
%UTIL_PARSE_PARA_FROMSTIMULATION ���ߺ������Ӵ̼������ṹ���н����������������ĸ��ִ̼����εı仯��Χ
%   �����̼������ṹ�壬�õ��ڸýṹ���а����Ĵ̼����α仯��Ϣ����
%   �ڱ��ļ��а������ٸ��̼����ڶ��ٸ��缫�����ظ�����ʩ�У����ȡ�����ʱ��ȷ���
%   �ı仯��Χ��
%
%   ���������
%       stimulation���̼������ṹ��
%   ���������
%       n���ܴ̼�����
%       e���̼��漰�ĵ缫
%       d��Phase Duration
%       a��Pulse Amplitude
%       s��Pulse Shape
%       i��Inter-stimulus Interval
%       t��Time Window [start end]
%
%   �ѽ��� 2010��5��4��

% Get length
n = length(stimulation);

% Get time window
t = [stimulation(1).time stimulation(n).time];

% Init
e = [];
d = [];
a = [];
s = [];
i = [];

for j = 1:n
   % Make sure the current parameters are not in each list.
   % If they are not repeated, Add into the list.
   if (~util_find_a_in_b(stimulation(j).elec, e))
       e = [e stimulation(j).elec];
   end

   if (~util_find_a_in_b(stimulation(j).phase_duration, d))
       d = [d stimulation(j).phase_duration];
   end
   
   if (~util_find_a_in_b(stimulation(j).pulse_amplitude, a))
       a = [a stimulation(j).pulse_amplitude];
   end
   
   if (~util_find_a_in_b(stimulation(j).shape, s))
       s = [s stimulation(j).shape];
   end
   
   if (~util_find_a_in_b(stimulation(j).inter_stimulus_interval, i))
       i = [i stimulation(j).inter_stimulus_interval];
   end
end

e = sort(e);
d = sort(d);
a = sort(a);
s = sort(s);
i = sort(i);


end

