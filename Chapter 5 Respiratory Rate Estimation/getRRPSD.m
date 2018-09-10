%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB codes for Final Year Project
% Respiratory Rate Estimation Using Power Spectrum Density
% Written by Galada Aditya
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [RR_psd,position]=getRRPSD(input_file,fs)
    %% Loading the input file    
    load(input_file)
    ECG_full=ECG;
    position=[];
    
    %% Divide the input into windows      
    for m = 1:floor(numel(ECG_full)/5/fs-20) 
        ECG_windowed=ECG_full(m*5*fs:m*5*fs+60*fs);
        position(m)=(m*5*fs+m*5*fs+60*fs)/2;
        
        %% calulate ibi and remove outliers using 20% rule
        % Obtain the R peak locations using Pan Tompkin's Method 
        [~,locs,~]=pan_tompkin(ECG_windowed,fs,0);
        
        % Generate the IBI time series using located R peaks
        ibi=abs(diff(locs))/fs;
        
        %% RSA signal extraction
        % generate the time locations for each heartbeat using IBI series
        t=cumsum(ibi);
        
        % resample the IBI time series @ 10 Hz
        fs=10;
        
        % use spline interpolation for IBI resampling
        y=interp1(t,ibi,1:1/fs:t(end),'spline');
        
        % mean subtraction to remove offset
        y=y-mean(y);
        
        %% Applying the Power Spectrum Density Method
        % set the parameters for FFT and generate the power spectrum
        window = 256; noverlap = 128; nfft = 512;
     %   [PSD,F] = pwelch(y,window,noverlap,(nfft*2)-1,fs,'onesided');
        [PSD,F]= pwelch(y,128,127,128,fs,'onesided');
        % Searching for respiratory rate in range on 12-25 breath per min
        f_min = 12/60;
        f_max = 25/60;
        
        % Peak frequency in this range corresponds to respiratory rate
        [~,locs]= findpeaks(PSD(floor(f_min/F(2)):ceil(f_max/F(2))));
        locs=locs+round(f_min/F(2));
        
        % Chooose the most prominent peak in case of multiple peaks
        if(numel(locs>1))
            lo=sortrows([PSD(locs),locs]');
            locs=lo(2,1);
            RR_psd(m)=60*F(2)*locs;
            psd_ensemble(m,:)=PSD;
        elseif (numel(locs)==1)
            RR_psd(m)=60*F(2)*locs;
        end
    end
    %% Result
    % Plot the estimated respiratory rate
    figure
    plot(RR_psd)
    
    % Save the respiratory rate and location for plotting in GUI
    save RR_psd RR_psd position
end