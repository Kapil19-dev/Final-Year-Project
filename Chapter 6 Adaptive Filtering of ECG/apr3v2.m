close all;
%clear;
clc;

load('20161108_S1486201G')
 
hpFilt = designfilt('highpassiir', 'StopbandFrequency', .5, ...
    'PassbandFrequency', 1, 'StopbandAttenuation', ...
    100, 'PassbandRipple', 1, 'SampleRate', 250, ...
    'DesignMethod', 'cheby2', 'MatchExactly', 'passband');
primary=filtfilt(hpFilt,ECG(43280:44500));

refer=zeros(1,numel(primary));
refer(190:196)=1;
refer(378:384)=1;
refer(566:570)=1;

 

  
  h(2)=subplot(4,1,2);
  plot(refer);
  ylabel('refer'); 

  h(3)=subplot(4,1,3);
  plot(primary);
  ylabel('primary');
  
  

 order=10;
 mu=0.02;
 n=length(primary);
 delayed=zeros(1,order);
 adap=zeros(1,order);
 sigma=6;
 input = zeros(n,order);
    for i=1:n-order-1
        input(i,:)=refer(i:i+order-1);
    end
   [cancelled]=mee_za(primary,input,adap,mu,sigma,order);      
    
  h(4)=subplot(4,1,4);
  plot(cancelled);
  ylabel('cancelled');

  
     h(1)=subplot(4,1,1);
   plot(primary-cancelled);
   
 linkaxes(h,'x')
