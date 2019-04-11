function [BetaHat,RQvalue,Hit,quantile] = intraCAViaR_estim1(y, THETA,St)
%只估计SAV模型，quantile(t) = BETA(1) + BETA(2) * abs(y(t-1)) + BETA(3) * quantile(t-1)+ BETA(4) * double(y(t-1)<=quantile(t-1));
%比较SAVloop1函数（CAViaR，2004），VaR(i)=BETA(1)+BETA(2)*VaR(i-1)+BETA(3)*abs(y(i-1));
%OutPut：BetaHat为4*1列向量
%本函数考虑分位数的日内周期效应，y的频率应和frequency一致！

% *****************************************************************************************
% Set parameters for optimisation.
% *****************************************************************************************
REP			  = 50;          % Number of times the optimization algorithm is repeated.
nInitialVectors = [100000, 3]; % Number of initial vector fed in the uniform random number generator.
nInitialCond = 20;            % Select the number of initial conditions for the optimisation.
MaxFunEvals = 5000;           % Parameters for the optimisation algorithm. 
MaxIter     = 5000;           % Increase them in case the algorithm does not converge.

options = optimset('LargeScale', 'off', 'HessUpdate', 'dfp', 'MaxFunEvals', ...
                    MaxFunEvals, 'display', 'off', 'MaxIter', MaxIter, 'TolFun', 1e-10, 'TolX', 1e-10);
                %'LineSearchType', 'quadcubic',
warning('off', 'verbose')
%   
%**************************** Optimization Routine ******************************************  
%
% Compute the empirical THETA-quantile for y.
ysort = sortrows(y(1:300), 1); 
empiricalQuantile = ysort(round(300*THETA));

rng('default')
rng(50)
initialTargetVectors = unifrnd(0,1, nInitialVectors);
RQfval = zeros(nInitialVectors(1), 1);
parfor i = 1:nInitialVectors(1)
    RQfval(i) = intraRQobjectiveFunction1(initialTargetVectors(i,:), 1, y, THETA, empiricalQuantile, St);
end
Results          = [RQfval, initialTargetVectors];
SortedResults    = sortrows(Results,1);%根据第一列数字大小，将每行排序

BestInitialCond  = SortedResults(1:nInitialCond,2:4);    
Beta = zeros(size(BestInitialCond)); fval = Beta(:,1); exitflag = Beta(:,1);

parfor i = 1:size(BestInitialCond,1)
    [Beta(i,:), fval(i,1), exitflag(i,1)] = fminsearch('intraRQobjectiveFunction1', BestInitialCond(i,:), ...
        options, 1, y, THETA, empiricalQuantile, St);
    for it = 1:REP
        % exitflag=1 means the function have converged to a solution
        [Beta(i,:), fval(i,1), exitflag(i,1)] = fminsearch('intraRQobjectiveFunction1', Beta(i,:), ...
            options, 1, y, THETA, empiricalQuantile, St);
        if exitflag(i,1) == 1, break, end
    end
end
SortedFval  = sortrows([fval, Beta, exitflag, BestInitialCond], 1);
    
BetaHat   = SortedFval(1, 2:4)';
RQvalue   = SortedFval(1,1);
output = intraRQobjectiveFunction1(BetaHat,2, y, THETA, empiricalQuantile, St);
Hit_series=output(:,2)+THETA;
quantile=output(:,1);
Hit=sum(Hit_series)/length(Hit_series);
if SortedFval(1,5)~=1, disp('Warning: CAViaR convergence not achieved.'), end
%**************************** End of Optimization Routine ******************************************
   