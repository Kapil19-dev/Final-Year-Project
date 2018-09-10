function varargout = untitled1(varargin)
% UNTITLED1 MATLAB code for untitled1.fig
%      UNTITLED1, by itself, creates a new UNTITLED1 or raises the existing
%      singleton*.
%
%      H = UNTITLED1 returns the handle to a new UNTITLED1 or the handle to
%      the existing singleton*.
%
%      UNTITLED1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED1.M with the given input arguments.
%
%      UNTITLED1('Property','Value',...) creates a new UNTITLED1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled1

% Last Modified by GUIDE v2.5 11-Apr-2018 11:09:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
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


% --- Executes just before untitled1 is made visible.
function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled1 (see VARARGIN)

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inputFile_Callback(hObject, eventdata, handles)
% hObject    handle to inputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputFile as text
%        str2double(get(hObject,'String')) returns contents of inputFile as a double


% --- Executes during object creation, after setting all properties.
function inputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputRefFile_Callback(hObject, eventdata, handles)
% hObject    handle to inputRefFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputRefFile as text
%        str2double(get(hObject,'String')) returns contents of inputRefFile as a double


% --- Executes during object creation, after setting all properties.
function inputRefFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputRefFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Load files
load(handles.inputFile.String);
loc_mee=loc_mee+hwin_size;
%% load ground truth
rpk=xlsread(handles.inputRefFile.String);
%% load PT
am(1)=numel(rpk);
am(2)=numel(loc_pt);
am(3)=0;
for i=1:numel(loc_pt)
    ans_tmp=ismember(loc_pt(i)-4,rpk)+ismember(loc_pt(i)-3,rpk)+ismember(loc_pt(i)-2,rpk)+ismember(loc_pt(i)-1,rpk)+ismember(loc_pt(i),rpk)+ismember(loc_pt(i)+1,rpk)+ismember(loc_pt(i)+2,rpk)+ismember(loc_pt(i)+3,rpk)+ismember(loc_pt(i)+4,rpk);
    am(3)=am(3)+ans_tmp;
end
am(4)=am(2)-am(3);
am(5)=am(1)-am(3);
%% load MEE
am(6)=numel(loc_mee);
am(7)=0;
for i=1:numel(loc_mee)
    ans_tmp=ismember(loc_mee(i)-5,rpk)+ismember(loc_mee(i)-4,rpk)+ismember(loc_mee(i)-3,rpk)+ismember(loc_mee(i)-2,rpk)+ismember(loc_mee(i)-1,rpk)+ismember(loc_mee(i),rpk)+ismember(loc_mee(i)+1,rpk)+ismember(loc_mee(i)+2,rpk)+ismember(loc_mee(i)+3,rpk)+ismember(loc_mee(i)+4,rpk)+ismember(loc_mee(i)+5,rpk);
    am(7)=am(7)+ans_tmp;
end
am(8)=am(6)-am(7);
am(9)=am(1)-am(7);

axes(handles.axes1)
set(gcf,'toolbar','figure');
hold on
title('Inter Beat Interval') 
xlabel('Time (s)')
ylabel('Duration (ms)')
%plot(rpk(1:end-1)/250,diff(rpk),'linewidth',2);
plot(loc_mee(1:end-1)/250,diff(loc_mee)*4,'linewidth',2);
plot(loc_pt(1:end-1)/250,diff(loc_pt)*4,'linewidth',1)
hold off
legend('MEE Method','PT Method')
row_pt=[am(1:5) , 100*am(3)/(am(3)+am(5)), 100*am(3)/(am(3)+am(4)), 100*am(3)/(am(3)+am(4)+am(5))];
row_mee=[am(1) am(6:9), 100*am(7)/(am(7)+am(9)), 100*am(7)/(am(7)+am(8)), 100*am(7)/(am(7)+am(8)+am(9))];
handles.uitable.Data=[row_mee;row_pt]
