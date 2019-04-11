function [output] = intramqRQobjectiveFunction_level(Beta0, y, THETA, empiricalQuantile, OUT,St,RSK)
%--------------------------------------------------------------------------
% mqRQobjectiveFunction computes the multivariate quantiles and the associated
% RQ criterion, for given vector of parameters BETA.
% If OUT=1, the output is the regression quantile objective function.
% If OUT=2, the output is the quantiles time series.
%--------------------------------------------------------------------------
%
[T,N]=size(y);
%
% 1. Predefine the matrix of quantiles and initialise them at the empirical quantile.
q = zeros(T,N); q(1,:) = empiricalQuantile;
%
% 2. Tranform the vector Beta0 into a matrix for simplicity.
A = reshape(Beta0, N, 1+3*N); % A = reshape(Beta0, N, 2+N);
c=A(:,1)'; a=A(:,N:N+1)'; b=A(:,2*N:1+2*N)'; d=A(:,3*N:1+3*N)';
%
% 3. Compute quantiles.
for t = 2:T
    q(t,:) = c + abs(y(t-1,:))*a + q(t-1,:)*b +(-RSK(t-1,:))*d;
end
Q=q.*St;
%
% 4. Compute the Regression Quantile criterion.
S = (y - Q).*(THETA*ones(T,N) - (y<Q));
S = sum(S,2); S = mean(S); % First sum the cross section and then take the average over time.
%
% 5. Prepare output.
if OUT == 1, output = S;
elseif OUT ==2, output = Q;
end
