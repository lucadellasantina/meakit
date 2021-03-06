function makeStrfGwn()

% GUI for calculating the spatiotemporal receptive field.
%
% here a couple of parameters and methods can be chosen
% used as UI to parameter value pair generation for the
% command line function sortSpikes.m
%
% H. Walz Feb 2008
% This function belongs to FIND_GUI Toolbox project
% http://find.bccn.uni-freiburg.de


global nsFile;

global BUTTON_HEIGHT;
global BUTTON_WIDTH;
global LABEL_HEIGHT;
global MESSAGEBAR_PANEL_HEIGHT;
global MESSAGEBAR_LEFT_OFFSET;
global MESSAGEBAR_RIGHT_OFFSET;

% the global ones are needed within the
% resize function
global MAIN_MIN_WIDTH;
global MAIN_MIN_HEIGHT;



try

    % Check if the makeStrfSpikes GUI is already open
    if ishandle(findobj('tag', 'makeStrfGwnGUI'))
        close(findobj('tag', 'makeStrfGwnGUI'));
    end;

    % GUI window
    GUIxPos=80;
    GUIyPos=40;
    GUIwidth=150;
    GUIheight=27;


    %some panels are flexible in one or both dimensions, in these cases the
    %values below are minimal values
    leftPanelHeight=15;
    leftPanelWidth=50;
    middlePanelWidth=50;
    middlePanelHeight=15; 
    rightPanelHeight=15;
    rightPanelWidth=50;
    bottomPanelHeight=8;
    bottomPanelWidth=GUIwidth;
    messageBarPanelWidth=GUIwidth-MESSAGEBAR_LEFT_OFFSET-MESSAGEBAR_RIGHT_OFFSET;
    topPanelHeight=GUIheight-bottomPanelHeight-leftPanelHeight;
    
    GUIwindow=figure('Units','characters',...
        'Position',[GUIxPos GUIyPos GUIwidth GUIheight], ...
        'Tag','makeStrfGwnGUI', ...
        'Name','receptive field calculation with gaussian white noise',...
        'MenuBar','none',...
         'NumberTitle','off',...
        'resize','off');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% panels %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %size parameters see above main window initialization
    mainWindow=uipanel('Parent',GUIwindow,...
        'Units','characters',...
        'Position',[0 MESSAGEBAR_PANEL_HEIGHT ...
        GUIwidth (GUIheight-MESSAGEBAR_PANEL_HEIGHT)],...
        'Tag','makeStrfGwnGUI_centralPanel',...
        'BackgroundColor', [0.8 0.8 0.8]);

    messageBarPanel=uipanel('Parent',GUIwindow,...
        'Units','characters',...
        'Position',[0 0 ...
        GUIwidth MESSAGEBAR_PANEL_HEIGHT],...
        'Tag','makeStrfGwnGUI_messageBarPanel');


    topPanel=uipanel('Parent',mainWindow,...
        'Units','characters',...
        'Position',[0 ...
        (bottomPanelHeight+rightPanelHeight)...%+MESSAGEBAR_PANEL_HEIGHT)...
        bottomPanelWidth topPanelHeight],...
        'Tag','makeStrfGwnGUI_topPanel',...
        'BackgroundColor', [0.8 0.8 0.8]);
    

    leftPanel=uipanel('Parent',mainWindow,...
        'Units','characters',...
        'Position',[0 ...
        bottomPanelHeight...%+MESSAGEBAR_PANEL_HEIGHT)...
        leftPanelWidth leftPanelHeight],...
        'Tag','makeStrfGwnGUI_leftPanel',...
        'BackgroundColor', [0.8 0.8 0.8]);
    
    
    middlePanel=uipanel('Parent',mainWindow,...
        'Units','characters',...
        'Position',[leftPanelWidth ...
        bottomPanelHeight...%+MESSAGEBAR_PANEL_HEIGHT)...
        middlePanelWidth middlePanelHeight],...
        'Tag','makeStrfGwnGUI_middlePanel',...
        'BackgroundColor', [0.8 0.8 0.8]);
    
    
    rightPanel=uipanel('Parent',mainWindow,...
        'Units','characters',...
        'Position',[leftPanelWidth + middlePanelWidth ...
        bottomPanelHeight...%+MESSAGEBAR_PANEL_HEIGHT)...
        rightPanelWidth rightPanelHeight],...
        'Tag','makeStrfGwnGUI_rightPanel',...
        'BackgroundColor', [0.8 0.8 0.8]);
   
    bottomPanel=uipanel('Parent',mainWindow,...
        'Units','characters',...
        'Position',[0 0 ...%MESSAGEBAR_PANEL_HEIGHT ...
        bottomPanelWidth bottomPanelHeight],...
        'Tag','makeStrfGwnGUI_bottomPanel',...
        'BackgroundColor', [0.8 0.8 0.8]);

 
    
    

    
        
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get the data sets for stimulus and response respectively %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 1)the stimulus
    % text label
    
    uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.15    0.92    0.7    0.07],...
        'Style','text',...
        'String','edit stimulus information',...
        'Tag','makeStrfGwnGUI_InfoLabelText',...
        'Enable','on');
    
    uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.1    0.81    0.8    0.07],...
        'Style','text',...
        'String','select stimulus from workspace',...
        'Tag','makeStrfGwnGUI_selectedEntityLabelText',...
        'Enable','on');
   
    h_listbox=uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.25  0.4  0.5  0.4],...
        'Style','ListBox',...
        'String', evalin('base','who'),...
        'Tag','makeStrfGwnGUI_stimulusSelectListBox',...
        'Enable','on');
    
   uicontrol('Parent',topPanel,...
        'Units','normalized',...
        'Position',[ 0.25  0.2  0.5  0.3 ],...
        'Style','text',...
        'String','for information read the tutorial',...
        'Tag', 'makeStrfGwnGUI_workLabelText',...
        'Enable','on');
        
    
    %%% edit refresh rate of stimulus
    uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.55    0.29    0.4    0.07],...
        'Style','text',...
        'String','frame duration [sec]',...
        'Tag','makeStrfGwnGUI_selectedRateLabelText',...
        'Enable','on');
    uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.6   0.19   0.3  0.09],...
        'Style','edit',...
        'String','[0.05]',...
        'Tag','makeStrfGwnGUI_selectedFrameDuration',...
        'Enable','on');

     
    %specify memory
    uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.05    0.29    0.4    0.07],...
        'Style','text',...
        'String','[no.] memorable frames',...
        'Tag','makeStrfGwnGUI_selectedMemoryLabelText',...
        'Enable','on');
    uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.1    0.19    0.3  0.09],...
        'Style','edit',...
        'String','[5]',...
        'Tag','makeStrfGwnGUI_selectedMemory',...
        'Enable','on');
    %edit event entity
      uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.25    0.11    0.5  0.07],...
        'Style','text',...
        'String','event [entityID]',...
        'Tag','makeStrfGwnGUI_selectedEventEntityLabelText',...
        'Enable','on');
    uicontrol('Parent',leftPanel,...
        'Units','normalized',...
        'Position',[0.25    0.01    0.5  0.09],...
        'Style','edit',...
        'String','[]',...
        'Tag','makeStrfGwnGUI_selectedEventEntity',...
        'Enable','on');

    
    
    %%%%% 2)the response
    uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.15    0.92    0.7   0.07],...
        'Style','text',...
        'String','edit response information',...
        'Tag','makeStrfGwnGUI_InfoLabelText',...
        'Enable','on');
  uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.25    0.75    0.5    0.07],...
        'Style','text',...
        'String','response [entityIDs]',...
        'Tag','makeStrfGwnGUI_selectedResponseEntitiesLabelText',...
        'Enable','on');
    uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.4    0.65    0.2  0.09],...
        'Style','edit',...
        'String','[]',...
        'Tag','makeStrfGwnGUI_selectedResponseEntities',...
        'Enable','on');


  
    
    %determine evaluation trial
    uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.05   0.2    0.9   0.07],...
        'Style','text',...
        'String','[no.] of estimation and validation trials',...
        'Tag','makeStrfGwnGUI_selectedTrialsLabelText',...
        'Enable','on');
    uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.2    0.1   0.25  0.09],...
        'Style','edit',...
        'String','[1:9]',...
        'Tag','makeStrfGwnGUI_selectedEstimationTrials',...
        'Enable','on');
    uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.55    0.1  0.25  0.09],...
        'Style','edit',...
        'String','[10]',...
        'Tag','makeStrfGwnGUI_selectedEvaluationTrials',...
        'Enable','on');
    
    
     
    %%%%%%%%%determine trial duration
   uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.05  0.49  0.4   0.07],...
        'Style','text',...
        'String','trial duration [sec]',...
        'Tag','makeStrfGwnGUI_selectedTrialsDurationLabelText',...
        'Enable','on');
    uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.15    0.39   0.2  0.09],...
        'Style','edit',...
        'String','[80]',...
        'Tag','makeStrfGwnGUI_selectedTrialDuration',...
        'Enable','on'); 
     %%%%%%%%%determine base duration
   uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.54  0.49   0.42   0.07],...
        'Style','text',...
        'String','base duration [sec]',...
        'Tag','makeStrfGwnGUI_selectedBaseDurationLabelText',...
        'Enable','on');
    uicontrol('Parent',middlePanel,...
        'Units','normalized',...
        'Position',[0.65    0.39   0.2  0.09],...
        'Style','edit',...
        'String','[1]',...
        'Tag','makeStrfGwnGUI_selectedBaseDuration',... 
                'Enable','on'); 
    
     
    %%%%%%%%%%%%%%%%%%%%%%%%%BUTTONS
      
    %%%%% 2)the response
    uicontrol('Parent',rightPanel,...
        'Units','normalized',...
        'Position',[0.15    0.92    0.7   0.07],...
        'Style','text',...
        'String','some preprocessing functions',...
        'Tag','makeStrfGwnGUI_InfoLabelText',...
        'Enable','on');
    
       % button to linearize the stimulus
    uicontrol('Parent',rightPanel,...
        'Units','normalized',...
        'Position',[0.05 0.68 0.9 0.1],... 
        'Style','pushbutton',...
        'String','linearize stim data if more than 2dim',...
        'Tag','makeStrfGwnGUI_linearizeStimulusPushbutton',...
        'Enable','on',...
        'Callback',@linearizeStimulusPushbuttonCallback); 
       % button to linearize the stimulus
    uicontrol('Parent',rightPanel,...
        'Units','normalized',...
        'Position',[0.1    0.53    0.8  0.1],... 
        'Style','pushbutton',...
        'String','extract trial onsets by black frames',...
        'Tag','makeStrfGwnGUI_extractOnsetsPushbutton',...
        'Enable','on',...
        'Callback',@extractOnsetsPushbuttonCallback); 
    uicontrol('Parent',rightPanel,...
        'Units','normalized',...
        'Position',[0.2    0.38 0.6  0.1],... 
        'Style','pushbutton',...
        'String','construct own spike train',...
        'Tag','makeStrfGwnGUI_constructSTPushbutton',...
        'Enable','off',...
        'Callback',@constructSTPushbuttonCallback); 
     %%%%%%button to align trials from response to trial onsets of%%%%%%%%%
            % event data
    uicontrol('Parent',rightPanel,...
        'Units','normalized',...
        'Position',[0.25    0.24    0.5  0.1],... 
        'Style','pushbutton',...
        'String','plot PSTH and raster',...
        'Tag','makeStrfGwnGUI_processResponsePushbutton',...
        'Enable','on',...
        'Callback',@processResponsePushbuttonCallback);
          %%%%%%button to find and cut putative Strfs%%%%%%%%%
     uicontrol('Parent',rightPanel,...
        'Units','normalized',...
        'Position',[0.15    0.1  0.7 0.1],... 
        'Style','pushbutton',...
        'String','find and cut putative Centers',...
        'Tag','makeStrfGwnGUI_findStrfPushbutton',...
        'Enable','on',...
        'Callback',@findStrfPushbuttonCallback); 
    
 %%%%   the functions in the bottom panel  %%%%% 
        
 %%%%%%button to calculate STA%%%%%%%%%
    uicontrol('Parent',bottomPanel,...
        'Units','normalized',...
        'Position',[0.05    0.6    0.15  0.18],... 
        'Style','pushbutton',...
        'String','calculate STA',...
        'Tag','makeStrfGwnGUI_calculateStaPushbutton',...
        'Enable','on',...
        'Callback',@calculateStaPushbuttonCallback); 
    
    %%%%%%button to calculate STC%%%%%%%%%
    uicontrol('Parent',bottomPanel,...
        'Units','normalized',...
        'Position',[0.05    0.3   0.15  0.18],... 
        'Style','pushbutton',...
        'String','calculate STC',...
        'Tag','makeStrfGwnGUI_calculateStcPushbutton',...
        'Enable','on',...
        'Callback',@calculateStcPushbuttonCallback); 
    
    %%%%%% button to determine nonlinearity %%%%%%%%%
    uicontrol('Parent',bottomPanel,...
        'Units','normalized',...
        'Position',[0.24 0.3 0.18 0.18],... 
        'Style','pushbutton',...
        'String','nonlinearity with STA',...
        'Tag','makeStrfGwnGUI_determineNonlinStaPushbutton',...
        'Enable','on',...
        'Callback',@determineNonlinStaPushbuttonCallback); 
    
    %%%%%%%%%%%%%%%% button to calculate linear prediction %%%%%%
    uicontrol('Parent',bottomPanel,...
        'Units','normalized',...
        'Position',[0.24    0.6    0.18  0.18],... 
        'Style','pushbutton',...
        'String','linear prediction',...
        'Tag','makeStrfGwnGUI_determinePredPushbutton',...
        'Enable','on',...
        'Callback',@determinePredPushbuttonCallback); 
    
    %%%%%% button to determine statistics %%%%%%%%
    uicontrol('Parent',bottomPanel,...
        'Units','normalized',...
        'Position',[0.46    0.6    0.20  0.18],... 
        'Style','pushbutton',...
        'String','statistics of spike train',...
        'Tag','makeStrfGwnGUI_StatisticsPushbutton',...
        'Enable','on',...
        'Callback',@determineStatisticsPushbuttonCallback); 

     
    %%%%%% button to determine information measures %%%%%%%%
    uicontrol('Parent',bottomPanel,...
        'Units','normalized',...
        'Position',[0.46    0.3    0.20  0.18],... 
        'Style','pushbutton',...
        'String','information measures',...
        'Tag','makeStrfGwnGUI_InfoPushbutton',...
        'Enable','on',...
        'Callback',@determineInfoPushbuttonCallback); 
    
        %%%%%% button to determine coherence between linear prediction and response %%%%%%%%
    uicontrol('Parent',bottomPanel,...
        'Units','normalized',...
        'Position',[0.7    0.6    0.25  0.18],... 
        'Style','pushbutton',...
        'String','coherence predictor vs. response',...
        'Tag','makeStrfGwnGUI_CoherencePushbutton',...
        'Enable','on',...
        'Callback',@determineCoherencePushbuttonCallback); 


catch
    %if error occurs here, the window is closed, the error is rethrown
    %    and then catched by the main window
    close(findobj('tag', ',makeStrfGwnGUI'));
    rethrow(lasterror);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                 %%%% FUNCTIONS %%%%
%%%%%%%%%%%%% linearize the stimulus data%%%%%%%%%%%%%%%%

  
function linearizeStimulusPushbuttonCallback(a,b)
% Get workspace stimulus variable
main_workspace=evalin('base','who');
selectedStimulus_tmp=main_workspace{get(findobj('Tag', 'makeStrfGwnGUI_stimulusSelectListBox'),'Value')};
selectedStimulus=evalin('base',selectedStimulus_tmp);
%get selected memory
selectedMemory=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedMemory'),'String'));
trialDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedTrialDuration'),'String'));
refreshRate=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedFrameDuration'),'String'));
%call linearizeStimulus
if isempty(selectedStimulus)
    error('no data loaded!');
else
    global linearizedStimulus;
    linearizedStimulus=linearizeStimulus('x',selectedStimulus,'n', selectedMemory,'t',trialDuration, 'frameDuration',refreshRate);
end
disp('done linearizing stimulus');


function processResponsePushbuttonCallback(a,b)
global linearizedStimulus;
selectedResponse=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedResponseEntities'),'String'));
selectedEvent=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedEventEntity'),'String'));
estimationTrials=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedEstimationTrials'),'String'));
refreshRate=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedFrameDuration'),'String'));
trialDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedTrialDuration'),'String'));
baseDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedBaseDuration'),'String'));
global idx;
global PSTH;
[idx,PSTH]=processResponse('responseEntities',selectedResponse,'eventEntity',selectedEvent, 'trialDuration',trialDuration,'trials',estimationTrials,'baseDuration',baseDuration);
disp('done plotting data');

function calculateStaPushbuttonCallback(a,b)
% Get stimulus variable
global linearizedStimulus idx STA STA_mean idx
% if there isn't a variable linearizedStimulus check if stimulus might have
% been linearized by other means
if size(linearizedStimulus,1)==0
    main_workspace=evalin('base','who');
    selectedStimulus_tmp=main_workspace{get(findobj('Tag', 'makeStrfGwnGUI_stimulusSelectListBox'),'Value')};
    selectedStimulus=evalin('base',selectedStimulus_tmp);
    sz=size(selectedStimulus);
    if prod(sz(2:end))>sz(2)
        error('Stimulus is not linearized! please linearize first!')
    else linearizedStimulus=selectedStimulus;
    end
end
%get selected memory
selectedMemory=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedMemory'),'String'));
selectedResponse=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedResponseEntities'),'String'));
refreshRate=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedFrameDuration'),'String'));
trialDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedTrialDuration'),'String'));
baseDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedBaseDuration'),'String'));
% Get spike triggered average
STA=calculateSTA('stimulus', linearizedStimulus,'responseEntities',selectedResponse,'mem',selectedMemory,'ifplot',1,'baseDuration',baseDuration,'trialDuration',trialDuration,'frameDuration',refreshRate);
    
%STA_mean]=calculateSTA('stimulus', linearizedStimulus, 'spikeTrain', idx,'responseEntities',selectedResponse,'mem',selectedMemory,'ifplot',1,'baseDuration',baseDuration,'trialDuration',trialDuration,'frameDuration',refreshRate);


function extractOnsetsPushbuttonCallback(a,b)
selectedEvent=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedEventEntity'),'String'));
trigger=extractOnsets('analogEntityIndices',selectedEvent)



function calculateStcPushbuttonCallback(a,b)
selectedResponse=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedResponseEntities'),'String'));
trialDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedTrialDuration'),'String'));
global linearizedStimulus STA PSTH rfCenters STC RawSTC
[STC,RawSTC]=calculateSTC('stimulus',linearizedStimulus,'responseEntities',selectedResponse,'STA',STA,'rfCenters',rfCenters,'trialDuration',trialDuration);


function findStrfPushbuttonCallback(a,b)
global nsFile;

findStrfGUI;



function determineNonlinStaPushbuttonCallback(a,b)
global nsFile linearizedStimulus PSTH nonLinearity rfCenters STA
nTrials=length(str2num(get(findobj('Tag','makeStrfGwnGUI_selectedEstimationTrials'),'String')));
selectedResponse=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedResponseEntities'),'String'));
selectedMemory=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedMemory'),'String'));
frameDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedFrameDuration'),'String'));
trialDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedTrialDuration'),'String'));
baseDuration=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedBaseDuration'),'String'));
if ~size(rfCenters)
  [linearPred,nonLinearity]=determineNonlin('stimulus',linearizedStimulus,'psth', PSTH,'nTrials',nTrials,'STA',STA,'responseEntities',selectedResponse,'mem',selectedMemory,'frameDuration',frameDuration,'baseDuration',baseDuration,'trialDuration',trialDuration);
else
[linearPred,nonLinearity]=determineNonlin('stimulus',linearizedStimulus,'psth', PSTH,'nTrials',nTrials,'STA',STA,'responseEntities',selectedResponse,'mem',selectedMemory,'frameDuration',frameDuration,'rfCenters',rfCenters,'baseDuration',baseDuration,'trialDuration',trialDuration);
end



function determinePredPushbuttonCallback(a,b)
global nsFile linearizedStimulus nonLinearity STA rfCenters
selectedResponse=str2num(get(findobj('Tag','makeStrfGwnGUI_selectedResponseEntities'),'String'));
prediction=determinePred('stimulus', linearizedStimulus,'nonLinearity', nonLinearity,'linearFilters',STA,'rfCenters',rfCenters,'analogEntityIndices',selectedResponse);

function constructSTPushbuttonCallback(a,b)
constructST;
%%%%%%%%%%%

function determineStatisticsPushbuttonCallback(a,b)
global type preferredOri
preferredOri=[];
type='Gwn';
makeStrfCodingGUI;

function determineInfoPushbuttonCallback(a,b)
global preferredOri type
preferredOri=[];
type='Gwn';
makeStrfInfoGUI;

function determineCoherencePushbuttonCallback(a,b)
global preferredOri type linearPred
preferredOri=[];
type='Gwn';

makeStrfCohGUI;

%%%%%%%%%%%



    
