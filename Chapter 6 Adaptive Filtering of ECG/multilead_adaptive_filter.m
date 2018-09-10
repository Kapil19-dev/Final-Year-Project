
close all;
%clear;
clc;

load('tmp_sig1')
 
hpFilt = designfilt('highpassiir', 'StopbandFrequency', .5, ...
    'PassbandFrequency', 1, 'StopbandAttenuation', ...
    100, 'PassbandRipple', 1, 'SampleRate', 3840, ...
    'DesignMethod', 'cheby2', 'MatchExactly', 'passband');
avf=filtfilt(hpFilt,avf);
%avf=avf-smooth(avf,1000)';
primary=avf;

refer=avr-avl;
%refer=refer-smooth(refer,1000)';
refer=filtfilt(hpFilt,refer);



  h(1)=subplot(4,1,1);
  plot(primary);
  ylabel('primary');
    
  h(2)=subplot(4,1,2);
  plot(refer);
  ylabel('refererence'); 


 order=10;
 mu=1e-6;
 n=length(primary);
 delayed=zeros(1,order);
 adap=zeros(1,order);
 sigma=6;
 input = zeros(n,order);
    for i=1:n-order-1
        input(i,:)=refer(i:i+order-1);
    end
   [cancelled]=mee_za(primary,input,adap,mu,sigma,order);      
%   [cancelled]=lms_za(primary,input,adap,mu,order);          
  h(3)=subplot(4,1,3);
  plot(cancelled);
  ylabel('Estimated Noise');

  
    h(4)=subplot(4,1,4);
   plot(primary-cancelled);
   ylabel('Output')
 linkaxes(h,'x')
 
 figure(2)
 title('Adaptive Noise Cancelling')
f(1)=subplot(1,3,1)
plot(primary)
xlabel('Primary Input')
f(2)=subplot(1,3,2)
plot(refer)
xlabel('Reference Input')
f(3)=subplot(1,3,3)
plot(primary-cancelled)
xlabel('Output')
linkaxes(f,'x')
xlim([8800 9800])