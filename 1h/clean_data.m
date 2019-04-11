function Wdata=clean_data(filename)
%������������D:\matlab2016b\bin\used_data\Expected_Shortfall ·����.csvָ����ָ���ڻ����ļ�
%ע�⣺�����ļ��У�����ʱ�ĳɽ�����3:00��3:15�������Ϊ0��NaN����Ӧ�ñ��������ɵ�������ָ��
%ʱ���뿼���Ƿ���Ҫ�������ʱ���������ݣ�

%Input:�����ļ���
%Output:Wdata���������ݾ��󣬰���ʱ�䡢�۸񡢳ɽ���
%Attention�� Don't use textscan to read .xlsx files, because
% it would produce unreadable codes.
% So, I convert .xlsx file into .csv file, and use textscan to load data
filenum1=fopen(filename);
kk1=textscan(filenum1,repmat('%s ',[1,9]),'Delimiter',',','HeaderLines',1);
fclose(filenum1);

date1=kk1{1};%cell���� ��������
open1=kk1{2};%cell���� ���̼�
close1=kk1{3};%cell���� ���̼�
volume1=kk1{6};%cell���� �ɽ���
amt1=kk1{7};%cell���� �ɽ���

wrong_location=zeros(size(date1,1),1);


for i=1:size(date1,1)
    try
        datenumber=datenum(date1{i});
    catch
        disp([filename,'�е�',num2str(i),'�а����������ַ���']);%��Ҫ����ʶ���ַ���'fetching'�Ϳ��ַ���
        wrong_location(i)=1;
    end
end
%datenum��������Ϊ���ַ�������datenum2�����벻��Ϊ���ַ���
clear_location=find(wrong_location==1);%�����������ַ�������������Ҫɾ��

date1(clear_location)=[];
open1(clear_location)=[];
close1(clear_location)=[];
volume1(clear_location)=[];
amt1(clear_location)=[];%�õ�����Ƿ������кͿ��к�����ݣ�cell����

%���open��close�п�ֵ
clean_loc1=cellfun(@(x) all(isempty(x)),open1);%�ж�ÿ��cell�Ƿ�Ϊ��
clean_loc2=cellfun(@(x) all(isempty(x)),close1);
clean_loc3=max(clean_loc1,clean_loc2);
date1(clean_loc3)=[];
open1(clean_loc3)=[];
close1(clean_loc3)=[];
volume1(clean_loc3)=[];
amt1(clean_loc3)=[];%ɾ���۸�Ϊ�յ���

%���open��close�е�NaN�ַ���
%open1ΪN*1cell��ÿ��cell�������Ȳ��ȵ��ַ���
%�����޷���open1ֱ��ʹ�ú���cell2mat,�ʲ���ѭ���ķ�ʽ
open2=zeros(size(open1,1),1);
for i=1:size(open1,1)
    open2(i)=str2num(open1{i,:});
end
clean_loc4=isnan(open2);
close2=zeros(size(close1,1),1);
for i=1:size(close1,1)
    close2(i)=str2num(close1{i,:});
end
clean_loc5=isnan(close2);
clean_loc6=max(clean_loc4,clean_loc5);%close��open�а���NaN������
date1(clean_loc6)=[];
open1(clean_loc6)=[];
close1(clean_loc6)=[];
volume1(clean_loc6)=[];
amt1(clean_loc6)=[];%ɾ������NaN����
%�õ����������ֵ��NaN�к�ĸ�����
%open1 close1 volume1 amt1��ÿ��cell��Ϊstr������double
%��ˣ���cell2mat�ᱨ���ַ������Ȳ�һ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�õ�double��������
date2=datenum(date1);
open2=cellfun(@(x) str2num(x),open1);
close2=cellfun(@(x) str2num(x),close1);
volume2=cellfun(@(x) str2num(x),volume1);
amt2=cellfun(@(x) str2num(x),amt1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���� close��open=0 �е�����
location_open=find(open2==0);
location_close=find(close2==0);
if location_open~=location_close
    error('���ڿ��̼�Ϊ0�����̼۲�Ϊ0�������̼�Ϊ0�����̼۲�Ϊ0��������')
end

if ~isempty(location_open)
    open2(location_open)=open2(location_open-1);%����ȡ0�ļ۸�������һ���ļ۸�
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wdata=[date2,open2,close2,volume2,amt2];%�����ݾ���
    
    