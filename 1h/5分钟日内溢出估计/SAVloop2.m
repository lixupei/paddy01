function q = SAVloop2(BETA, y, empiricalQuantile)
%此处生成分位数的序列，注意不是VaR的序列
% Compute the quantile time series for the Symmetric Absolute Value model,
% given the vector of returns y and the vector of parameters BETA.
%
T = length(y);
q = zeros(T,1); q(1) = empiricalQuantile;
for t = 2:T
    %q(t) = BETA(1) + BETA(2) * max(y(t-1),0) + BETA(3) * max(-y(t-1),0) +BETA(4) * q(t-1);
    q(t) = BETA(1) + BETA(2) * abs(y(t-1)) + BETA(3) * q(t-1);
end

%注意，此处直接对分位数回归，而不是对VaR进行回归
%在2004年CAViaR代码中，则是直接对VaR建模，因此会设定VaR(0)=-empiricalQuantile