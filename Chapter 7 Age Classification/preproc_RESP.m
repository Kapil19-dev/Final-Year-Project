tic

close all
clear
clc

fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,40) '\n\n']);

list ={ 'f1o01', 'f1o02', 'f1o03','f1o04','f1o05','f1o06','f1o07','f1o08','f1o09','f1o10','f1y01','f1y02','f1y03','f1y04','f1y05','f1y06','f1y07','f1y08','f1y09','f1y10','f2o01','f2o02','f2o03','f2o04','f2o05','f2o06','f2o07','f2o08','f2o09','f2o10','f2y01','f2y02','f2y03','f2y04','f2y05','f2y06','f2y07','f2y08','f2y09','f2y10'};
features_resp=[];

for i=1:1
list(i)=strcat(list(i),'.mat');
val=load(sprintf(list{i}));
val=val.val;
val=val(:,2);
ECG=val;
          lpFilt = designfilt('lowpassfir', 'PassbandFrequency', .9/125,...
             'StopbandFrequency', 1/125, 'PassbandRipple', 0.5, ...
             'StopbandAttenuation', 65, 'DesignMethod', 'kaiserwin');
ECG=filtfilt(lpFilt,ECG);
               hpFilt = designfilt('highpassiir', 'StopbandFrequency', 0.01, ...
                   'PassbandFrequency', 0.1, 'StopbandAttenuation', ...
                   100, 'PassbandRipple', 1, 'SampleRate', 250, ...
                   'DesignMethod', 'cheby2', 'MatchExactly', 'passband');
ECG=filtfilt(hpFilt,ECG);
energy=sum(ECG.^2);
fourthpower=sum(ECG.^4);
nonlinearenergy=0;
for j=3:numel(ECG)
    nonlinearenergy = nonlinearenergy + ECG(j)*ECG(j-2)+ ECG(j-1).^2;
end
curvelength=sum(diff(ECG));
hurst=library_RS(ECG);
    PSD=pwelch(ECG);
[peakpower,peakfrequency]=max(PSD);
meanfrequency=meanfreq(PSD);
medianfrequency=medfreq(PSD);
spectralentropy=entropy(PSD./max(PSD));
shannonentropy=entropy(ECG./max(ECG));
katzfd=library_Katz_FD(ECG);
features_resp(i,:)=[energy,fourthpower,nonlinearenergy,curvelength,hurst,peakpower,peakfrequency,meanfrequency,medianfrequency,spectralentropy,shannonentropy,katzfd];
fprintf('\b|\n');
end
toc