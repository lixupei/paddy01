%%-----------保存日内数据（更新至2018年）----------
tic;
clc;
clear;
load('data_index_future_update.mat');
date_start='2015-04-16';
date_end='2018-04-27';
%选出目标范围内的小时数据
[HS300_time_day_1hour,HS300_close_day_1hour,logreturn_HS300_1hour]=intra_1hourindex_logreturn(date_start,date_end,CSI300minutetime_all,CSI300minuteclose_all);
[SZ50_time_day_1hour,SZ50_close_day_1hour,logreturn_SZ50_1hour]=intra_1hourindex_logreturn(date_start,date_end,SZ50minutetime_all,SZ50minuteclose_all);
[CSI500_time_day_1hour,CSI500_close_day_1hour,logreturn_CSI500_1hour]=intra_1hourindex_logreturn(date_start,date_end,CSI500minutetime_all,CSI500minuteclose_all);

[IF300_time_day_1hour,IF300_close_day_1hour,logreturn_IF300_1hour]=intra_1hourfuture_logreturn(date_start,date_end,IF300minutetime_all,IF300minuteclose_all);
[IH50_time_day_1hour,IH50_close_day_1hour,logreturn_IH50_1hour]=intra_1hourfuture_logreturn(date_start,date_end,IH50minutetime_all,IH50minuteclose_all);
[IC500_time_day_1hour,IC500_close_day_1hour,logreturn_IC500_1hour]=intra_1hourfuture_logreturn(date_start,date_end,IC500minutetime_all,IC500minuteclose_all);


% [HS300date,logreturn_HS300_day]=logreturn_close(date_start,date_end,CSI300daytime_all,CSI300dayclose_all);
% [IF300date,logreturn_IF300_day]=logreturn_close(date_start,date_end,IF300daytime_all,IF300dayclose_all);
% [SZ50date,logreturn_SZ50_day]=logreturn_close(date_start,date_end,SZ50daytime_all,SZ50dayclose_all);
% [IH50date,logreturn_IH50_day]=logreturn_close(date_start,date_end,IH50daytime_all,IH50dayclose_all);
% [CSI500date,logreturn_CSI500_day]=logreturn_close(date_start,date_end,CSI500daytime_all,CSI500dayclose_all);
% [IC500date,logreturn_IC500_day]=logreturn_close(date_start,date_end,IC500daytime_all,IC500dayclose_all);

%选出目标范围内的5分钟对数收益率
[HS300_time_day_5minute,HS300_close_day_5minute,logreturn_HS300_5min]=intra_5minuteindex_logreturn(date_start,date_end,CSI300minutetime_all,CSI300minuteclose_all);
[SZ50_time_day_5minute,SZ50_close_day_5minute,logreturn_SZ50_5min]=intra_5minuteindex_logreturn(date_start,date_end,SZ50minutetime_all,SZ50minuteclose_all);
[CSI500_time_day_5minute,CSI500_close_day_5minute,logreturn_CSI500_5min]=intra_5minuteindex_logreturn(date_start,date_end,CSI500minutetime_all,CSI500minuteclose_all);

[IF300_time_day_5minute,IF300_close_day_5minute,logreturn_IF300_5min]=intra_5minutefuture_logreturn(date_start,date_end,IF300minutetime_all,IF300minuteclose_all);
[IH50_time_day_5minute,IH50_close_day_5minute,logreturn_IH50_5min]=intra_5minutefuture_logreturn(date_start,date_end,IH50minutetime_all,IH50minuteclose_all);
[IC500_time_day_5minute,IC500_close_day_5minute,logreturn_IC500_5min]=intra_5minutefuture_logreturn(date_start,date_end,IC500minutetime_all,IC500minuteclose_all);

% %%----------保存日度数据(收盘价日期及对数收益率序列)-----------
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\HS300date','HS300date')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_HS300_day','logreturn_HS300_day')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IF300date','IF300date')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_IF300_day','logreturn_IF300_day')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\SZ50date','SZ50date')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_SZ50_day','logreturn_SZ50_day')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IH50date','IH50date')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_IH50_day','logreturn_IH50_day')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\CSI500date','CSI500date')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_CSI500_day','logreturn_CSI500_day')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IC500date','IC500date')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_IC500_day','logreturn_IC500_day')
% 
% %%----------保存五分钟对数收益率序列（收盘价日期及对数收益率）----------
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\HS300_time_day_5minute','HS300_time_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\HS300_close_day_5minute','HS300_close_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_HS300_5min','logreturn_HS300_5min')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\SZ50_time_day_5minute','SZ50_time_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\SZ50_close_day_5minute','SZ50_close_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_SZ50_5min','logreturn_SZ50_5min')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\CSI500_time_day_5minute','CSI500_time_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\CSI500_close_day_5minute','CSI500_close_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_CSI500_5min','logreturn_CSI500_5min')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IF300_time_day_5minute','IF300_time_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IF300_close_day_5minute','IF300_close_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_IF300_5min','logreturn_IF300_5min')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IH50_time_day_5minute','IH50_time_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IH50_close_day_5minute','IH50_close_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_IH50_5min','logreturn_IH50_5min')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IC500_time_day_5minute','IC500_time_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\IC500_close_day_5minute','IC500_close_day_5minute')
% save('C:\Users\lixup\Desktop\data_2mat\data_choose\result_20150416-201800416\logreturn_IC500_5min','logreturn_IC500_5min')
toc;




