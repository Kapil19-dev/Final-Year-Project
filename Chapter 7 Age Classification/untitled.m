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

% Last Modified by GUIDE v2.5 16-Apr-2018 19:43:28

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
load('features_ECG')
load('features_HRV')
load('features_RESP')
target=features_ECG(:,end);
[trainedClassifierECG, validationAccuracyECG,validationPredictionsECG] = trainClassifierECG(features_ECG);
[trainedClassifierHRV, validationAccuracyHRV,validationPredictionsHRV] = trainClassifierHRV(features_HRV);
[trainedClassifierRESP, validationAccuracyRESP,validationPredictionsRESP] = trainClassifierRESP(features_RESP);
clc

for i=1:40
fusion_predictions(i)=mode([validationPredictionsECG(i),validationPredictionsHRV(i),validationPredictionsRESP(i)])
end
fusion_predictions=fusion_predictions';
figure(1)
plotconfusion(target',validationPredictionsECG')
set(gcf,'Position',[300 300 300 300])
title('Conf. Matrix : ECG Waveform')
saveas(gcf,'confmat1.png')

figure(2)
plotconfusion(target',validationPredictionsHRV')
set(gcf,'Position',[300 300 300 300])
title('Conf. Matrix : HRV')
saveas(gcf,'confmat2.png')

figure(3)
plotconfusion(target',validationPredictionsRESP')
set(gcf,'Position',[300 300 300 300])
title('Conf. Matrix : Respiratory Waveform')
saveas(gcf,'confmat3.png')

figure(4)
plotconfusion(target',fusion_predictions')
set(gcf,'Position',[300 300 300 300])
title('Conf. Matrix : Data Fusion')
saveas(gcf,'confmat4.png')
close(1:4)

img1= imread('confmat1.png');
axes(handles.axes1)
imshow(img1);

img1= imread('confmat2.png');
axes(handles.axes2)
imshow(img1);

img1= imread('confmat3.png');
axes(handles.axes3)
imshow(img1);

img1= imread('confmat4.png');
axes(handles.axes4)
imshow(img1);
colergen = @(color,text) ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
table_out=[validationPredictionsECG,validationPredictionsHRV,validationPredictionsRESP,fusion_predictions,target];

for i=1:40
    if validationPredictionsECG(i)==target(i)
        clr='#00FF00';
    else
        clr='#FF0000';
    end
    tab_html{i,1}=colergen(clr,num2str(validationPredictionsECG(i)));
    
    if validationPredictionsHRV(i)==target(i)
        clr='#00FF00';
    else
        clr='#FF0000';
    end
    tab_html{i,2}=colergen(clr,num2str(validationPredictionsHRV(i)));
    
    if validationPredictionsRESP(i)==target(i)
        clr='#00FF00';
    else
        clr='#FF0000';
    end
    tab_html{i,3}=colergen(clr,num2str(validationPredictionsRESP(i)));
    
    if fusion_predictions(i)==target(i)
        clr='#00FF00';
    else
        clr='#FF0000';
    end
    tab_html{i,4}=colergen(clr,num2str(fusion_predictions(i)));
    tab_html{i,5}=colergen('#00FF00',num2str(target(i)));
end
handles.uitable1.Data=tab_html;
% handles    structure with handles and user data (see GUIDATA)
