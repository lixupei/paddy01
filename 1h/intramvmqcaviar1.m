function [Q, Beta, fval, exitflag] = intramvmqcaviar1(y,THETA,St)
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
% Beta = Parameter estimate N*(2N+1)的列向量
%
%该函数只适用于多变量、同分位数的模型、没有拓展考虑多分位数的联合建模
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
c=zeros(3,2);
for i=1:2, ysort(:,i) = sortrows(y((1:WIN),i)); end
for i=1:2, empiricalQuantile(1,i) = ysort(round(WIN*THETA),i); end
%_____________________________________
% 2. Estimate the initial values of the parameters using univariate CAViaR.
for i = 1:2, c(:,i) = intraCAViaR_estim1(y(:,i), THETA, St(:,i)); end
w = c(1,:)'; a = diag(c(2,:)); b = diag(c(3,:));
%部分参数的初始估计值
%注意参数的排列顺序受mqRQobjectiveFunction中参数的输入形式有关
%生成的参数为列向量，排序方式[a0,b0,a1,b1,a2,b2,...]，对比参数的排列顺序，观察初始值的设定方式
%即如文中所说，单变量CAViaR估计的参数为初始参数，未估计参数值取0


% ACTIVATE THE FOLLOWING LINES TO GENERATE MORE INITIAL CONDITIONS.
nInitialCond = 50000; % Defines how many initial values are considered in the optimization routine.
Beta00 = [w; a(:); b(:)];
empty_location=[4,5,8,9];

rng('default')
rng(10)% set seed
shock1=zeros(10,nInitialCond);
off1=(rand(4,nInitialCond)-0.5)/2.5;%生成区间[-0.2,0.2]内的均匀分布随机数

for k=1:length(empty_location)
    shock1(empty_location(k),:)=off1(k,:);
end
Beta01 = [w; a(:); b(:)]*ones(1,nInitialCond) + shock1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng('default')
rng(20)% set seed
shock2=zeros(10,nInitialCond);
off2=randn(4,nInitialCond)/20;

for k=1:length(empty_location)
    shock2(empty_location(k),:)=off2(k,:);
end
Beta02 = [w; a(:); b(:)]*ones(1,nInitialCond) + shock2;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
Beta_all = [Beta00, Beta01, Beta02];% Vector of initial values
% 
% 
each_fval=zeros(length(Beta_all),1);
parfor i=1:length(Beta_all)
    each_fval(i)=intramqRQobjectiveFunction1(Beta_all(:,i), y, THETA, empiricalQuantile,1, St);
end
% 
initialnum=5;
sort_fval=sortrows(each_fval,1);
critical_val=sort_fval(initialnum);%Select the best original values 
initial_location= find(each_fval<=critical_val);
Beta0=Beta_all(:,initial_location);
% 
% %_____________________________________
% % 3. Estimate joint multivariate CAViaR.
% Beta0=Beta00;
Beta=zeros(10,size(Beta0,2));
fval=zeros(1,size(Beta0,2));
exittflag=fval;
% Beta0=Beta_all;
parfor i =1:size(Beta0,2)  
    [Beta(:,i),fval(1,i),exitflag(1,i)] = fminsearch('intramqRQobjectiveFunction1', Beta0(:,i), options, y, THETA, empiricalQuantile, 1,St); % it does not work with OUT=2 
    for ii = 1:REP
        [Beta(:,i),fval(1,i),exitflag(1,i)] = fminsearch('intramqRQobjectiveFunction1', Beta(:,i), options, y, THETA, empiricalQuantile, 1,St); 
        if exitflag(1,i) == 1, break, end
    end
end
I = find(fval == min(fval));
Beta = Beta(:,I); exitflag = exitflag(1,I); fval = fval(:,I);
if exitflag~=1, disp('Warning: Multivariate CAViaR convergence not achieved!'), end
%_____________________________________
% 4. Compute joint quantiles series.
Q = intramqRQobjectiveFunction1(Beta, y, THETA, empiricalQuantile, 2, St);
