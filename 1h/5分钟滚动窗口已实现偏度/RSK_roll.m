%%--------------------滚动窗口的已实现偏度-------------------
clear;
clc;
PATH_RSK='C:\Users\lixup\Desktop\1h\5分钟滚动窗口已实现偏度\结果保存\';
PATH_1min='C:\Users\lixup\Desktop\1h\1分钟数据保存\20150416-20180731\';
PATH_interval='C:\Users\lixup\Desktop\1h\1分钟数据保存\给定时间区间\';

load([PATH_interval,'return_data_IF300_1min']);
load([PATH_interval,'return_data_IF300index_1min']);
load([PATH_interval,'return_data_IH50_1min']);
load([PATH_interval,'return_data_IH50index_1min']);
load([PATH_interval,'return_data_IC500_1min']);
load([PATH_interval,'return_data_IC500index_1min']);

[RSK_IF300_30]=high_frequency_realized_moment(return_data_IF300_1min(:,3),30);
[RSK_IF300index_30]=high_frequency_realized_moment(return_data_IF300index_1min(:,3),30);
[RSK_IH50_30]=high_frequency_realized_moment(return_data_IH50_1min(:,3),30);
[RSK_IH50index_30]=high_frequency_realized_moment(return_data_IH50index_1min(:,3),30);
[RSK_IC500_30]=high_frequency_realized_moment(return_data_IC500_1min(:,3),30);
[RSK_IC500index_30]=high_frequency_realized_moment(return_data_IC500index_1min(:,3),30);

[RSK_IF300_60]=high_frequency_realized_moment(return_data_IF300_1min(:,3),60);
[RSK_IF300index_60]=high_frequency_realized_moment(return_data_IF300index_1min(:,3),60);
[RSK_IH50_60]=high_frequency_realized_moment(return_data_IH50_1min(:,3),60);
[RSK_IH50index_60]=high_frequency_realized_moment(return_data_IH50index_1min(:,3),60);
[RSK_IC500_60]=high_frequency_realized_moment(return_data_IC500_1min(:,3),60);
[RSK_IC500index_60]=high_frequency_realized_moment(return_data_IC500index_1min(:,3),60);

[RSK_IF300_120]=high_frequency_realized_moment(return_data_IF300_1min(:,3),120);
[RSK_IF300index_120]=high_frequency_realized_moment(return_data_IF300index_1min(:,3),120);
[RSK_IH50_120]=high_frequency_realized_moment(return_data_IH50_1min(:,3),120);
[RSK_IH50index_120]=high_frequency_realized_moment(return_data_IH50index_1min(:,3),120);
[RSK_IC500_120]=high_frequency_realized_moment(return_data_IC500_1min(:,3),120);
[RSK_IC500index_120]=high_frequency_realized_moment(return_data_IC500index_1min(:,3),120);

[RSK_IF300_240]=high_frequency_realized_moment(return_data_IF300_1min(:,3),240);
[RSK_IF300index_240]=high_frequency_realized_moment(return_data_IF300index_1min(:,3),240);
[RSK_IH50_240]=high_frequency_realized_moment(return_data_IH50_1min(:,3),240);
[RSK_IH50index_240]=high_frequency_realized_moment(return_data_IH50index_1min(:,3),240);
[RSK_IC500_240]=high_frequency_realized_moment(return_data_IC500_1min(:,3),240);
[RSK_IC500index_240]=high_frequency_realized_moment(return_data_IC500index_1min(:,3),240);

% save([PATH_RSK,'RSK_IF300_30'],'RSK_IF300_30');
% save([PATH_RSK,'RSK_IF300index_30'],'RSK_IF300index_30');
% save([PATH_RSK,'RSK_IH50_30'],'RSK_IH50_30');
% save([PATH_RSK,'RSK_IH50index_30'],'RSK_IH50index_30');
% save([PATH_RSK,'RSK_IC500_30'],'RSK_IC500_30');
% save([PATH_RSK,'RSK_IC500index_30'],'RSK_IC500index_30');
% 
save([PATH_interval,'RSK_IF300_30'],'RSK_IF300_30');
save([PATH_interval,'RSK_IF300index_30'],'RSK_IF300index_30');
save([PATH_interval,'RSK_IH50_30'],'RSK_IH50_30');
save([PATH_interval,'RSK_IH50index_30'],'RSK_IH50index_30');
save([PATH_interval,'RSK_IC500_30'],'RSK_IC500_30');
save([PATH_interval,'RSK_IC500index_30'],'RSK_IC500index_30');

save([PATH_interval,'RSK_IF300_60'],'RSK_IF300_60');
save([PATH_interval,'RSK_IF300index_60'],'RSK_IF300index_60');
save([PATH_interval,'RSK_IH50_60'],'RSK_IH50_60');
save([PATH_interval,'RSK_IH50index_60'],'RSK_IH50index_60');
save([PATH_interval,'RSK_IC500_60'],'RSK_IC500_60');
save([PATH_interval,'RSK_IC500index_60'],'RSK_IC500index_60');

save([PATH_interval,'RSK_IF300_120'],'RSK_IF300_120');
save([PATH_interval,'RSK_IF300index_120'],'RSK_IF300index_120');
save([PATH_interval,'RSK_IH50_120'],'RSK_IH50_120');
save([PATH_interval,'RSK_IH50index_120'],'RSK_IH50index_120');
save([PATH_interval,'RSK_IC500_120'],'RSK_IC500_120');
save([PATH_interval,'RSK_IC500index_120'],'RSK_IC500index_120');

save([PATH_interval,'RSK_IF300_240'],'RSK_IF300_240');
save([PATH_interval,'RSK_IF300index_240'],'RSK_IF300index_240');
save([PATH_interval,'RSK_IH50_240'],'RSK_IH50_240');
save([PATH_interval,'RSK_IH50index_240'],'RSK_IH50index_240');
save([PATH_interval,'RSK_IC500_240'],'RSK_IC500_240');
save([PATH_interval,'RSK_IC500index_240'],'RSK_IC500index_240');