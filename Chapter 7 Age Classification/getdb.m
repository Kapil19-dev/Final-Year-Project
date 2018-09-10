%% Clear the Workspace
close all
clear
clc

%% List of filenames to be fetched
list ={ 'f1o01', 'f1o02', 'f1o03','f1o04','f1o05','f1o06','f1o07','f1o08','f1o09','f1o10','f1y01','f1y02','f1y03','f1y04','f1y05','f1y06','f1y07','f1y08','f1y09','f1y10','f2o01','f2o02','f2o03','f2o04','f2o05','f2o06','f2o07','f2o08','f2o09','f2o10','f2y01','f2y02','f2y03','f2y04','f2y05','f2y06','f2y07','f2y08','f2y09','f2y10'};

%% Downloading the files using WFDB
for i=1:409
    % generate the full file name and fetch it from physionet 
    list_name(i)=strcat('challenge/2016/training-a/',list(i));
    tmp=char(list_name(i));
    val=rdsamp(tmp);
    
    % save as a .mat file for further processing
    save(sprintf(list{i}),'val');
    i
end