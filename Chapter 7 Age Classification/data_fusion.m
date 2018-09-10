%% Clear the workspace
close all
clear
clc

%% Load the extracted features and targets
load('features_ECG')
load('features_HRV')
load('features_RESP')

target=features_ECG(:,end);

%% traing the 3 proposed classifiers
[trainedClassifierECG, validationAccuracyECG,validationPredictionsECG] = trainClassifierECG(features_ECG);
[trainedClassifierHRV, validationAccuracyHRV,validationPredictionsHRV] = trainClassifierHRV(features_HRV);
[trainedClassifierRESP, validationAccuracyRESP,validationPredictionsRESP] = trainClassifierRESP(features_RESP);
clc

%% Taking hard majority vote as fusion output
for i=1:40
fusion_predictions(i)=mode([validationPredictionsECG(i),validationPredictionsHRV(i),validationPredictionsRESP(i)])
end

%% Plotting the results
figure(1)
plotconfusion(target',validationPredictionsECG')
title('Confusion Matrix : ECG Waveform')

figure(2)
plotconfusion(target',validationPredictionsHRV')
title('Confusion Matrix : HRV')

figure(3)
plotconfusion(target',validationPredictionsRESP')
title('Confusion Matrix : Respiratory Waveform')

figure(4)
plotconfusion(target',fusion_predictions)
title('Confusion Matrix : Data Fusion')