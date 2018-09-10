close all;
clear;
clc;
load('20161108_S1486201G.mat')
load('bwm.mat')
t=1:250*60*2;
 
desired=ECG(t);
desired=desired-smooth(desired,250)';
% desired=desired-smooth(desired,125)';

 noise=1*val(1,t);

 
 primary=desired+noise;
 refer=filtfilt([1 0.5 -.2],1,noise);
 refer=noise;

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
 mu=0.0005;
 n=length(primary);
 delayed=zeros(1,order);
 adap=zeros(1,order);
 cancelled=zeros(1,n);
 
 for k=1:n,
     delayed(1)=refer(k);
     y=delayed*adap';
     cancelled(k)=primary(k)-y;
     adap = adap + 2*mu*cancelled(k) .* delayed;
     delayed(2:order)=delayed(1:order-1);
 end

 
    
  h(4)=subplot(4,1,4);
  plot(cancelled);
  ylabel('cancelled');
 
 linkaxes(h,'x')
snr_old=snr(desired,noise)
snr_new=snr(desired,desired-cancelled)
