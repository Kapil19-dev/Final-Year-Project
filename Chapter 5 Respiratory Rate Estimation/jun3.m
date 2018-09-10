%% Setup 

% clear the workspace
close all
clear
clc

% set upper and lower bound for RR
f_low=8;
f_high=16;

%% Processing Thorax Data

    % load the file
    load('thorax')
    fs = 8000;

    % plot the histogram
    figure(1)
    hist(thorax, 39)
    xlabel('amplitude')
    ylabel('count')
    title('Histogram - Thorax')

    % resample the time series @ 2Hz
    fs_down = 2;
    y = interp1(1:numel(thorax), thorax, 1:1/2:20, 'spline');
    y = y - mean(y);

    % Applying the Autoregressive Model method
    % model y using AR burg model of order 10
    a = arburg(y, 10);

    % obtain the poles of this AR model
    r = roots(a);

    % searching for poles only between 10 Hz to 25 Hz
    r(angle(r) <= f_low / 60 * 2 * pi / fs_down) = [];
    r(angle(r) > f_high / 60 * 2 * pi / fs_down) = [];
    r = sort(r, 'descend');
    % plot(r,'o')

    % Determine the respiratory rate
    RR_thorax = 60 * angle(r(1)) * fs_down / 2 / pi

%% Processing Chest Bare Skin Data

    % load the file
    load('chestbareskin')
    fs = 8000;
    
    % plot the histogram
    figure(2)
    hist(chestbareskin, 35)
    xlabel('amplitude')
    ylabel('count')
    title('Histogram - Chest Bare Skin')

    % resample the time series @ 2Hz
    fs_down = 2;
    y = interp1(1:numel(chestbareskin), chestbareskin, 1:1/2:20, 'spline');
    y = y - mean(y);

    % Applying the Autoregressive Model method
    % model y using AR burg model of order 10
    a = arburg(y, 10);

    % obtain the poles of this AR model
    r = roots(a);

    % searching for poles only between 10 Hz to 25 Hz
    r(angle(r) <= f_low / 60 * 2 * pi / fs_down) = [];
    r(angle(r) > f_high / 60 * 2 * pi / fs_down) = [];
    r = sort(r, 'descend');
    % plot(r,'o')
    
    % Determine the respiratory rate
    RR_chestbareskin = 60 * angle(r(1)) * fs_down / 2 / pi

%% Processing Chest Thru Clothes Data

    % load the file
    load('chestthruclothes')
    fs = 8000;
    
    % plot the histogram
    figure(3)
    hist(chestthruclothes, 37)
    xlabel('amplitude')
    ylabel('count')
    title('Histogram - Chest Thru Clothes')

    % resample the time series @ 2Hz
    fs_down = 2;
    y = interp1(1:numel(chestthruclothes), chestthruclothes, 1:1/2:20, 'spline');
    y = y - mean(y);
    
    % Applying the Autoregressive Model method
    % model y using AR burg model of order 10
    a = arburg(y, 10);

    % obtain the poles of this AR model
    r = roots(a);

    % searching for poles only between 10 Hz to 25 Hz
    r(angle(r) <= f_low / 60 * 2 * pi / fs_down) = [];
    r(angle(r) > f_high / 60 * 2 * pi / fs_down) = [];
    r = sort(r, 'descend');
    % plot(r,'o')
    
    % Determine the respiratory rate
    RR_chestthruclothes = 60 * angle(r(1)) * fs_down / 2 / pi
    
%% close all plots
close all