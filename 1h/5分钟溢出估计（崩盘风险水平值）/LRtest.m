function [qmean,qstd,total,hitnum,ratio,LR,pvalue]= LRtest(y,quantile,theta)
%LRºÏ—È
qmean=mean(quantile);
qstd=std(quantile);
%if theta<0.5 
    hit=double(y<quantile);
%else 
%    hit=double(y>quantile);
%end
N=length(y);
n=sum(hit);
%LR=-2*log((1-theta)^(N-n)*theta^n)+2*log((1-n/N)^(N-n)*(n/N)^n);
a=(1-n/N)/(1-theta);
b=(n/N)/theta;
LR=2*log((a^(N-n))*(b^n));

total=N;
hitnum=sum(hit);
ratio=hitnum/total;
pvalue=1-chi2cdf(LR,1);

