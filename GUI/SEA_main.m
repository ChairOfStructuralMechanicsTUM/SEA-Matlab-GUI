function varargout = SEA_main(varargin)
% #################Note of the authors###########################
%
% Created and validated by Dionysios Panagiotopoulos, Christian Robl and 
% Khalid Malik under the supervision of Chistoph Winter during a software 
% project in the study program "Comutational Mechanics (M.Sc.)" at the 
% Chair of Structural Mechanics at Technical University of Munich.
%
% Last Version (March 2017) by Dionysios Panagiotopoulos. 
%
% Published under the GNU GENERAL PUBLIC LICENSE Version 3.
%
% ################# Content of the file #########################
%
% SEA_main MATLAB code for SEA_main.fig
%      SEA_main, by itself, creates a new SEA_main or raises the existing
%      singleton*.
%
%      H = SEA_main returns the handle to a new SEA_main or the handle to
%      the existing singleton*.
%
%      SEA_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEA_main.M with the given input arguments.
%
%      SEA_main('Property','Value',...) creates a new SEA_main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SEA_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SEA_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SEA_main

% Last Modified by GUIDE v2.5 16-Oct-2015 17:12:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SEA_main_OpeningFcn, ...
    'gui_OutputFcn',  @SEA_main_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%
% --- Executes just before SEA_main is made visible.
function SEA_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SEA_main (see VARARGIN)

% Choose default command line output for SEA_main

handles.output = hObject;

%define strings of variable names that are stored in the workspace for
%later use in buttons 'Save','Reset','Close'
handles.saveString = ['''subsystems'',''frequencies'',',...
    '''CLFMatrix'',''connections'',''positionCirc'',',...
    '''positionRec'',''handles'',''allWavesIncluded'''];
handles.clearString = ['clear subsystems frequencies ',...
    'CLFMatrix connections positionCirc positionRec ',...
    'handles cursorClick'];
handles.isDrawnRec = 0;
handles.isDrawnCirc = 0;

%pixels
set(handles.main,'Units','pixels' );

%get your display size
screenSize = get(0,'ScreenSize');

%calculate the center of the display
position = get( handles.main, 'Position' );
position(1) = (screenSize(3)-position(3))/2;
position(2) = (screenSize(4)-position(4))/2;

%center the window
set(handles.main,'Position', position );

%initialization of data
handles.data = {};

% Add folders with classes, functions and GUI to path
addpath(genpath('../Classes/'));
addpath(genpath('../Functions/'));
addpath(genpath('../GUI/'));

%disable the following warning
% "Cannot specify the parent of an annotation object - Ignoring the parent
% property"
%warning('off', 'MATLAB:annotation:BadParent')

%Create Panels
handles.OptionsPanel = uipanel('Units','pixels',...
    'Title','Options',...
    'FontSize',11,...
    'Position', [300 5 500 54]);
handles.PathAnalysisPanel = uipanel('Units','pixels',...
    'Title','Path Analysis',...
    'FontSize',11,...
    'Position', [300 55 500 49]);

handles.VisualizationPanel = uipanel('Units','pixels',...
    'Title','Visualization',...
    'FontSize',11,...
    'Position', [300 100 500 500]);

handles.PreprocessingPanel = uipanel('Units','pixels',...
    'Title','Preprocessing',...
    'FontSize',11,...
    'Position', [5 300 295 300]);

handles.PostprocessingPanel = uipanel('Units','pixels',...
    'Title','Postprocessing',...
    'FontSize',11,...
    'Position', [5 5 295 296]);

handles.SubsystemSelection = uipanel('Parent',handles.PreprocessingPanel,...
    'Units','pixels',...
    'Title','Subsystem Selection',...
    'FontSize',9,...
    'Position', [5 160 285 120]);

handles.VisFigure=axes('Parent', handles.VisualizationPanel,...
    'units','pixels',...
    'xlimmode','manual','ylimmode','manual',...
    'xlim',[0 490],'ylim',[0 490],...
    'position',[0 0 500 500],'visible','off');

handles.Inputs = uipanel('Parent',handles.PreprocessingPanel,...
    'Units','pixels',...
    'Title','Inputs',...
    'FontSize',9,...
    'Position', [5 5 285 150]);

handles.Solution = uipanel('Parent',handles.PostprocessingPanel,...
    'Units','pixels',...
    'Title','Solution',...
    'FontSize',9,...
    'Position', [5 210 285 68]);

handles.Results = uipanel('Parent',handles.PostprocessingPanel,...
    'Units','pixels',...
    'Title','Results',...
    'FontSize',9,...
    'Position', [5 5 285 200]);
%path analysis visualization
handles.pathStart=uicontrol('Parent', handles.PathAnalysisPanel,...
    'style','text','string','Start of Path:',...
    'HorizontalAlignment','left',...
    'FontSize',9,...
    'position',[5 5 80 20],'enable','off');

handles.pathEnd=uicontrol('Parent', handles.PathAnalysisPanel,...
    'style','text','string','End of Path:',...
    'HorizontalAlignment','left',...
    'FontSize',9,...
    'position',[180 5 80 20],'enable','off');

handles.pathFrequency=uicontrol('Parent', handles.PathAnalysisPanel,...
    'style','text','string','Frequency (Hz):',...
    'HorizontalAlignment','left',...
    'FontSize',9,...
    'position',[345 5 90 20],'enable','off');

handles.pathStart_popupmenu = uicontrol('Parent', handles.PathAnalysisPanel,...
    'style','popupmenu','string',{'Plate 1'},...
    'HorizontalAlignment','right',...
    'FontSize',8,...
    'position',[90 10 80 18],'enable','off');

handles.pathEnd_popupmenu = uicontrol('Parent', handles.PathAnalysisPanel,...
    'style','popupmenu','string',{'Plate 2'},...
    'HorizontalAlignment','right',...
    'FontSize',8,...
    'position',[255 10 80 18],'enable','off');

handles.pathFrequency_popupmenu = uicontrol('Parent', handles.PathAnalysisPanel,...
    'style','popupmenu','string',{'125','160','200','250','315','400','500','630','800','1000','1250','1600',...
    '2000','2500','3150','4000','5000','6300','8000','10000','12500','16000'},...
    'HorizontalAlignment','right',...
    'FontSize',8,...
    'position',[435 10 60 18],'enable','off');

handles.pathNextButton=uicontrol('parent',handles.VisualizationPanel,'style',...
    'pushbutton','String','Next','Units',...
    'pixels','FontSize',10,...
    'Position',[415 5 80 20], 'tooltips', 'help' ,'enable','off' );

handles.pathPreviousButton=uicontrol('parent',handles.VisualizationPanel,'style',...
    'pushbutton','String','Previous','Units',...
    'pixels','FontSize',10,...
    'Position',[330 5 80 20], 'tooltips', 'help','enable','off' );

handles.pathClearButton=uicontrol('parent',handles.VisualizationPanel,'style',...
    'pushbutton','String','Clear','Units',...
    'pixels','FontSize',10,...
    'Position',[245 5 80 20], 'tooltips', 'help','enable','off' );

%-----------------------Subsystem Selection--------------------------------
uicontrol('Parent',handles.SubsystemSelection,...
    'style','text','string','Number of Subsystems:',...
    'HorizontalAlignment','center',...
    'FontSize',9,...
    'position',[0 50 140 20])

uicontrol('Parent',handles.SubsystemSelection,...
    'style','text','string','Plates',...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[147 80 40 20])

uicontrol('Parent',handles.SubsystemSelection,...
    'style','text','string','Cavities',...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[213 80 50 20])

handles.plates_popupmenu = uicontrol('Parent',handles.SubsystemSelection,...
    'style','popupmenu','string',{'2','3',...
    '4','5','6','7','8','9','10','11'},...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[145 55 50 20]);

handles.cavities_popupmenu = uicontrol('Parent',handles.SubsystemSelection,...
    'style','popupmenu','string',{'0','1','2'},...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[215 55 50 20]);

handles.Create = uicontrol('parent',handles.SubsystemSelection,'style',...
    'pushbutton','String','Create','Units',...
    'pixels','FontSize',10,...
    'Position',[165 10 100 28], 'tooltips', 'help' );

%-----------------------Save Button----------------------------------------
handles.Save = uicontrol('parent',handles.OptionsPanel,'style',...
    'pushbutton','String','Save','Units',...
    'pixels','FontSize',10,'enable','off',...
    'Position',[5 5 100 28], 'tooltips',...
    'Save the project.' );

%-----------------------Load Button----------------------------------------
handles.Load = uicontrol('parent',handles.OptionsPanel,'style',...
    'pushbutton','String','Load','Units',...
    'pixels','FontSize',10,...
    'Position',[135 5 100 28], 'tooltips',...
    'Load a project.' );

%-----------------------Reset Button---------------------------------------
handles.Reset = uicontrol('parent',handles.OptionsPanel,'style',...
    'pushbutton','String','Reset','Units',...
    'pixels','FontSize',10,...
    'Position',[265 5 100 28], 'tooltips',...
    'Reset the program.' );

%-----------------------Exit Button---------------------------------------
handles.Exit = uicontrol('parent',handles.OptionsPanel,'style',...
    'pushbutton','String','Exit','Units',...
    'pixels','FontSize',10,...
    'Position',[395 5 100 28], 'tooltips',...
    'Exit the program.' );

%--------------------------------------------------------------------------

%-----------------------------Frequency Selection--------------------------
uicontrol('Parent',handles.Inputs,...
    'style','text','string','Frequency Band:',...
    'HorizontalAlignment','center',...
    'FontSize',9,...
    'position',[0 100 120 20])

handles.frequencies_popupmenu = uicontrol('Parent',handles.Inputs,...
    'style','popupmenu','string',{'Third Octave','Octave'},...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[130 105 100 20]);
%--------------------------------------------------------------------------

%--------------------------Insert Couplings--------------------------------
handles.Coupling_pushbutton = uicontrol('parent',handles.Inputs,...
    'style','pushbutton','String',...
    'Add Coupling','Units',...
    'pixels','FontSize',10,...
    'enable','off',...
    'Position',[150 60 130 30] );


%--------------------------------------------------------------------------

%--------------------------Subsystem Parameters----------------------------
handles.SystemInputs = uicontrol('parent',handles.Inputs,...
    'style','pushbutton','String',...
    'Subsystem Parameters','Units',...
    'pixels','FontSize',10,...
    'enable','off',...
    'Position',[5 60 140 30] );

%--------------------------------------------------------------------------

%----------------------------Power Input-----------------------------------
% uicontrol('Parent',handles.Inputs,...
%     'style','text','string','Input Power: [W] ',...
%     'HorizontalAlignment','center',...
%     'FontSize',9,...
%     'position',[5 10 70 30])

% handles.InputPower_editbox = uicontrol(handles.Inputs,'style',...
%     'edit','string','','HorizontalAlignment','Center','Units',...
%     'pixels','Position',[80 22 50 20]);

% uicontrol('Parent',handles.Inputs,...
%     'style','text','string','at ',...
%     'HorizontalAlignment','center',...
%     'FontSize',9,...
%     'position',[140 20 30 20])

% handles.Power_popupmenu = uicontrol('Parent',handles.Inputs,...
%     'style','popupmenu','string',{''},...
%     'HorizontalAlignment','right',...
%     'FontSize',9,...
%     'position',[175 25 100 20]);
handles.PowerInputs = uicontrol('parent',handles.Inputs,...
    'style','pushbutton','String',...
    'Power Input','Units',...
    'pixels','FontSize',10,...
    'enable','off',...
    'Position',[150 20 130 30] );
%-------------------------------------------------------------
%-------------------------solution Options-------------------------------------------------
handles.solution_Options_pushbutton = uicontrol('parent',handles.Inputs,...
    'style','pushbutton','String',...
    'Solution Options','Units',...
    'pixels','FontSize',10,...
    'enable','off',...
    'Position',[5 20 140 30] );
%-------------------------------Solution-----------------------------------
handles.solution_pushbutton = uicontrol('parent',handles.Solution,...
    'style','pushbutton','String',...
    'Solve','Units',...
    'pixels','FontSize',12,...
    'enable','off',...
    'Position',[65 12 150 30] );

%--------------------------------------------------------------------------
%--------------------------Result selection listbox------------------------
handles.Results_listbox = uicontrol('parent',handles.Results,...
    'style','listbox','FontSize',9,...
    'string',{'Modal Density','Modal Overlap Factor',...
    'Energy','Engineering Values','Engineering Levels','Power Input',...
    'Coupling Loss Factors'},...
    'position',[5 35 135 145],'max',2,'min',0);

handles.CLF_listbox = uicontrol('parent',handles.Results,...
    'style','listbox','FontSize',9,...
    'String',{''},...
    'Visible','Off',...
    'position',[145 35 135 145]);
handles.Subsystems_listbox = uicontrol('parent',handles.Results,...
    'style','listbox','FontSize',9,...
    'String',{''},...
    'Visible','On',...
    'position',[145 35 135 145]);
handles.Paths_listbox = uicontrol('parent',handles.Results,...
    'style','listbox','FontSize',9,...
    'String',{''},...
    'Visible','On',...
    'position',[145 35 135 145]);

%--------------------------------------------------------------------------
%----------------------------Plot Pusbutton--------------------------------
handles.PlotResults_pushbutton = uicontrol('parent',handles.Results,...
    'style','pushbutton','String',...
    'Plot Results','Units',...
    'pixels','FontSize',10,...
    'enable','off',...
    'Position',[145 5 135 25]);
%path analysis plot
handles.PlotPathAnalysis_pushbutton = uicontrol('parent',handles.Results,...
    'style','pushbutton','String',...
    'Path Analysis','Units',...
    'pixels','FontSize',10,...
    'enable','off',...
    'Position',[5 5 135 25]);

%--------------------------------------------------------------------------
%initialization of the arrows
handles.drawarrow(1) = annotation('arrow','parent',handles.VisFigure,...
    'position',[0 0 0 0],'visible','off');

handles.drawarrowPath(1) = annotation('arrow','parent',handles.VisFigure,...
    'position',[0 0 0 0],'visible','off');

%--------------------------------------------------------------------------
%Callback for pushbutton Create
% set(handles.Create,'callback',{@Create_Callback,handles});
set(handles.Create,'callback',{@(hObject,...
    eventdata)SEA_main('Create_Callback',hObject,eventdata,...
    guidata(hObject))});
%Callback for pushbutton Solution
set(handles.solution_pushbutton,'callback',{@(hObject,...
    eventdata)SEA_main('Solution_Callback',hObject,eventdata,...
    guidata(hObject))});
%Callback for pushbutton Solution Options
set(handles.solution_Options_pushbutton,'callback',{@(hObject,...
    eventdata)SEA_main('Solution_Options_Callback',hObject,eventdata,...
    guidata(hObject))});
%Callback for pushbutton Coupling
set(handles.Coupling_pushbutton,'callback',{@(hObject,...
    eventdata)SEA_main('Coupling_Callback',hObject,eventdata,...
    guidata(hObject))});
%Callback for pushbutton INputs
set(handles.SystemInputs,'callback',{@(hObject,...
    eventdata)SEA_main('Inputs_Callback',hObject,eventdata,...
    guidata(hObject))});
%Callback for pushbutton Power
set(handles.PowerInputs,'callback',{@(hObject,...
    eventdata)SEA_main('Power_Callback',hObject,eventdata,...
    guidata(hObject))});
%Callback for pushbutton Save
set(handles.Save,'callback',{@(hObject,...
    eventdata)SEA_main('Save_Callback',guidata(hObject))});
%Callback for pushbutton Load
set(handles.Load,'callback',{@(hObject,...
    eventdata)SEA_main('Load_Callback',guidata(hObject))});
%Callback for pushbutton Reset
set(handles.Reset,'callback',{@(hObject,...
    eventdata)SEA_main('Reset_Callback',hObject,guidata(hObject))});
%Callback for pushbutton Close
set(handles.Exit,'callback',{@(hObject,...
    eventdata)SEA_main('Exit_Callback',guidata(hObject))});
%Callback for results listbox with
set(handles.Results_listbox,'callback',{@(hObject,...
    eventdata)SEA_main('ResultsListbox_Callback',hObject,eventdata,...
    guidata(hObject))});
%Callback for Plot Results pushbutton
set(handles.PlotResults_pushbutton,'callback',{@(hObject,...
    eventdata)SEA_main('PlotResults_Callback',hObject,eventdata,...
    guidata(hObject))});
%callback for path analysis
set(handles.PlotPathAnalysis_pushbutton,'callback',{@(hObject,...
    eventdata)SEA_main('PathAnalysisPlot_Callback',hObject,eventdata,...
    guidata(hObject))});
%callbacks for dropdowns of Path analysis
set(handles.pathStart_popupmenu,'callback',{@(hObject,eventdata)...
    SEA_main('PathAnalysisShow_Callback',hObject,eventdata,guidata(hObject))});

set(handles.pathEnd_popupmenu,'callback',{@(hObject,eventdata)...
    SEA_main('PathAnalysisShow_Callback',hObject,eventdata,guidata(hObject))});

set(handles.pathFrequency_popupmenu,'callback',{@(hObject,eventdata)...
    SEA_main('PathAnalysisShow_Callback',hObject,eventdata,guidata(hObject))});
%callbacks for next and previous paths
set(handles.pathNextButton,'callback',{@(hObject,eventdata)...
    SEA_main('PathAnalysisNext_Callback',hObject,eventdata,guidata(hObject))});

set(handles.pathPreviousButton,'callback',{@(hObject,eventdata)...
    SEA_main('PathAnalysisPrevious_Callback',hObject,eventdata,guidata(hObject))});

set(handles.pathClearButton,'callback',{@(hObject,eventdata)...
    SEA_main('PathAnalysisClear_Callback',hObject,eventdata,guidata(hObject))});
%functions for drag n dropping
set(handles.main,'WindowButtonDownFcn', {@(hObject,...
    eventdata)SEA_main('Getposition1',hObject,eventdata,...
    guidata(hObject))});
set(handles.main,'WindowButtonUpFcn', {@(hObject,...
    eventdata)SEA_main('Getposition2',hObject,eventdata,...
    guidata(hObject))});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SEA_main wait for user response (see UIRESUME)
% uiwait(handles.main);
%%

% --- Outputs from this function are returned to the command line.
function varargout = SEA_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function Getposition1(hObject,event_data,handles)
%get the position of the click in the visualization panel
if handles.isDrawnRec == 1 %only get position if something was drawn
    C = get(handles.main,'CurrentPoint');
    C=[C(1,1)-300 C(1,2)-100];
    %store position on workspace
    assignin('base','cursorClick',C);
end

function Getposition2(hObject,event_data,handles)
%update the visualization of the subsystems each time something is moved

if handles.isDrawnRec == 1 %proceed only if something was drawn
    
    %load data for rectangles, data, arrows from workspace
    handles.positionRec = evalin('base','positionRec');
    handles.positionCirc = evalin('base','positionCirc');
    handles.drawarrow = evalin('base','handles.drawarrow');
    handles.drawarrowPath=evalin('base','handles.drawarrowPath');
    Cnew = get(handles.main,'CurrentPoint');
    Cnew=[Cnew(1,1)-300 Cnew(1,2)-100];
    Cold=evalin('base','cursorClick');
    
    %move rectangles and corresponding arrows
    for i=1:handles.val_plate
        if Cold(1)>=handles.positionRec(i,1) && ...
                Cold(1)<=handles.positionRec(i,1)...
                +50 && Cold(2)>=handles.positionRec(i,2) && ...
                Cold(2)<=handles.positionRec(i,2)+50
            for j=1:length(handles.drawarrow)
                xarrow=get(handles.drawarrow(j),'x');
                yarrow=get(handles.drawarrow(j),'y');
                if xarrow(1)==handles.positionRec(i,1)+25 && ...
                        (yarrow(1)==handles.positionRec(i,2) || ...
                        yarrow(1)==handles.positionRec(i,2)+50)
                    set(handles.drawarrow(j),'x',[Cnew(1,1) xarrow(2)]);
                    if Cnew(1,2)>yarrow(2)
                        set(handles.drawarrow(j),'y',...
                            [Cnew(1,2)-25 yarrow(2)]);
                    else
                        set(handles.drawarrow(j),'y',...
                            [Cnew(1,2)+25 yarrow(2)]);
                    end
                end
                if xarrow(2)==handles.positionRec(i,1)+25 && ...
                        (yarrow(2)==handles.positionRec(i,2) || ...
                        yarrow(2)==handles.positionRec(i,2)+50)
                    set(handles.drawarrow(j),'x',[xarrow(1) Cnew(1,1) ]);
                    if Cnew(1,2)>yarrow(1)
                        set(handles.drawarrow(j),'y',...
                            [yarrow(1) Cnew(1,2)-25 ]);
                    else
                        set(handles.drawarrow(j),'y',...
                            [yarrow(1) Cnew(1,2)+25 ]);
                    end
                end
            end
            
            %change position of rectangle
            set(handles.drawrec(i),'position',....
                [Cnew(1,1)-25 Cnew(1,2)-25 50 50]);
            set(handles.txtrec(i),'position',[Cnew(1,1)-20 Cnew(1,2) 0],...
                'Color','white','FontSize',10,'FontWeight','bold');
            
            %store x and y coordinate of rectangle
            handles.positionRec(i,1)=Cnew(1,1)-25;
            handles.positionRec(i,2)=Cnew(1,2)-25;
            
        end
    end
    
    %move rectangles and corresponding arrows
    for i=1:(handles.val_cavity-1)
        if Cold(1)>=handles.positionCirc(i,1) && ...
                Cold(1)<=handles.positionCirc(i,1)+50 && ...
                Cold(2)>=handles.positionCirc(i,2) && ...
                Cold(2)<=handles.positionCirc(i,2)+50
            for j=1:length(handles.drawarrow)
                xarrow=get(handles.drawarrow(j),'x');
                yarrow=get(handles.drawarrow(j),'y');
                if xarrow(1)==handles.positionCirc(i,1)+25 && ...
                        (yarrow(1)==handles.positionCirc(i,2) || ...
                        yarrow(1)==handles.positionCirc(i,2)+50)
                    set(handles.drawarrow(j),'x',[Cnew(1,1) xarrow(2)]);
                    if Cnew(1,2)>yarrow(2)
                        set(handles.drawarrow(j),'y',[Cnew(1,2)-25 yarrow(2)]);
                    else
                        set(handles.drawarrow(j),'y',[Cnew(1,2)+25 yarrow(2)]);
                    end
                end
                if xarrow(2)==handles.positionCirc(i,1)+25 && ...
                        (yarrow(2)==handles.positionCirc(i,2) || ...
                        yarrow(2)==handles.positionCirc(i,2)+50)
                    set(handles.drawarrow(j),'x',[xarrow(1) Cnew(1,1) ]);
                    if Cnew(1,2)>yarrow(1)
                        set(handles.drawarrow(j),'y',[yarrow(1) Cnew(1,2)-25 ]);
                    else
                        set(handles.drawarrow(j),'y',[yarrow(1) Cnew(1,2)+25 ]);
                    end
                end
            end
            
            %change position of circle
            set(handles.drawcirc(i),'position',[Cnew(1,1)-25 Cnew(1,2)-25 50 50]);
            set(handles.txtcirc(i),'position',[Cnew(1,1)-20 Cnew(1,2) 0],...
                'Color','white','FontSize',10,'FontWeight','bold');
            
            %store x and y coordinate of circle
            handles.positionCirc(i,1)=Cnew(1,1)-25;
            handles.positionCirc(i,2)=Cnew(1, 2)-25;
        end
    end
    handles.positionObject=[handles.positionRec;handles.positionCirc];
    %store positions in workspace
    assignin('base','positionRec',handles.positionRec);
    assignin('base','positionCirc',handles.positionCirc);
    assignin('base','positionObject',handles.positionObject);
end


function Create_Callback(hObject,event_data,handles)

%clear workspace variables that are being created againg here
evalin('base','clear subsystems');

handles.val_plate = get(handles.plates_popupmenu,'Value') +1 ;
handles.val_cavity = get(handles.cavities_popupmenu,'Value');

handles.subsystems = [handles.val_plate handles.val_cavity];

%%drawing part
%delete existing rectangles, circles, text
if handles.isDrawnRec == 1
    delete(handles.drawrec);
    delete(handles.txtrec);
end

if handles.isDrawnCirc == 1
    delete(handles.drawcirc);
    delete(handles.txtcirc);
end

%reset positions, rectangles, circles, text
handles.positionRec=[];
handles.positionCirc=[];
handles.drawrec=[];
handles.drawcirc=[];
handles.txtrec=[];
handles.txtcirc=[];

cmap = colororder;
%draw plates
for i=1:handles.val_plate
    if i<7
        handles.drawrec(i)=rectangle('parent',handles.VisFigure,...
            'FaceColor',cmap(i,:),'edgecolor','black',...
            'linewidth',2,'Position',[50 (450-i*70) 50 50]);
        handles.txtrec(i)=text(55 ,(450-i*70)+25,...
            strcat('plate',num2str(i)),'Color','white','FontSize',10,...
            'FontWeight','bold');
        handles.positionRec(i,1)=50;
        handles.positionRec(i,2)=(450-i*70);
        handles.positionRec(i,3)=i;
        handles.positionTxtRec(i,1)=55;
        handles.positionTxtRec(i,2)=(450-i*70)+25;
        
    elseif i>=7
        handles.drawrec(i)=rectangle('parent',handles.VisFigure,...
            'FaceColor',cmap(i,:),'edgecolor','black',...
            'linewidth',2,'Position',[200 (449-(i-6)*70) 50 50]);
        handles.txtrec(i)=text(205 ,(449-(i-6)*70)+25,...
            strcat('plate',num2str(i)),'Color','white','FontSize',10,...
            'FontWeight','bold');
        handles.positionRec(i,1)=200;
        handles.positionRec(i,2)=(449-(i-6)*70);
        handles.positionTxtRec(i,1)=205;
        handles.positionTxtRec(i,2)=(449-(i-6)*70)+25;
        
    end
    
    handles.isDrawnRec = 1;
end

%draw cavities
for i=1:(handles.val_cavity-1)
    handles.drawcirc(i)=rectangle('parent',handles.VisFigure,...
        'curvature',[1 1],'FaceColor',cmap(i+handles.val_plate,:),...
        'edgecolor','black','linewidth',2,'Position',[350 (448-i*70) 50 50]);
    handles.txtcirc(i)=text(355 ,(448-i*70)+25,strcat('cavity',num2str(i)),...
        'Color','white','FontSize',10,'FontWeight','bold');
    handles.isDrawnCirc = 1;
    handles.positionCirc(i,1)=350;
    handles.positionCirc(i,2)=(448-i*70);
    handles.positionCirc(i,3)=i+handles.val_plate;
    handles.positionTxtCirc(i,1)=355;
    handles.positionTxtCirc(i,2)=(448-i*70)+25;
end
handles.positionObject=[handles.positionRec; handles.positionCirc];

assignin('base','positionObject',handles.positionObject);
assignin('base','positionRec',handles.positionRec);
assignin('base','positionCirc',handles.positionCirc);
assignin('base','handles',handles);

%%

handles.SubsystemString = {};
for counterPlate=1:handles.val_plate
    handles.SubsystemString{end+1} = ['Plate ',int2str(counterPlate)];
end

if handles.val_cavity > 1
    for counterCavity=1:(handles.subsystems(2)-1)
        handles.SubsystemString{end+1} = ['Cavity ',...
            int2str(counterCavity)];
    end
end

%change string of possible options for power input
%set(handles.Power_popupmenu,'string',handles.SubsystemString)

% Update string in plot selection listboxes
set(handles.Subsystems_listbox,'string',handles.SubsystemString)
set(handles.pathStart_popupmenu,'string',handles.SubsystemString,'value',1)
set(handles.pathEnd_popupmenu,'string',handles.SubsystemString,'value',2)
%make multiple selection of in parameters listbox available
set(handles.Subsystems_listbox,'min',0,'max',...
    length(handles.SubsystemString))

%enable button for subsystem parameter input
set(handles.SystemInputs,'enable','on');

%generate subsystems struct in 'base' workspace
evalin('base','clear subsystems');

init_subs_cmd = 'subsystems ';
subs_cmd = 'subsystems(end+1)';

plate_term = '= struct(''type'',''plate'',''data'','''',''modal_density'','''',';
cavity_term = '= struct(''type'',''cavity'',''data'','''',''modal_density'','''',';

end_term = '''modal_overlap'','''',';
end_term = strcat(end_term,'''input_power'','''',''energy'','''',');
end_term = strcat(end_term,'''eng_value'','''',''eng_level'','''',''dlf'','''')');

evalin('base', strcat(init_subs_cmd,plate_term,end_term,';'));

for k=2:(handles.subsystems(1))
    evalin('base', strcat(subs_cmd,plate_term,end_term,';'));
end

if handles.subsystems(2) > 1
    for l=1:(handles.subsystems(2)-1)
        evalin('base', strcat(subs_cmd,cavity_term,end_term,';'));
    end
end

%Update handles structure
guidata(hObject,handles);


function Coupling_Callback(hObject,event_data,handles)

%clear workspace variables that are being created againg here
evalin('base','clear frequencies');
evalin('base','clear connections');

contents = get(handles.frequencies_popupmenu,'String');
frequencies = contents{get(handles.frequencies_popupmenu,'Value')};

%get the frequency vector from the respective function
handles.frequencies = FrequencyBand(frequencies);

%choice of theory applied
chosenTheory = questdlg('What kind of waves should be included?', ...
    'Waves', ...
    'Bending Waves','Bending and In-plane Waves','Bending Waves');
global allWavesFlag;
switch chosenTheory
    case 'Bending Waves'
        %set up connections matrix
        
        allWavesFlag = 0;
        handles.connections = Couplings(...
            handles.subsystems,handles.SUBSYSTEMS,handles.frequencies,...
            handles.VisFigure);
        
        %make popup to let user know that couplings are applied
        msgbox('The couplings have been applied.')
        
    case 'Bending and In-plane Waves'
        allWavesFlag = 1;
        handles.connections = Couplings(...
            handles.subsystems,handles.SUBSYSTEMS,handles.frequencies,...
            handles.VisFigure);
        msgbox('The couplings have been applied.')
end


% [handles.connections, handles.drawarrow] = Couplings(...
%     handles.subsystems,handles.SUBSYSTEMS,handles.frequencies,...
%     handles.VisFigure);



%save variables to workspace
assignin('base','frequencies',handles.frequencies);
assignin('base','connections',handles.connections);



% Update string in CLF plot listbox
handles.CLFstring = {};
if ~allWavesFlag
    for counter= 1:length(handles.connections)
        %     handles.CLFstring{end+1} = strcat('eta',...
        %         handles.connections(1,counter).getID);
        if handles.connections(1,counter).getElementI > handles.val_plate
            stringOfFirstElement=strcat('C',num2str(handles.connections(1,counter).getElementI-handles.val_plate));
        else
            stringOfFirstElement=strcat('P',num2str(handles.connections(1,counter).getElementI));
        end
        if handles.connections(1,counter).getElementJ > handles.val_plate
            stringOfSecondElement=strcat('C',num2str(handles.connections(1,counter).getElementJ-handles.val_plate));
        else
            stringOfSecondElement=strcat('P',num2str(handles.connections(1,counter).getElementJ));
        end
        handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement);
        handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement);
    end
    
    set(handles.CLF_listbox,'string',handles.CLFstring);
    %make multiple selection in listbox with CLFs available
    set(handles.CLF_listbox,'Min',0,'Max',2*length(handles.connections))
else
    counterCavitiesPlates = 0;
    counterPlatesPlates = 0;
    for counter= 1:length(handles.connections)
        %     handles.CLFstring{end+1} = strcat('eta',...
        %         handles.connections(1,counter).getID);
        if handles.connections(1,counter).getElementI > handles.val_plate
            stringOfFirstElement=strcat('C',num2str(handles.connections(1,counter).getElementI-handles.val_plate));
        else
            stringOfFirstElement=strcat('P',num2str(handles.connections(1,counter).getElementI));
        end
        if handles.connections(1,counter).getElementJ > handles.val_plate
            stringOfSecondElement=strcat('C',num2str(handles.connections(1,counter).getElementJ-handles.val_plate));
        else
            stringOfSecondElement=strcat('P',num2str(handles.connections(1,counter).getElementJ));
        end
        if handles.connections(1,counter).getElementI > handles.val_plate || handles.connections(1,counter).getElementJ > handles.val_plate
            counterCavitiesPlates = counterCavitiesPlates+1;
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement);
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement);
        else
            %for plate1 to plate2
            counterPlatesPlates = counterPlatesPlates + 1;
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - B2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - L2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - S2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - L2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - S2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - L2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - S2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - B2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - B2S');
            %for plate2 to plate1
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - B2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - L2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - S2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - L2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - S2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - L2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - S2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - B2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - B2S');
        end
    end
    
    set(handles.CLF_listbox,'string',handles.CLFstring);
    %make multiple selection in listbox with CLFs available
    set(handles.CLF_listbox,'Min',0,'Max',18*counterPlatesPlates + 2 * counterCavitiesPlates);
    handles.counterPlatesPlates= counterPlatesPlates;
    handles.counterCavitiesPlates = counterCavitiesPlates;
end
%enable the pushbutton of Power inputs
set(handles.solution_Options_pushbutton,'enable','on');

%Update handles structure
guidata(hObject,handles);


function Solution_Callback(hObject,event_data,handles)
global allWavesFlag

%get data from workspace
subsystems = evalin('base','subsystems');
frequencies = evalin('base','frequencies');
connections = evalin('base','connections');

%calculate the modal density and modal overlap

for i=1:length(subsystems)
    if strcmp(subsystems(i).type,'plate')
        if ~allWavesFlag
            subsystems(i).modal_density = ...
                subsystems(i).data.modalDensityLyon*...
                ones(1,length(frequencies))';
            subsystems(i).modal_overlap = ...
            subsystems(i).data.modalOverlapFactor(frequencies);
        else
            subsystems(i).modal_density{3} = ...
                subsystems(i).data.modalDensityLyon*...
                ones(1,length(frequencies))';
            subsystems(i).modal_density{1}= ...
                subsystems(i).data.modalDensityLongitudinal(frequencies);
            subsystems(i).modal_density{2}= ...
                subsystems(i).data.modalDensityTransverse(frequencies);
            subsystems(i).modal_overlap{3} = ...
            subsystems(i).data.modalOverlapFactor(frequencies);
        subsystems(i).modal_overlap{1} = ...
            subsystems(i).data.modalOverlapFactorLongitudinal(frequencies);
        subsystems(i).modal_overlap{2} = ...
            subsystems(i).data.modalOverlapFactorTransverse(frequencies);
        end
        
    elseif strcmp(subsystems(i).type,'cavity')
        subsystems(i).modal_density = ...
            subsystems(i).data.modalDensity(frequencies);
        subsystems(i).modal_overlap = ...
            subsystems(i).data.modalOverlapFactor(frequencies);
    end
end

%
%pass input power data into struct
for i=1:length(subsystems)
    if strcmp(subsystems(i).type,'plate')
        if ~allWavesFlag
            subsystems(i).input_power = handles.powerInputGlobal(i,:)';
        else
            for j=1:3
                subsystems(i).input_power{j} = handles.powerInputGlobal((i-1)*3+j,:)';
            end
        end
    else
        if ~allWavesFlag
            subsystems(i).input_power = handles.powerInputGlobal(i,:)';
        else
            subsystems(i).input_power = handles.powerInputGlobal(handles.subsystems(1)*3+i-handles.subsystems(1),:)';
        end
    end
    
end

%initialize and fill up the damping loss factor vector
if ~allWavesFlag
    DLF = zeros(length(subsystems),1);
    for i=1:length(subsystems)
        DLF(i)=subsystems(i).data.getDLF();
    end
else
    for i=1:length(subsystems)
        if strcmp(subsystems(i).type,'plate')
            for j=1:3
                DLF((i-1)*3+j) = subsystems(i).data.getDLF();
            end
        else
            DLF(handles.subsystems(1)*3+i-handles.subsystems(1)) = subsystems(i).data.getDLF();
        end
    end
end
%solve the system for energies
if ~allWavesFlag
    [energyVector,CLFMatrix]=SolveSystem(length(subsystems),...
        length(connections),connections,DLF,frequencies,handles.powerInputGlobal);
else
    [energyVector,CLFMatrix]=SolveSystem(length(subsystems),...
        length(connections),connections,DLF,frequencies,handles.powerInputGlobal,handles.subsystems);
end
% save energy after calculation to subsystems struct
for i=1:length(subsystems)
    if ~allWavesFlag
        subsystems(i).energy = energyVector(i,:)';
    else
        if strcmp(subsystems(i).type,'plate')
            for j=1:3
                subsystems(i).energy{j} =  energyVector((i-1)*3+j,:)';
            end
        else
            subsystems(i).energy = energyVector(handles.subsystems(1)*3+i-handles.subsystems(1),:)';
        end
    end
end

% calculate engineering values and levels
%     if ~allWavesFlag
for i=1:length(subsystems)
    [subsystems(i).eng_value, subsystems(i).eng_level] = ...
        engValues(subsystems(i).type,subsystems(i).energy,...
        subsystems(i).data);
end
%     else
%     end
%save variables to workspace
assignin('base','subsystems',subsystems);
assignin('base','CLFMatrix',CLFMatrix);

%enable the save and results button
set(handles.Save,'enable','on');
set(handles.PlotResults_pushbutton,'enable','on');

%write to workspace for user to remember
dispString = 'disp(''The solution has been calculated.'')';
evalin('base',dispString);

%message box to let user know
msgbox('The calculation has been finished.');

%Update handles structure
guidata(hObject,handles);

function Solution_Options_Callback(hObject,event_data,handles)
subsystems = evalin('base','subsystems');
frequencies = evalin('base','frequencies');
handles.data =Solution_options(handles.data,handles.subsystems);
global allWavesFlag allWavesFlag2
allWavesFlag2 = handles.data(2);
if handles.data(1)==1
    nonResCLF=NonResonantCLF( handles,subsystems, frequencies);
else
    nonResCLF=[];
end
if handles.data(1)==1
for i=1:length(nonResCLF)
    
    handles.connections(end+1)=nonResCLF(i);
    stringOfFirstElement=strcat('C',num2str(handles.connections(end).getElementI-handles.val_plate));
    stringOfSecondElement=strcat('C',num2str(handles.connections(end).getElementJ-handles.val_plate));
    handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement);
    handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement);
end
assignin('base','connections',handles.connections);
set(handles.CLF_listbox,'string',handles.CLFstring);
end
%% part for making further calculations only with bending waves coefficients
%make multiple selection in listbox with CLFs available
if allWavesFlag
    if ~allWavesFlag2
        handles.CLFstring = {};
        for i=1:length(handles.connections)
            if ~(handles.connections(i).getElementI> handles.subsystems(1) || handles.connections(i).getElementJ> handles.subsystems(1))
                clfToChange = handles.connections(i).getCLF;
                rclfToChange = handles.connections(i).getRCLF;
                for ff =1:length(frequencies)
                    CLFtoCreate(ff) = clfToChange{ff}(3,6);
                    RCLFtoCreate (ff) = rclfToChange{ff}(3,6);
                end
                handles.connections(i) = CouplingLossFactor(handles.connections(i).getID,handles.connections(i).getElementI,...
                    handles.connections(i).getElementJ,transpose(CLFtoCreate),transpose(RCLFtoCreate),handles.connections(i).getInvID);
            end
        end
        assignin('base','connections',handles.connections);
        allWavesFlag = 0;
    end
    if ~allWavesFlag
        for counter= 1:length(handles.connections)
            %     handles.CLFstring{end+1} = strcat('eta',...
            %         handles.connections(1,counter).getID);
            if handles.connections(1,counter).getElementI > handles.val_plate
                stringOfFirstElement=strcat('C',num2str(handles.connections(1,counter).getElementI-handles.val_plate));
            else
                stringOfFirstElement=strcat('P',num2str(handles.connections(1,counter).getElementI));
            end
            if handles.connections(1,counter).getElementJ > handles.val_plate
                stringOfSecondElement=strcat('C',num2str(handles.connections(1,counter).getElementJ-handles.val_plate));
            else
                stringOfSecondElement=strcat('P',num2str(handles.connections(1,counter).getElementJ));
            end
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement);
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement);
        end
        
        set(handles.CLF_listbox,'string',handles.CLFstring);
        %make multiple selection in listbox with CLFs available
        set(handles.CLF_listbox,'Min',0,'Max',2*length(handles.connections))
    end
    if allWavesFlag
        set(handles.CLF_listbox,'Min',0,'Max',18 * handles.counterPlatesPlates + 2 *handles.counterCavitiesPlates + 2*length(nonResCLF) );
    else
        set(handles.CLF_listbox,'Min',0,'Max',2* length(handles.connections));
    end
end
%%  part of path analysis
if handles.data(3)==1
    handles.paths = PathAnalysis(subsystems, handles.connections,handles.data(4));
    assignin('base','paths',handles.paths);
    handles.PathString = {};
    set(handles.Results_listbox,'string',{'Modal Density','Modal Overlap Factor',...
        'Energy','Engineering Values','Engineering Levels','Power Input',...
        'Coupling Loss Factors','Paths'});
    %create the string of the listbox for paths.
    for counter= 1:length(handles.SUBSYSTEMS)
        if isa(handles.SUBSYSTEMS{1,counter},'Cavity')
            stringOfFirstElement=strcat('C',num2str(handles.SUBSYSTEMS{1,counter}.getID-handles.val_plate));
        else
            stringOfFirstElement=strcat('P',num2str(handles.SUBSYSTEMS{1,counter}.getID));
        end
        for i=1:length(handles.SUBSYSTEMS)
            if handles.SUBSYSTEMS{1,i}.getID > handles.val_plate
                stringOfSecondElement=strcat('C',num2str(handles.SUBSYSTEMS{1,i}.getID-handles.val_plate));
            else
                stringOfSecondElement=strcat('P',num2str(handles.SUBSYSTEMS{1,i}.getID));
            end
            if ~strcmp(stringOfFirstElement,stringOfSecondElement)
                handles.PathString{end+1} = strcat('paths:',stringOfFirstElement,'->',stringOfSecondElement);
            end
        end
    end
    
    set(handles.Paths_listbox,'string',handles.PathString);
    set(handles.Paths_listbox,'Min',0,'Max',length(handles.PathString))
    set(handles.Paths_listbox,'enable','on','visible','on');
    set (handles.PlotPathAnalysis_pushbutton,'enable','on');
    for i=1:handles.data(4)+1
        evalin('base','handles.drawarrowPath(end+1)=annotation(''arrow'');');
        handles.drawarrowPath=evalin('base','handles.drawarrowPath');
        set(handles.drawarrowPath( end),'parent',handles.VisFigure,...
            'position',[0 0 0 0],'visible','off','HeadStyle', 'hypocycloid', 'LineWidth', 3,'Color','y','Linestyle','- -');
    end
    %     handles.drawarrowPath(1:handles.data(4)+1) = annotation('arrow','parent',handles.VisFigure,...
    %     'position',[0 0 0 0],'visible','off','HeadStyle', 'hypocycloid', 'LineWidth', 3,'Color','r');
    %     assignin('base','drawarrowPath',handles.drawarrowPath);
    %     evalin('base','handles.drawarrowPath=drawarrowPath;')
else
    set(handles.Paths_listbox,'enable','off','visible','off');
    assignin('base','paths',[]);
end


set(handles.PowerInputs,'enable','on');

function Inputs_Callback(hObject,event_data,handles)
%let the user input data for the plate and cavity subsystems

handles.data = Inputstab(handles.data,handles.subsystems);

for i = 1:handles.val_plate
    
    %Creation of Plates Object
    handles.Plate(i) = Plate(i,handles.data{i}(1),...
        handles.data{i}(2),handles.data{i}(3),...
        handles.data{i}(4),handles.data{i}(5),...
        handles.data{i}(6),handles.data{i}(7));
    handles.SUBSYSTEMS{i} = handles.Plate(i);
end

% store number of plate objects for numbering of cavity objects
a = handles.val_plate;

for j = 1:handles.val_cavity-1
    
    %Creation of Cavity Object
    handles.Cavity(j) = Cavity(j+a,handles.data{j+a}(1),...
        handles.data{j+a}(2),handles.data{j+a}(3),...
        handles.data{j+a}(4),handles.data{j+a}(5),...
        handles.data{j+a}(6));
    handles.SUBSYSTEMS{j+a} = handles.Cavity(j);
    
end

%enable Coupling button
set(handles.Coupling_pushbutton,'enable','on');

% output subsystems to workspace
for k = 1:(handles.val_plate+handles.val_cavity-1)
    
    %workaround to save data from GUI to workspace struct
    assignin('base','temp',handles.SUBSYSTEMS{k});
    subsystems_string = strcat('subsystems(',int2str(k),').data = temp;');
    evalin('base',subsystems_string);
end

%clear the temporary variable used for the workaround
evalin('base','clear temp');

%Update handles structure
guidata(hObject,handles);

function Power_Callback(hObject,event_data,handles)
subsystems = evalin('base','subsystems');
contents = get(handles.frequencies_popupmenu,'String');
frequencies = contents{get(handles.frequencies_popupmenu,'Value')};
handles.frequencies = FrequencyBand(frequencies);
%connections = evalin('base','connections');
handles.data =PowerInputs(handles.data,handles.subsystems);
msgbox('The power input has been applied.');
%get input power
% contentInputPower = handles.InputPower_editbox;
% inputPower = str2double(contentInputPower.String);
%assignin('base','inp_pow',input_power);

%get number of subsystem where input power will be applied
% contentSubsystemOfInputPower = handles.Power_popupmenu;
% subsystemOfInputPower = contentSubsystemOfInputPower.Value;
%assignin('base','subsysOfInp',subsysOfInp);

%initialize global input power matrix and local input power vector
global allWavesFlag
if ~allWavesFlag
    handles.powerInputGlobal = zeros(length(subsystems),length(handles.frequencies));
    %powerInputLocal = zeros(length(subsystems),1);
    for i=1:length(subsystems)
        powerInputLocal(i) = handles.data{1}(i);
    end
    %fill up the local input power vector
    %powerInputLocal(subsystemOfInputPower) = inputPower;
else
    handles.powerInputGlobal = zeros(handles.subsystems(1)*3 +handles.subsystems(2)-1 ,length(handles.frequencies));
    for i=1:handles.subsystems (1)
        for j=1:3
            powerInputLocal(3*(i-1)+j) = handles.data{1}(i,j);
        end
    end
    for i=1:handles.subsystems (2)-1
        powerInputLocal(handles.subsystems (1)*3 + i) = handles.data{2}(i);
    end
end
%fill up the global input power matrix
for i=1:length(handles.frequencies)
    handles.powerInputGlobal(:,i) = powerInputLocal;
end
%enable the solution button
set(handles.solution_pushbutton,'enable','on');
set(handles.solution_Options_pushbutton,'enable','on');
guidata(hObject,handles);


function Save_Callback(handles)
global allWavesFlag
assignin('base','allWavesIncluded',allWavesFlag);
%get filename and path from user
[filename, pathname] = uiputfile('*.mat','Save Workspace As');

%make full path
savefile = fullfile(pathname, filename);

if filename == 0
    %write to workspace for user to remember
    dispString = 'disp(''No filename given. Saving aborted.'')';
    evalin('base',dispString);
    
else %filename selected
    
    %enable and disable buttons before saving
    set(handles.Create,'enable','off');
    set(handles.SystemInputs,'enable','off');
    set(handles.Coupling_pushbutton,'enable','off');
    set(handles.solution_pushbutton,'enable','on');
    set(handles.solution_Options_pushbutton,'enable','on');
    set(handles.PlotResults_pushbutton,'enable','on');
    set(handles.Save,'enable','off');
    set(handles.Load,'enable','on');
    set(handles.Reset,'enable','on');
    set(handles.Exit,'enable','on');
    
    %string for evalin command
    saveString = ['save(''' savefile ''',' handles.saveString ')'];
    
    %saving project data from workspace with popup GUI
    evalin('base',saveString);
    
    %enable and disable buttons after saving
    set(handles.Create,'enable','on');
    set(handles.SystemInputs,'enable','on');
    set(handles.Coupling_pushbutton,'enable','on');
    set(handles.solution_pushbutton,'enable','on');
    set(handles.solution_Options_pushbutton,'enable','on');
    set(handles.PlotResults_pushbutton,'enable','on');
    set(handles.Save,'enable','on');
    set(handles.Load,'enable','on');
    set(handles.Reset,'enable','on');
    set(handles.Exit,'enable','on');
    
    %write to workspace for user to remember
    dispString = ['disp(''The workspace have been saved to the file "' ...
        filename '".'')'];
    evalin('base',dispString);
end


function Load_Callback(handles)

%get filename from user
[filename,pathname] = uigetfile('*.mat','Load Workspace');

%make full path
loadfile = fullfile(pathname, filename);

if filename == 0
    %write to workspace for user to remember
    dispString = 'disp(''No file selected. Loading aborted.'')';
    evalin('base',dispString);
else
    %string for evalin command
    loadString = ['load(''' loadfile ''')'];
    
    %loading data into workspace with popup GUI
    evalin('base',loadString);
    
    %% draw visualization
    subsystems = evalin('base','subsystems');
    connections = evalin('base','connections');
%     handles = evalin('base','handles');
    handles.connections = connections;
    global allWavesFlag
    allWavesFlag = evalin('base','allWavesIncluded');
    handles.val_plate = 0;
    handles.val_cavity = 1; %has to be 1
    
    %get number of plates and cavities
    for i=1:length(subsystems)
        if strcmp(subsystems(i).type,'plate')
            handles.val_plate = handles.val_plate +1 ;
        else
            handles.val_cavity = handles.val_cavity + 1;
        end
    end
    
    % change the strings in the results windows
    handles.SubsystemString = {};
    for counterPlate=1:handles.val_plate
        handles.SubsystemString{end+1} = ['Plate ',int2str(counterPlate)];
    end
    
    if handles.val_cavity > 1
        for counterCavity=1:(handles.val_cavity-1)
            handles.SubsystemString{end+1} = ['Cavity ',...
                int2str(counterCavity)];
        end
    end
    
    % Update string in subsystems listbox
    set(handles.Subsystems_listbox,'string',handles.SubsystemString);
    %make multiple selection in subsystems listbox available
    set(handles.Subsystems_listbox,'min',0,'max',...
        length(handles.SubsystemString));
    
    % Update string in CLF plot listbox
    handles.CLFstring = {};
    counterPlatesPlates = 0;
    counterCavitiesPlates =0;
    for counter= 1:length(handles.connections)
        %     handles.CLFstring{end+1} = strcat('eta',...
        %         handles.connections(1,counter).getID);
        if handles.connections(1,counter).getElementI > handles.val_plate
            stringOfFirstElement=strcat('C',num2str(handles.connections(1,counter).getElementI-handles.val_plate));
        else
            stringOfFirstElement=strcat('P',num2str(handles.connections(1,counter).getElementI));
        end
        if handles.connections(1,counter).getElementJ > handles.val_plate
            stringOfSecondElement=strcat('C',num2str(handles.connections(1,counter).getElementJ-handles.val_plate));
        else
            stringOfSecondElement=strcat('P',num2str(handles.connections(1,counter).getElementJ));
        end
        if handles.connections(1,counter).getElementI > handles.val_plate || handles.connections(1,counter).getElementJ > handles.val_plate
            counterCavitiesPlates = counterCavitiesPlates+1;
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement);
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement);
        else
            %for plate1 to plate2
            counterPlatesPlates = counterPlatesPlates + 1;
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - B2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - L2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - S2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - L2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - S2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - L2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - S2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - B2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfFirstElement,stringOfSecondElement,' - B2S');
            %for plate2 to plate1
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - B2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - L2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - S2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - L2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - S2B');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - L2S');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - S2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - B2L');
            handles.CLFstring{end+1} = strcat('eta',stringOfSecondElement,stringOfFirstElement,' - B2S');
        end
    end
    %update string in CLF listbox
    set(handles.CLF_listbox,'string',handles.CLFstring);
    %make multiple selection in listbox with CLFs available
    set(handles.CLF_listbox,'Min',0,'Max',18*counterPlatesPlates + 2 * counterCavitiesPlates);
    
    %enable and disable buttons
    set(handles.Create,'enable','off');
    set(handles.SystemInputs,'enable','off');
    set(handles.Coupling_pushbutton,'enable','off');
    set(handles.solution_pushbutton,'enable','off');
     set(handles.solution_Options_pushbutton,'enable','off');
    set(handles.PlotResults_pushbutton,'enable','on');
    set(handles.Save,'enable','off');
    set(handles.Load,'enable','on');
    set(handles.Reset,'enable','on');
    set(handles.Exit,'enable','on');
    
    %write to workspace for user to remember
    dispString = ['disp(''The file "' filename '" has been loaded.'')'];
    evalin('base',dispString);
end


function Reset_Callback(hObject,handles)

%popup to verify that the button was not pushed accidentally
resetAnswer = questdlg('Do you really want to reset the program?',...
    'Reset Check','Yes','No','Yes');

switch resetAnswer,
    case 'Yes',
        
        %delete existing visualization
        if handles.isDrawnRec == 1
            delete(handles.drawrec);
            delete(handles.txtrec);
        end
        
        if handles.isDrawnCirc == 1
            delete(handles.drawcirc);
            delete(handles.txtcirc);
        end
        
        %try to delete the arrows (no catch statement as the error
        %can only be that handles.drawarrow does not exist)
        try
            evalin('base','delete(handles.drawarrow)');
            %initialization of the arrows
            handles.drawarrow(1) = annotation('arrow','parent',handles.VisFigure,...
                'position',[0 0 0 0],'visible','off');
            
            
        end
        try
            evalin('base','delete(handles.drawarrowPath)');
            %initialization of the arrows
            handles.drawarrowPath(1) = annotation('arrow','parent',handles.VisFigure,...
                'position',[0 0 0 0],'visible','off');
        end
        handles.drawrec=[];
        handles.drawcirc=[];
        handles.txtrec=[];
        handles.txtcirc=[];
        
        %hide GUI from being closed
        set(handles.output, 'HandleVisibility', 'off');
        
        %close all figures
        evalin('base','close all');
        
        %unhide GUI again
        set(handles.output, 'HandleVisibility', 'on');
        
        %delete data in the workspace
        evalin('base',handles.clearString);
        
        %write to workspace for user to remember
        evalin('base','disp(''The program has been reset.'')');
        
        %enable and disable buttons
        set(handles.Create,'enable','on');
        set(handles.SystemInputs,'enable','off');
        set(handles.Coupling_pushbutton,'enable','off');
        set(handles.solution_pushbutton,'enable','off');
        set(handles.solution_Options_pushbutton,'enable','off');
        set(handles.PlotResults_pushbutton,'enable','off');
        set(handles.Save,'enable','off');
        set(handles.Load,'enable','on');
        set(handles.Reset,'enable','on');
        set(handles.Exit,'enable','on');
        set(handles.PowerInputs,'enable','off');
        
        set(handles.pathStart,'enable','off')
        set(handles.pathEnd,'enable','off')
        set(handles.pathFrequency,'enable','off')
        set(handles.pathStart_popupmenu,'enable','off')
        set(handles.pathEnd_popupmenu,'enable','off')
        set(handles.pathFrequency_popupmenu,'enable','off')
        set(handles.pathNextButton,'enable','off')
        set(handles.pathPreviousButton,'enable','off')
        set(handles.pathClearButton,'enable','off')
        
        set (handles.PlotPathAnalysis_pushbutton,'enable','off');
        %Update handles structure
        guidata(hObject,handles);
        
    case 'No'
        return
end


function Exit_Callback(handles)

%popup to verify that the button was not pushed accidentally
exitAnswer = questdlg('Do you really want to exit the program?',...
    'Exit Check',...
    'Yes','No','Yes');

switch exitAnswer,
    case 'Yes',
        %delete data in the workspace
        evalin('base',handles.clearString);
        evalin('base','clear drawarrow');
        
        %write to workspace for user to remember
        evalin('base','disp(''The program has been exited.'')');
        
        %close all figures and GUIs
        evalin('base','close all');
    case 'No'
        return
end


function ResultsListbox_Callback(hObject,event_data,handles)
%enable the CLF listbox or the subsystems listbox depending on selection
%in the results listbox

%get current selection in the results listbox
CurrentSelection = get(handles.Results_listbox,'value');

%change listboxes on the right only when 1 item is selected
if length(CurrentSelection) == 1
    switch CurrentSelection
        
        case 1 %modal density
            set(handles.CLF_listbox,'Visible','Off');
            set(handles.Subsystems_listbox,'Visible','On');
            set(handles.Paths_listbox,'Visible','Off');
            
        case 2 %modal overlap factor
            set(handles.CLF_listbox,'Visible','Off');
            set(handles.Subsystems_listbox,'Visible','On');
            set(handles.Paths_listbox,'Visible','Off');
            
        case 3 %energy
            set(handles.CLF_listbox,'Visible','Off');
            set(handles.Subsystems_listbox,'Visible','On');
            set(handles.Paths_listbox,'Visible','Off');
            
        case 4 %engineering values
            set(handles.CLF_listbox,'Visible','Off');
            set(handles.Subsystems_listbox,'Visible','On');
            set(handles.Paths_listbox,'Visible','Off');
            
        case 5 %engineering levels
            set(handles.CLF_listbox,'Visible','Off');
            set(handles.Subsystems_listbox,'Visible','On');
            set(handles.Paths_listbox,'Visible','Off');
            
        case 6 %power input
            set(handles.CLF_listbox,'Visible','Off');
            set(handles.Subsystems_listbox,'Visible','On');
            set(handles.Paths_listbox,'Visible','Off');
            
        case 7 %coupling loss factors
            set(handles.CLF_listbox,'Visible','On');
            set(handles.Subsystems_listbox,'Visible','Off');
            set(handles.Paths_listbox,'Visible','Off');
            
        case 8 %paths
            set(handles.CLF_listbox,'Visible','Off');
            set(handles.Subsystems_listbox,'Visible','Off');
            set(handles.Paths_listbox,'Visible','On');
    end
end

%update handles
guidata(hObject,handles);


function PlotResults_Callback(hObject,event_data,handles)
%plot the results when pushing the "Plot Results" button

%---------------------------Results Figure---------------------------------
% % close all figures
%     %hide GUI from being closed
%     set(handles.output, 'HandleVisibility', 'off');
%
%     %close all figures
%     evalin('base','close all');
%
%     %unhide GUI again
%     set(handles.output, 'HandleVisibility', 'on');

%generate new figure with results
resultsFigure = figure('name','Results');

%pixels
set(resultsFigure,'Units','pixels');

%get your display size
screenSize = get(0,'ScreenSize');

%calculate the center of the display
position = get(resultsFigure,'Position');
position(1) = (screenSize(3)-position(3))/2;
position(2) = (screenSize(4)-position(4))/2;

%center the window
set(resultsFigure,'Position',position);

%get the items to be plotted
selectionResultsListbox = get(handles.Results_listbox,'value');

%get subsystem struct and frequencies from workspace
subsystems = evalin('base','subsystems');
frequencies = evalin('base','frequencies');
connections = evalin('base','connections');
handles.paths = evalin('base','paths');

%set up colormap for following dynamic plot
colormap=colororder;

%only generate TABs depending on user choice
tabgp = uitabgroup(resultsFigure,'Position',[.05 .05 0.9 0.9]);

global allWavesFlag
%get number of plates
numOfPlates = 0;
for i=1:length(subsystems)
    if strcmp(subsystems(i).type,'plate')
        numOfPlates = numOfPlates +1;
    else
        break
    end
end

for i=1:length(selectionResultsListbox)
    switch selectionResultsListbox(i)
        case 1 %modal density
            tab1 = uitab(tabgp,'Title','Modal Density');
            handles.axesMD = axes('Parent',tab1,...
                'Position',[.12 .12 0.80 0.80]);
            
            %get the subsystems to be plotted
            subsysToBePlotted = get(handles.Subsystems_listbox,'value');
            
            %axes(handles.axesEnergy)
            for subsysCount = subsysToBePlotted
                %                         plotSmthng = 0;
                legendName = subsystems(subsysCount).type;
                if subsysCount <= numOfPlates
                    subsysNum = subsysCount;
                    plateFlag = 1;
                else %cavity
                    subsysNum = subsysCount - numOfPlates;
                    plateFlag = 0;
                end
                if allWavesFlag && plateFlag
                    for j=1:3
                        if j==1;wave = 'longitudinal';marker = 's';...
                        elseif j==2; wave = 'shear';marker = 'x';elseif j==3;wave='bending';marker = 'o';end
                    loglog(frequencies,subsystems(subsysCount).modal_density{j},...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum),' - ',wave],'Marker',marker);
                    hold on
                    end
                else
                    loglog(frequencies,subsystems(subsysCount).modal_density,...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum)],'Marker','o');
                end
                hold on
            end
            
            title('Modal Density')
            xlabel('Frequency [Hz]')
            ylabel('Modal Density')
            legend('-DynamicLegend')
            grid on
            
        case 2 %modal overlap factor
            tab2 = uitab(tabgp,'Title','Modal Overlap Factor');
            handles.axesMOF = axes('Parent',tab2,...
                'Position',[.12 .12 0.80 0.80]);
            
            %get the subsystems to be plotted
            subsysToBePlotted = get(handles.Subsystems_listbox,'value');
            
            %axes(handles.axesEnergy)
            for subsysCount = subsysToBePlotted
                
                legendName = subsystems(subsysCount).type;
                if subsysCount <= numOfPlates
                    subsysNum = subsysCount;
                    plateFlag = 1;
                else %cavity
                    subsysNum = subsysCount - numOfPlates;
                    plateFlag = 0;
                end
                if allWavesFlag && plateFlag
                    for j=1:3
                        if j==1;wave = 'longitudinal';marker = 's';...
                        elseif j==2; wave = 'shear';marker = 'x';elseif j==3;wave='bending';marker = 'o';end
                    loglog(frequencies,subsystems(subsysCount).modal_overlap{j},...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum),' - ',wave],'Marker',marker);
                    hold on
                    end
                else
                    loglog(frequencies,subsystems(subsysCount).modal_overlap,...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum)],'Marker','o');
                end
                hold on
            end
            
            title('Modal Overlap Factor')
            xlabel('Frequency [Hz]')
            ylabel('Modal Overlap Factor')
            legend('-DynamicLegend')
            grid on
            
        case 3 %energy
            tab3 = uitab(tabgp,'Title','Energy');
            handles.axesEnergy = axes('Parent',tab3,...
                'Position',[.12 .12 0.80 0.80]);
            
            %get the subsystems to be plotted
            subsysToBePlotted = get(handles.Subsystems_listbox,'value');
            
            %axes(handles.axesEnergy)
            for subsysCount = subsysToBePlotted
                
                legendName = subsystems(subsysCount).type;
                if subsysCount <= numOfPlates
                    subsysNum = subsysCount;
                    plateFlag = 1;
                else %cavity
                    subsysNum = subsysCount - numOfPlates;
                    plateFlag = 0;
                end
                if allWavesFlag && plateFlag
                    for j=1:3
                        if j==1;wave = 'longitudinal';marker = 's';...
                        elseif j==2; wave = 'shear';marker = 'x';elseif j==3;wave='bending';marker = 'o';end
                    loglog(frequencies,subsystems(subsysCount).energy{j},...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum),' - ',wave],'Marker',marker);
                    hold on
                    end
                else
                    loglog(frequencies,subsystems(subsysCount).energy,'color',...
                        colormap(subsysCount,:),'DisplayName',[legendName,' ',...
                        num2str(subsysNum)],'Marker','o');
                end
                hold on
            end
            
            title('System Energies')
            xlabel('Frequency [Hz]')
            ylabel('Energy [J]')
            legend('-DynamicLegend')
            grid on
            
        case 4 %engineering values
            tab4 = uitab(tabgp,'Title','Engineering Values');
            handles.axesEngVal = axes('Parent',tab4,...
                'Position',[.12 .12 0.80 0.80]);
            
            %get the subsystems to be plotted
            subsysToBePlotted = get(handles.Subsystems_listbox,'value');
            
            %axes(handles.axesEnergy)
            for subsysCount = subsysToBePlotted
                
                legendName = subsystems(subsysCount).type;
                if subsysCount <= numOfPlates
                    subsysNum = subsysCount;
                    plateFlag = 1;
                else %cavity
                    subsysNum = subsysCount - numOfPlates;
                    plateFlag = 0;
                end
                if allWavesFlag && plateFlag
                    for j=1:3
                        if j==1;wave = 'longitudinal';marker = 's';...
                        elseif j==2; wave = 'shear';marker = 'x';elseif j==3;wave='bending';marker = 'o';end
                    loglog(frequencies,subsystems(subsysCount).eng_value{j},...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum),' - ',wave],'Marker',marker);
                    hold on
                    end
                else
                    loglog(frequencies,subsystems(subsysCount).eng_value,...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum)],'Marker','o');
                end
                hold on
            end
            
            title('Engineering Values')
            xlabel('Frequency [Hz]')
            ylabel('Surface Velocity [m/s] / Sound Pressure [N/m^2]')
            legend('-DynamicLegend')
            grid on
            
        case 5 %engineering levels
            tab5 = uitab(tabgp,'Title','Engineering Levels');
            handles.axesEngVal = axes('Parent',tab5,...
                'Position',[.12 .12 0.80 0.80]);
            
            %get the subsystems to be plotted
            subsysToBePlotted = get(handles.Subsystems_listbox,'value');
            
            %axes(handles.axesEnergy)
            for subsysCount = subsysToBePlotted
                
                legendName = subsystems(subsysCount).type;
                if subsysCount <= numOfPlates
                    subsysNum = subsysCount;
                    plateFlag = 1;
                else %cavity
                    subsysNum = subsysCount - numOfPlates;
                    plateFlag = 0;
                end
                if allWavesFlag && plateFlag
                    for j=1:3
                        if j==1;wave = 'longitudinal';marker = 's';...
                        elseif j==2; wave = 'shear';marker = 'x';elseif j==3;wave='bending';marker = 'o';end
                    semilogx(frequencies,subsystems(subsysCount).eng_level{j},...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum),' - ',wave],'Marker',marker);
                    hold on
                    end
                else
                    semilogx(frequencies,subsystems(subsysCount).eng_level,...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum)],'Marker','o');
                end
                hold on
            end
            
            title('Engineering Levels')
            xlabel('Frequency [Hz]')
            ylabel('Velocity Level / Sound Pressure Level [dB]')
            legend('-DynamicLegend')
            grid on
            
        case 6 %power input
            tab6 = uitab(tabgp,'Title','Power Input');
            handles.axesPowInp = axes('Parent',tab6,...
                'Position',[.12 .12 0.80 0.80]);
            
            %get the subsystems to be plotted
            subsysToBePlotted = get(handles.Subsystems_listbox,'value');
            
            %axes(handles.axesEnergy)
            for subsysCount = subsysToBePlotted
                
                legendName = subsystems(subsysCount).type;
                if subsysCount <= numOfPlates
                    subsysNum = subsysCount;
                    plateFlag = 1;
                else %cavity
                    subsysNum = subsysCount - numOfPlates;
                    plateFlag = 0;
                end
                if allWavesFlag && plateFlag
                    for j=1:3
                        if j==1;wave = 'longitudinal';marker = 's';...
                        elseif j==2; wave = 'shear';marker = 'x';elseif j==3;wave='bending';marker = 'o';end
                    semilogx(frequencies,subsystems(subsysCount).input_power{j},...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum),' - ',wave],'Marker',marker);
                    hold on
                    end
                else
                    semilogx(frequencies,subsystems(subsysCount).input_power,...
                        'color',colormap(subsysCount,:),'DisplayName',...
                        [legendName,' ',num2str(subsysNum)],'Marker','o');
                end
                hold on
            end
            
            title('Input Power')
            xlabel('Frequency [Hz]')
            ylabel('Input Power [W]')
            legend('-DynamicLegend')
            grid on
            
        case 7 %coupling loss factors
            
            %only open the coupling loss factors TAB when
            %the user only sected THIS option
            if length(selectionResultsListbox) == 1
                
                tab7 = uitab(tabgp,'Title','Coupling Loss Factors');
                handles.axesCLF = axes('Parent',tab7,...
                    'Position',[.12 .12 0.80 0.80]);
                
                %get the CLFs to be plotted
                subsysToBePlotted = get(handles.CLF_listbox,'value');
                
                %plot the selected CLFs
                for subsysCount = subsysToBePlotted
                    
                    %get list of CLF strings in CLF_listbox
                    list = get(handles.CLF_listbox,'String');
                    clfid = list{subsysCount};
                    
                    %split string to get number
                    temp1= strsplit(clfid,'a');
                    %string with number of CLF
                    %                    clfid=temp1{2};
                    temp=temp1{2};
                    if strcmp(temp(1),'P')
                        firstSubs=temp(2);
                        plate1Flag = 1;
                    else
                        firstSubs=num2str(str2num(temp(2))+handles.val_plate);
                        plate1Flag = 0;
                    end
                    if strcmp(temp(3),'P')
                        secSubs=temp(4);
                        plate2Flag = 1;
                    else
                        secSubs=num2str(str2num(temp(4))+handles.val_plate);
                        plate2Flag = 0;
                    end
                    clfid=strcat(firstSubs,secSubs);
                    legendName = 'eta';
                    %which wave will be plotted
                    if allWavesFlag && plate1Flag && plate2Flag
                        wave2bePlotted = strcat(temp(8),temp(9),temp(10));
                        if strcmp(temp(8),'B')
                            waveFrom=3;
                        elseif strcmp(temp(8),'S')
                            waveFrom=2;
                        elseif strcmp(temp(8),'L')
                            waveFrom=1;
                        end
                        if strcmp(temp(10),'B')
                            waveTo=3;
                        elseif strcmp(temp(10),'S')
                            waveTo=2;
                        elseif strcmp(temp(10),'L')
                            waveTo=1;
                        end
                    end
                    for ii=1:length(connections)
                        plotSmthng = 0;
                        if strcmp(connections(ii).getID,clfid)
                            clfToPlot = connections(ii).getCLF;
                            plotSmthng = 1;
                        elseif strcmp(connections(ii).getInvID,clfid)
                            clfToPlot = connections(ii).getRCLF;
                            plotSmthng = 1;
                        end
                        if plotSmthng
                            if ~(allWavesFlag && plate1Flag && plate2Flag)
                            
                                CLFPlot = clfToPlot;
                            else
                                for ff=1:length(frequencies)
                                    
                                    CLFPlot(ff) = clfToPlot{ff}(waveFrom,waveTo+3);
                                end
                            end
                            loglog(frequencies,CLFPlot,...
                                'color',colormap(subsysCount,:),'DisplayName',...
                                [legendName,' ',temp],'Marker','o');
                        end
                        hold on
                    end
                    
                end
                
                
                title('Coupling Loss Factors')
                xlabel('Frequency [Hz]')
                ylabel('Coupling Loss Factor [-]')
                legend('-DynamicLegend')
                grid on
            end
        case 8 %paths
            
            %only open the coupling loss factors TAB when
            %the user only sected THIS option
            if length(selectionResultsListbox) == 1
                
                tab8 = uitab(tabgp,'Title','Paths');
                handles.axesPaths = axes('Parent',tab8,...
                    'Position',[.12 .12 0.80 0.80]);
                
                %get the CLFs to be plotted
                subsysToBePlotted = get(handles.Paths_listbox,'value');
                
                %plot the selected CLFs
                for subsysCount = subsysToBePlotted
                    
                    %get list of CLF strings in CLF_listbox
                    list = get(handles.Paths_listbox,'String');
                    pathid = list{subsysCount};
                    
                    %split string to get number
                    temp1= strsplit(pathid,':');
                    %string with number of CLF
                    %                    clfid=temp1{2};
                    path=temp1{2};
                    temp=strsplit(path,'->');
                    startSub=temp{1};
                    endSub=temp{2};
                    if strcmp(startSub(1),'P')
                        firstSubs=startSub(2);
                    else
                        firstSubs=num2str(str2num(startSub(2))+handles.val_plate);
                    end
                    if strcmp(endSub(1),'P')
                        secSubs=endSub(2);
                    else
                        secSubs=num2str(str2num(endSub(2))+handles.val_plate);
                    end
                    
                    counterColor=1;
                    for ii=1:length(handles.paths)
                        if handles.paths(ii).idPath(1)==str2num(firstSubs) && handles.paths(ii).idPath(end)==str2num(secSubs)
                            counterColor=counterColor+1;
                            legendName=' ';
                            for jj=1:length(handles.paths(ii).idPath)
                                if handles.paths(ii).idPath(jj) > handles.val_plate
                                    stringAdded=strcat('C',num2str(handles.paths(ii).idPath(jj)-handles.val_plate));
                                else
                                    stringAdded=strcat('P',num2str(handles.paths(ii).idPath(jj)));
                                end
                                if jj > 1
                                    legendName=strcat(legendName,'->',stringAdded);
                                else
                                    legendName=strcat(legendName,stringAdded);
                                end
                            end
                            loglog(frequencies,handles.paths(ii).couplingLossFactor,...
                                'color',colormap(counterColor+subsysCount,:),'DisplayName',...
                                legendName,'Marker','o');
                            hold on
                        end
                        
                    end
                    
                    
                end
                
            end
            
            
            title('Paths')
            xlabel('Frequency [Hz]')
            ylabel('Energy Loss Factor [-]')
            legend('-DynamicLegend')
            grid on
    end
end


function PathAnalysisPlot_Callback(hObject,event_data,handles)
set(handles.pathStart,'enable','on')
set(handles.pathEnd,'enable','on')
set(handles.pathFrequency,'enable','on')
set(handles.pathStart_popupmenu,'enable','on')
set(handles.pathEnd_popupmenu,'enable','on')
set(handles.pathFrequency_popupmenu,'enable','on')
set(handles.pathNextButton,'enable','on')
set(handles.pathPreviousButton,'enable','on')
set(handles.pathClearButton,'enable','on')

function PathAnalysisShow_Callback(hObject,event_data,handles)
handles.positionObject=evalin('base','positionObject');
handles.paths = evalin('base','paths');
handles.drawarrowPath = evalin('base','handles.drawarrowPath');
% handles.drawarrowPath=evalin('base','handles.drawarrowPath');
frequencyIndex=get(handles.pathFrequency_popupmenu,'Value');
value = get(handles.pathStart_popupmenu,'Value');
firstlist = get(handles.pathStart_popupmenu,'String');
SubsystemStart = firstlist{value};
value= get(handles.pathEnd_popupmenu,'Value');
SubsystemEnd = firstlist{value};

if strncmp(SubsystemStart,'P',1)
    temp1= strsplit(SubsystemStart,' ');
    Subsystem1text=['Plate ',temp1{2}];
    Subsystem1 = str2num(temp1{2});
else
    temp1= strsplit(SubsystemStart,' ');
    Subsystem1text=['Cavity ',temp1{2}];
    Subsystem1 = str2num(temp1{2})+handles.val_plate;
end

if strncmp(SubsystemEnd,'P',1)
    temp1= strsplit(SubsystemEnd,' ');
    Subsystem2text=['Plate ',temp1{2}];
    Subsystem2 = str2num(temp1{2});
else
    temp1= strsplit(SubsystemEnd,' ');
    Subsystem2text=['Cavity ',temp1{2}];
    Subsystem2 = str2num(temp1{2})+handles.val_plate;
end
pathsMatchingArray=PathsCouplings.empty;
for i=1:length(handles.paths)
    if  handles.paths(i).idPath(1)==Subsystem1 && handles.paths(i).idPath(end)==Subsystem2
        pathsMatchingArray(end+1)=handles.paths(i);
    end
end
if length(pathsMatchingArray)==0
    msgbox('There is no path connecting the two subsystems.')
    set(handles.drawarrowPath(:),'visible','off');
    return
end
%% sort the paths from most important (smaller value) to least
tempPath=PathsCouplings.empty;
for i=1:length(pathsMatchingArray)-1
    for j=1:length(pathsMatchingArray)-1
        if pathsMatchingArray(j).couplingLossFactor(frequencyIndex) > pathsMatchingArray(j+1).couplingLossFactor(frequencyIndex)
            tempPath=pathsMatchingArray(j);
            pathsMatchingArray(j)=pathsMatchingArray(j+1);
            pathsMatchingArray(j+1)=tempPath;
        end
    end
end
%% arrows should be drawn showing the path and a button of next and a button of previous path
set(handles.drawarrowPath(:),'visible','off');
for i=1:length(pathsMatchingArray(1).idPath(:))-1
    
    for j=1:length(handles.positionObject(:,1))
        for k=1:length(handles.positionObject(:,1))
            if handles.positionObject(j,3)==pathsMatchingArray(1).idPath(i) && handles.positionObject(k,3)==pathsMatchingArray(1).idPath(i+1)
                arrowRelative(1)=handles.positionObject(k,1)-handles.positionObject(j,1);
                arrowRelative(2)=handles.positionObject(k,2)-handles.positionObject(j,2);
                set(handles.drawarrowPath(i+1),'visible','on','position',[handles.positionObject(j,1)+25 ...
                    handles.positionObject(j,2)+25  arrowRelative(1)  arrowRelative(2)])
            end
        end
    end
end
plottedPath=1;
assignin('base','pathsMatchingArray',pathsMatchingArray);
assignin('base','plottedPath',plottedPath)
function PathAnalysisNext_Callback(hObject,event_data,handles)
pathsMatchingArray=evalin('base','pathsMatchingArray');
plottedPath2=evalin('base','plottedPath');
handles.positionObject=evalin('base','positionObject');
handles.paths = evalin('base','paths');
handles.drawarrowPath = evalin('base','handles.drawarrowPath');
set(handles.drawarrowPath(:),'visible','on');
plottedPath=plottedPath2+1;
if plottedPath> length(pathsMatchingArray)
    plottedPath=1;
end
if length(pathsMatchingArray(plottedPath2).idPath(:))>length(pathsMatchingArray(plottedPath).idPath(:))
    for i=1:(length(pathsMatchingArray(plottedPath2).idPath(:))-length(pathsMatchingArray(plottedPath).idPath(:)))
        set(handles.drawarrowPath(end+1-i),'visible','off')
    end
end
set(handles.drawarrowPath(:),'visible','off');
for i=1:length(pathsMatchingArray(plottedPath).idPath(:))-1
    
    for j=1:length(handles.positionObject(:,1))
        for k=1:length(handles.positionObject(:,1))
            if handles.positionObject(j,3)==pathsMatchingArray(plottedPath).idPath(i) && handles.positionObject(k,3)==pathsMatchingArray(plottedPath).idPath(i+1)
                arrowRelative(1)=handles.positionObject(k,1)-handles.positionObject(j,1);
                arrowRelative(2)=handles.positionObject(k,2)-handles.positionObject(j,2);
                set(handles.drawarrowPath(i+1),'visible','on','position',[handles.positionObject(j,1)+25 ...
                    handles.positionObject(j,2)+25  arrowRelative(1)  arrowRelative(2)])
            end
        end
    end
end
assignin('base','pathsMatchingArray',pathsMatchingArray);
assignin('base','plottedPath',plottedPath)

function PathAnalysisPrevious_Callback(hObject,event_data,handles)
pathsMatchingArray=evalin('base','pathsMatchingArray');
plottedPath2=evalin('base','plottedPath');
handles.positionObject=evalin('base','positionObject');
handles.paths = evalin('base','paths');
handles.drawarrowPath = evalin('base','handles.drawarrowPath');
set(handles.drawarrowPath(:),'visible','on');
plottedPath=plottedPath2-1;
if plottedPath< 1
    plottedPath=length(pathsMatchingArray);
end

if length(pathsMatchingArray(plottedPath2).idPath(:))>length(pathsMatchingArray(plottedPath).idPath(:))
    for i=1:(length(pathsMatchingArray(plottedPath2).idPath(:))-length(pathsMatchingArray(plottedPath).idPath(:)))
        set(handles.drawarrowPath(end+1-i),'visible','off')
    end
end
set(handles.drawarrowPath(:),'visible','off');

for i=1:length(pathsMatchingArray(plottedPath).idPath(:))-1
    
    for j=1:length(handles.positionObject(:,1))
        for k=1:length(handles.positionObject(:,1))
            if handles.positionObject(j,3)==pathsMatchingArray(plottedPath).idPath(i) && handles.positionObject(k,3)==pathsMatchingArray(plottedPath).idPath(i+1)
                arrowRelative(1)=handles.positionObject(k,1)-handles.positionObject(j,1);
                arrowRelative(2)=handles.positionObject(k,2)-handles.positionObject(j,2);
                set(handles.drawarrowPath(i+1),'visible','on','position',[handles.positionObject(j,1)+25 ...
                    handles.positionObject(j,2)+25  arrowRelative(1)  arrowRelative(2)])
            end
        end
    end
end
assignin('base','pathsMatchingArray',pathsMatchingArray);
assignin('base','plottedPath',plottedPath)

function PathAnalysisClear_Callback(hObject,event_data,handles)
pathsMatchingArray=evalin('base','pathsMatchingArray');
plottedPath2=evalin('base','plottedPath');
handles.positionObject=evalin('base','positionObject');
handles.paths = evalin('base','paths');
handles.drawarrowPath = evalin('base','handles.drawarrowPath');
set(handles.drawarrowPath(:),'visible','off');
%% somehow the whole path should be plotted

