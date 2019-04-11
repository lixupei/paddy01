function [NSK]=high_frequency_realized_moment(y,window)
%y:���ڸ�Ƶ���������ʣ�������
% [m,n]=size(y);
% RV=sum(y.^2);
% RSK=sqrt(m)*sum(y.^3)./(RV.^(3/2));
% RSK=sum(y.^3)./(RV.^(3/2));
% RV=RV';
% RSK=RSK';
% n=length(y);
% for i=480:5:n
%     RSK((i-475)/5,1)=(sqrt(48)*sum(y(i-48:i-1).^3))/((sum(y(i-48:i-1).^2))^(3/2));
% end

n=length(y);
RSK=zeros(n,1);
RSK(1)=0;
RSK(2)=0;  %ǰ����ʱ�̵�ƫ�ȳ�ʼ��Ϊ0�����������ݺ��ڲ��ᱻ�õ�
for i=3:window
    NSK(i)=-skewness(y(1:i-1));
end
for i=window+1:n
    NSK(i)=-skewness(y(i-window:i-1));
end

frequency=5;
NSK_reshape=reshape(NSK,frequency,n/frequency);
NSK=NSK_reshape(frequency,:);
NSK=NSK(:);
id=find(isnan(NSK));
NSK(id)=0;
