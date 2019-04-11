%%--------------------main_5min--------------------
clear;
clc;
PATH_5min='C:\Users\lixup\Desktop\1h\5分钟数据保存\';
PATH_RSK='C:\Users\lixup\Desktop\1h\5分钟滚动窗口已实现偏度\结果保存\';
PATH_interval='C:\Users\lixup\Desktop\1h\1分钟数据保存\给定时间区间\';

load([PATH_interval,'IF300_5min_logreturn']);
load([PATH_interval,'IF300index_5min_logreturn']);
load([PATH_interval,'IH50_5min_logreturn']);
load([PATH_interval,'IH50index_5min_logreturn']);
load([PATH_interval,'IC500_5min_logreturn']);
load([PATH_interval,'IC500index_5min_logreturn']);

load([PATH_interval,'RSK_IF300index_30']);
load([PATH_interval,'RSK_IF300_30']);
load([PATH_interval,'RSK_IH50index_30']);
load([PATH_interval,'RSK_IH50_30']);
load([PATH_interval,'RSK_IC500index_30']);
load([PATH_interval,'RSK_IC500_30']);

load([PATH_interval,'RSK_IF300index_60']);
load([PATH_interval,'RSK_IF300_60']);
load([PATH_interval,'RSK_IH50index_60']);
load([PATH_interval,'RSK_IH50_60']);
load([PATH_interval,'RSK_IC500index_60']);
load([PATH_interval,'RSK_IC500_60']);

load([PATH_interval,'RSK_IF300index_120']);
load([PATH_interval,'RSK_IF300_120']);
load([PATH_interval,'RSK_IH50index_120']);
load([PATH_interval,'RSK_IH50_120']);
load([PATH_interval,'RSK_IC500index_120']);
load([PATH_interval,'RSK_IC500_120']);

load([PATH_interval,'RSK_IF300index_240']);
load([PATH_interval,'RSK_IF300_240']);
load([PATH_interval,'RSK_IH50index_240']);
load([PATH_interval,'RSK_IH50_240']);
load([PATH_interval,'RSK_IC500index_240']);
load([PATH_interval,'RSK_IC500_240']);

IF_5min=48*[IF300index_5min_logreturn,IF300_5min_logreturn];
IH_5min=48*[IH50index_5min_logreturn,IH50_5min_logreturn];
IC_5min=48*[IC500index_5min_logreturn,IC500_5min_logreturn];

%--------------------计算日内效应----------
THETA1=0.05;frequency=5;
for i=1:2
    each_quantile_IF(:,i)=intrayQuantile(IF_5min(1:end,i),THETA1,frequency);%各子区间的平均分位数
    each_quantile_IH(:,i)=intrayQuantile(IH_5min(1:end,i),THETA1,frequency);
    each_quantile_IC(:,i)=intrayQuantile(IC_5min(1:end,i),THETA1,frequency);
end
days=length(IF_5min)/(240/frequency);
St_IF_5min=repmat(each_quantile_IF,days,1);
St_IC_5min=repmat(each_quantile_IC,days,1);
St_IH_5min=repmat(each_quantile_IH,days,1);

RSK_IF_30=[RSK_IF300index_30,RSK_IF300_30];
RSK_IH_30=[RSK_IH50index_30,RSK_IH50_30];
RSK_IC_30=[RSK_IC500index_30,RSK_IC500_30];
RSK_IF_60=[RSK_IF300index_60,RSK_IF300_60];
RSK_IH_60=[RSK_IH50index_60,RSK_IH50_60];
RSK_IC_60=[RSK_IC500index_60,RSK_IC500_60];
RSK_IF_120=[RSK_IF300index_120,RSK_IF300_120];
RSK_IH_120=[RSK_IH50index_120,RSK_IH50_120];
RSK_IC_120=[RSK_IC500index_120,RSK_IC500_120];
RSK_IF_240=[RSK_IF300index_240,RSK_IF300_240];
RSK_IH_240=[RSK_IH50index_240,RSK_IH50_240];
RSK_IC_240=[RSK_IC500index_240,RSK_IC500_240];


[total_IF_RSK30_5min.q, total_IF_RSK30_5min.Beta, total_IF_RSK30_5min.fval, total_IF_RSK30_5min.exitflag] = intramvmqcaviar_spillover(IF_5min,THETA1,St_IF_5min,RSK_IF_30);
% [total_IF_RSK_5min.se, total_IF_RSK_5min.TS, total_IF_RSK_5min.pValueTS, total_IF_RSK_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK_5min.Beta, total_IF_RSK_5min.q,St_IF_5min,RSK_IF);
[total_IF_RSK30_5min.se, total_IF_RSK30_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK30_5min.Beta, total_IF_RSK30_5min.q,St_IF_5min,RSK_IF_30);

[total_IC_RSK30_5min.q, total_IC_RSK30_5min.Beta, total_IC_RSK30_5min.fval, total_IC_RSK30_5min.exitflag] = intramvmqcaviar_spillover(IC_5min,THETA1,St_IC_5min,RSK_IC_30);
% [total_IC_RSK_5min.se, total_IC_RSK_5min.TS, total_IC_RSK_5min.pValueTS, total_IC_RSK_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK_5min.Beta, total_IC_RSK_5min.q,St_IC_5min,RSK_IC);
[total_IC_RSK30_5min.se, total_IC_RSK30_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK30_5min.Beta, total_IC_RSK30_5min.q,St_IC_5min,RSK_IC_30);

[total_IH_RSK30_5min.q, total_IH_RSK30_5min.Beta, total_IH_RSK30_5min.fval, total_IH_RSK30_5min.exitflag] = intramvmqcaviar_spillover(IH_5min,THETA1,St_IH_5min,RSK_IH_30);
% [total_IH_RSK_5min.se, total_IH_RSK_5min.TS, total_IH_RSK_5min.pValueTS, total_IH_RSK_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK_5min.Beta, total_IH_RSK_5min.q,St_IH_5min,RSK_IH);
[total_IH_RSK30_5min.se, total_IH_RSK30_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK30_5min.Beta, total_IH_RSK30_5min.q,St_IH_5min,RSK_IH_30);

[total_IF_RSK60_5min.q, total_IF_RSK60_5min.Beta, total_IF_RSK60_5min.fval, total_IF_RSK60_5min.exitflag] = intramvmqcaviar_spillover(IF_5min,THETA1,St_IF_5min,RSK_IF_60);
% [total_IF_RSK_5min.se, total_IF_RSK_5min.TS, total_IF_RSK_5min.pValueTS, total_IF_RSK_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK_5min.Beta, total_IF_RSK_5min.q,St_IF_5min,RSK_IF);
[total_IF_RSK60_5min.se, total_IF_RSK60_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK60_5min.Beta, total_IF_RSK60_5min.q,St_IF_5min,RSK_IF_60);

[total_IC_RSK60_5min.q, total_IC_RSK60_5min.Beta, total_IC_RSK60_5min.fval, total_IC_RSK60_5min.exitflag] = intramvmqcaviar_spillover(IC_5min,THETA1,St_IC_5min,RSK_IC_60);
% [total_IC_RSK_5min.se, total_IC_RSK_5min.TS, total_IC_RSK_5min.pValueTS, total_IC_RSK_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK_5min.Beta, total_IC_RSK_5min.q,St_IC_5min,RSK_IC);
[total_IC_RSK60_5min.se, total_IC_RSK60_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK60_5min.Beta, total_IC_RSK60_5min.q,St_IC_5min,RSK_IC_60);

[total_IH_RSK60_5min.q, total_IH_RSK60_5min.Beta, total_IH_RSK60_5min.fval, total_IH_RSK60_5min.exitflag] = intramvmqcaviar_spillover(IH_5min,THETA1,St_IH_5min,RSK_IH_60);
% [total_IH_RSK_5min.se, total_IH_RSK_5min.TS, total_IH_RSK_5min.pValueTS, total_IH_RSK_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK_5min.Beta, total_IH_RSK_5min.q,St_IH_5min,RSK_IH);
[total_IH_RSK60_5min.se, total_IH_RSK60_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK60_5min.Beta, total_IH_RSK60_5min.q,St_IH_5min,RSK_IH_60);

[total_IF_RSK120_5min.q, total_IF_RSK120_5min.Beta, total_IF_RSK120_5min.fval, total_IF_RSK120_5min.exitflag] = intramvmqcaviar_spillover(IF_5min,THETA1,St_IF_5min,RSK_IF_120);
% [total_IF_RSK_5min.se, total_IF_RSK_5min.TS, total_IF_RSK_5min.pValueTS, total_IF_RSK_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK_5min.Beta, total_IF_RSK_5min.q,St_IF_5min,RSK_IF);
[total_IF_RSK120_5min.se, total_IF_RSK120_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK120_5min.Beta, total_IF_RSK120_5min.q,St_IF_5min,RSK_IF_120);

[total_IC_RSK120_5min.q, total_IC_RSK120_5min.Beta, total_IC_RSK120_5min.fval, total_IC_RSK120_5min.exitflag] = intramvmqcaviar_spillover(IC_5min,THETA1,St_IC_5min,RSK_IC_120);
% [total_IC_RSK_5min.se, total_IC_RSK_5min.TS, total_IC_RSK_5min.pValueTS, total_IC_RSK_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK_5min.Beta, total_IC_RSK_5min.q,St_IC_5min,RSK_IC);
[total_IC_RSK120_5min.se, total_IC_RSK120_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK120_5min.Beta, total_IC_RSK120_5min.q,St_IC_5min,RSK_IC_120);

[total_IH_RSK120_5min.q, total_IH_RSK120_5min.Beta, total_IH_RSK120_5min.fval, total_IH_RSK120_5min.exitflag] = intramvmqcaviar_spillover(IH_5min,THETA1,St_IH_5min,RSK_IH_120);
% [total_IH_RSK_5min.se, total_IH_RSK_5min.TS, total_IH_RSK_5min.pValueTS, total_IH_RSK_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK_5min.Beta, total_IH_RSK_5min.q,St_IH_5min,RSK_IH);
[total_IH_RSK120_5min.se, total_IH_RSK120_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK120_5min.Beta, total_IH_RSK120_5min.q,St_IH_5min,RSK_IH_120);

[total_IF_RSK240_5min.q, total_IF_RSK240_5min.Beta, total_IF_RSK240_5min.fval, total_IF_RSK240_5min.exitflag] = intramvmqcaviar_spillover(IF_5min,THETA1,St_IF_5min,RSK_IF_240);
% [total_IF_RSK_5min.se, total_IF_RSK_5min.TS, total_IF_RSK_5min.pValueTS, total_IF_RSK_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK_5min.Beta, total_IF_RSK_5min.q,St_IF_5min,RSK_IF);
[total_IF_RSK240_5min.se, total_IF_RSK240_5min.VC] = intrastandardErrors_spillover(IF_5min, THETA1, total_IF_RSK240_5min.Beta, total_IF_RSK240_5min.q,St_IF_5min,RSK_IF_240);

[total_IC_RSK240_5min.q, total_IC_RSK240_5min.Beta, total_IC_RSK240_5min.fval, total_IC_RSK240_5min.exitflag] = intramvmqcaviar_spillover(IC_5min,THETA1,St_IC_5min,RSK_IC_240);
% [total_IC_RSK_5min.se, total_IC_RSK_5min.TS, total_IC_RSK_5min.pValueTS, total_IC_RSK_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK_5min.Beta, total_IC_RSK_5min.q,St_IC_5min,RSK_IC);
[total_IC_RSK240_5min.se, total_IC_RSK240_5min.VC] = intrastandardErrors_spillover(IC_5min, THETA1, total_IC_RSK240_5min.Beta, total_IC_RSK240_5min.q,St_IC_5min,RSK_IC_240);

[total_IH_RSK240_5min.q, total_IH_RSK240_5min.Beta, total_IH_RSK240_5min.fval, total_IH_RSK240_5min.exitflag] = intramvmqcaviar_spillover(IH_5min,THETA1,St_IH_5min,RSK_IH_240);
% [total_IH_RSK_5min.se, total_IH_RSK_5min.TS, total_IH_RSK_5min.pValueTS, total_IH_RSK_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK_5min.Beta, total_IH_RSK_5min.q,St_IH_5min,RSK_IH);
[total_IH_RSK240_5min.se, total_IH_RSK240_5min.VC] = intrastandardErrors_spillover(IH_5min, THETA1, total_IH_RSK240_5min.Beta, total_IH_RSK240_5min.q,St_IH_5min,RSK_IH_240);

% PATH1='C:\Users\lixup\Desktop\1h\5分钟溢出机制\结果保存1\';
PATH1='C:\Users\lixup\Desktop\1h\5分钟溢出机制\结果保存_不同滚动窗口\';
save([PATH1,'total_IF_RSK30_5min'], 'total_IF_RSK30_5min');
save([PATH1,'total_IC_RSK30_5min'], 'total_IC_RSK30_5min');
save([PATH1,'total_IH_RSK30_5min'], 'total_IH_RSK30_5min');

save([PATH1,'total_IF_RSK60_5min'], 'total_IF_RSK60_5min');
save([PATH1,'total_IC_RSK60_5min'], 'total_IC_RSK60_5min');
save([PATH1,'total_IH_RSK60_5min'], 'total_IH_RSK60_5min');

save([PATH1,'total_IF_RSK120_5min'], 'total_IF_RSK120_5min');
save([PATH1,'total_IC_RSK120_5min'], 'total_IC_RSK120_5min');
save([PATH1,'total_IH_RSK120_5min'], 'total_IH_RSK120_5min');

save([PATH1,'total_IF_RSK240_5min'], 'total_IF_RSK240_5min');
save([PATH1,'total_IC_RSK240_5min'], 'total_IC_RSK240_5min');
save([PATH1,'total_IH_RSK240_5min'], 'total_IH_RSK240_5min');

save([PATH1,'each_quantile_IF'], 'each_quantile_IF');
save([PATH1,'each_quantile_IH'], 'each_quantile_IH');
save([PATH1,'each_quantile_IC'], 'each_quantile_IC');

% [IF_IR1_RSK, IF_IRplusSE1_RSK, IF_IRminusSE1_RSK, IF_se1_RSK] = imref(IF_5min, total_IF_RSK_5min.Beta, RSK_IF, 1, THETA1, 1);
% [IF_IR2_RSK, IF_IRplusSE2_RSK, IF_IRminusSE2_RSK, IF_se2_RSK] = imref(IF_5min, total_IF_RSK_5min.Beta, RSK_IF, 2, THETA1, 1);
% [IH_IR1_RSK, IH_IRplusSE1_RSK, IH_IRminusSE1_RSK, IH_se1_RSK] = imref(IH_5min, total_IH_RSK_5min.Beta, RSK_IH, 1, THETA1, 1);
% [IH_IR2_RSK, IH_IRplusSE2_RSK, IH_IRminusSE2_RSK, IH_se2_RSK] = imref(IH_5min, total_IH_RSK_5min.Beta, RSK_IH, 2, THETA1, 1);
% [IC_IR1_RSK, IC_IRplusSE1_RSK, IC_IRminusSE1_RSK, IC_se1_RSK] = imref(IC_5min, total_IC_RSK_5min.Beta, RSK_IC, 1, THETA1, 1);
% [IC_IR2_RSK, IC_IRplusSE2_RSK, IC_IRminusSE2_RSK, IC_se2_RSK] = imref(IC_5min, total_IC_RSK_5min.Beta, RSK_IC, 2, THETA1, 1);

