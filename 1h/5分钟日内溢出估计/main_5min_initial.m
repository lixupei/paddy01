%%--------------------main_5min_initial--------------------
% %----------加载数据----------

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

% 
IF_5min=48*[IF300index_5min_logreturn,IF300_5min_logreturn];
IH_5min=48*[IH50index_5min_logreturn,IH50_5min_logreturn];
IC_5min=48*[IC500index_5min_logreturn,IC500_5min_logreturn];



%--------------------计算日内效应----------
THETA1=0.05;frequency=5;
for i=1:2
    each_quantile_IF(:,i)=intrayQuantile(IF_5min(97:end,i),THETA1,frequency);%各子区间的平均分位数
    each_quantile_IH(:,i)=intrayQuantile(IH_5min(97:end,i),THETA1,frequency);
    each_quantile_IC(:,i)=intrayQuantile(IC_5min(97:end,i),THETA1,frequency);
end
days=length(IF_5min)/(240/frequency);
St_IF_5min=repmat(each_quantile_IF,days,1);
St_IC_5min=repmat(each_quantile_IC,days,1);
St_IH_5min=repmat(each_quantile_IH,days,1);

[total_IF1_5min.q, total_IF1_5min.Beta, total_IF1_5min.fval, total_IF1_5min.exitflag] = intramvmqcaviar1(IF_5min,THETA1,St_IF_5min);
[total_IF1_5min.se, total_IF1_5min.TS, total_IF1_5min.pValueTS, total_IF1_5min.VC] = intrastandardErrors1(IF_5min, THETA1, total_IF1_5min.Beta, total_IF1_5min.q,St_IF_5min);

[total_IC1_5min.q, total_IC1_5min.Beta, total_IC1_5min.fval, total_IC1_5min.exitflag] = intramvmqcaviar1(IC_5min,THETA1,St_IC_5min);
[total_IC1_5min.se, total_IC1_5min.TS, total_IC1_5min.pValueTS, total_IC1_5min.VC] = intrastandardErrors1(IC_5min, THETA1, total_IC1_5min.Beta, total_IC1_5min.q,St_IC_5min);

[total_IH1_5min.q, total_IH1_5min.Beta, total_IH1_5min.fval, total_IH1_5min.exitflag] = intramvmqcaviar1(IH_5min,THETA1,St_IH_5min);
[total_IH1_5min.se, total_IH1_5min.TS, total_IH1_5min.pValueTS, total_IH1_5min.VC] = intrastandardErrors1(IH_5min, THETA1, total_IH1_5min.Beta, total_IH1_5min.q,St_IH_5min);

PATH1='C:\Users\lixup\Desktop\1h\5分钟日内溢出估计\结果保存_project803\';
save([PATH1,'total_IF1_5min'], 'total_IF1_5min');
save([PATH1,'total_IC1_5min'], 'total_IC1_5min');
save([PATH1,'total_IH1_5min'], 'total_IH1_5min');

[IF_IR1, IF_IRplusSE1, IF_IRminusSE1, IF_se1] = imref(IF_5min, total_IF1_5min.Beta, 1, THETA1, 1);
[IF_IR2, IF_IRplusSE2, IF_IRminusSE2, IF_se2] = imref(IF_5min, total_IF1_5min.Beta, 2, THETA1, 1);
[IH_IR1, IH_IRplusSE1, IH_IRminusSE1, IH_se1] = imref(IH_5min, total_IF1_5min.Beta, 1, THETA1, 1);
[IH_IR2, IH_IRplusSE2, IH_IRminusSE2, IH_se2] = imref(IH_5min, total_IF1_5min.Beta, 2, THETA1, 1);
[IC_IR1, IC_IRplusSE1, IC_IRminusSE1, IC_se1] = imref(IC_5min, total_IF1_5min.Beta, 1, THETA1, 1);
[IC_IR2, IC_IRplusSE2, IC_IRminusSE2, IC_se2] = imref(IC_5min, total_IF1_5min.Beta, 2, THETA1, 1);

