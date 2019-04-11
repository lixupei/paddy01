function [se, TS, pValueTS, VC,dq] = standardErrors(y, THETA, Beta, q)
%
%--------------------------------------------------------------------------
% Compute standard errors for the MQ CAViaR model.
% se = standard errors associated to Beta
% TS = Test statistic for the null hypothesis that all off-diagonal
%               coefficients are equal to zero.
% pValueTS = p-value of TS.
%--------------------------------------------------------------------------
%
[T,N] = size(y);
A = reshape(Beta, N, 1+2*N);
%
% 1. Compute gradient of MQ CAViaR (refer to mqRQobjectiveFunction.m file).
dA1 = [eye(N), zeros(N,2*N^2)];
dA2 = [zeros(N^2,N), eye(N^2), zeros(N^2)];
dA3 = [zeros(N^2,N), zeros(N^2), eye(N^2)];

dq = zeros(N, N+2*N^2, T);
for t = 2:T
    dq(:,:,t) = dA1 + kron(abs(y(t-1,:)), eye(N))*dA2 + A(:,4:5)*dq(:,:,t-1) + kron(q(t-1,:),eye(N))*dA3;
end
%
% 2. Compute V and Q.
eps = y-q;
%Bandwidth (old value ==1)
% Bandwidth of Koenker (2005) - see http://privatewww.essex.ac.uk/~jmcss/JM_JSS.pdf
kk = median(abs(eps(:,1)-median(eps(:,1))));
hh = T^(-1/3)*(norminv(1-0.05/2))^(2/3)*((1.5*(normpdf(norminv(THETA)))^2)/(2*(norminv(THETA))^2+1))^(1/3);
c = kk*(norminv(THETA+hh)-norminv(THETA-hh));%c=1;
% disp(c); disp(sum(eps(:,1)<c));

Q = zeros(N+2*N^2); V=Q;
for t = 1:T
    psi = THETA - (eps(t,:)'<0);
    eta = reshape(dq(:,:,t),N,N+2*N^2).*(psi*ones(1,N+2*N^2));
    eta = sum(eta);
    V = V + eta'*eta;
    
    Qt = zeros(N+2*N^2);
    for j = 1: N
        Qt = Qt + (abs(eps(t,j))<c) * (reshape(dq(j,:,t),N+2*N^2,1) * reshape(dq(j,:,t),1,N+2*N^2));
    end
    Q = Q + Qt;
end
V = V/T; 
Q = Q/(2*c*T);
VC = (Q\V/Q)/T;
se = sqrt(diag(VC));
%
% 3. Test for off-diagonal coefficients.
R = [0 0 0 1 0 0 0 0 0 0;
     0 0 0 0 1 0 0 0 0 0;
     0 0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 0 1 0];
 TS = (R*Beta)' * inv(R*VC*R') * (R*Beta);
 pValueTS = 1-chi2cdf(TS,4);