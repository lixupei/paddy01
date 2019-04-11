function [se,VC] = intrastandardErrors_spillover(y, THETA, Beta, q, St, RSK) 
%[se, TS, pValueTS, VC] = intrastandardErrors_spillover(y, THETA, Beta, q,St,RSK)
%--------------------------------------------------------------------------
% Compute standard errors for the MQ CAViaR model.
% se = standard errors associated to Beta
% TS = Test statistic for the null hypothesis that all off-diagonal
%               coefficients are equal to zero.
% pValueTS = p-value of TS.
%--------------------------------------------------------------------------
%
[T,N] = size(y);
% A = reshape(Beta, N, 1+3*N);
a=[Beta(1);Beta(2)];
b=reshape(Beta(3:6),2,2);
c=reshape(Beta(7:10),2,2);
d=reshape(Beta(11:14),2,2)';
e=reshape(Beta(15:18),2,2)';
f=reshape(Beta(19:22),2,2);

%
% 1. Compute gradient of MQ CAViaR (refer to mqRQobjectiveFunction.m file).
% dA1 = [eye(N), zeros(N,3*N^2)];
% dA2 = [zeros(N^2,N), eye(N^2), zeros(N^2,2*N^2)];
% dA3 = [zeros(N^2,N),zeros(N^2), eye(N^2),zeros(N^2)];
% dA4 = [zeros(N^2,N+N^2), zeros(N^2), eye(N^2)];
dA1=[eye(2),zeros(2,20)];
dA2=[zeros(4,2),eye(4),zeros(4,16)];
dA3=[zeros(4,6),eye(4),zeros(4,12)];
dA4=[zeros(8,10),eye(8),zeros(8,4)];
dA5=[zeros(4,18),eye(4)];

dq = zeros(2, 22, T);
for t = 2:T
%     dq(:,:,t) = dA1 + kron(abs(y(t-1,:)), eye(N))*dA2 + A(:,4:5)*dq(:,:,t-1) + kron(q(t-1,:),eye(N))*dA3 +kron(-(RSK(t-1,:)), eye(N))*dA4;
    dq(:,:,t) = dA1 + kron(abs(y(t-1,:)), eye(N))*dA2 + c*dq(:,:,t-1) + kron(q(t-1,:),eye(N))*dA3+kron(q(t-1,:),blkdiag((-RSK(t-1,:)),(-RSK(t-1,:))))*dA4 +kron(-(RSK(t-1,:)), eye(N))*dA5;
end

dQ=zeros(2, 22, T);
for i=1:N
    for j=1:22
        for t=1:T
            dQ(i,j,t)=dq(i,j,t)*St(t,i);
        end
    end
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

Q = zeros(22); V=Q;
for t = 1:T
    psi = THETA - (eps(t,:)'<0);
    eta = reshape(dq(:,:,t),2,22).*(psi*ones(1,22));
    eta = sum(eta);
    V = V + eta'*eta;
    
    Qt = zeros(22);
    for j = 1: N
        Qt = Qt + (abs(eps(t,j))<c) * (reshape(dq(j,:,t),22,1) * reshape(dq(j,:,t),1,22));
    end
    Q = Q + Qt;
end
V = V/T; 
Q = Q/(2*c*T);
VC = (Q\V/Q)/T;
se = sqrt(diag(VC));
%
% % 3. Test for off-diagonal coefficients.
% R = [0 0 0 1 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 0 1 0 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 1 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 1 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 1 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 1 0];
%  TS = (R*Beta)' * inv(R*VC*R') * (R*Beta);
%  pValueTS = 1-chi2cdf(TS,6);