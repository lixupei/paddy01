function output = intraRQobjectiveFunction1(BETA, OUT, y, THETA, empiricalQuantile,St)
% ���ں���quantile(t) = BETA(1) + BETA(2) * abs(y(t-1)) + BETA(3) *
% quantile(t-1)��Ŀ�꺯��
%StΪ��λ������ЧӦ����

%--------------------------------------------------------------------------
% RQobjectiveFunction computes the quantile and the RQ criterion for given 
% vector of parameters BETA.
% If OUT=1, the output is the regression quantile objective function.
% If OUT=2, the output is [Q, Hit].
%--------------------------------------------------------------------------
%
% Compute the quantile

q = intraSAVloop1(BETA, y, empiricalQuantile);
Q=q(:).*St(:);
Hit = (y < Q) - THETA;
%
%**********************************************
% Compute the Regression Quantile criterion.
RQ  = -Hit'*(y - Q);
%
%**********************************************
% Select the output of the program.
if OUT == 1
    output = RQ;
elseif OUT ==2
    output = [Q, Hit];
else error('Wrong output selected. Choose OUT = 1 for RQ, or OUT = 2 for [q, Hit].')
end