function [Q, Beta, fval, exitflag] = intramvmqcaviar_spillover(y,THETA,St,RSK)
%Comparing to function intramvmqcaviar1, the initial vectors are different.
%--------------------------------------------------------------------------
%INPUT:
% y       = matrix (T,N) where N=2
%            First column is the index
%            Second column is the series of equity prices of the ith bank
% THETA   = quantile probability
%
%OUTPUT: 
% q = Time series of estimated quantiles
% Beta = Parameter estimate N*(2N+1)��������
%
%�ú���ֻ�����ڶ������ͬ��λ����ģ�͡�û����չ���Ƕ��λ�������Ͻ�ģ
%--------------------------------------------------------------------------
if size(y,2)~=2
    error('Data should only contain 2 conlums!');
end


options = optimset('Display','iter', 'MaxFunEvals', 50000, 'MaxIter',50000,'TolFun', 1e-10, 'TolX', 1e-10);
REP = 50; warning('off')
%_____________________________________
% 1. Compute the empirical quantile using the first WIN observations.
WIN = 300;

ysort=zeros(300,2);
empiricalQuantile=zeros(1,2);
c=zeros(4,2);
for i=1:2, ysort(:,i) = sortrows(y((1:WIN),i)); end
for i=1:2, empiricalQuantile(1,i) = ysort(round(WIN*THETA),i); end
%_____________________________________
% 2. Estimate the initial values of the parameters using univariate CAViaR.
for i = 1:2, Beta_initial(:,i) = intraCAViaR_estim_level(y(:,i), THETA, St(:,i),RSK(:,i)); end
a = Beta_initial(1,:)'; b = diag(Beta_initial(2,:)); c = diag(Beta_initial(3,:)); f=diag(Beta_initial(4,:));
%���ֲ����ĳ�ʼ����ֵ
%ע�����������˳����mqRQobjectiveFunction�в�����������ʽ�й�
%���ɵĲ���Ϊ������������ʽ[a0,b0,a1,b1,a2,b2,...]���ԱȲ���������˳�򣬹۲��ʼֵ���趨��ʽ
%����������˵��������CAViaR���ƵĲ���Ϊ��ʼ������δ���Ʋ���ֵȡ0


ACTIVATE THE FOLLOWING LINES TO GENERATE MORE INITIAL CONDITIONS.
nInitialCond = 1000; % Defines how many initial values are considered in the optimization routine.
Beta00 = [a; b(:); c(:);zeros(8,1);f(:)];
empty_location=[4,5,8,9,11,12,13,14,15,16,17,18,20,21];

rng('default')
rng(10)% set seed
shock1=zeros(22,nInitialCond);
off1=(rand(14,nInitialCond)-0.5)/2.5;%��������[-0.2,0.2]�ڵľ��ȷֲ������

for k=1:length(empty_location)
    shock1(empty_location(k),:)=off1(k,:);
end
Beta01 = Beta00*ones(1,nInitialCond) + shock1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng('default')
rng(20)% set seed
shock2=zeros(22,nInitialCond);
off2=randn(14,nInitialCond)/100;

for k=1:length(empty_location)
    shock2(empty_location(k),:)=off2(k,:);
end
Beta02 = Beta00*ones(1,nInitialCond) + shock2;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
Beta_all = [Beta00, Beta01, Beta02];% Vector of initial values
% 
% 
each_fval=zeros(length(Beta_all),1);
parfor i=1:length(Beta_all)
    each_fval(i)=intramqRQobjectiveFunction_level(Beta_all(:,i), y, THETA, empiricalQuantile,1, St,RSK);
end
% 
initialnum=10;
sort_fval=sortrows(each_fval,1);
critical_val=sort_fval(initialnum);%Select the best original values 
initial_location= find(each_fval<=critical_val);
Beta0=Beta_all(:,initial_location);
% Beta0=Beta00;
% 
% %_____________________________________
% % 3. Estimate joint multivariate CAViaR.
% Beta0=Beta00;
Beta=zeros(22,size(Beta0,2));
fval=zeros(1,size(Beta0,2));
exittflag=fval;
% Beta0=Beta_all;
parfor i =1:size(Beta0,2)  
    [Beta(:,i),fval(1,i),exitflag(1,i)] = fminsearch('intramqRQobjectiveFunction_spillover', Beta0(:,i), options, y, THETA, empiricalQuantile, 1,St,RSK); % it does not work with OUT=2 
    for ii = 1:REP
        [Beta(:,i),fval(1,i),exitflag(1,i)] = fminsearch('intramqRQobjectiveFunction_spillover', Beta(:,i), options, y, THETA, empiricalQuantile, 1,St,RSK); 
        if exitflag(1,i) == 1, break, end
    end
end
I = find(fval == min(fval));
Beta = Beta(:,I); exitflag = exitflag(1,I); fval = fval(:,I);
if exitflag~=1, disp('Warning: Multivariate CAViaR convergence not achieved!'), end
%_____________________________________
% 4. Compute joint quantiles series.
Q = intramqRQobjectiveFunction_spillover(Beta, y, THETA, empiricalQuantile, 2, St,RSK);
