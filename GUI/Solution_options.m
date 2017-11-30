function varargout = Solution_options(varargin)
% #################Note of the authors###########################
%
% Created by Dionysios Panagiotopoulos in the context of a HIWI for
% Christoph Winter. Last Version March 2017. 
% Contributors to the first version Christian Robl, Khalid Malik
%
% ################# Content of the file #########################
%
% SOLUTION_OPTIONS MATLAB code for Solution_options.fig
%      SOLUTION_OPTIONS, by itself, creates a new SOLUTION_OPTIONS or raises the existing
%      singleton*.
%
%      H = SOLUTION_OPTIONS returns the handle to a new SOLUTION_OPTIONS or the handle to
%      the existing singleton*.
%
%      SOLUTION_OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOLUTION_OPTIONS.M with the given input arguments.
%
%      SOLUTION_OPTIONS('Property','Value',...) creates a new SOLUTION_OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Solution_options_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Solution_options_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Solution_options

% Last Modified by GUIDE v2.5 14-Feb-2016 15:28:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Solution_options_OpeningFcn, ...
                   'gui_OutputFcn',  @Solution_options_OutputFcn, ...
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


% --- Executes just before Solution_options is made visible.
function Solution_options_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Solution_options (see VARARGIN)

% Choose default command line output for Solution_options
handles.output = hObject;

set(handles.figure1,'Units','pixels');

%get your display size
screenSize = get(0,'ScreenSize');
handles.data = varargin{1};
handles.subsystems = varargin{2};
%calculate the center of the display
position = get(handles.figure1,'Position');
position(3)=350;
position(4)=230;
position(1) = (screenSize(3)-position(3))/2;
position(2) = (screenSize(4)-position(4))/2;
%center the window
set(handles.figure1,'Position',position);
%panels
handles.FeaturesPanel = uipanel('Units','pixels',...
    'Title','Features',...
    'FontSize',11,...
    'Position', [5 5 340 225]);
%Text strings
uicontrol('Parent',handles.FeaturesPanel,'style','text','string',...
    'Non-Resonant transmission','HorizontalAlignment','left','Units','pixels',...
    'FontSize',10,'Position',[20 position(4)-70 180 20]);
uicontrol('Parent',handles.FeaturesPanel,'style','text','string',...
    'In-Plane waves','HorizontalAlignment','left','Units','pixels',...
    'FontSize',10,'Position',[20 position(4)-110 180 20],'Enable','on');
uicontrol('Parent',handles.FeaturesPanel,'style','text','string',...
    'Path Analysis','HorizontalAlignment','left','Units','pixels',...
    'FontSize',10,'Position',[20 position(4)-150 180 20],'Enable','on');
handles.lengthPath=uicontrol('Parent',handles.FeaturesPanel,'style','text','string',...
    'Length of Path:','HorizontalAlignment','left','Units','pixels',...
    'FontSize',9,'Position',[200 position(4)-185 180 20],'Enable','off');
%dropdown for length of paths
    handles.path_popupmenu = uicontrol('Parent',handles.FeaturesPanel,...
    'style','popupmenu','string',{'3','4','5','6'},...
    'HorizontalAlignment','right',...
    'FontSize',8,...
    'position',[285 position(4)-177 30 15],'Enable','off');
%checkbox
handles.checkbox(1) = uicontrol('Parent',handles.FeaturesPanel,'style','checkbox','value',0,'HorizontalAlignment','Center',...
        'Units','pixels','Position',[300 position(4)-70 30 20],'Tag','1');
handles.checkbox(2) = uicontrol('Parent',handles.FeaturesPanel,'style','checkbox','value',0,'HorizontalAlignment','Center',...
        'Units','pixels','Position',[300 position(4)-110 30 20],'Tag','2','Enable','Off');
handles.checkbox(3) = uicontrol('Parent',handles.FeaturesPanel,'style','checkbox','value',0,'HorizontalAlignment','Center',...
        'Units','pixels','Position',[300 position(4)-150 30 20],'Tag','3','Enable','On');
    
    global allWavesFlag
    if allWavesFlag
        set(handles.checkbox(2),'enable','on','value',1);
        set(handles.checkbox(3),'enable','off');
        set(handles.path_popupmenu,'enable','off')
    end
set(handles.checkbox(3),'callback',{@Checkbox_3_Callback,handles});
set(handles.checkbox(2),'callback',{@Checkbox_2_Callback,handles});

    %pushbutton OK
handles.Solve_OK = uicontrol('style','pushbutton','String','OK',...
    'Units','pixels','enable','off','Position',[255 15 80 25],'Visible', 'Off');
set(handles.Solve_OK,'callback',{@Solve_OK_Callback,handles});
handles.Solve_apply = uicontrol('style','pushbutton','String','Apply',...
    'Units','pixels','enable','on','Position',[255 15 80 25] );
set(handles.Solve_apply,'callback',{@Solve_apply_Callback,handles});
    % Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);

% UIWAIT makes Solution_options wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end
% --- Outputs from this function are returned to the command line.
function varargout = Solution_options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1}= handles.Data{2};
end
function Solve_OK_Callback(hObject,event_data,handles)


close Solution_options
end
function Solve_apply_Callback(hObject,event_data,handles)
apply(1)=get(handles.checkbox(1),'Value');
apply(2)=get(handles.checkbox(2),'Value');
apply(3)=get(handles.checkbox(3),'Value');
apply(4)=get(handles.path_popupmenu,'Value');%here the value of the dropdown is passed
%handles.Data{3}=str2num(applyDropdownstr);
handles.Data{2}=apply;
set(handles.Solve_OK,'Visible','on','enable','on')
set(handles.Solve_apply,'Visible','off','enable','off')
uiwait(msgbox('Options have been applied.'))
handles.Data{2}=apply;
guidata(hObject,handles)
uiresume(handles.figure1)
end
    function Checkbox_3_Callback(hObject,event_data,handles)
        global allWavesFlag
        flag=get(handles.checkbox(3),'Value');
        if flag==0
            set(handles.lengthPath,'enable','off')
            set(handles.path_popupmenu,'enable','off')
            if allWavesFlag
                set(handles.checkbox(2),'enable','on')
            end
        elseif flag==1
            set(handles.lengthPath,'enable','on')
            set(handles.path_popupmenu,'enable','on')
            set(handles.checkbox(2),'value',0)
            set(handles.checkbox(2),'enable','off')
            
        end
    end
function Checkbox_2_Callback(hObject,event_data,handles)
     flag2=get(handles.checkbox(2),'Value');
    if flag2
        set(handles.checkbox(3),'value',0)
        set(handles.checkbox(3),'enable','off')
        
        set(handles.lengthPath,'enable','off')
        set(handles.path_popupmenu,'enable','off')
    else
        set(handles.checkbox(3),'enable','on')
%         set(handles.lengthPath,'enable','on')
%         set(handles.path_popupmenu,'enable','on')
    end
end
end