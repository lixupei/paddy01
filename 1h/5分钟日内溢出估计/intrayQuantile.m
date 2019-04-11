function [St,each_quantile]=intrayQuantile(data,THETA,frequency)
%���������ڼ���quantile������ЧӦ
%dataΪ�����ݣ�frequencyΪ������ĳ���Ƶ�ʣ�ҲΪdata��Ƶ��
n=240/frequency;%���������
days=length(data)/n;%����������
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
    error('���ִ������ڷ�λ������ȡֵ��')
end
end