close all
clear
clc

tic

load ft
load network1
rpm=randperm(400);

ft=ft(rpm,:);

for i=1:20
    tmp=ft;
    d(:,:,i)=tmp((i-1)*20+1:i*20,:);
    tmp((i-1)*20+1:i*20,:)=[];
    set(:,:,i)=tmp;
end

network1.divideparam.trainratio=0.8;
network1.divideparam.valratio=0.2;
network1.divideparam.testratio=0;

set1=set(:,:,1);
setabnormal = set1(set1(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set1(set1(:,end)==-1,:);
nno=numel(setnormal(:,1));
set1=[set1; setnormal(randi(nno,1,nab-nno),:)];
tar=[set1(:,end)==1,set1(:,end)==-1];
[net1,tr] = train(network1,set1(:,1:end-1)',tar');

set2=set(:,:,2);
setabnormal = set2(set2(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set2(set2(:,end)==-1,:);
nno=numel(setnormal(:,1));
set2=[set2; setnormal(randi(nno,1,nab-nno),:)];
tar=[set2(:,end)==1,set2(:,end)==-1];
[net2,tr] = train(network1,set2(:,1:end-1)',tar');

set3=set(:,:,3);
setabnormal = set3(set3(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set3(set3(:,end)==-1,:);
nno=numel(setnormal(:,1));
set3=[set3; setnormal(randi(nno,1,nab-nno),:)];
tar=[set3(:,end)==1,set3(:,end)==-1];
[net3,tr] = train(network1,set3(:,1:end-1)',tar');

set4=set(:,:,4);
setabnormal = set4(set4(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set4(set4(:,end)==-1,:);
nno=numel(setnormal(:,1));
set4=[set4; setnormal(randi(nno,1,nab-nno),:)];
tar=[set4(:,end)==1,set4(:,end)==-1];
[net4,tr] = train(network1,set4(:,1:end-1)',tar');

set5=set(:,:,5);
setabnormal = set5(set5(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set5(set5(:,end)==-1,:);
nno=numel(setnormal(:,1));
set5=[set5; setnormal(randi(nno,1,nab-nno),:)];
tar=[set5(:,end)==1,set5(:,end)==-1];
[net5,tr] = train(network1,set5(:,1:end-1)',tar');

set6=set(:,:,6);
setabnormal = set6(set6(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set6(set6(:,end)==-1,:);
nno=numel(setnormal(:,1));
set6=[set6; setnormal(randi(nno,1,nab-nno),:)];
tar=[set6(:,end)==1,set6(:,end)==-1];
[net6,tr] = train(network1,set6(:,1:end-1)',tar');

set7=set(:,:,7);
setabnormal = set7(set7(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set7(set7(:,end)==-1,:);
nno=numel(setnormal(:,1));
set7=[set7; setnormal(randi(nno,1,nab-nno),:)];
tar=[set7(:,end)==1,set7(:,end)==-1];
[net7,tr] = train(network1,set7(:,1:end-1)',tar');

set8=set(:,:,8);
setabnormal = set8(set8(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set8(set8(:,end)==-1,:);
nno=numel(setnormal(:,1));
set8=[set8; setnormal(randi(nno,1,nab-nno),:)];
tar=[set8(:,end)==1,set8(:,end)==-1];
[net8,tr] = train(network1,set8(:,1:end-1)',tar');

set9=set(:,:,9);
setabnormal = set9(set9(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set9(set9(:,end)==-1,:);
nno=numel(setnormal(:,1));
set9=[set9; setnormal(randi(nno,1,nab-nno),:)];
tar=[set9(:,end)==1,set9(:,end)==-1];
[net9,tr] = train(network1,set9(:,1:end-1)',tar');

set10=set(:,:,10);
setabnormal = set10(set10(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set10(set10(:,end)==-1,:);
nno=numel(setnormal(:,1));
set10=[set10; setnormal(randi(nno,1,nab-nno),:)];
tar=[set10(:,end)==1,set10(:,end)==-1];
[net10,tr] = train(network1,set10(:,1:end-1)',tar');

set11=set(:,:,11);
setabnormal = set11(set11(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set11(set11(:,end)==-1,:);
nno=numel(setnormal(:,1));
set11=[set11; setnormal(randi(nno,1,nab-nno),:)];
tar=[set11(:,end)==1,set11(:,end)==-1];
[net11,tr] = train(network1,set11(:,1:end-1)',tar');

set12=set(:,:,12);
setabnormal = set12(set12(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set12(set12(:,end)==-1,:);
nno=numel(setnormal(:,1));
set12=[set12; setnormal(randi(nno,1,nab-nno),:)];
tar=[set12(:,end)==1,set12(:,end)==-1];
[net12,tr] = train(network1,set12(:,1:end-1)',tar');

set13=set(:,:,13);
setabnormal = set13(set13(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set13(set13(:,end)==-1,:);
nno=numel(setnormal(:,1));
set13=[set13; setnormal(randi(nno,1,nab-nno),:)];
tar=[set13(:,end)==1,set13(:,end)==-1];
[net13,tr] = train(network1,set13(:,1:end-1)',tar');


set14=set(:,:,14);
setabnormal = set14(set14(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set14(set14(:,end)==-1,:);
nno=numel(setnormal(:,1));
set14=[set14; setnormal(randi(nno,1,nab-nno),:)];
tar=[set14(:,end)==1,set14(:,end)==-1];
[net14,tr] = train(network1,set14(:,1:end-1)',tar');


set15=set(:,:,15);
setabnormal = set15(set15(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set15(set15(:,end)==-1,:);
nno=numel(setnormal(:,1));
set15=[set15; setnormal(randi(nno,1,nab-nno),:)];
tar=[set15(:,end)==1,set15(:,end)==-1];
[net15,tr] = train(network1,set15(:,1:end-1)',tar');

set16=set(:,:,16);
setabnormal = set16(set16(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set16(set16(:,end)==-1,:);
nno=numel(setnormal(:,1));
set16=[set16; setnormal(randi(nno,1,nab-nno),:)];
tar=[set16(:,end)==1,set16(:,end)==-1];
[net16,tr] = train(network1,set16(:,1:end-1)',tar');

set17=set(:,:,17);
setabnormal = set17(set17(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set17(set17(:,end)==-1,:);
nno=numel(setnormal(:,1));
set17=[set17; setnormal(randi(nno,1,nab-nno),:)];
tar=[set17(:,end)==1,set17(:,end)==-1];
[net17,tr] = train(network1,set17(:,1:end-1)',tar');

set18=set(:,:,18);
setabnormal = set18(set18(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set18(set18(:,end)==-1,:);
nno=numel(setnormal(:,1));
set18=[set18; setnormal(randi(nno,1,nab-nno),:)];
tar=[set18(:,end)==1,set18(:,end)==-1];
[net18,tr] = train(network1,set18(:,1:end-1)',tar');

set19=set(:,:,19);
setabnormal = set19(set19(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set19(set19(:,end)==-1,:);
nno=numel(setnormal(:,1));
set19=[set19; setnormal(randi(nno,1,nab-nno),:)];
tar=[set19(:,end)==1,set19(:,end)==-1];
[net19,tr] = train(network1,set19(:,1:end-1)',tar');

set20=set(:,:,20);
setabnormal = set20(set20(:,end)==1,:);
nab=numel(setabnormal(:,1));
setnormal = set20(set20(:,end)==-1,:);
nno=numel(setnormal(:,1));
set20=[set20; setnormal(randi(nno,1,nab-nno),:)];
tar=[set20(:,end)==1,set20(:,end)==-1];
[net20,tr] = train(network1,set20(:,1:end-1)',tar');

out=net1(ft(:,1:end-1)');
out=out+net2(ft(:,1:end-1)');
out=out+net3(ft(:,1:end-1)');
out=out+net4(ft(:,1:end-1)');
out=out+net5(ft(:,1:end-1)');
out=out+net6(ft(:,1:end-1)');
out=out+net7(ft(:,1:end-1)');
out=out+net8(ft(:,1:end-1)');
out=out+net9(ft(:,1:end-1)');
out=out+net10(ft(:,1:end-1)');
out=out+net11(ft(:,1:end-1)');
out=out+net12(ft(:,1:end-1)');
out=out+net13(ft(:,1:end-1)');
out=out+net14(ft(:,1:end-1)');
out=out+net15(ft(:,1:end-1)');
out=out+net16(ft(:,1:end-1)');
out=out+net17(ft(:,1:end-1)');
out=out+net18(ft(:,1:end-1)');
out=out+net19(ft(:,1:end-1)');
out=out+net20(ft(:,1:end-1)');

out=out/20;
ou=out(1,:)>0.5;
in=[ft(:,end)==1];
plotconfusion(in',ou)
toc