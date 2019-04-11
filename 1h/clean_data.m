function Wdata=clean_data(filename)
%本函数适用于D:\matlab2016b\bin\used_data\Expected_Shortfall 路径下.csv指数和指数期货的文件
%注意：数据文件中，收盘时的成交量（3:00或3:15）大多数为0或NaN，在应用本函数生成的流动性指标
%时，请考虑是否需要清除收盘时的样本数据！

%Input:数据文件名
%Output:Wdata清理后的数据矩阵，包含时间、价格、成交量
%Attention： Don't use textscan to read .xlsx files, because
% it would produce unreadable codes.
% So, I convert .xlsx file into .csv file, and use textscan to load data
filenum1=fopen(filename);
kk1=textscan(filenum1,repmat('%s ',[1,9]),'Delimiter',',','HeaderLines',1);
fclose(filenum1);

date1=kk1{1};%cell类型 日期数据
open1=kk1{2};%cell类型 开盘价
close1=kk1{3};%cell类型 收盘价
volume1=kk1{6};%cell类型 成交量
amt1=kk1{7};%cell类型 成交额

wrong_location=zeros(size(date1,1),1);


for i=1:size(date1,1)
    try
        datenumber=datenum(date1{i});
    catch
        disp([filename,'中第',num2str(i),'行包含非日期字符串']);%主要用于识别字符串'fetching'和空字符串
        wrong_location(i)=1;
    end
end
%datenum的输入能为空字符串，而datenum2的输入不能为空字符串
clear_location=find(wrong_location==1);%包含非日期字符串的行数据需要删除

date1(clear_location)=[];
open1(clear_location)=[];
close1(clear_location)=[];
volume1(clear_location)=[];
amt1(clear_location)=[];%得到清除非法日期行和空行后的数据，cell类型

%清除open和close中空值
clean_loc1=cellfun(@(x) all(isempty(x)),open1);%判断每个cell是否为空
clean_loc2=cellfun(@(x) all(isempty(x)),close1);
clean_loc3=max(clean_loc1,clean_loc2);
date1(clean_loc3)=[];
open1(clean_loc3)=[];
close1(clean_loc3)=[];
volume1(clean_loc3)=[];
amt1(clean_loc3)=[];%删除价格为空的行

%清除open和close中的NaN字符串
%open1为N*1cell，每个cell包含长度不等的字符串
%所以无法对open1直接使用函数cell2mat,故采用循环的方式
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
clean_loc6=max(clean_loc4,clean_loc5);%close或open中包含NaN的行数
date1(clean_loc6)=[];
open1(clean_loc6)=[];
close1(clean_loc6)=[];
volume1(clean_loc6)=[];
amt1(clean_loc6)=[];%删除包含NaN的行
%得到清除包含空值和NaN行后的各序列
%open1 close1 volume1 amt1的每个cell均为str而不是double
%因此，用cell2mat会报错，字符串长度不一致
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%得到double类型数据
date2=datenum(date1);
open2=cellfun(@(x) str2num(x),open1);
close2=cellfun(@(x) str2num(x),close1);
volume2=cellfun(@(x) str2num(x),volume1);
amt2=cellfun(@(x) str2num(x),amt1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%修正 close、open=0 行的数据
location_open=find(open2==0);
location_close=find(close2==0);
if location_open~=location_close
    error('存在开盘价为0而收盘价不为0（或收盘价为0而开盘价不为0）的情形')
end

if ~isempty(location_open)
    open2(location_open)=open2(location_open-1);%对于取0的价格，沿用上一个的价格
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wdata=[date2,open2,close2,volume2,amt2];%总数据矩阵
    
    