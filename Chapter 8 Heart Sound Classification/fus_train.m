close all
clear
clc

tic

load ft;
load ft_ecg;

ft_pcg=ft;
clear ft

%ft_pcg(:,16)=[];
ft_ecg(:,13)=[];

load network1
load network2

network1.dividefcn='dividerand';
network2.dividefcn='dividerand';

network1.divideparam.trainratio=0.8;
network1.divideparam.valratio=0.2;
network1.divideparam.testratio=0;

network2.divideparam.trainratio=0.8;
network2.divideparam.valratio=0.2;
network2.divideparam.testratio=0;


rpm=randperm(400);

ft_pcg=ft_pcg(rpm,:);
ft_ecg=ft_ecg(rpm,:);

for i=1:20
    tmp=ft_pcg;
    val(:,:,i)=tmp((i-1)*20+1:i*20,:);
    tmp((i-1)*20+1:i*20,:)=[];
    set(:,:,i)=tmp;
end

net_ens_pcg=cell(20,1);
out_pcg=zeros(2,400);

for i=1:20
    [in,tar,tind,vind]=bootstrap_resample(set(:,:,i),[]);
    [net_ens_pcg{i},tr] = train(network1,in,tar);
    out_pcg=out_pcg+net_ens_pcg{i}(ft_pcg(:,1:end-1)');
end

out_pcg=out_pcg/20;
ou=out_pcg(1,:)>0.5;
in=[ft_pcg(:,end)==1];
figure(1)
plotconfusion(in',ou)

%
clear val tmp set
for i=1:20
    tmp=ft_ecg;
    val(:,:,i)=tmp((i-1)*20+1:i*20,:);
    tmp((i-1)*20+1:i*20,:)=[];
    set(:,:,i)=tmp;
end

net_ens_ecg=cell(20,1);
out_ecg=zeros(2,400);

for i=1:20
    [in,tar,tind,vind]=bootstrap_resample(set(:,:,i),[]);
    [net_ens_ecg{i},tr] = train(network2,in,tar);
    out_ecg=out_ecg+net_ens_ecg{i}(ft_ecg(:,1:end-1)');
end

out_ecg=out_ecg/20;
ou=out_ecg(1,:)>0.5;
in=[ft_ecg(:,end)==1];
figure(2)
plotconfusion(in',ou)

out_fus=(out_ecg+out_pcg)/2;
ou=out_fus(1,:)>0.5;
in=[ft_ecg(:,end)==1];
figure(3)
plotconfusion(in',ou)

toc