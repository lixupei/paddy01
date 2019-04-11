function q = SAVloop2(BETA, y, empiricalQuantile)
%�˴����ɷ�λ�������У�ע�ⲻ��VaR������
% Compute the quantile time series for the Symmetric Absolute Value model,
% given the vector of returns y and the vector of parameters BETA.
%
T = length(y);
q = zeros(T,1); q(1) = empiricalQuantile;
for t = 2:T
    %q(t) = BETA(1) + BETA(2) * max(y(t-1),0) + BETA(3) * max(-y(t-1),0) +BETA(4) * q(t-1);
    q(t) = BETA(1) + BETA(2) * abs(y(t-1)) + BETA(3) * q(t-1);
end

%ע�⣬�˴�ֱ�ӶԷ�λ���ع飬�����Ƕ�VaR���лع�
%��2004��CAViaR�����У�����ֱ�Ӷ�VaR��ģ����˻��趨VaR(0)=-empiricalQuantile