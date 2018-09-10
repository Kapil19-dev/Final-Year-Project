%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB codes for data analysis of ECG 
% Algorithm: 
% Written by NTU/EEE/Zhang Jianmin, Mar. 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
%close all;
clc;

% nameVrb = char('numIBI','numIBIoutliners','IBImax','IBImin','IBImean','IBImedian','SDNN','SDANN','NNx','pNNx',...
%     'RMSSD','SDNNi','meanHR','sdHR','HRVTi','TINN','Welch_aVLF','Welch_aLF','Welch_aHF','Welch_aTotal',...
%     'Welch_pVLF','Welch_pLF','Welch_pHF','Welch_nLF','Welch_nHF','Welch_LFHF','Welch_peakVLF','Welch_peakLF','Welch_peakHF','AR_aVLF',...
%     'AR_aLF','AR_aHF','AR_aTotal','AR_pVLF','AR_pLF','AR_pHF','AR_nLF','AR_nHF','AR_LFHF','AR_peakVLF',...
%     'AR_peakLF','AR_peakHF','LS_aVLF','LS_aLF','LS_aHF','LS_aTotal','LS_pVLF','LS_pLF','LS_pHF','LS_nLF',...
%     'LS_nHF','LS_LFHF','LS_peakVLF','LS_peakLF','LS_peakHF','Poincare_SD1','Poincare_SD2','Nonlinear_sampen','Nonlinear_alpha','Nonlinear_alpha1',...
%     'Nonlinear_alpha2','TFAR_aVLF','TFAR_aLF','TFAR_aHF','TFAR_aTotal','TFAR_pVLF','TFAR_pLF','TFAR_pHF','TFAR_nLF','TFAR_nHF',...
%     'TFAR_LFHF','TFAR_peakVLF','TFAR_peakLF','TFAR_peakHF','TFAR_rLFHF','TFLS_aVLF','TFLS_aLF','TFLS_aHF','TFLS_aTotal','TFLS_pVLF',...
%     'TFLS_pLF','TFLS_pHF','TFLS_nLF','TFLS_nHF','TFLS_LFHF','TFLS_peakVLF','TFLS_peakLF','TFLS_peakHF','TFLS_rLFHF','TFWT_aVLF',...
%     'TFWT_aLF','TFWT_aHF','TFWT_aTotal','TFWT_pVLF','TFWT_pLF','TFWT_pHF','TFWT_nLF','TFWT_nHF','TFWT_LFHF','TFWT_peakVLF',...
%     'TFWT_peakLF','TFWT_peakHF','TFWT_rLFHF');
% exType1 = 'TM'; exType2 = 'SC'; exType3 = 'AC'; exType4 = 'IR';
idx_patient = [1;1;1;2;2;3;3;3;4;4;5;5;6;6;6;7;7;8;8;8;9;9;9;10;10;10;11;11;12;12;12];
idx_exType = [1;2;4;2;3;1;2;3;1;3;1;3;1;2;3;2;4;1;2;3;1;2;3;1;2;3;2;3;1;2;3];
X0 = xlsread('ECG_DataAnalysis_exType.csv');
rRMSSD = X0(:,11)./X0(:,5);
% r_SD = X0(:,56)./X0(:,57);
r_SD = X0(:,57)./X0(:,56);
S_SD = pi*X0(:,56).*X0(:,57);
% X = [X0 rRMSSD r_SD];

figure;
for k = 1:length(idx_exType)
    ex = idx_exType(k);
    switch ex
        case 1
            Cl = 'r';
        case 2
            Cl = 'b';
        case 3
            Cl = 'k';
        case 4
            Cl = 'm';
        otherwise
            display('Error: There are only 4 types of exercises!');
    end
    pt = idx_patient(k);
    switch pt
        case 1
            Mk = 'o';
        case 2
            Mk = '+';
        case 3
            Mk = '*';
        case 4
            Mk = 'x';
        case 5
            Mk = 's';
        case 6
            Mk = 'd';
        case 7
            Mk = '^';
        case 8
            Mk = 'v';
        case 9
            Mk = '>';
        case 10
            Mk = '<';
        case 11
            Mk = 'p';
        case 12
            Mk = 'h';
        otherwise
            display('Error: There are only 12 patients!');
    end
%     errorbar(k,X0(k,5),X0(k,7),'Marker',Mk,'Color',Cl); hold on;    % IBI with standard derivation
%    errorbar(k,X0(k,13),X0(k,14),'Marker',Mk,'Color',Cl); hold on;    % HR with standard derivation
%     plot(k,X0(k,11),'Marker',Mk,'Color',Cl); hold on;    % RMSSD
%     plot(k,rRMSSD(k),'Marker',Mk,'Color',Cl); hold on;    % Ratio of RMSSD to mean IBI
%     plot(k,r_SD(k),'Marker',Mk,'Color',Cl); hold on;    % Ratio of SD1 to SD2  
%     semilogy(k,S_SD(k),'Marker',Mk,'Color',Cl); hold on;    % area of ellipse formed by SD1 and SD2  
    errorbar(k,X0(k,5),X0(k,8),'Marker','.','Color',Cl); hold on;    % IBI with SDANN
%     errorbar(k,X0(k,5),X0(k,12),'Marker',Mk,'Color',Cl); hold on;    % IBI with SDNNi
%     plot(k,X0(k,10),'Marker',Mk,'Color',Cl); hold on;    % pNNx of IBI
%     plot(k,X0(k,5)./X0(k,16),'Marker',Mk,'Color',Cl); hold on;    % ratio of TINN to mean IBI
%     plot(k,X0(k,52),'Marker',Mk,'Color',Cl); hold on;    % power ratio of LF to HF - LS
%     plot(k,X0(k,26),'Marker',Mk,'Color',Cl); hold on;    % power ratio of LF to HF - Welch
%     semilogy(k,X0(k,18),'Marker',Mk,'Color',Cl); hold on;    % Power of LF - Welch 
%     semilogy(k,X0(k,19),'Marker',Mk,'Color',Cl); hold on;    % Power of HF - Welch 
%     plot(k,X0(k,44),'Marker',Mk,'Color',Cl); hold on;     % power of LF - LS
%     plot(k,X0(k,45),'Marker',Mk,'Color',Cl); hold on;    % power of HF - LS 
%     plot(k,X0(k,58),'Marker',Mk,'Color',Cl); hold on;    % Sample Entropy
%     plot(k,X0(k,99),'Marker',Mk,'Color',Cl); hold on;    % power ratio of LF to HF - WT
%     semilogy(k,X0(k,91),'Marker',Mk,'Color',Cl); hold on;    % Power of LF - WT 
%     semilogy(k,X0(k,92),'Marker',Mk,'Color',Cl); hold on;    % Power of HF - WT 
%     plot(k,X0(k,97),'Marker',Mk,'Color',Cl); hold on;    % Normalized power ratio of LF – WT
%     plot(k,X0(k,98),'Marker',Mk,'Color',Cl); hold on;    % Normalized power ratio of HF – WT
end
hold off; 
% title('Inter-Beat Interval'); ylabel('time (ms)'); xlabel('index'); 
% title('meanHR with SDHR'); ylabel('bpm'); xlabel('index'); 
% title('RMSSD of IBI'); ylabel('amplitude (ms)'); xlabel('index'); 
% title('Ratio of RMSSD to meanIBI'); ylabel('amplitude'); xlabel('index'); 
% title('Ratio of SD2 to SD1'); ylabel('amplitude'); xlabel('index'); 
% title('Area of ellipse in Poincare plot'); ylabel('amplitude (ms^2)'); xlabel('index'); 
title('meanIBI with SDANN'); ylabel('time (ms)'); xlabel('index'); 
% title('Inter-Beat Interval w SDNNi'); ylabel('time (ms)'); xlabel('index'); 
% title('pNNx of IBI'); ylabel('percentage (%)'); xlabel('index'); 
% title('Ratio of TINN to mean IBI'); ylabel('%'); xlabel('index'); 
% title('Power ratio of LF to HF - LS'); ylabel('amplitude'); xlabel('index'); 
% title('Power ratio of LF to HF - Welch'); ylabel('amplitude'); xlabel('index'); 
% title('Power of LF - Welch'); ylabel('amplitude'); xlabel('index'); 
% title('Power of HF - Welch'); ylabel('amplitude'); xlabel('index'); 
% title('Power of LF - LS'); ylabel('amplitude'); xlabel('index'); 
% title('Power of HF - LS'); ylabel('amplitude'); xlabel('index'); 
% title('Sample Entropy'); ylabel('amplitude'); xlabel('index'); 
% title('Power ratio of LF to HF'); ylabel('amplitude'); xlabel('index'); %WT
% title('Power of LF'); ylabel('amplitude'); xlabel('index'); %WT
% title('Power of HF'); ylabel('amplitude'); xlabel('index'); %WT
% title('Normalized power ratio of LF'); ylabel('Percentage (%)'); xlabel('index'); %WT
% title('Normalized power ratio of HF'); ylabel('Percentage (%)'); xlabel('index'); %WT

% figure;
% x = 1:3
% % errorbar(x,X0(1:3,5),X0(1:3,7),'r*'); %hold on;
% errorbar(x,X0(1:3,5),X0(1:3,7),'Marker','*','Color','r'); %hold on;

% X_ex1 = []; X_ex2 = []; X_ex3 = []; X_ex4 = []; 
% for k = 1:length(idx_ex)
%     ex = idx_ex(k);
%     switch ex
%         case 1
%             X_ex1 = [X_ex1;X(k,:)];
%         case 2
%             X_ex2 = [X_ex2;X(k,:)];
%         case 3
%             X_ex3 = [X_ex3;X(k,:)];
%         case 4
%             X_ex4 = [X_ex4;X(k,:)];
%         otherwise
%             display('Error: There are only 4 types of exercises!');
%     end
% end
% 
% mean_X_ex1 = mean(X_ex1);
% SD_X_ex1 = std(X_ex1);
% mean_X_ex2 = mean(X_ex2);
% SD_X_ex2 = std(X_ex2);
% mean_X_ex3 = mean(X_ex3);
% SD_X_ex3 = std(X_ex3);
% mean_X_ex4 = mean(X_ex4);
% SD_X_ex4 = std(X_ex4);
% 
% figure; %errorbar(mean_X_ex1(1:16),SD_X_ex1(1:16),'rx');
% x = 1:4:4*13+1;
% errorbar(x,mean_X_ex1(3:16),SD_X_ex1(3:16),'r*'); hold on;
% x = 2:4:4*13+2;
% errorbar(x,mean_X_ex2(3:16),SD_X_ex2(3:16),'b.'); hold on;
% x = 3:4:4*13+3;
% errorbar(x,mean_X_ex3(3:16),SD_X_ex3(3:16),'k+'); hold on;
% x = 4:4:4*13+4;
% errorbar(x,mean_X_ex4(3:16),SD_X_ex4(3:16),'go'); hold off;

x=ones(1,900-400);
y=401:900;
hold on
plot(x*3.5,y,':k')
plot(x*5.5,y,':k')
plot(x*8.5,y,':k')
plot(x*10.5,y,':k')
plot(x*12.5,y,':k')
plot(x*15.5,y,':k')
plot(x*17.5,y,':k')
plot(x*20.5,y,':k')
plot(x*23.5,y,':k')
plot(x*26.5,y,':k')
plot(x*28.5,y,':k')
xlim([0.5 31.5]);