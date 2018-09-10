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

% Last Modified by GUIDE v2.5 16-Apr-2018 23:51:57

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%%generate plots

ifile='input_file.mat';
fs=300;
getbaseline(ifile,25);
getRRAR(ifile,300);
getRRPSD(ifile,300);
getRRIF(ifile,300);
close(1:4)

tmp=load('RR_if');
RR_if=tmp.RR_if;
tmp=load('RR_psd');
RR_psd=tmp.RR_psd;
tmp=load('RR_ar');
RR_ar=tmp.RR_ar;
tmp=load('RR_baseline');
RR_baseline_pos=tmp.RR_baseline_pos;
RR_baseline=tmp.RR_baseline;

axes(handles.axes1)
hold on
plot(266*RR_baseline_pos(1:end-1)./RR_baseline_pos(end),smooth(RR_baseline),'linewidth',2)
plot(266*[1/numel(RR_if):1/numel(RR_if):1],smooth(RR_if,100),'-.','linewidth',2)
plot(266*[1/numel(RR_psd):1/numel(RR_psd):1],smooth(RR_psd,20),':','linewidth',1)
plot(266*[1/numel(RR_ar):1/numel(RR_ar):1],RR_ar,'linewidth',1)

test_pts=round(266*RR_baseline_pos(1:end-1)./RR_baseline_pos(end));
test_pts(test_pts>250)=[];
test_pts(test_pts<50)=[];

y_bs=smooth(RR_baseline);
y_bs=y_bs(14:82);

y_if=resample(smooth(RR_if,100),266,numel(smooth(RR_if,100)))';
y_ar=resample(RR_ar,266,numel(RR_ar));
y_psd=resample(smooth(RR_psd,20),266,numel(smooth(RR_psd,20)))';
for i=1:numel(test_pts)
    MAE_if(i)=abs(y_if(test_pts(i))-y_bs(i));
    PE_if(i)=100*MAE_if(i)/y_bs(i);
    MAE_psd(i)=abs(y_psd(test_pts(i))-y_bs(i));
    PE_psd(i)=100*MAE_psd(i)/y_bs(i);
    MAE_ar(i)=abs(y_ar(test_pts(i))-y_bs(i));
    PE_ar(i)=100*MAE_ar(i)/y_bs(i);
end
if_m_err=sum(MAE_if)/numel(test_pts);
if_p_err=sum(PE_if)/numel(test_pts);
psd_m_err=sum(MAE_psd)/numel(test_pts);
psd_p_err=sum(PE_psd)/numel(test_pts);
ar_m_err=sum(MAE_ar)/numel(test_pts);
ar_p_err=sum(PE_ar)/numel(test_pts);
handles.uitable1.Data=[if_m_err,if_p_err;psd_m_err,psd_p_err;ar_m_err,ar_p_err]
% title('Respiratory Rate')
xlabel('Time (s)')
ylabel('Breaths per minute')
xlim([50 250])
ylim([16 26])
legend('True RR','RR IF','RR PSD','RR AR')
hold off
% handles    structure with handles and user data (see GUIDATA)
