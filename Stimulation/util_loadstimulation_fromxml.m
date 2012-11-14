function [ sti_seq ] = util_loadstimulation_fromxml( filename )
%UTIL_LOADSTIMULATION_FROMXML ���ߺ������Ӹ�����XML�ļ�������̼�����
%   �Ӹ�����XML�ļ�������̼�����
%   ���������Filename��ָ���Ĵ̼������ļ���һ������RBS����
%   ����̼������ṹ�壺sti_seq
%
%   �ѽ��� 2010��5��3��

% ��XML�ļ�
xDoc = xmlread(filename);

% ��ȡ�ڵ�
all_items = xDoc.getElementsByTagName('node');

% ��ʼ��������
h = waitbar(0, 'Please wait...');
set(h,'Name','Please wait while reading:');

% Note that the item list index is zero-based.
for i = 0:all_items.getLength - 1
    sti_seq(i+1) = parse_node_byname(all_items.item(i));
    waitbar(i/(all_items.getLength - 1), h, strrep(filename, '\', '\\'));
    % strrep is used to deal with the TeX intepreter (path\string)
end

% �رս�����
close(h);

end

function [result] = parse_node_byname(node)
% PARSE_NODE_BYNAME ����XML�Ľڵ㣬���ڵ��е�������Ϊһ���ṹ�巵��
%   ������
%       ���룺node���ڵ�
%       �����result������֮�����ڵ�ȫ����Ϣ�Ľṹ��
%
%   �ѽ��� 2010��5��3��


%[#text:      1     11:00:34     47            400            300
% 3000            PN   ]
% getLength-1����Ϊ���item�б��Ǵ�0��ʼ�ģ�����Ҫ-1��
% ���ǵ�һ����#text������������Ϣ#text���ڶ������ã����������ã���step=2
% �����Ի�ȡ���е���Ϣ�����ڽṹ���У����ǣ����ܺܺõ��ж���Щ����������Ϣ����Щ���ַ���
% for i=1:2:node.getLength-1
    % result.(char(node.getChildNodes.item(i).getNodeName)) = char(node.getChildNodes.item(i).getTextContent)
% end

result.index = str2num(char(node.getChildNodes.item(1).getTextContent));
result.time = strtrim(char(node.getChildNodes.item(3).getTextContent));
result.elec = str2num(char(node.getChildNodes.item(5).getTextContent));
result.phase_duration = str2num(char(node.getChildNodes.item(7).getTextContent));
result.pulse_amplitude = str2num(char(node.getChildNodes.item(9).getTextContent));
result.inter_stimulus_interval = str2num(char(node.getChildNodes.item(11).getTextContent));
result.shape = strtrim(char(node.getChildNodes.item(13).getTextContent));

end

