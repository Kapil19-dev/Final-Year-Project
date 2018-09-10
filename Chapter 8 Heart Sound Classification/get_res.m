train_res=[];
%% 
% The following code is used to generate the sensitivity, specificity and
% accuracy table for 10 folds for the PCG, ECG & Fusion schemes
for i=1:10
   train_res(i,1)=pcg_res(i,2).sensitivity;
   train_res(i,2)=pcg_res(i,2).specificity;
   train_res(i,3)=pcg_res(i,2).correctrate;
   
   train_res(i,4)=ecg_res(i,2).sensitivity;
   train_res(i,5)=ecg_res(i,2).specificity;
   train_res(i,6)=ecg_res(i,2).correctrate;
   
   train_res(i,7)=fus_res(i,2).sensitivity;
   train_res(i,8)=fus_res(i,2).specificity;
   train_res(i,9)=fus_res(i,2).correctrate;
end