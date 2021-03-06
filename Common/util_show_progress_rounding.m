function [] = util_show_progress_rounding( percent )    %#codegen
%UTIL_SHOW_PROGRESS_ROUNDING Show the progress using \|/-
%   Input:
%       percent: 0 - 100
%
%   Created on Jul/22/2010 By Pu Jiangbo
%   Britton Chance Center for Biomedical Photonics
%
%   $Revision:
%       PJB#2011-03-28  Bug fix, dont show 'done' twice.
%       PJB#2011-05-16  Changed to MEX format.
%       PJB#2012-09-16  Changed persistent var name to co-use with
%                       util_show_progress_init()
%       PJB#2012-11-14  Fixed Bug when calling at 100% twice.

coder.extrinsic('fprintf', 'clear');

persistent util_show_progress_rounding_style;   % style of the cycling

if percent == 100 && isempty(util_show_progress_rounding_style)
    return;
end

if isempty(util_show_progress_rounding_style)
    % First time
    fprintf('        ');
    util_show_progress_rounding_style = 1;
end

switch util_show_progress_rounding_style
    case 1
        fprintf(1, '\b\b\b\b\b\b\b');
        fprintf(1, '\\ %3.0f %%', percent);
        util_show_progress_rounding_style = 2;
    case 2
        fprintf(1, '\b\b\b\b\b\b\b');
        fprintf(1, '| %3.0f %%', percent);
        util_show_progress_rounding_style = 3;
    case 3
        fprintf(1, '\b\b\b\b\b\b\b');
        fprintf(1, '/ %3.0f %%', percent);
        util_show_progress_rounding_style = 4;
    case 4
        fprintf(1, '\b\b\b\b\b\b\b');
        fprintf(1, '- %3.0f %%', percent);
        util_show_progress_rounding_style = 1;
end

if percent == 100
    clear util_show_progress_rounding_style;
    fprintf(1, '\b\b\b\b\b\b\b');
    fprintf('Done.\n');
end

end

