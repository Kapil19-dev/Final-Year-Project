 function [e]=lms_za(primary,refer,W_lms,mu_lms,L)         

 N = length(primary);
 e = zeros(1,N);
 
    for loop2 = 1:N
       e(loop2) = primary(loop2)-W_lms*refer(loop2,:)';
       W_lms = W_lms +mu_lms*e(loop2)*refer(loop2,:);
    end
 end
    