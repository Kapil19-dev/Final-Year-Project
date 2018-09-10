%% clear the workspace
close all
clear
clc

% Start the timer
tic

%% load the extracted features
load ft;
load ft_ecg;

ft_pcg=ft;
clear ft

%ft_pcg(:,16)=[];
ft_ecg(:,13)=[];

load network1
load network2

network1.dividefcn='divideind';
network2.dividefcn='divideind';
%network1.trainFcn = 'trainscg';
%network2.trainFcn = 'trainscg';

%network2.input.processFcns = {'mapminmax'};
%network2.output.processFcns = {'mapminmax'};

rpm=randperm(400);
res=[];

for loop=1:10
    rpm_cv=(loop-1)*(40)+1:loop*40;

    ft_pcg_train=ft_pcg(rpm,:);
    ft_pcg_train(rpm_cv,:)=[];
    ft_pcg_val=ft_pcg(rpm_cv,:);

    ft_ecg_train=ft_ecg(rpm,:);
    ft_ecg_train(rpm_cv,:)=[];
    ft_ecg_val=ft_ecg(rpm_cv,:);

    clear val tmp set
    for i=1:20
        tmp=ft_pcg_train;
        val(:,:,i)=tmp((i-1)*18+1:i*18,:);
        tmp((i-1)*18+1:i*18,:)=[];
        set(:,:,i)=tmp;
    end

    net_ens_pcg=cell(20,1);
    out_pcg_train=zeros(2,360);
    out_pcg_val=zeros(2,40);

    for i=1:20
        [in,tar,tind,vind]=bootstrap_resample(set(:,:,i),val(:,:,i));
        network1.divideparam.trainInd=[1:tind];
        network1.divideparam.valInd=[tind+1:tind+vind];
        [net_ens_pcg{i},tr] = train(network1,in,tar,'useGPU','only');
        out_pcg_train=out_pcg_train+net_ens_pcg{i}(ft_pcg_train(:,1:end-1)');
        out_pcg_val=out_pcg_val+net_ens_pcg{i}(ft_pcg_val(:,1:end-1)');
    end

    out_pcg_train=out_pcg_train/20;
    out_thresh=out_pcg_train(1,:)>0.5;  
    in=[ft_pcg_train(:,end)==1];
    pcg_res(loop,1)=classperf(in',out_thresh);

    out_pcg_val=out_pcg_val/20;
    out_thresh=out_pcg_val(1,:)>0.5;
    in=[ft_pcg_val(:,end)==1];
    pcg_res(loop,2)=classperf(in',out_thresh);

% figure(1)
% plotconfusion(in',ou)

%
clear val tmp set
for i=1:20
    tmp=ft_ecg;
    val(:,:,i)=tmp((i-1)*18+1:i*18,:);
    tmp((i-1)*18+1:i*18,:)=[];
    set(:,:,i)=tmp;
end

net_ens_ecg=cell(20,1);
out_ecg_train=zeros(2,360);
out_ecg_val=zeros(2,40);

for i=1:20
    [in,tar,tind,vind]=bootstrap_resample(set(:,:,i),val(:,:,i));
    network2.divideparam.trainInd=[1:tind];
    network2.divideparam.valInd=[tind+1:tind+vind];
    [net_ens_ecg{i},tr] = train(network2,in,tar,'useGPU','only');
    out_ecg_train=out_ecg_train+net_ens_ecg{i}(ft_ecg_train(:,1:end-1)');
    out_ecg_val=out_ecg_val+net_ens_ecg{i}(ft_ecg_val(:,1:end-1)');
end

out_ecg_train=out_ecg_train/20;
out_thresh=out_ecg_train(1,:)>0.5;
in=[ft_ecg_train(:,end)==1];
ecg_res(loop,1)=classperf(in',out_thresh);

out_ecg_val=out_ecg_val/20;
out_thresh=out_ecg_val(1,:)>0.5;
in=[ft_ecg_val(:,end)==1];
ecg_res(loop,2)=classperf(in',out_thresh);

% figure(2)
% plotconfusion(in',ou)

% out_fus=(out_ecg+out_pcg)/2;
% ou=out_fus(1,:)>0.5;
% in=[ft_ecg(:,end)==1];

out_fus_train=(out_ecg_train+out_pcg_train)/2;
out_thresh=out_fus_train(1,:)>0.5;
in=[ft_ecg_train(:,end)==1];
fus_res(loop,1)=classperf(in',out_thresh);

out_fus_val=(out_ecg_val+out_pcg_val)/2;
out_thresh=out_fus_val(1,:)>0.5;
in=[ft_ecg_val(:,end)==1];
fus_res(loop,2)=classperf(in',out_thresh);

% figure(3)
% plotconfusion(in',ou)
loop
end
toc