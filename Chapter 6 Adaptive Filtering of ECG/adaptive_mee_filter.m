%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB codes for Final Year Project
% Adaptive Filtering of ECG - MEE filter
% Written by Galada Aditya
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [primary, refer, cancelled, step_size_optimal, snr_improvement_optimal,snr_improvement, mu_vec] = adaptive_mee_filter(input_ECG, input_noise_type, snratio)
    t = 1:250 * 60 * 2;
    hpFilt = designfilt('highpassiir', 'StopbandFrequency', .5, 'PassbandFrequency', 1, 'StopbandAttenuation',100, 'PassbandRipple', 1, 'SampleRate', 250,'DesignMethod', 'cheby2', 'MatchExactly', 'passband');
    ECG = filtfilt(hpFilt, input_ECG);
    desired = ECG(t);
    desired = desired - smooth(desired, 250)';
 
    mu_vec = [0.000025/8:0.000025/8:0.001];
    
    load(input_noise_type);
        noise = 2 * val(1, t);
        noise = noise / norm(noise) * norm(desired) / 10.0 ^ (0.05 * snratio);
     
        primary = desired + noise;
        refer = filtfilt([1 0.5 - .2], 1, noise);
    parfor cc = 1:numel(mu_vec)
        order = 3;
        mu = mu_vec(cc);
        n = length(primary);
        adap = zeros(1, order);
        sigma = 6;
        input = zeros(n, order);
        for i = 1:n - order - 1
            input(i, :) = refer(i:i + order - 1);
        end
        [cancelled(cc,:)] = mee_za(primary, input, adap, mu, sigma, order);
        
        if(strcmp(input_noise_type,'bwm.mat'))
    %       cancelled=filtfilt(hpFilt,cancelled);
        end
        
        snr_old = snr(desired, noise);
        snr_new = snr(desired, desired - cancelled(cc,:));
        snr_improvement(cc) = snr_new - snr_old;
    end
    [snr_improvement_optimal,ind]=max(snr_improvement);
    step_size_optimal=mu_vec(ind);
    cancelled=cancelled(ind,:);
end
