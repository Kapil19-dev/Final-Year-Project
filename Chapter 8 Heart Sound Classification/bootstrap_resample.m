%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB codes for Final Year Project
% Heart Sound Classification - Bootstrap Resampling
% Written by Galada Aditya
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [set, target, train_indices, val_indices]=bootstrap_resample(testset,validation_set)
    % Calculate number of abnormal records in the test set
    setabnormal = testset(testset(:,end)==1,:);
    num_abnormal=numel(setabnormal(:,1));
    
    % Calculate number of normal records in the test set
    setnormal = testset(testset(:,end)==-1,:);
    num_normal=numel(setnormal(:,1));
    
    
    train_set=[testset; setnormal(randi(num_normal,1,num_abnormal-num_normal),:)];
    train_set=[train_set; setabnormal(randi(num_abnormal,1,num_normal-num_abnormal),:)];
    train_tar=[train_set(:,end)==1,train_set(:,end)==-1];
    train_indices=numel(train_tar(:,1));
    if(numel(validation_set))
    setabnormal = validation_set(validation_set(:,end)==1,:);
    num_abnormal=numel(setabnormal(:,1));
    setnormal = validation_set(validation_set(:,end)==-1,:);
    num_normal=numel(setnormal(:,1));
    val_set=[validation_set; setnormal(randi(num_normal,1,num_abnormal-num_normal),:)];
    val_set=[val_set; setabnormal(randi(num_abnormal,1,num_normal-num_abnormal),:)];
    val_tar=[val_set(:,end)==1,val_set(:,end)==-1];
    val_indices=numel(val_tar(:,1));
   
    set=[train_set(:,1:end-1);val_set(:,1:end-1)]';
    target=[train_tar;val_tar]';
    else
        val_indices=0;
        set=[train_set(:,1:end-1)]';
        target=[train_tar]';
    end
end