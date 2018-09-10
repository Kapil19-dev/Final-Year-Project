%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB codes for Final Year Project
% Respiratory Rate Estimation Using Autoregressive model
% Written by Galada Aditya
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function getRRAR(input_file, fs)
    %% loading the input file
    load(input_file)
    ECG_full = ECG;
    k = numel(ECG_full);
    
    %% Divide the input file into windows
    for m = 1:floor(numel(ECG_full) / 5 / fs - 12)
        ECG_windowed = ECG_full(m * 5 * fs:m * 5 * fs + 60 * fs);
        
        %% calulate ibi and outlier removal using 20% rule
        % Obtain the R peak locations using Pan Tompkin's Method 
        [~,locs,~]=pan_tompkin(ECG_windowed,fs,0);
        
        % Generate the IBI time series using located R peaks
        ibi=abs(diff(locs))/fs;
        
        %% RSA signal extraction
        % generate the time locations for each heartbeat using IBI series
        t=cumsum(ibi);
        
        % resample the IBI time series @ 2Hz
        fs_down = 2;
        
        y = interp1(t, ibi, 1:1 / fs_down:t(end), 'spline');
        y = y - mean(y);
        
        %% Applying the Autoregressive Model method
        % model y using AR burg model of order 10
        a = arburg(y, 10);
        
        % obtain the poles of this AR model
        r = roots(a);
 
        % searching for poles only between 10 Hz to 25 Hz
        r(angle(r) <= 10 / 60 * 2 * pi / fs_down) = [];
        r(angle(r) > 25 / 60 * 2 * pi / fs_down) = [];
        r = sort(r, 'descend');
        
        % plot(r,'o')
        k(m) = numel(r);
        RR_ar(m) = NaN;
        if (~ isempty(r))
     
        % 
        if numel(r) == 1
            RR_ar(m) = 60 * angle(r(1)) * fs_down / 2 / pi;
        elseif numel(r) == 2
            RR_ar(m) = 60 * angle(r(1)) * fs_down / 2 / pi;
            RR_ar1(m) = 60 * angle(r(2)) * fs_down / 2 / pi;
        end
    end
    end
    %% Plot the respiratory poles from autoregressive model
    figure
    plot(RR_ar)
    hold on
    plot(RR_ar1)
    title('Respiratory Rate')
    legend('first pole', 'second pole')
    xlim([- 1 1])
    ylim([- 1 1])
    
    %% Plot number of dominant poles in the frequency range of interest
    figure; plot(k)
    title('Number of poles between 0.2 to 0.7 Hz')
save RR_ar RR_ar RR_ar1
end