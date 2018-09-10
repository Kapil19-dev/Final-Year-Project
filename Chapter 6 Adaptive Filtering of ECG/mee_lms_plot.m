close all;
clear;
clc;
load('20161108_S1486201G.mat')
load('mam.mat')
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

 noise=2*val(1,t);

 
 primary=desired+noise;
 refer=filtfilt([1 0.5 -.2],1,noise);
 

  h(1)=subplot(5,1,1);
  plot(desired);
  ylabel('desired');
  
  h(2)=subplot(5,1,2);
  plot(refer);
  ylabel('refer'); 

  h(3)=subplot(5,1,3);
  plot(primary);
  ylabel('primary');
  
  
 
 order=3;
 mu=0.0001;
 n=length(primary);
 delayed=zeros(1,order);
 adap=zeros(1,order);
 sigma=6;
 input = zeros(n,order);
    for i=1:n-order-1
        input(i,:)=refer(i:i+order-1);
    end
   [cancelled_mee]=mee_za(primary,input,adap,mu,sigma,order);      
    
  h(4)=subplot(5,1,4);
  plot(cancelled_mee);
  ylabel('cancelled mee');

  
   order=3;
 mu=0.0000001;
 n=length(primary);
 delayed=zeros(1,order);
 adap=zeros(1,order);
 sigma=6;
 input = zeros(n,order);
    for i=1:n-order-1
        input(i,:)=refer(i:i+order-1);
    end
   [cancelled_lms]=lms_za(primary,input,adap,mu,order);      
    
  h(5)=subplot(5,1,5);
  plot(cancelled_lms);
  ylabel('cancelled_lms');

 linkaxes(h,'xy')
