function varargout = Inputstab(varargin)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
% INPUTSTAB MATLAB code for Inputstab.fig
%      INPUTSTAB, by itself, creates a new INPUTSTAB or raises the existing
%      singleton*.
%
%      H = INPUTSTAB returns the handle to a new INPUTSTAB or the handle to
%      the existing singleton*.
%
%      INPUTSTAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INPUTSTAB.M with the given input arguments.
%
%      INPUTSTAB('Property','Value',...) creates a new INPUTSTAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Inputstab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Inputstab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Inputstab

% Last Modified by GUIDE v2.5 07-Jul-2015 13:27:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Inputstab_OpeningFcn, ...
    'gui_OutputFcn',  @Inputstab_OutputFcn, ...
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


% --- Executes just before Inputstab is made visible.
function Inputstab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Inputstab (see VARARGIN)

% Choose default command line output for Inputstab
handles.output = hObject;

%pixels
set(handles.figure1,'Units','pixels');

%get your display size
screenSize = get(0,'ScreenSize');

%calculate the center of the display
position = get(handles.figure1,'Position');
position(1) = (screenSize(3)-position(3))/2;
position(2) = (screenSize(4)-position(4))/2;

%center the window
set(handles.figure1,'Position',position);

%------------------------------DATA FROM PARENT----------------------------
handles.data = varargin{1};
handles.subsystems = varargin{2};

%--------------------------------------------------------------------------
%-------------------------------TABS---------------------------------------
tabgp = uitabgroup('Units','Pixels','Position',[25 25 375 310]);
a = {'Plate 1' 'Plate 2' 'Plate 3' 'Plate 4' 'Plate 5' 'Plate 6'... 
    'Plate 7' 'Plate 8' 'Plate 9' 'Plate 10' 'Plate 11'};
b = {'Cavity 1' 'Cavity 2'};

%plate TABs
for i = 1:handles.subsystems(1)
    
    handles.tab(i) = uitab(tabgp,'Title',a{i});
    handles.GeoProp_Plate(i) = uipanel(handles.tab(i),'Units','Pixels',...
        'Title','Geometrical Properties','Position',[5 50 180 225]);
    handles.MatProp_Plate(i) = uipanel(handles.tab(i),'Units','Pixels',...
        'Title','Material Properties','Position',[185 50 180 225]);
    
    %Geometric Properties
    uicontrol(handles.GeoProp_Plate(i),'style','text','string',...
        'Length [m]:','HorizontalAlignment','right','Units','pixels',...
        'Position',[10 170 60 20]);
    uicontrol(handles.GeoProp_Plate(i),'style','text','string',...
        'Width [m]:','HorizontalAlignment','right','Units','pixels',...
    'Position',[10 140 60 20]);
    uicontrol(handles.GeoProp_Plate(i),'style','text','string',...
        'Thickness [m]:','HorizontalAlignment','center','Units',...
        'pixels','Position',[5 110 80 20]);
    handles.Length_Plate(i) = uicontrol(handles.GeoProp_Plate(i),...
        'style','edit','string','1','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 175 80 20]);
    handles.Width_Plate(i) = uicontrol(handles.GeoProp_Plate(i),...
        'style','edit','string','1','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 145 80 20]);
    handles.Thickness_Plate(i) = uicontrol(handles.GeoProp_Plate(i),...
        'style','edit','string','0.001','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 115 80 20]);
    
    %Material Properties
    uicontrol(handles.MatProp_Plate(i),'style','text','string',...
        'Density [kg*m^-3]:','HorizontalAlignment','right','Units',...
        'pixels','Position',[10 170 60 30]);
    uicontrol(handles.MatProp_Plate(i),'style','text','string',...
        'Youngs Modulus [N*m^-2]:','HorizontalAlignment','right',...
        'Units','pixels','Position',[10 122 60 40]);
    uicontrol(handles.MatProp_Plate(i),'style','text','string',...
        'Poisson Ratio [-]:','HorizontalAlignment','right','Units',...
        'pixels','Position',[10 75 60 40]);
    uicontrol(handles.MatProp_Plate(i),'style','text','string',...
        'Damping Loss Factor [-]:','HorizontalAlignment','right',...
        'Units','pixels','Position',[10 35 60 40]);
    handles.Density_Plate(i) = uicontrol(handles.MatProp_Plate(i),...
        'style','edit','string','7800','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 170 80 20]);
    handles.YoungsMod_Plate(i) = uicontrol(handles.MatProp_Plate(i),...
        'style','edit','string','2.1e11','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 132 80 20]);
    handles.PoissonRatio_Plate(i) = uicontrol(handles.MatProp_Plate(i),...
        'style','edit','string','0.3125','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 90 80 20]);
    handles.DampLossFactor_Plate(i) = uicontrol(handles.MatProp_Plate(i),...
        'style','edit','string','0.01','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 45 80 20]);
end

%cavity TABs
for j = 1:handles.subsystems(2)-1
    handles.tab(j) = uitab(tabgp,'Title',b{j});
    handles.GeoProp_Cavity(j) = uipanel(handles.tab(j),'Units','Pixels',...
        'Title','Geometrical Properties','Position',[5 50 180 225]);
    handles.MatProp_Cavity(j) = uipanel(handles.tab(j),'Units','Pixels',...
        'Title','Material Properties','Position',[185 50 180 225]);
    
    %Geometric Properties
    uicontrol(handles.GeoProp_Cavity(j),'style','text','string',...
        'Length [m]:','HorizontalAlignment','right','Units','pixels',...
        'Position',[10 170 60 20]);
    uicontrol(handles.GeoProp_Cavity(j),'style','text','string',...
        'Width [m]:','HorizontalAlignment','right','Units','pixels',...
        'Position',[10 140 60 20]);
    uicontrol(handles.GeoProp_Cavity(j),'style','text','string',...
        'Height [m]:','HorizontalAlignment','right','Units','pixels',...
        'Position',[10 110 60 20]);
    handles.Length_Cavity(j) = uicontrol(handles.GeoProp_Cavity(j),...
        'style','edit','string','1','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 175 80 20]);
    handles.Width_Cavity(j) = uicontrol(handles.GeoProp_Cavity(j),...
        'style','edit','string','1','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 145 80 20]);
    handles.Height_Cavity(j) = uicontrol(handles.GeoProp_Cavity(j),...
        'style','edit','string','1','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 115 80 20]);
    
    %Material Properties
    uicontrol(handles.MatProp_Cavity(j),'style','text','string',...
        'Density [kg*m^-3]:','HorizontalAlignment','right','Units',...
        'pixels','Position',[10 162 60 40]);
    uicontrol(handles.MatProp_Cavity(j),'style','text','string',...
        'Speed of Sound [m*s^-1]:','HorizontalAlignment','right',...
        'Units','pixels','Position',[10 135 60 40]);
    uicontrol(handles.MatProp_Cavity(j),'style','text','string',...
        'Damping Loss Factor [-]:','HorizontalAlignment','right',...
        'Units','pixels','Position',[10 95 60 40]);
    handles.Density_Cavity(j) = uicontrol(handles.MatProp_Cavity(j),...
        'style','edit','string','1.21','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 175 80 20]);
    handles.SpeedofSound_Cavity(j) = uicontrol(handles.MatProp_Cavity(j),...
        'style','edit','string','343','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 145 80 20]);
    handles.DampLossFactor_Cavity(j) = uicontrol(handles.MatProp_Cavity(j),...
        'style','edit','string','0.01','HorizontalAlignment','Center',...
        'Units','pixels','Position',[80 115 80 20]);
end

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Pushbutton Finish
handles.Plate_Finish = uicontrol('style','pushbutton','String','Finish',...
    'Units','pixels','enable','off','Position',[305 40 80 25] );

%Callback for pushbutton Ok
set(handles.Plate_Finish,'callback',{@Plate_Finish_Callback,handles});

%Pushbutton Ok
handles.Plate_Apply = uicontrol('style','pushbutton','String','Apply',...
    'Units','pixels','Position',[220 40 80 25] );

%Callback for pushbutton Ok
set(handles.Plate_Apply,'callback',{@Plate_Apply_Callback,handles});
%--------------------------------------------------------------------------


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Inputstab wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Inputstab_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.Data;

function Plate_Apply_Callback(hObject,event_data,handles)

for i = 1:handles.subsystems(1)
    
    %Input for Plate
    handles.Data{i}(1) = str2double(get(handles.Length_Plate(i),'string'));
    handles.Data{i}(2) = str2double(get(handles.Width_Plate(i),'string'));
    handles.Data{i}(3) = str2double(get(handles.Thickness_Plate(i),...
    'string'));
    handles.Data{i}(5) = str2double(get(handles.Density_Plate(i),...
        'string'));
    handles.Data{i}(4) = str2double(get(handles.YoungsMod_Plate(i),...
        'string'));
    handles.Data{i}(6) = str2double(get(handles.PoissonRatio_Plate(i),...
        'string'));
    handles.Data{i}(7) = str2double(get(handles.DampLossFactor_Plate(i),...
        'string'));
    a = i;
end

for j = 1:handles.subsystems(2)-1
    
    %Input for Cavity
    handles.Data{j+a}(1) = str2double(get(handles.Length_Cavity(j),...
        'string'));
    handles.Data{j+a}(2) = str2double(get(handles.Width_Cavity(j),...
        'string'));
    handles.Data{j+a}(3) = str2double(get(handles.Height_Cavity(j),...
        'string'));
    handles.Data{j+a}(4) = str2double(get(handles.Density_Cavity(j),...
        'string'));
    handles.Data{j+a}(5) = str2double(get(handles.SpeedofSound_Cavity(j),...
        'string'));
    handles.Data{j+a}(6) = str2double(get(handles.DampLossFactor_Cavity(j),...
        'string'));
    
end

%enable finish button
uiwait(msgbox('Parameters have been set.'))
set(handles.Plate_Finish,'enable','on');

%Update handles structure
guidata(hObject,handles)
uiresume(handles.figure1)

function Plate_Finish_Callback(hObject,event_data,handles)

close Inputstab
