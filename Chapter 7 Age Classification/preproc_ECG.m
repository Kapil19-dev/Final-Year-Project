%% Clear the Workspace
close all
clear
clc

%% Setup
% Start Timer
tic
fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,40) '\n\n']);
list ={ 'f1o01', 'f1o02', 'f1o03','f1o04','f1o05','f1o06','f1o07','f1o08','f1o09','f1o10','f1y01','f1y02','f1y03','f1y04','f1y05','f1y06','f1y07','f1y08','f1y09','f1y10','f2o01','f2o02','f2o03','f2o04','f2o05','f2o06','f2o07','f2o08','f2o09','f2o10','f2y01','f2y02','f2y03','f2y04','f2y05','f2y06','f2y07','f2y08','f2y09','f2y10'};
features=[];
    parfor i=1:40
    %% Load the record for ith patient
    list(i)=strcat(list(i),'.mat');
    val=load(sprintf(list{i}));
    val=val.val;
    val=val(:,1);
    ECG=val;

    %% Preprocessing
    % Apply low pass filter
    lowPassFilt = designfilt('lowpassfir', 'PassbandFrequency', 45/125,'StopbandFrequency', 50/125, 'PassbandRipple', 0.5, 'StopbandAttenuation', 65, 'DesignMethod', 'kaiserwin');
    ECG=filtfilt(lowPassFilt,ECG);
    
    % Apply high pass filter
    highPassFilt = designfilt('highpassiir', 'StopbandFrequency', .5,'PassbandFrequency', 1, 'StopbandAttenuation',100, 'PassbandRipple', 1, 'SampleRate', 250,'DesignMethod', 'cheby2', 'MatchExactly', 'passband');
    ECG=filtfilt(highPassFilt,ECG);

    %% Feature Extraction
    % Caluculate the signal energy
    energy=sum(ECG.^2);
    
    % Calculate the fourth power
    fourthpower=sum(ECG.^4);
    
    % Calculate the non-linear energy
    nonlinearenergy=0;
    for j=3:numel(ECG)
        nonlinearenergy = nonlinearenergy + ECG(j)*ECG(j-2)+ ECG(j-1).^2;
    end
    
    % Calculate the curve length
    curvelength=sum(diff(ECG)); 
    
    % Calculate the hurst parameter
    hurst=library_RS(ECG);
    
    % Compute the power spectrum
    PSD=pwelch(ECG);
    
    % Calcualte the peak power and frequency
    [peakpower,peakfrequency]=max(PSD);
    
    % Calculate the mean and median frequency
    meanfrequency=meanfreq(PSD);
    medianfrequency=medfreq(PSD);
    
    % Calculate the Spectral Entropy
    spectralentropy=entropy(PSD./max(PSD));
    
    % Calculate the Shannon Entropy
    shannonentropy=entropy(ECG./max(ECG));
    
    % Calculate the Katz FD
    katzfd=library_Katz_FD(ECG);
    
    % Save the calcuated features for ith patient
    features(i,:)=[energy,fourthpower,nonlinearenergy,curvelength,hurst,peakpower,peakfrequency,meanfrequency,medianfrequency,spectralentropy,shannonentropy,katzfd];
    
    % update progress bar
    fprintf('\b|\n');
    end
 % End timer   
 toc