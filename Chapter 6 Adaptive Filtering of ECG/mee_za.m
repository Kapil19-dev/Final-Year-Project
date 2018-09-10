 function [e]=mee_za(primary,refer,W_mee,mu_mee,sigma,L)         
   N = length(primary);
 e = zeros(1,N);
 
    for loop2 = L+1:N
        
       e(loop2) = primary(loop2)-W_mee*refer(loop2,:)';
       V = zeros(size(W_mee));
       for i=loop2-L+1:loop2
           for j=loop2-L+1:loop2
                   V = V + (e(i)-e(j))*exp(-norm(e(i)-e(j))/(2*sigma^2))*(refer(i,:)-refer(j,:));    
           end 
       end
       s = V/((sigma^2)*L^2);
        
       W_mee = W_mee +mu_mee*s;
    end
 end    
   