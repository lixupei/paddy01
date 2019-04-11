%%--------------------data_logreturn_1min--------------------
%---------------------保存2015-04-16至2018-08-17的1分钟收益率
tic;
warning off;
filename1=['C:\Users\lixup\Desktop\1h\data_csv\IH50minute.csv']; %CSI300 index 2015/4/16-2017/5/31 one-minute frequency data
data_IH50_all=clean_data(filename1);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50_all'], 'data_IH50_all')

filename2=['C:\Users\lixup\Desktop\1h\data_csv\SZ50minute.csv'];
data_IH50index_all=clean_data(filename2);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50index_all'], 'data_IH50index_all')

filename3=['C:\Users\lixup\Desktop\1h\data_csv\IF300minute.csv'];
data_IF300_all=clean_data(filename3);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300_all'], 'data_IF300_all')

filename4=['C:\Users\lixup\Desktop\1h\data_csv\CSI300minute.csv'];
data_IF300index_all=clean_data(filename4);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300index_all'], 'data_IF300index_all')

filename5=['C:\Users\lixup\Desktop\1h\data_csv\IC500minute.csv'];
data_IC500_all=clean_data(filename5);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500_all'], 'data_IC500_all')

filename6=['C:\Users\lixup\Desktop\1h\data_csv\CSI500minute.csv'];
data_IC500index_all=clean_data(filename6);
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500index_all'], 'data_IC500index_all')

datename={'time','open','close','volume','amt'};
clear;clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP2:清除隔夜收益率，得到时间、开盘收益率、收盘收益率三列的矩阵
%r_t=log(P_t)-log(P_(t-1));
%以上证50主力合约为例
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50_all.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IH50index_all.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300_all.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IF300index_all.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500_all.mat')
load('C:\Users\lixup\Desktop\1h\1分钟数据保存\data_IC500index_all.mat')

[return_data_IH50_1min_all,cell_data_IH50_1min_all]=price_to_return(data_IH50_all);
[return_data_IH50index_1min_all,cell_data_IH50index_1min_all]=price_to_return(data_IH50index_all);
[return_data_IF300_1min_all,cell_data_IF300_1min_all]=price_to_return(data_IF300_all);
[return_data_IF300index_1min_all,cell_data_IF300index_1min_all]=price_to_return(data_IF300index_all);
[return_data_IC500_1min_all,cell_data_IC500_1min_all]=price_to_return(data_IC500_all);
[return_data_IC500index_1min_all,cell_data_IC500index_1min_all]=price_to_return(data_IC500index_all);

save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IH50_1min_all'], 'return_data_IH50_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IH50index_1min_all'], 'return_data_IH50index_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IC500_1min_all'], 'return_data_IC500_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IC500index_1min_all'], 'return_data_IC500index_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IF300_1min_all'], 'return_data_IF300_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\return_data_IF300index_1min_all'], 'return_data_IF300index_1min_all')

save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IH50_1min_all'], 'cell_data_IH50_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IH50index_1min_all'], 'cell_data_IH50index_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IC500_1min_all'], 'cell_data_IC500_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IC500index_1min_all'], 'cell_data_IC500index_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IF300_1min_all'], 'cell_data_IF300_1min_all')
save(['C:\Users\lixup\Desktop\1h\1分钟数据保存\cell_data_IF300index_1min_all'], 'cell_data_IF300index_1min_all')

%--------------------5分钟对数收益率--------------------
clear;clc;
PATH_1min='C:\Users\lixup\Desktop\1h\1分钟数据保存\';
PATH_5min='C:\Users\lixup\Desktop\1h\5分钟数据保存\';
PATH_day='C:\Users\lixup\Desktop\1h\日度数据保存\';
PATH_time='C:\Users\lixup\Desktop\1h\1分钟数据保存\20150416-20180731\';
PATH_interval='C:\Users\lixup\Desktop\1h\1分钟数据保存\给定时间区间\';

load([PATH_1min,'return_data_IF300_1min_all.mat'])
load([PATH_1min,'return_data_IF300index_1min_all.mat'])
load([PATH_1min,'return_data_IH50_1min_all.mat'])
load([PATH_1min,'return_data_IH50index_1min_all.mat'])
load([PATH_1min,'return_data_IC500_1min_all.mat'])
load([PATH_1min,'return_data_IC500index_1min_all.mat'])

location_start=min(find(return_data_IF300_1min_all(:,1)>=datenum('2015-04-16')));
location_end=max(find(return_data_IF300_1min_all(:,1)<=datenum('2018-07-31')));

return_data_IF300_1min=return_data_IF300_1min_all(location_start:location_end,:);
return_data_IF300index_1min=return_data_IF300index_1min_all(location_start:location_end,:);
return_data_IH50_1min=return_data_IH50_1min_all(location_start:location_end,:);
return_data_IH50index_1min=return_data_IH50index_1min_all(location_start:location_end,:);
return_data_IC500_1min=return_data_IC500_1min_all(location_start:location_end,:);
return_data_IC500index_1min=return_data_IC500index_1min_all(location_start:location_end,:);

save([PATH_interval,'return_data_IH50_1min'], 'return_data_IH50_1min')
save([PATH_interval,'return_data_IH50index_1min'], 'return_data_IH50index_1min')
save([PATH_interval,'return_data_IC500_1min'], 'return_data_IC500_1min')
save([PATH_interval,'return_data_IC500index_1min'], 'return_data_IC500index_1min')
save([PATH_interval,'return_data_IF300_1min'], 'return_data_IF300_1min')
save([PATH_interval,'return_data_IF300index_1min'], 'return_data_IF300index_1min')

frequency=5;
THETA=0.05;
n=length(return_data_IF300_1min(:,1));
IF300_5min=reshape(return_data_IF300_1min(:,3),frequency,n/frequency);
IF300index_5min=reshape(return_data_IF300index_1min(:,3),frequency,n/frequency);
IH50_5min=reshape(return_data_IH50_1min(:,3),frequency,n/frequency);
IH50index_5min=reshape(return_data_IH50index_1min(:,3),frequency,n/frequency);
IC500_5min=reshape(return_data_IC500_1min(:,3),frequency,n/frequency);
IC500index_5min=reshape(return_data_IC500index_1min(:,3),frequency,n/frequency);

IF300_5min_logreturn=sum(IF300_5min)';
IF300index_5min_logreturn=sum(IF300index_5min)';
IH50_5min_logreturn=sum(IH50_5min)';
IH50index_5min_logreturn=sum(IH50index_5min)';
IC500_5min_logreturn=sum(IC500_5min)';
IC500index_5min_logreturn=sum(IC500index_5min)';

save([PATH_5min,'IF300_5min_logreturn'], 'IF300_5min_logreturn');
save([PATH_5min,'IF300index_5min_logreturn'], 'IF300index_5min_logreturn');
save([PATH_5min,'IH50_5min_logreturn'], 'IH50_5min_logreturn');
save([PATH_5min,'IH50index_5min_logreturn'], 'IH50index_5min_logreturn');
save([PATH_5min,'IC500_5min_logreturn'], 'IC500_5min_logreturn');
save([PATH_5min,'IC500index_5min_logreturn'], 'IC500index_5min_logreturn');

save([PATH_interval,'IF300_5min_logreturn'], 'IF300_5min_logreturn');
save([PATH_interval,'IF300index_5min_logreturn'], 'IF300index_5min_logreturn');
save([PATH_interval,'IH50_5min_logreturn'], 'IH50_5min_logreturn');
save([PATH_interval,'IH50index_5min_logreturn'], 'IH50index_5min_logreturn');
save([PATH_interval,'IC500_5min_logreturn'], 'IC500_5min_logreturn');
save([PATH_interval,'IC500index_5min_logreturn'], 'IC500index_5min_logreturn');


%--------------------日对数收益率（给定时间区间）---------------------
frequency2=240;
THETA=0.05;
n=length(return_data_IF300_1min(:,1));
IF300_day=reshape(return_data_IF300_1min(:,3),frequency2,n/frequency2);
IF300index_day=reshape(return_data_IF300index_1min(:,3),frequency2,n/frequency2);
IH50_day=reshape(return_data_IH50_1min(:,3),frequency2,n/frequency2);
IH50index_day=reshape(return_data_IH50index_1min(:,3),frequency2,n/frequency2);
IC500_day=reshape(return_data_IC500_1min(:,3),frequency2,n/frequency2);
IC500index_day=reshape(return_data_IC500index_1min(:,3),frequency2,n/frequency2);

IF300_day_logreturn=sum(IF300_day)';
IF300index_day_logreturn=sum(IF300index_day)';
IH50_day_logreturn=sum(IH50_day)';
IH50index_day_logreturn=sum(IH50index_day)';
IC500_day_logreturn=sum(IC500_day)';
IC500index_day_logreturn=sum(IC500index_day)';

save([PATH_day,'IF300_day_logreturn'], 'IF300_day_logreturn');
save([PATH_day,'IF300index_day_logreturn'], 'IF300index_day_logreturn');
save([PATH_day,'IH50_day_logreturn'], 'IH50_day_logreturn');
save([PATH_day,'IH50index_day_logreturn'], 'IH50index_day_logreturn');
save([PATH_day,'IC500_day_logreturn'], 'IC500_day_logreturn');
save([PATH_day,'IC500index_day_logreturn'], 'IC500index_day_logreturn');

save([PATH_interval,'IF300_day_logreturn'], 'IF300_day_logreturn');
save([PATH_interval,'IF300index_day_logreturn'], 'IF300index_day_logreturn');
save([PATH_interval,'IH50_day_logreturn'], 'IH50_day_logreturn');
save([PATH_interval,'IH50index_day_logreturn'], 'IH50index_day_logreturn');
save([PATH_interval,'IC500_day_logreturn'], 'IC500_day_logreturn');
save([PATH_interval,'IC500index_day_logreturn'], 'IC500index_day_logreturn');
toc;