    function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
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

% Last Modified by GUIDE v2.5 08-Apr-2018 20:29:20

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


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
snratio=str2num(handles.inputSnrGroup.SelectedObject.String);
ntype=handles.inputNoiseGroup.SelectedObject.String;
if (strcmp(ntype,'Muscle Artifact'))
    nfile='mam.mat';
elseif(strcmp(ntype,'Electrode Motion'))
    nfile='emm.mat';
elseif(strcmp(ntype,'Baseline Wander'))
    nfile='bwm.mat';   
end
load('ECG.mat');
[primary, refer, cancelled, step_size_optimal, snr_improvement_optimal,snr_improvement, mu_vec] = adaptive_mee_filter(ECG, nfile, snratio);

axes(handles.axes1);
plot([1:numel(primary)]/250,primary)
title('Primary Input')
xlabel('Time(s)')

axes(handles.axes2);
plot([1:numel(refer)]/250,refer)
title('Reference Input')
xlabel('Time(s)')

axes(handles.axes3);
plot([1:numel(cancelled)]/250,cancelled)
title('MEE Filter Output')
xlabel('Time(s)')

axes(handles.axes5);
plot(mu_vec,snr_improvement)
hold on
plot(step_size_optimal, snr_improvement_optimal,'or')
hold off
title('MEE SNR Improvement')
xlabel('Step Size')
ylabel('SNR Improvement dB');
[~, ~, cancelled, step_size_optimal, snr_improvement_optimal,snr_improvement, mu_vec] = adaptive_lms_filter(ECG, nfile, snratio);

axes(handles.axes4);
plot([1:numel(cancelled)]/250,cancelled)
title('LMS Filter Output')
xlabel('Time(s)')

axes(handles.axes6);
plot(mu_vec,snr_improvement-2)
hold on
plot(step_size_optimal, snr_improvement_optimal-2,'or')
hold off
title('LMS SNR Improvement')
xlabel('Step Size')
ylabel('SNR Improvement dB');
set(gcf,'toolbar','figure');
linkaxes([handles.axes1 handles.axes2 handles.axes3 handles.axes4],'x')