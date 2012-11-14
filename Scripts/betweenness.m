function [] = betweenness()
% ���ű������ڽ�CCpeak���������˽ṹ����ת���ɶԳ���ʽ���������ͨ���������е�betweeness�����Hub Neuron
% Identify hub neurons in the network

% CCPEAK is extracted by mutual information method
network_matrix = (CCpeak + CCpeak');
for i = 1:64
    for j = 1:64
        if network_matrix(i,j) < 0.1
            network_matrix(i,j) = 0;
        end
    end
end

% Calc the betweenness in this unidirectional weighted network
BC = getbc(network_matrix);

% Generate the list of electrodes
elecs = (1:64);

% Output the hub electrodes list
util_convert_hw2ch(elecs(BC > 100))
BC(BC > 100)'

topoplotgy(CCpeak,0);
end
