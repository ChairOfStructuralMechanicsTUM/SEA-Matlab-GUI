function varargout = PowerInputs(varargin)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
% POWERINPUTS MATLAB code for PowerInputs.fig
%      POWERINPUTS, by itself, creates a new POWERINPUTS or raises the existing
%      singleton*.
%
%      H = POWERINPUTS returns the handle to a new POWERINPUTS or the handle to
%      the existing singleton*.
%
%      POWERINPUTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POWERINPUTS.M with the given input arguments.
%
%      POWERINPUTS('Property','Value',...) creates a new POWERINPUTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PowerInputs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PowerInputs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PowerInputs

% Last Modified by GUIDE v2.5 24-Jan-2016 15:45:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PowerInputs_OpeningFcn, ...
                   'gui_OutputFcn',  @PowerInputs_OutputFcn, ...
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


% --- Executes just before PowerInputs is made visible.
function PowerInputs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PowerInputs (see VARARGIN)

% Choose default command line output for PowerInputs
handles.output = hObject;
%pixels
set(handles.figure1,'Units','pixels');

%get your display size
screenSize = get(0,'ScreenSize');
handles.data = varargin{1};
handles.subsystems = varargin{2};
%calculate the center of the display
position = get(handles.figure1,'Position');
global allWavesFlag
if allWavesFlag
    position(3)=400;
else
    position(3)=235;
end
position(4)=180+35*(handles.subsystems(1)+handles.subsystems(2)-3);
position(1) = (screenSize(3)-position(3))/2;
position(2) = (screenSize(4)-position(4))/2;

%center the window
set(handles.figure1,'Position',position);
%------------------------------DATA FROM PARENT----------------------------
% handles.data = varargin{1};
% handles.subsystems = varargin{2};
%--------TITLE----
uicontrol('style','text','string',...
    'Subsystem','HorizontalAlignment','left','Units','pixels',...
    'FontSize',12,'FontWeight','bold','Position',[10 position(4)-30 120 20]);
yPosition=position(4)-30;
uicontrol('style','text','string',...
    'Power [W]','HorizontalAlignment','left','Units','pixels',...
    'FontSize',12,'FontWeight','bold','Position',[140 position(4)-30 120 20]);
yPosition=position(4)-30;

if allWavesFlag
    uicontrol('style','text','string',...
        'Longitudinal','HorizontalAlignment','Center','Units','pixels',...
        'FontSize',8,'Position',[150 position(4)-50 60 15]);
    uicontrol('style','text','string',...
        'Shear','HorizontalAlignment','center','Units','pixels',...
        'FontSize',8,'Position',[230 position(4)-50 60 15]);
    uicontrol('style','text','string',...
        'Bending','HorizontalAlignment','center','Units','pixels',...
        'FontSize',8,'Position',[310 position(4)-50 60 15]);
    yPosition=position(4)-40;
end
%-------label for subssystem---------
for i=1:handles.subsystems (1)
    title=strcat({'Plate '},num2str(i));
    label(i)=uicontrol('style','text','string',...
        title,'HorizontalAlignment','right','Units','pixels',...
        'FontSize',10,'Position',[20 yPosition-35 60 20]);
   if allWavesFlag 
       handles.editPower(i,1) = uicontrol('style','edit','string','0','HorizontalAlignment','Center',...
           'Units','pixels','Position',[150 yPosition-35 60 20]);
       handles.editPower(i,2) = uicontrol('style','edit','string','0','HorizontalAlignment','Center',...
           'Units','pixels','Position',[230 yPosition-35 60 20]);
       handles.editPower(i,3) = uicontrol('style','edit','string','0','HorizontalAlignment','Center',...
           'Units','pixels','Position',[310 yPosition-35 60 20]);
       
       
   else
       handles.editPower(i) = uicontrol('style','edit','string','0','HorizontalAlignment','Center',...
           'Units','pixels','Position',[150 yPosition-35 60 20]);
   end
   yPosition=yPosition-35;
end
for i=1:handles.subsystems (2)-1
    title=strcat({'Cavity '},num2str(i));
    label(end+1)=uicontrol('style','text','string',...
        title,'HorizontalAlignment','right','Units','pixels',...
        'FontSize',10,'Position',[20 yPosition-35 60 20]);
    if allWavesFlag 
        handles.editPower(end+1,1) = uicontrol('style','edit','string','0','HorizontalAlignment','Center',...
            'Units','pixels','Position',[150 yPosition-35 60 20]);
    else
        handles.editPower(end+1) = uicontrol('style','edit','string','0','HorizontalAlignment','Center',...
            'Units','pixels','Position',[150 yPosition-35 60 20]);
    end
     yPosition=yPosition-35;
end
if ~allWavesFlag
    handles.Power_Finish = uicontrol('style','pushbutton','String','Finish',...
        'Units','pixels','enable','off','Position',[140 15 80 25] );
    
    handles.Power_Apply = uicontrol('style','pushbutton','String','Apply',...
        'Units','pixels','Position',[50 15 80 25] );
else
    handles.Power_Finish = uicontrol('style','pushbutton','String','Finish',...
        'Units','pixels','enable','off','Position',[305 15 80 25] );

handles.Power_Apply = uicontrol('style','pushbutton','String','Apply',...
    'Units','pixels','Position',[215 15 80 25] );
end
set(handles.Power_Apply,'callback',{@Power_Apply_Callback,handles});
set(handles.Power_Finish,'callback',{@Power_Finish_Callback,handles});
% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes PowerInputs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PowerInputs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.Data;
function Power_Apply_Callback(hObject,event_data,handles)
global allWavesFlag
if ~allWavesFlag
    for i=1:length(handles.editPower)
        value=get(handles.editPower(i),'string');
        handles.Data{1}(i)=str2double(value);
    end
else
    for i=1:handles.subsystems (1)
        for j=1:3
            value=get(handles.editPower(i,j),'string');
            handles.Data{1}(i,j)=str2double(value);
        end
    end
    for i=1:handles.subsystems (2)-1
         value=get(handles.editPower(handles.subsystems (1)+ i,1),'string');
         handles.Data{2}(i)=str2double(value);
    end
end
set(handles.Power_Finish,'enable','on');
guidata(hObject,handles)
uiresume(handles.figure1)
function Power_Finish_Callback(hObject,event_data,handles)

close PowerInputs


