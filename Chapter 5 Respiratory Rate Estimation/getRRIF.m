%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB codes for Final Year Project
% Respiratory Rate Estimation Using Instantaneous Frequency Tracking
% Written by Galada Aditya
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function getRRIF(input_file, fs)
    %% load ecg signal
    load(input_file);
    
    %% calulate ibi and outlier removal using 20% rule
    % Obtain the R peak locations using Pan Tompkin's Method
    [~, locs, ~] = pan_tompkin(ECG, fs, 0);
    
    % Generate the IBI time series using located R peaks
    ibi = abs(diff(locs)) / fs;
    
    %% RSA signal extraction
    % generate the time locations for each heartbeat using IBI series
    t=cumsum(ibi);

    % resample the IBI time series @ 10 Hz
    fs=10;

    % use spline interpolation for IBI resampling
    u = interp1(t, ibi, 1:1 / fs:t(end), 'spline');
    
    % mean subtraction to remove offset
    u = u - mean(u);
    
    % FIR filtering to search for frequencies in the range of 10-25bpm
    B = fir1(250, [10 / 60 25 / 60] * 2 / fs);
    u = filtfilt(B, 1, u);
    
    %% Adaptive frequency tracking
    % this section implements a OSC-MSE IIR adaptive filter
    
    b = 0.02;
    d = 0.9;
    y = 0.5 * ones(1, numel(u));
    a = 0.5 * ones(1, numel(u));
    p = zeros(1, numel(u));
    q = zeros(1, numel(u));
 
    % a is alpha the adaptive coeff
    % d = delta(update rate) and b= beta(bandwidth)
 
    for n = 3:numel(u) - 1 
        y(n) = (1 + b) * a(n) * y(n - 1) - b * y(n - 2) + 0.5 * (1 - b) * (u(n) - u(n - 2));
        p(n) = d * p(n - 1) + (1 - d) * y(n - 1) .^ 2;
        q(n) = d * q(n - 1) + (1 - d) * y(n - 1) * (y(n) + y(n - 2));
        a(n + 1) = q(n) / p(n) / 2;
    end
    
    % remove values which lie outside -1 to 1 range
    a(abs(a) > 1) = [];
    
    %% Result
    % Plot the estimated respiratory rate
    figure
    hold on
    plot(acos(a) / 2 / pi * 60 * fs);
    plot(smooth(acos(a) / 2 / pi * 60 * fs, 20 * fs), 'r', 'LineWidth', 2)
    legend('instantaneous frequency', 'smooth')
    ylabel('Breaths per minute')
    xlabel('Samples')
    
    % Save the respiratory rate for plotting in GUI
    RR_if = acos(a) / 2 / pi * 60 * fs;
    save RR_if RR_if
end