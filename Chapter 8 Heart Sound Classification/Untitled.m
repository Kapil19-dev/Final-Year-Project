%% Setup
tic
fs=2000;

cd D:\FYP\hs\training\training-a
F = dir('*.wav');
for i=1:409
    F(i).name=strcat('D:\FYP\hs\training\training-a\',F(i).name);
end
cd D:\FYP\hs\
parfor ii = 1:length(F)
X = audioread(F(ii).name);

%% 1 LPC coefficients
[a g]=lpc(X,10);
features = [a(1) a(3) a(6) a(9) a(10)];
features = [a(2) a(4) a(7) a(10) a(11)];
%% 2 Entropy Based Features
p = hist(X,numel(X)/50);
p(p==0)=[];
entropy_natural = -sum(p.*log2(p));
entropy_tsallis = 1-sum(p.^2);
features = [ features entropy_natural entropy_tsallis];

%% 3 MFCC
    Tw = 25;                % analysis frame duration (ms)
    Ts = 15;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 40;                 % number of filterbank channels 
    C = 14;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 1;               % lower frequency limit (Hz)
    HF = 999;              % upper frequency limit (Hz)
  [ MFCCs, FBEs, frames ] = mfcc( X, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                
FMatrix=MFCCs;
N=numel(FMatrix(1,:));
AVmfcc=(sum(min(FMatrix')))/N;
urmax=mean((max(FMatrix')-mean(FMatrix')).^2);
urskew=mean((skewness(FMatrix')-mean(FMatrix')).^2);
features = [features AVmfcc urmax urskew];
%% 4 Wavelet Transform
[c,l] = wavedec(X,5,'db4');
[cd3,cd4,cd5] = detcoef(c,l,[3 4 5]);
ca5=appcoef(c,l,'db4',[5]);

p = hist(ca5,numel(ca5)/10);
p(p==0)=[];
Ha5 = -sum(p.*log2(p));

p = hist(cd5,numel(cd5));
Hqd5 = log(sum(cd5.^2));

p = hist(cd4,numel(cd4)/10);
p(p==0)=[];
Hd4 = -sum(p.*log(p));

ld3=log2(var(cd3));

features = [features Ha5 Hqd5 Hd4 ld3];

%% 5 Band Power
f=0:1/numel(p):1;
f(1)=[];
MPSD_C = sum(f.*p.^2)./sum(p.^2);
AUC1 = bandpower(X,fs,[0.7 0.8]*fs/2);
AUC2 = bandpower(X,fs,[0.9 .9999]*fs/2);
features = [features MPSD_C AUC1 AUC2];
ft(ii,:)=features;
end
toc
