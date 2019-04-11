function [St,each_quantile]=intrayQuantile(data,THETA,frequency)
%本函数用于计算quantile的日内效应
%data为总数据，frequency为子区间的抽样频率，也为data的频率
n=240/frequency;%子区间个数
days=length(data)/n;%数据总天数
each_data=zeros(days,n);
for i=1:n
    each_data(:,i)=data(i:n:end);
end
quantile=zeros(days,n);
for i=1:n
    [~,~,quantile(:,i)] = CAViaR_estim1(each_data(:,i), THETA);
end
each_quantile=mean(quantile);
each_quantile=each_quantile(:);
St=each_quantile/mean(each_quantile);
if ~all(St>0)
    error('出现错误日内分位数调整取值！')
end
end