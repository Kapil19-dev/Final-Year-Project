close all;
clear;
clc;
load('20161108_S1486201G.mat')
load('bwm.mat')
t=1:250*60*2;
 
hpFilt = designfilt('highpassiir', 'StopbandFrequency', .5, ...
    'PassbandFrequency', 1, 'StopbandAttenuation', ...
    100, 'PassbandRipple', 1, 'SampleRate', 250, ...
    'DesignMethod', 'cheby2', 'MatchExactly', 'passband');
ECG=filtfilt(hpFilt,ECG);
desired=ECG(3.5e5:3.9e5);
desired=ECG(t);

desired=desired-smooth(desired,250)';
% desired=desired-smooth(desired,125)';
snratio=[-10:.5:15];
mu_vec=[0.0000001/16:0.0000001/16:0.0000001];
%for cc=1:numel(snratio)
for cc=1:numel(mu_vec)
 noise=2*val(1,t);
%noise = noise / norm(noise) * norm(desired) / 10.0^(0.05*snratio(cc));
noise = noise / norm(noise) * norm(desired) / 10.0^(0.05*6);
 
 primary=desired+noise;
 refer=filtfilt([1 0.5 -.2],1,noise);
 

  h(1)=subplot(4,1,1);
  plot(desired);
  ylabel('desired');
  
  h(2)=subplot(4,1,2);
  plot(refer);
  ylabel('refer'); 

  h(3)=subplot(4,1,3);
  plot(primary);
  ylabel('primary');
  
  
 
 order=3;
 mu=0.0000001;
 mu=mu_vec(cc);
 n=length(primary);
 delayed=zeros(1,order);
 adap=zeros(1,order);
 sigma=6;
 input = zeros(n,order);
    for i=1:n-order-1
        input(i,:)=refer(i:i+order-1);
    end
   [cancelled]=lms_za(primary,input,adap,mu,order);      
    
  h(4)=subplot(4,1,4);
  plot(cancelled);
  ylabel('cancelled');
 
 linkaxes(h,'x')
snr_old=snr(desired,noise)
snr_new=snr(desired,desired-cancelled)

snr_improvement(cc)=snr_new-snr_old
end
% corr_before=corr(desired',primary')
% corr_after=corr(desired',cancelled')
