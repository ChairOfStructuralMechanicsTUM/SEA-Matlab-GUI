function varargout = Couplings(varargin)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
% Couplings MATLAB code for Couplings.fig
%      Couplings, by itself, creates a new Couplings or raises the existing
%      singleton*.
%
%      H = Couplings returns the handle to a new Couplings or the handle to
%      the existing singleton*.
%
%      Couplings('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Couplings.M with the given input arguments.
%
%      Couplings('Property','Value',...) creates a new Couplings or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Couplings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Couplings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Couplings

% Last Modified by GUIDE v2.5 24-Oct-2015 11:46:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Couplings_OpeningFcn, ...
    'gui_OutputFcn',  @Couplings_OutputFcn, ...
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


% --- Executes just before Couplings is made visible.
function Couplings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Couplings (see VARARGIN)
global allWavesFlag;
% Choose default command line output for Couplings
handles.output = hObject;

handles.input = varargin{1};
handles.SUBSYSTEMS = varargin{2};
handles.subsystems = handles.input(1)+handles.input(2)-1;
handles.frequencies = varargin{3};
handles.VisFigure=varargin{4};
handles.ConnectionDescription = '';
handles.positionRec=evalin('base','positionRec');
handles.positionCirc=evalin('base','positionCirc');
handles.arrowStart=[];
handles.arrowEnd=[];
handles.arrowRelative=[];

handles.drawarrow(1)=annotation('arrow','parent',handles.VisFigure,...
    'position',[0 0 0 0],'visible','off');

% Generate String
for counter = 1:handles.input(1)
    NoOfSubsystems{counter} = ['Plate ',num2str(counter)];
end
for counter = 1:handles.input(1)
    NoOfPlates{counter} = num2str(counter);
end
for counter = 1:(handles.input(2)-1)
    NoOfSubsystems{end+1}= ['Cavity ',num2str(counter)];
end

%pixels
set(handles.Couplings,'Units','pixels');

%get your display size
screenSize = get(0,'ScreenSize');

%calculate the center of the display
position = get(handles.Couplings,'Position');
position(1) = (screenSize(3)-position(3))/2;
position(2) = (screenSize(4)-position(4))/2;

%center the window
set(handles.Couplings,'Position',position);

%-------------------------------TABS---------------------------------------
tabgp = uitabgroup('Units','Pixels','Position',[10 230 460 180],'parent',handles.Couplings);

handles.NormalConnection = uitab(tabgp,'Title','L-Connection');
handles.TConnection = uitab(tabgp,'Title','T-Connection');
handles.CrossConnection = uitab(tabgp,'Title','X-Connection');

%----------------------------------Strings---------------------------------
uicontrol(handles.NormalConnection,'style','text','string','Subsystem',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[10 120 100 20]);
uicontrol(handles.NormalConnection,'style','text','string','Subsystem',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[120 120 100 20]);
uicontrol(handles.TConnection,'style','text','string','Plate',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[10 120 100 20]);
uicontrol(handles.TConnection,'style','text','string','Plate',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[120 120 100 20]);
uicontrol(handles.TConnection,'style','text','string','Plate',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[230 120 100 20]);
uicontrol(handles.CrossConnection,'style','text','string','Plate',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[10 120 100 20]);
uicontrol(handles.CrossConnection,'style','text','string','Plate',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[120 120 100 20]);
uicontrol(handles.CrossConnection,'style','text','string','Plate',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[230 120 100 20]);
uicontrol(handles.CrossConnection,'style','text','string','Plate',...
    'HorizontalAlignment','center','Fontsize',11,'Units','pixels',...
    'Position',[340 120 100 20]);

handles.lengthTextNormal=uicontrol(handles.NormalConnection,'style',...
    'text','string','Length of Connection:','HorizontalAlignment',...
    'right','Fontsize',11,'Units','pixels','Position',[10 40 155 20]);
% global allWavesFlag
if allWavesFlag
    handles.angleTextNormal=uicontrol(handles.NormalConnection,'style',...
    'text','string','Angle of Connection:','HorizontalAlignment',...
    'right','Fontsize',11,'Units','pixels','Position',[10 10 155 20]);
end
uicontrol(handles.TConnection,'style','text','string',...
    'Length of Connection:','HorizontalAlignment','right','Fontsize',...
    11,'Units','pixels','Position',[10 40 155 20]);
uicontrol(handles.CrossConnection,'style','text','string',...
    'Length of Connection:','HorizontalAlignment','right','Fontsize',...
    11,'Units','pixels','Position',[10 40 155 20]);

%--------------------------------------------------------------------------

%---------------------------Drop Down Menus--------------------------------

handles.FirstNormal_popupmenu = uicontrol('Parent',handles.NormalConnection,...
    'style','popupmenu','string',NoOfSubsystems,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[20 90 80 20]);

handles.SecondNormal_popupmenu = uicontrol('Parent',handles.NormalConnection,...
    'style','popupmenu','string',NoOfSubsystems,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[130 90 80 20]);

handles.FirstT_popupmenu = uicontrol('Parent',handles.TConnection,...
    'style','popupmenu','string',NoOfPlates,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[20 90 80 20]);

handles.SecondT_popupmenu = uicontrol('Parent',handles.TConnection,...
    'style','popupmenu','string',NoOfPlates,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[130 90 80 20]);

handles.ThirdT_popupmenu = uicontrol('Parent',handles.TConnection,...
    'style','popupmenu','string',NoOfPlates,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[240 90 80 20]);

handles.FirstCross_popupmenu = uicontrol('Parent',handles.CrossConnection,...
    'style','popupmenu','string',NoOfPlates,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[20 90 80 20]);


handles.SecondCross_popupmenu = uicontrol('Parent',handles.CrossConnection,...
    'style','popupmenu','string',NoOfPlates,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[130 90 80 20]);

handles.ThirdCross_popupmenu = uicontrol('Parent',handles.CrossConnection,...
    'style','popupmenu','string',NoOfPlates,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[240 90 80 20]);


handles.FourthCross_popupmenu = uicontrol('Parent',handles.CrossConnection,...
    'style','popupmenu','string',NoOfPlates,...
    'HorizontalAlignment','right',...
    'FontSize',9,...
    'position',[350 90 80 20]);

%--------------------------------------------------------------------------

%--------------------------Edit Text Box-----------------------------------

handles.LengthofNormalConnection = uicontrol(handles.NormalConnection,...
    'style','edit','string','','HorizontalAlignment','Center','Units',...
    'pixels','Position',[170 40 80 20]);
if allWavesFlag
    handles.AngleofNormalConnection = uicontrol(handles.NormalConnection,...
    'style','edit','string','90','HorizontalAlignment','Center','Units',...
    'pixels','Position',[170 10 80 20]);
end
handles.LengthofTConnection = uicontrol(handles.TConnection,'style',...
    'edit','string','','HorizontalAlignment','Center','Units','pixels',...
    'Position',[170 40 80 20]);
handles.LengthofCrossConnection = uicontrol(handles.CrossConnection,...
    'style','edit','string','','HorizontalAlignment','Center','Units',...
    'pixels','Position',[170 40 80 20]);

%--------------------------------------------------------------------------

%---------------------Add Connection Pushbutton----------------------------
handles.InsertNormalConnection = uicontrol('parent',handles.NormalConnection,...
    'style','pushbutton','String',...
    'Insert Connection','Units',...
    'pixels','FontSize',10,...
    'enable','on',...
    'Position',[310 35 120 30] );

handles.InsertTConnection = uicontrol('parent',handles.TConnection,...
    'style','pushbutton','String',...
    'Insert Connection','Units',...
    'pixels','FontSize',10,...
    'enable','on',...
    'Position',[310 35 120 30] );

handles.InsertCrossConnection = uicontrol('parent',handles.CrossConnection,...
    'style','pushbutton','String',...
    'Insert Connection','Units',...
    'pixels','FontSize',10,...
    'enable','on',...
    'Position',[310 35 120 30] );

%--------------------------------------------------------------------------
%------------------------------Close Pushbutton----------------------------
handles.Apply = uicontrol('parent',handles.Couplings,...
    'style','pushbutton','String',...
    'Apply','Units',...
    'pixels','FontSize',10,...
    'enable','on',...
    'Position',[250 10 100 30] );

handles.Finish = uicontrol('parent',handles.Couplings,...
    'style','pushbutton','String',...
    'Finish','Units',...
    'pixels','FontSize',10,...
    'enable','off',...
    'Position',[370 10 100 30] );

%--------------------------------------------------------------------------
%------------------------------List Box------------------------------------
handles.ListBox = uicontrol('style','listbox','FontSize',11,...
    'position',[10 50 460 170],'parent',handles.Couplings);

%--------------------------------------------------------------------------
%---------------------Callback for pushbutton Insert-----------------------
set(handles.InsertNormalConnection,'callback',{@(hObject,eventdata)...
    Couplings('InsertNormalConnection_Callback',hObject,eventdata,...
    guidata(hObject))});
set(handles.InsertTConnection,'callback',{@(hObject,eventdata)...
    Couplings('InsertTConnection_Callback',hObject,eventdata,...
    guidata(hObject))});
set(handles.InsertCrossConnection,'callback',{@(hObject,eventdata)...
    Couplings('InsertCrossConnection_Callback',hObject,eventdata,...
    guidata(hObject))});

%--------------------------------------------------------------------------
%--------------------Callback for pushbutton Close-------------------------
set(handles.Apply,'callback',{@(hObject,eventdata)...
    Couplings('Apply_Callback',hObject,eventdata,guidata(hObject))});
set(handles.Finish,'callback',{@(hObject,eventdata)...
    Couplings('Finish_Callback',hObject,eventdata,guidata(hObject))});
set(handles.FirstNormal_popupmenu,'callback',{@(hObject,eventdata)...
    Couplings('HideLength',hObject,eventdata,guidata(hObject))});
set(handles.SecondNormal_popupmenu,'callback',{@(hObject,eventdata)...
    Couplings('HideLength',hObject,eventdata,guidata(hObject))});
%--------------------------------------------------------------------------
if allWavesFlag
handles.CLFs=struct('subsystem1',[],'subsystem2',[],'frequencies',...
    [],'length',[],'angle',[]);
else
    handles.CLFs=struct('subsystem1',[],'subsystem2',[],'frequencies',...
    [],'length',[])
end
handles.TCLFs=struct('subsystem1',[],'subsystem2',[],'subsystem3',...
    [],'frequencies',[],'length',[]);
handles.CrCLFs=struct('subsystem1',[],'subsystem2',[],'subsystem3',...
    [],'subsystem4',[],'frequencies',[],'length',[]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Couplings wait for user response (see UIRESUME)
uiwait(handles.Couplings);


% --- Outputs from this function are returned to the command line.
function varargout = Couplings_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
%handles.CLFs=[];
CLF=CouplingLossFactor.empty;
TCLF=ComplexConnections.empty;
CrCLF=ComplexConnections.empty;
global allWavesFlag
if ~allWavesFlag
    for i=2:length(handles.CLFs)
        CLF(i-1)=CouplingLossFactor(handles.CLFs(i).subsystem1,...
            handles.CLFs(i).subsystem2,handles.CLFs(i).frequencies,...
            handles.CLFs(i).length);
    end
    for i=2:length(handles.TCLFs)
        TCLF(i-1)=ComplexConnections(handles.TCLFs(i).subsystem1,...
            handles.TCLFs(i).subsystem2,handles.TCLFs(i).subsystem3,...
            handles.TCLFs(i).frequencies,handles.TCLFs(i).length);
    end
    for i=2:length(handles.CrCLFs)
        CrCLF(i-1)=ComplexConnections(handles.CrCLFs(i).subsystem1,...
            handles.CrCLFs(i).subsystem2,handles.CrCLFs(i).subsystem3,...
            handles.CrCLFs(i).subsystem4,handles.CrCLFs(i).frequencies,...
            handles.CrCLFs(i).length);
    end
    CLF=FormCLFMatrix(CLF,TCLF,CrCLF);
    varargout{1}=CLF;
else
    for i=2:length(handles.CLFs)
        CLF(i-1)=CouplingLossFactor(handles.CLFs(i).subsystem1,...
            handles.CLFs(i).subsystem2,handles.CLFs(i).frequencies,...
            handles.CLFs(i).length, handles.CLFs(i).angle);
    end
%     CLF=FormCLFMatrix(CLF,TCLF,CrCLF);
    varargout{1}=CLF;
end
%enable finish button
set(handles.Finish,'enable','on');



function InsertNormalConnection_Callback(hObject,event_data,handles)

value = get(handles.FirstNormal_popupmenu,'Value');
firstlist = get(handles.FirstNormal_popupmenu,'String');
Subsystem11 = firstlist{value};
value= get(handles.SecondNormal_popupmenu,'Value');
Subsystem21 = firstlist{value};

%length of connection
LoC = get(handles.LengthofNormalConnection,'string');
LoC = str2double(LoC);

LoCIndicator = 0;

global allWavesFlag
%angle of Connection
if allWavesFlag
    AoC = get(handles.AngleofNormalConnection,'string');
    AoC = str2double(AoC);
    AoCIndicator = 0;
end
if strncmp(Subsystem11,'P',1)
    temp1= strsplit(Subsystem11,' ');
    Subsystem1text=['Plate ',temp1{2}];
    Subsystem1 = str2num(temp1{2});
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem1,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem1,2)+25;
else
    temp1= strsplit(Subsystem11,' ');
    Subsystem1text=['Cavity ',temp1{2}];
    Subsystem1 = str2num(temp1{2})+handles.input(1);
    LoCIndicator = LoCIndicator + 1;
    if allWavesFlag
        AoCIndicator = 1;
    end
    handles.arrowStart(end+1,1)=handles.positionCirc(Subsystem1-...
        handles.input(1),1)+25;
    handles.arrowStart(end,2)=handles.positionCirc(Subsystem1-...
        handles.input(1),2)+25;
end

if strncmp(Subsystem21,'P',1)
    temp2= strsplit(Subsystem21,' ');
    Subsystem2text=['Plate ',temp2{2}];
    Subsystem2 = str2num(temp2{2});
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem2,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem2,2)+25;
else
    temp2= strsplit(Subsystem21,' ');
    Subsystem2text=['Cavity ',temp2{2}];
    Subsystem2 = str2num(temp2{2})+handles.input(1);%stores the number of the subsystem
    LoCIndicator = LoCIndicator + 1;
    if allWavesFlag
        AoCIndicator = 1;
    end
    handles.arrowStart(end+1,1)=handles.positionCirc(Subsystem2-...
        handles.input(1),1)+25;
    handles.arrowStart(end,2)=handles.positionCirc(Subsystem2-...
        handles.input(1),2)+25;
end
%get colour of the arrow
colorOfArrow='k' ;
if strcmp(temp1{1},'Cavity') || strcmp(temp2{1},'Cavity')
    colorOfArrow='m';
end
%% visualization part
for i=0:1
    for j=0:1
        if not(j==i)
            handles.arrowRelative(end+1,1)=handles.arrowStart(end-j,1)-...
                handles.arrowStart(end-i,1);%difference in x-pixels
            handles.arrowRelative(end,2)=handles.arrowStart(end-j,2)-...
                handles.arrowStart(end-i,2);%difference in y-pixels
            %handles.drawarrow(end+1)=annotation('arrow');
            
            evalin('base','handles.drawarrow(end+1)=annotation(''arrow'');');
            handles.drawarrow=evalin('base','handles.drawarrow');
            if handles.arrowRelative(end,2)<=0
                set(handles.drawarrow(end),'parent',handles.VisFigure,...
                    'position',[handles.arrowStart(end-i,1) ...
                    handles.arrowStart(end-i,2)-25 ...
                    handles.arrowRelative(end,1) ...
                    handles.arrowRelative(end,2)+50],'visible','on',...
                    'HeadStyle', 'hypocycloid', 'LineWidth', 3,'Color',colorOfArrow);
            elseif handles.arrowRelative(end,2)>=0
                set(handles.drawarrow(end),'parent',...
                    handles.VisFigure,'position',....
                    [handles.arrowStart(end-i,1) ...
                    handles.arrowStart(end-i,2)+25 ...
                    handles.arrowRelative(end,1) ...
                    handles.arrowRelative(end,2)-50],'visible','on',...
                    'HeadStyle', 'hypocycloid', 'LineWidth', 3,'Color',colorOfArrow);
            end
        end
    end
end

%%
if LoCIndicator > 0
    LoCText = '';
else
    LoCText = [', ',num2str(LoC),' m connection length'];
end

if ~allWavesFlag

Connection = ['Two Subsystem Connection, ',Subsystem1text,'/',...
    Subsystem2text,LoCText];
else
  if AoCIndicator > 0
    AoCText = '';
  else
    AoCText = [', ',num2str(AoC),' deg connection angle'];
  end
Connection = ['Two Subsystem Connection, ',Subsystem1text,'/',...
    Subsystem2text,LoCText,AoCText];
 
end
%--------------------------------------------------------------------------
existingItems = get(handles.ListBox, 'String');
existingItems{end+1} = Connection;
set(handles.ListBox,'string',existingItems);
%--------------------------------------------------------------------------

% CLFs = struct('subsystem1',[],'subsystem2',[],'frequencies',[],'length',[],'angle',[]);
if allWavesFlag
    CLFs = struct('subsystem1',[],'subsystem2',[],'frequencies',[],'length',[],'angle',[]);
    CLFs(end+1) = struct('subsystem1',handles.SUBSYSTEMS{1,Subsystem1},...
        'subsystem2',handles.SUBSYSTEMS{1,Subsystem2},'frequencies',...
        handles.frequencies,'length',LoC,'angle',AoC);
else
    CLFs = struct('subsystem1',[],'subsystem2',[],'frequencies',[],'length',[]);
    CLFs(end+1) = struct('subsystem1',handles.SUBSYSTEMS{1,Subsystem1},...
    'subsystem2',handles.SUBSYSTEMS{1,Subsystem2},'frequencies',...
    handles.frequencies,'length',LoC);
end
handles.CLFs(end+1) = CLFs(end);

%Update handles structure
guidata(hObject,handles)

function InsertTConnection_Callback(hObject,event_data,handles)
global allWavesFlag;
if allWavesFlag
    msgbox('Not available yet for all wave types - Purchase the new version online')
else
    
    
    Subsystem1 = get(handles.FirstT_popupmenu,'value');
    Subsystem2 = get(handles.SecondT_popupmenu,'value');
    Subsystem3 = get(handles.ThirdT_popupmenu,'value');
    LoC = get(handles.LengthofTConnection,'string');
    LoC = str2double(LoC);
    
    Connection = ['T-Connection, ','Plate ',num2str(Subsystem1),'/',...
        num2str(Subsystem2),'/',num2str(Subsystem3),', ',num2str(LoC),...
        ' m connection length'];
    %%---------------------------------------------VISUALIZATION-------------
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem1,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem1,2)+25;
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem2,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem2,2)+25;
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem3,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem3,2)+25;
    for i=0:2
        for j=0:2
            if not(j==i)
                handles.arrowRelative(end+1,1)=handles.arrowStart(end-j,1)-...
                    handles.arrowStart(end-i,1);
                handles.arrowRelative(end,2)=handles.arrowStart(end-j,2)-...
                    handles.arrowStart(end-i,2);
                
                evalin('base','handles.drawarrow(end+1)=annotation(''arrow'');');
                handles.drawarrow=evalin('base','handles.drawarrow');
                if handles.arrowRelative(end,2)<=0
                    set(handles.drawarrow(end),'parent',handles.VisFigure,...
                        'position',[handles.arrowStart(end-i,1) ...
                        handles.arrowStart(end-i,2)-25 ...
                        handles.arrowRelative(end,1) ...
                        handles.arrowRelative(end,2)+50],'visible','on',...
                        'HeadStyle', 'hypocycloid', 'LineWidth', 3);
                elseif handles.arrowRelative(end,2)>=0
                    set(handles.drawarrow(end),'parent',...
                        handles.VisFigure,'position',....
                        [handles.arrowStart(end-i,1) ...
                        handles.arrowStart(end-i,2)+25 ...
                        handles.arrowRelative(end,1) ...
                        handles.arrowRelative(end,2)-50],'visible','on',...
                        'HeadStyle', 'hypocycloid', 'LineWidth', 3);
                end
            end
        end
    end
    assignin('base','drawarrow',handles.drawarrow);
    %--------------------------------------------------------------------------
    existingItems = get(handles.ListBox, 'String');
    existingItems{end+1} = Connection;
    set(handles.ListBox,'string',existingItems);
    %--------------------------------------------------------------------------
    
    TCLFs = struct('subsystem1',[],'subsystem2',[],'subsystem3',[],...
        'frequencies',[],'length',[]);
    TCLFs(end+1) = struct('subsystem1',handles.SUBSYSTEMS{1,Subsystem1},...
        'subsystem2',handles.SUBSYSTEMS{1,Subsystem2},'subsystem3',...
        handles.SUBSYSTEMS{1,Subsystem3},'frequencies',handles.frequencies,...
        'length',LoC);
    handles.TCLFs(end+1) = TCLFs(end);
end
%Update handles structure
guidata(hObject,handles)

function InsertCrossConnection_Callback(hObject,event_data,handles)
global allWavesFlag;
if allWavesFlag
    msgbox('Not available yet for all wave types - Purchase the new version online')
else
    Subsystem1 = get(handles.FirstCross_popupmenu,'value');
    Subsystem2 = get(handles.SecondCross_popupmenu,'value');
    Subsystem3 = get(handles.ThirdCross_popupmenu,'value');
    Subsystem4 = get(handles.FourthCross_popupmenu,'value');
    LoC = get(handles.LengthofCrossConnection,'string');
    LoC = str2double(LoC);
    
    Connection = ['X-Connection, ','Plate ',num2str(Subsystem1),...
        '/',num2str(Subsystem2),'/',num2str(Subsystem3),'/',...
        num2str(Subsystem4),', ',num2str(LoC), ' m connection length'];
    %% visualization
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem1,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem1,2)+25;
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem2,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem2,2)+25;
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem3,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem3,2)+25;
    handles.arrowStart(end+1,1)=handles.positionRec(Subsystem4,1)+25;
    handles.arrowStart(end,2)=handles.positionRec(Subsystem4,2)+25;
    for i=0:3
        for j=0:3
            if not(j==i)
                handles.arrowRelative(end+1,1)=handles.arrowStart(end-j,1)-...
                    handles.arrowStart(end-i,1);
                handles.arrowRelative(end,2)=handles.arrowStart(end-j,2)-...
                    handles.arrowStart(end-i,2);
                evalin('base','handles.drawarrow(end+1)=annotation(''arrow'');');
                handles.drawarrow=evalin('base','handles.drawarrow');
                if handles.arrowRelative(end,2)<=0
                    set(handles.drawarrow(end),'parent',...
                        handles.VisFigure,'position',...
                        [handles.arrowStart(end-i,1) ...
                        handles.arrowStart(end-i,2)-25 ...
                        handles.arrowRelative(end,1) ...
                        handles.arrowRelative(end,2)+50],'visible','on',...
                        'HeadStyle', 'hypocycloid', 'LineWidth', 3);
                elseif handles.arrowRelative(end,2)>=0
                    set(handles.drawarrow(end),'parent',...
                        handles.VisFigure,'position',....
                        [handles.arrowStart(end-i,1) ...
                        handles.arrowStart(end-i,2)+25 ...
                        handles.arrowRelative(end,1) ...
                        handles.arrowRelative(end,2)-50],'visible','on',...
                        'HeadStyle', 'hypocycloid', 'LineWidth', 3);
                end
            end
        end
    end
    assignin('base','drawarrow',handles.drawarrow);
    %--------------------------------------------------------------------------
    existingItems = get(handles.ListBox, 'String');
    existingItems{end+1} = Connection;
    set(handles.ListBox,'string',existingItems);
    %--------------------------------------------------------------------------
    
    CrCLFs = struct('subsystem1',[],'subsystem2',[],'subsystem3',[],...
        'subsystem4',[],'frequencies',[],'length',[]);
    CrCLFs(end+1) = struct('subsystem1',handles.SUBSYSTEMS{1,Subsystem1},...
        'subsystem2',handles.SUBSYSTEMS{1,Subsystem2},'subsystem3',...
        handles.SUBSYSTEMS{1,Subsystem3},'subsystem4',...
        handles.SUBSYSTEMS{1,Subsystem4},'frequencies',...
        handles.frequencies,'length',LoC);
    handles.CrCLFs(end+1) = CrCLFs(end);
end
%Update handles structure
guidata(hObject,handles)

function Apply_Callback(hObject,event_data,handles)

uiresume(handles.Couplings)

function Finish_Callback(hObject,event_data,handles)

close(handles.Couplings)

function HideLength(hObject,event_data,handles)
global allWavesFlag
if isa(handles.SUBSYSTEMS{get(handles.FirstNormal_popupmenu,'value')},...
        'Cavity')||isa(handles.SUBSYSTEMS{get(handles.SecondNormal_popupmenu,...
        'value')},'Cavity')
    set(handles.lengthTextNormal,'visible','off')
    set(handles.LengthofNormalConnection,'visible','off')
    if allWavesFlag
        set(handles.angleTextNormal,'visible','off')
        set(handles.AngleofNormalConnection,'visible','off')
    end
else
    set(handles.lengthTextNormal,'visible','on')
    set(handles.LengthofNormalConnection,'visible','on')
    if allWavesFlag
        set(handles.angleTextNormal,'visible','on')
        set(handles.AngleofNormalConnection,'visible','on')
    end
end
