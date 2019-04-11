function [output] = intramqRQobjectiveFunction_spillover(Beta0, y, THETA, empiricalQuantile, OUT,St,RSK)
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
% A = reshape(Beta0, N, 1+3*N); % A = reshape(Beta0, N, 2+N);
% c=A(:,1)'; a=A(:,N:N+1)'; b=A(:,2*N:1+2*N)'; d=A(:,3*N:1+3*N)';
a=[Beta0(1);Beta0(2)];
b=reshape(Beta0(3:6),2,2);
c=reshape(Beta0(7:10),2,2);
d=reshape(Beta0(11:14),2,2)';
e=reshape(Beta0(15:18),2,2)';
f=reshape(Beta0(19:22),2,2);

%
% 3. Compute quantiles.
for t = 2:T
%     q(t,:) = c + abs(y(t-1,:))*a + q(t-1,:)*b +(-RSK(t-1,:))*d;
      q(t,:)=a+b*abs(y(t-1,:)')+c*q(t-1,:)'+[d,e]*blkdiag((-RSK(t-1,:)'),(-RSK(t-1,:)'))*q(t-1,:)'+f*(-RSK(t-1,:)');
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
