function [IR, IRplusSE, IRminusSE, se] = imref(y, Beta,RSK, IMP, THETA, seIND)
%
%--------------------------------------------------------------------------
% Compute impulse-response functions, based on a Cholesky decomposition
% where the first variable is the market shock and the second variable is
% the individual bank shock.
% IMP = 1 --> shock to the market
% IMP = 2 --> shock to the bank
%
% seIND = 1 --> compute error bands for IRF
%--------------------------------------------------------------------------
%
% 1. Compute the Cholesky decomposition
omega = cov(y);
L = chol(omega, 'lower');
%
% 2. Compute the long run quantiles.
A = reshape(Beta, 2, 7); 
a = A(:,2:3); 
b = A(:,4:5); 
[m,n]=size(y);
St=ones(m,2);
%
% 3. Define the shocks.
SHOCK = zeros(2,1);
if IMP == 1
    SHOCK(1,1) = 2; 
elseif IMP == 2
    SHOCK(2,1) = 2; 
end
%
% 4. Compute the impulse-response functions.
IR = zeros(300,2);
IR(1,:) = a*abs(L*SHOCK);
for s=2:300, IR(s,:) = (b*IR(s-1,:)')'; end
%
% 5. Plot the impluse-response function (set the if equal to 1).
if 1
    figure, plot(IR), legend('Index quantile', 'Assets quantile') 
end
%
% 6. Compute standard errors for impulse responses
if seIND
    WIN = 100;
    for i=1:2, ysort(:,i) = sortrows(y((1:WIN),i)); end
    for i=1:2, empiricalQuantile(1,i) = ysort(round(WIN*THETA),i); end

    q = intramqRQobjectiveFunction_level(Beta, y, THETA, empiricalQuantile,2, St,RSK);
    [se, ~, ~, VC] = intrastandardErrors_level(y, THETA, Beta, q,St,RSK);

    dVecA = [zeros(4,2),eye(4),zeros(4),zeros(4)];
    dVecB = [zeros(4,2), zeros(4), eye(4),zeros(4)];
    seIRF = zeros(300,2);
    G1 = kron(abs(L*SHOCK)', eye(2)) * dVecA;
    seIRF(1,:) = diag(sqrt(G1 * VC * G1'));
    G2 = b*G1 + kron((a*abs(L*SHOCK))',eye(2))*dVecB;
    seIRF(2,:) = diag(sqrt(G2 * VC * G2'));
    for s = 3:300
        sumB = zeros(4);
        for i = 0:s-2
            sumB = sumB + kron((b')^(s-2-i),b^i);
        end
        dVecBs = sumB * dVecB;
        G = b^(s-1)*G1 + kron((a*abs(L*SHOCK))',eye(2))*dVecBs;
        seIRF(s,:) = diag(sqrt(G * VC * G')); 
    end
    IRplusSE  = IR + 2*seIRF;
    IRminusSE = IR - 2*seIRF;
end