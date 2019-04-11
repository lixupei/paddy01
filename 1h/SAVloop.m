function q = SAVloop(BETA, y, empiricalQuantile)
%
% Compute the quantile time series for the Symmetric Absolute Value model,
% given the vector of returns y and the vector of parameters BETA.
%
T = length(y);
q = zeros(T,1); q(1) = empiricalQuantile;
for t = 2:T
    q(t) = BETA(1) + BETA(2) * abs(y(t-1)) + BETA(3) * q(t-1);
end