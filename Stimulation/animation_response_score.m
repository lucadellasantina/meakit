function [ movie_frm ] = animation_response_score( result_cell_array )
%ANIMATION_RESPONSE_SCORE ���ɼ�Cell��������ݻ��Ƴɶ���
%   ����UTIL_STI_CALC_TEST_SCORE_MULTIPLE_ARRAYWIDE�����Ľ�����󣨷Ǿ�ֵ�󣬶��Ǳ�����ÿ�δ̼���Ӧ����
%   �ĺ��漸�Լ���������������������е����ݷֲ������֡���ж��ٴδ̼������ж���֡������ÿһ֡�Ľ������plot_mea_dotsgraph����
%   ��ͼ������ͼ�δ���frame���У���Ϊ������ء�������п�������movie�������Ƴɵ�Ӱ����movie2gif�������Ƴ�gif������
%
%   ���������util_sti_calc_test_score_multiple_arraywide�����Ľ��
%   ���������movie�ļ�
%
%   See also PLOT_MEA_DOTSGRAPH,
%   UTIL_STI_CALC_TEST_SCORE_MULTIPLE_ARRAYWIDE,
%   UTIL_PLOT_8S_INTO_DOTSGRAPH
%
%   �ѽ��� 2009��11��24��


% ���㶯����֡��
% �����Ǽ���result_cell_array���������cell��ά����ȡ����

max_dimension = 0;

for i = 1:64
    this_dimension = size( result_cell_array{i}, 2 );
    if this_dimension > max_dimension
        max_dimension = this_dimension;
    end
end

number_of_frames = max_dimension;

% ��ÿ֡���Ƴɶ���
% �����ǽ�����������ÿ�δ̼�����Ӧȡ���������ɰ��յ缫���л��Ƴ�ͼ������getframe���档
% ��ͼ���������ȱ�д��plot_mea_dotsgraph�������

for i = 1:number_of_frames
    tmp_vector = zeros(1,64);
    for hwID = 1:64
        if size( result_cell_array{hwID},2 ) < number_of_frames
            tmp_vector(hwID) = 0;
        else
            tmp_vector(hwID) = result_cell_array{hwID}(i);
        end
    end
    
    tmp_vector_s = util_convert_64to8s(tmp_vector);
    
    movie_frm(i) = util_plot_8s_into_dotsgraph('the_matrix', tmp_vector_s, 'haveAxes', 0, 'isFigureWindowStayedOpen', 1, 'haveIndicator', 1);
end
end

