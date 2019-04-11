function [BetaHat,RQvalue,quantile] = CAViaR_estim1(y, THETA)
%只估计SAV模型，quantile(t) = BETA(1) + BETA(2) * abs(y(t-1)) + BETA(3) * quantile(t-1);
%比较SAVloop1函数（CAViaR，2004），VaR(i)=BETA(1)+BETA(2)*VaR(i-1)+BETA(3)*abs(y(i-1));
%OutPut：BetaHat为3*1列向量

% *****************************************************************************************
% Set parameters for optimisation.
% *****************************************************************************************
REP			  = 30;          % Number of times the optimization algorithm is repeated.
nInitialVectors = [10000, 3]; % Number of initial vector fed in the uniform random number generator.
nInitialCond = 5;            % Select the number of initial conditions for the optimisation.
MaxFunEvals = 500;           % Parameters for the optimisation algorithm. 
MaxIter     = 500;           % Increase them in case the algorithm does not converge.

options = optimset('LargeScale', 'off', 'HessUpdate', 'dfp', 'MaxFunEvals', ...
                    MaxFunEvals, 'display', 'off', 'MaxIter', MaxIter, 'TolFun', 1e-10, 'TolX', 1e-10);
                %'LineSearchType', 'quadcubic',
warning('off', 'verbose')
%   
%**************************** Optimization Routine ******************************************  
%
% Compute the empirical THETA-quantile for y.
WIN=300;
ysort = sortrows(y(1:WIN), 1); 
empiricalQuantile = ysort(round(WIN*THETA));


initialTargetVectors = unifrnd(0, 1, nInitialVectors);
RQfval = zeros(nInitialVectors(1), 1);
for i = 1:nInitialVectors(1)
    RQfval(i) = RQobjectiveFunction2(initialTargetVectors(i,:), 1, y, THETA, empiricalQuantile);
end
Results          = [RQfval, initialTargetVectors];
SortedResults    = sortrows(Results,1);%根据第一列数字大小，将每行排序

BestInitialCond  = SortedResults(1:nInitialCond,2:4);    
Beta = zeros(size(BestInitialCond)); fval = Beta(:,1); exitflag = Beta(:,1);

for i = 1:size(BestInitialCond,1)
    [Beta(i,:), fval(i,1), exitflag(i,1)] = fminsearch('RQobjectiveFunction2', BestInitialCond(i,:), ...
        options, 1, y, THETA, empiricalQuantile);
    for it = 1:REP
        if exitflag(i,1) == 1, break, end % exitflag=1 means the function have converged to a solution
        [Beta(i,:), fval(i,1), exitflag(i,1)] = fminsearch('RQobjectiveFunction2', Beta(i,:), ...
            options, 1, y, THETA, empiricalQuantile);
        if exitflag(i,1) == 1, break, end
    end
end
SortedFval  = sortrows([fval, Beta, exitflag, BestInitialCond], 1);
    
BetaHat   = SortedFval(1, 2:4)';
RQvalue   = fval;
output = RQobjectiveFunction2(BetaHat, 2, y, THETA, empiricalQuantile);
quantile=output(:,1);
if SortedFval(1,5)~=1, disp('Warning: CAViaR convergence not achieved.'), end
%**************************** End of Optimization Routine ******************************************
   