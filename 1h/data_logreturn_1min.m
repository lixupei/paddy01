%%--------------------data_logreturn_1min--------------------
%---------------------保存2015-04-16至2018-08-17的1分钟收益率
filename1=['C:\Users\lixup\Desktop\1h\data_csv\IH50minute.csv']; %CSI300 index 2015/4/16-2017/5/31 one-minute frequency data
data_IH50=clean_data(filename1);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50'], 'data_IH50')

filename2=['C:\Users\lixup\Desktop\1h\data_csv\SZ50minute.csv'];
data_IH50index=clean_data(filename2);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50index'], 'data_IH50index')

filename3=['C:\Users\lixup\Desktop\1h\data_csv\IF300minute.csv'];
data_IF300=clean_data(filename3);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300'], 'data_IF300')

filename4=['C:\Users\lixup\Desktop\1h\data_csv\CSI300minute.csv'];
data_IF300index=clean_data(filename4);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300index'], 'data_IF300index')

filename5=['C:\Users\lixup\Desktop\1h\data_csv\IC500minute.csv'];
data_IC500=clean_data(filename5);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500'], 'data_IC500')

filename6=['C:\Users\lixup\Desktop\1h\data_csv\CSI500minute.csv'];
data_IC500index=clean_data(filename6);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500index'], 'data_IC500index')

datename={'time','open','close','volume','amt'};
clear;clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP2:清除隔夜收益率，得到时间、开盘收益率、收盘收益率三列的矩阵
%r_t=log(P_t)-log(P_(t-1));
%以上证50主力合约为例
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50index.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300index.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500index.mat')

[return_data_IH50_1min,cell_data_IH50_1min]=price_to_return(data_IH50);
[return_data_IH50index_1min,cell_data_IH50index_1min]=price_to_return(data_IH50index);
[return_data_IF300_1min,cell_data_IF300_1min]=price_to_return(data_IF300);
[return_data_IF300index_1min,cell_data_IF300index_1min]=price_to_return(data_IF300index);
[return_data_IC500_1min,cell_data_IC500_1min]=price_to_return(data_IC500);
[return_data_IC500index_1min,cell_data_IC500index_1min]=price_to_return(data_IC500index);

% all_date1=datestr(floor(return_data_IF300_1min(1,1)),'yyyy-mm-dd');%2015-04-16
% all_date2=datestr(floor(return_data_IF300_1min(end,1)),'yyyy-mm-dd');%2017-05-31

location_start=find(return_data_IF300_1min(:,1)>=datenum('2015-04-16'),1);%牛市期-9600
location_end=find(return_data_IF300_1min(:,1)<=datenum('2018-07-31'),1);%熊市期-46800

return_data_IF300_1min=return_data_IF300_1min(location_start:location_end,:);
return_data_IF300index_1min=return_data_IF300index_1min(location_start:location_end,:);
return_data_IH50_1min=return_data_IH50_1min(location_start:location_end,:);
return_data_IH50index_1min=return_data_IH50index_1min(location_start:location_end,:);
return_data_IC500_1min=return_data_IC500_1min(location_start:location_end,:);
return_data_IC500index_1min=return_data_IC500index_1min(location_start:location_end,:);

save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IH50_1min'], 'return_data_IH50_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IH50index_1min'], 'return_data_IH50index_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IC500_1min'], 'return_data_IC500_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IC500index_1min'], 'return_data_IC500index_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IF300_1min'], 'return_data_IF300_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IF300index_1min'], 'return_data_IF300index_1min')

save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IH50_1min'], 'cell_data_IH50_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IH50index_1min'], 'cell_data_IH50index_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IC500_1min'], 'cell_data_IC500_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IC500index_1min'], 'cell_data_IC500index_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IF300_1min'], 'cell_data_IF300_1min')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IF300index_1min'], 'cell_data_IF300index_1min')

%--------------------5分钟对数收益率--------------------
clear;clc;
PATH_1min='C:\Users\lixup\Desktop\1h\1分钟数据保存\';
PATH_5min='C:\Users\lixup\Desktop\1h\5分钟数据保存\';
load([PATH_1min,'return_data_IF300_1min.mat'])
load([PATH_1min,'return_data_IF300index_1min.mat'])
load([PATH_1min,'return_data_IH50_1min.mat'])
load([PATH_1min,'return_data_IH50index_1min.mat'])
load([PATH_1min,'return_data_IC500_1min.mat'])
load([PATH_1min,'return_data_IC500index_1min.mat'])

frequency=5;
THETA=0.05;
n=length(return_data_IF300);
IF300=reshape(return_data_IF300_1min(:,3),frequency,n/frequency);
IF300index_1min=reshape(return_data_IF300index_1min(:,3),frequency,n/frequency);
IH50=reshape(return_data_IH50_1min(:,3),frequency,n/frequency);
IH50index=reshape(return_data_IH50index_1min(:,3),frequency,n/frequency);
IC500=reshape(return_data_IC500_1min(:,3),frequency,n/frequency);
IC500index=reshape(return_data_IC500index_1min(:,3),frequency,n/frequency);

IF300_5min_logreturn=sum(IF300)';
IF300index_5min_logreturn=sum(IF300index)';
IH50_5min_logreturn=sum(IH50)';
IH50index_5min_logreturn=sum(IH50index)';
IC500_5min_logreturn=sum(IC500)';
IC500index_5min_logreturn=sum(IC500index)';




















