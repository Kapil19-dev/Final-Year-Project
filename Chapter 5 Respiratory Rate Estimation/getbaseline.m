function getbaseline(input_file,fs)
load(input_file)
%% Filtering the CO2 Signal
N     = 100;  % Order
Fpass = 0.15;   % Passband Frequency
Fstop = 1;  % Stopband Frequency
Wpass = 10;   % Passband Weight
Wstop = 1;   % Stopband Weight
dens  = 20;  % Density Factor
Fs=25;
% Calculate the coefficients using the FIRPM function.
b  = firpm(N, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop], ...
           {dens});
Hd = dfilt.dffir(b);
CO2_lp=filtfilt(b,1,CO2);
%% Peak Detection
x_new=diff(CO2_lp);
[~,RR_baseline_pos]=findpeaks(x_new,'MinPeakDistance',60);
y=diff(RR_baseline_pos);
RR_baseline=60./y*fs;
save RR_baseline RR_baseline RR_baseline_pos
end