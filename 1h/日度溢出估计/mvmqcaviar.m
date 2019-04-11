function [q, Beta, fval, exitflag] = mvmqcaviar(y,THETA)
%--------------------------------------------------------------------------
%INPUT:
% y       = matrix (T,N) where N=2
%            First column is the index
%            Second column is the series of equity prices of the ith bank
% THETA   = quantile probability
%
%OUTPUT: 
% q = Time series of estimated quantiles
% Beta = Parameter estimate
% 
%--------------------------------------------------------------------------
[~,N]=size(y);   
options = optimset('LargeScale', 'on', 'HessUpdate', 'dfp','Display','iter', 'MaxFunEvals', 100000, 'MaxIter',100000, 'TolFun', 1e-10, 'TolX', 1e-10);
REP =50; warning('off')
%_____________________________________
% 1. Compute the empirical quantile using the first WIN observations.
WIN = 200;
for i=1:N, ysort(:,i) = sortrows(y((1:WIN),i)); end
for i=1:N, empiricalQuantile(1,i) = ysort(round(WIN*THETA),i); end
%_____________________________________
% 2. Estimate the initial values of the parameters using univariate CAViaR.
for i = 1:N, c(:,i) = CAViaR_estim(y(:,i), THETA); end
w = c(1,:)'; a = diag(c(2,:)); b = diag(c(3,:));

% ACTIVATE THE FOLLOWING LINES TO GENERATE MORE INITIAL CONDITIONS.
% nInitialCond = 30; % Defines how many initial values are considered in the optimization routine.
% Beta00 = [w; a(:); b(:)];
% rng('default')
% rng(10)% set seed
% Beta01 = [w; a(:); b(:)]*ones(1,nInitialCond) + randn(10,nInitialCond)/50; % Vector of initial values
% rng('default')
% rng(20)% set seed
% Beta02 = [w; a(:); b(:)]*ones(1,nInitialCond) + randn(10,nInitialCond)/20; % Vector of initial values
% rng('default')
% rng(30)% set seed
% Beta03 = [w; a(:); b(:)]*ones(1,nInitialCond) + randn(10,nInitialCond)/30; % Vector of initial values
% rng('default')
% rng(40)% set seed
% Beta04 = [w; a(:); b(:)]*ones(1,nInitialCond) + randn(10,nInitialCond)/40; % Vector of initial values
% Beta0 = [Beta00, Beta01, Beta02,Beta03,Beta04];   % Vector of initial values
% Beta0=Beta00;

% ACTIVATE THE FOLLOWING LINES TO GENERATE MORE INITIAL CONDITIONS.
% nInitialCond = 10; % Defines how many initial values are considered in the optimization routine.
% Beta00 = [w; a(:); b(:)];
% Beta01 = [w; a(:); b(:)]*ones(1,nInitialCond) + randn(10,nInitialCond)/10; % Vector of initial values
% Beta02 = [w; a(:); b(:)]*ones(1,nInitialCond) + randn(10,nInitialCond)/20; % Vector of initial values
%Beta0 = [Beta00, Beta01, Beta02];   % Vector of initial values
Beta0 = [w; a(:); b(:)];   % Vector of initial values
% Beta0=[Beta00,Beta01,Beta02];
%_____________________________________
% 3. Estimate joint multivariate CAViaR.
for i =1:size(Beta0,2)
    [Beta(:,i),fval(1,i),exitflag(1,i)] = fminsearch('mqRQobjectiveFunction', Beta0(:,i), options, y, THETA, empiricalQuantile, 1); % it does not work with OUT=2 
    for ii = 1:REP
        [Beta(:,i),fval(1,i),exitflag(1,i)] = fminsearch('mqRQobjectiveFunction', Beta(:,i), options, y, THETA, empiricalQuantile, 1); 
        if exitflag(1,i) == 1, break, end
    end
end
I = find(fval == min(fval));
Beta = Beta(:,I); exitflag = exitflag(1,I); fval = fval(:,I);
if exitflag~=1, disp('Warning: Multivariate CAViaR convergence not achieved!'), end
%_____________________________________
% 4. Compute joint quantiles series.
q = mqRQobjectiveFunction(Beta, y, THETA, empiricalQuantile, 2);