function output = RQobjectiveFunction2(BETA, OUT, y, THETA, empiricalQuantile)
% 关于函数quantile(t) = BETA(1) + BETA(2) * abs(y(t-1)) + BETA(3) *
% quantile(t-1)的目标函数

%--------------------------------------------------------------------------
% RQobjectiveFunction computes the quantile and the RQ criterion for given 
% vector of parameters BETA.
% If OUT=1, the output is the regression quantile objective function.
% If OUT=2, the output is [q, Hit].
%--------------------------------------------------------------------------
%
% Compute the quantile
q = SAVloop1(BETA, y, empiricalQuantile);
Hit = (y < q) - THETA;
%
%**********************************************
% Compute the Regression Quantile criterion.
RQ  = -Hit'*(y - q);
%
%**********************************************
% Select the output of the program.
if OUT == 1
    output = RQ;
elseif OUT ==2
    output = [q, Hit];
else error('Wrong output selected. Choose OUT = 1 for RQ, or OUT = 2 for [q, Hit].')
end