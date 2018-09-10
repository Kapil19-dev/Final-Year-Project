function H = RS(sequence)
%
% 'RS' estimate the hurst parameter of a given sequence with R/S method.
%
% Inputs:
%     sequence: the input sequence for estimate 
%     isplot: whether display the plot. without a plot if isplot equal to 0  
% Outputs:
%     H: the estimated hurst coeffeient of the input sequence

%  Author: Chu Chen 
%  Version 1.0,  03/10/2008
%  chen-chu@163.com
%


N = length(sequence);
dlarge = floor(N/5);
dsmall = max(10,log10(N)^2);
D = floor(logspace(log10(dsmall),log10(dlarge),50));
D = unique(D);
n = length(D);
x = zeros(1,n);
y = zeros(1,n);

R = cell(1,n);
S = cell(1,n);
for i = 1:n
    d = D(i);
    m = floor(N/d);
    R{i} = zeros(1,m);
    S{i} = zeros(1,m);
    matrix_sequence = reshape(sequence(1:d*m),d,m);

    Z1 = cumsum(matrix_sequence);
    Z2 = cumsum(repmat(mean(matrix_sequence),d,1));
    R{i} = (max(Z1-Z2)-min(Z1-Z2));
    S{i} = std(matrix_sequence);
    
    if min(R{i})==0 || min(S{i}) ==0
        continue;
    end
    
    x(i) = log10(d);
    y(i) = mean(log10(R{i}./S{i}));
end

% fit a line with middle part of sequence
index = x~=0;
x = x(index);
y = y(index);
n2 = length(x);
cut_min = ceil(3*n2/10);
cut_max = floor(9*n2/10);

X = x(cut_min:cut_max);
Y = y(cut_min:cut_max);
p1 = polyfit(X,Y,1);
Yfit = polyval(p1,X);
H = (Yfit(end)-Yfit(1))/(X(end)-X(1));
end