function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      mainUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      mainUI('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".    
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 08-Apr-2018 14:55:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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
end

% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.headingText.String="MEE Based R Peak Detection"
end

% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function inputFile_Callback(hObject, eventdata, handles)
% hObject    handle to inputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputFile as text
%        str2double(get(hObject,'String')) returns contents of inputFile as a double
end

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
end


function outputMAT_Callback(hObject, eventdata, handles)
% hObject    handle to outputMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputMAT as text
%        str2double(get(hObject,'String')) returns contents of outputMAT as a double
end

% --- Executes during object creation, after setting all properties.
function outputMAT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)

% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hwin_size=str2num(handles.inputWindowSize.String);
min_pk_dist=str2num(handles.inputMinPeakDistance.String);

handles.ECGRaw=load(handles.inputFile.String,'ECG');
ECG=handles.ECGRaw.ECG;
axes(handles.axesRaw);
plot([1:numel(ECG)]/250,ECG);
xlabel('Time (s)')
title('Raw ECG Signal')
set(gca,'YTickLabel',[]);
set(gcf,'toolbar','figure');
linkaxes([handles.axesRaw,handles.axesFilt,handles.axesIP],'x')
fs=250;
%load the .mat file containing ECG Signal
% % trim the signal upto user defined start and end points
%basel
Wn = 5*2/fs;
N = 5; % order of 3 less processing
[a,b] = butter(N,Wn,'high'); %bandpass filtering
ecg_h = filtfilt(a,b,ECG); 
ecg_h = ecg_h/ max(abs(ecg_h));
axes(handles.axesFilt);
plot([1:numel(ecg_h)]/250,ecg_h)
title('Baseline Wander Removal')
set(gca,'YTickLabel',[]);
xlabel('Time (s)')
[~,loc_pt,~]=pan_tompkin(ECG,250,0);

for i=2:numel(loc_pt)-2
    qrs(i-1,:)=ecg_h(loc_pt(i)-hwin_size:loc_pt(i)+hwin_size);
end
qrs=mean(qrs);

parfor k=1:numel(ECG)-2*hwin_size-1;
    % save information potential in c
    c(k)=mee(ecg_h(k:k+2*hwin_size)-qrs,5,hwin_size);
    % save mean square error in d (not used in this study)
   %d(k)= mean((ecg_h(k:k+160)-qrs).^2);
end

%save the output in save_file.mat

axes(handles.axesIP);
plot([1:numel(c)]/fs,c)
xlabel('Time (s)')
title('Information Potential')
set(gca,'YTickLabel',[]);
[y,loc_mee]=findpeaks(c,'MinPeakDistance',min_pk_dist);
hold on
plot(loc_mee/fs,y,'or')
hold off
axes(handles.axesIBI);
plot(loc_mee(1:end-1)/fs,diff(loc_mee)*4)
title('Inter-Beat-Interval')
xlabel('Seconds')
ylabel('IBI in ms')
save(handles.outputMAT.String,'ECG','ecg_h','c','hwin_size','loc_mee','loc_pt');
csvwrite(handles.outputIBI.String,(loc_mee-hwin_size)/fs);
end



function outputIBI_Callback(hObject, eventdata, handles)
% hObject    handle to outputIBI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputIBI as text
%        str2double(get(hObject,'String')) returns contents of outputIBI as a double
end

% --- Executes during object creation, after setting all properties.
function outputIBI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputIBI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function inputMinPeakDistance_Callback(hObject, eventdata, handles)
% hObject    handle to inputMinPeakDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputMinPeakDistance as text
%        str2double(get(hObject,'String')) returns contents of inputMinPeakDistance as a double
end

% --- Executes during object creation, after setting all properties.
function inputMinPeakDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputMinPeakDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function inputWindowSize_Callback(hObject, eventdata, handles)
% hObject    handle to inputWindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputWindowSize as text
%        str2double(get(hObject,'String')) returns contents of inputWindowSize as a double
end

% --- Executes during object creation, after setting all properties.
function inputWindowSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputWindowSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function y=mee(e,sigma,hwin_size)
y=0;
    for i=1:2*hwin_size+1
        for j=1:2*hwin_size+1
            y=y+kernel(e(i)-e(j),sigma*sqrt(2));
        end
    end
y=y/((2*hwin_size+1)^2);
end

%the gaussian function
function y=kernel(x,sigma)
    y=exp((-x^2)/(2*sigma^2))/(sqrt(2)*sigma*pi);
end
