function [] = generate_gif_for_animation( movie_frames )
%GENERATE_GIF_FOR_ANIMATION ͨ��Movie֡����GIF����
%   movie_frames��animation_response_score���ɵġ�
%   gif����������ѭ����
%
%   See also ANIMATION_RESPONSE_SCORE, MOVIE2GIF,
%   UTIL_PLOT_8S_INTO_DOTSGRAPH
%
%   �ѽ��� 2009��11��24��

% ��ȡmovie�Ĵ�С������movie����ʹ֮����(��һ֡=����֡)
[h w p] = size( movie_frames(1).cdata );
hf = figure;

% ����طŴ��ڴ�С
set(hf, 'position', [0 0 w h]);
axis off

movie(hf, movie_frames, 1, 30, [0 0 0 0]);

% ����GIF
[filename pathname] = uiputfile('*.gif', 'The animated gif filename');
movie2gif(movie_frames, [pathname filename]);
end

