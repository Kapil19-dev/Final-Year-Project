%% Clear the workspace
close all
clear
clc
% Start the timer
tic

%% Load files
% The input .mat and .xlsx files
str='20161202_S1327247F';

strmat=strcat(str,'_trim.mat');
strxlsx=strcat(str,'.xlsx');

load(strcat('MEE_',strmat));
% load ground truth
cd 'D:\IA\IA\Delta NTU\R Peak Detection Results'
rpk=xlsread(strxlsx);
% manually remove the fofset if signal was trimmed
rpk=rpk-180000;
cd 'D:\IA\IA\Delta NTU\HRVAS-master'
ansmat(1)=numel(rpk);
%% Pan Tompkins Result
% perform R Peak detection using PT Method
[~,locpt,~]=pan_tompkin(ECG,250,0);
ansmat(2)=numel(locpt);
ansmat(3)=0;
for i=1:numel(locpt)
    ans=ismember(locpt(i)-4,rpk)+ismember(locpt(i)-3,rpk)+ismember(locpt(i)-2,rpk)+ismember(locpt(i)-1,rpk)+ismember(locpt(i),rpk)+ismember(locpt(i)+1,rpk)+ismember(locpt(i)+2,rpk)+ismember(locpt(i)+3,rpk)+ismember(locpt(i)+4,rpk);
    ansmat(3)=ansmat(3)+ans;
end
ansmat(4)=ansmat(2)-ansmat(3);
ansmat(5)=ansmat(1)-ansmat(3);
%% load MEE
%[~,locmee]=findpeaks(-d,'MinPeakDistance',125);
[locmee]=ptpk(d,120,ecg_h);
% locmee=locmee+80;
ansmat(6)=numel(locmee);
ansmat(7)=0;
for i=1:numel(locmee)
    ans=ismember(locmee(i)-5,rpk)+ismember(locmee(i)-4,rpk)+ismember(locmee(i)-3,rpk)+ismember(locmee(i)-2,rpk)+ismember(locmee(i)-1,rpk)+ismember(locmee(i),rpk)+ismember(locmee(i)+1,rpk)+ismember(locmee(i)+2,rpk)+ismember(locmee(i)+3,rpk)+ismember(locmee(i)+4,rpk)+ismember(locmee(i)+5,rpk);
    ansmat(7)=ansmat(7)+ans;
end
ansmat(8)=ansmat(6)-ansmat(7);
ansmat(9)=ansmat(1)-ansmat(7);
ansmat
toc