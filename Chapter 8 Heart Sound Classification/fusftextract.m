%% Setup
close all
clear
clc

warning('off','all')

tic
fs=2000;

cd 'D:\FYP\hs\challenge set'
F = dir('*.mat');
for i=1:409
    F(i).name=strcat('D:\FYP\hs\challenge set\',F(i).name);
end
cd D:\FYP\hs\
parfor ii = 1:length(F)
    a1=load(F(ii).name);
    ft_pcg(ii,:)=feature_extraction_pcg(a1.val(:,1));
    if numel(a1.val(1,:))==2
        ft_ecg(ii,:)=feature_extraction_ecg(a1.val(:,2));
    else
        ft_ecg(ii,:)=NaN*ones(1,15);
    end
end


for i=1:409
    for j=1:18
        if isnan(ft_pcg(i,j))
            ft_pcg(i,j)=nanmean(ft_pcg(:,j));
        end
    end
end


for i=1:409
    for j=1:15
        if isnan(ft_ecg(i,j))
            ft_ecg(i,j)=nanmean(ft_ecg(:,j));
        end
    end
end
toc
warning('on','all')
