%%--------------------main_2_RS-----------------------
tic;
clc;
clear;
PATH_interval='C:\Users\lixup\Desktop\1h\1分钟数据保存\给定时间区间\';

load([PATH_interval,'IF300index_day_logreturn.mat'])
load([PATH_interval,'IF300_day_logreturn.mat'])
load([PATH_interval,'IH50index_day_logreturn.mat'])
load([PATH_interval,'IH50_day_logreturn.mat'])
load([PATH_interval,'IC500index_day_logreturn.mat'])
load([PATH_interval,'IC500_day_logreturn.mat'])


THETA1=0.05;
THETA2=0.95;

IF_day=[IF300index_day_logreturn,IF300_day_logreturn];
IH_day=[IH50index_day_logreturn,IH50_day_logreturn];
IC_day=[IC500index_day_logreturn,IC500_day_logreturn];

% Insample=550;
[HS300_IF300_day.q, HS300_IF300_day.Beta,HS300_IF300_day.fval,HS300_IF300_day.exitflag]=mvmqcaviar(IF_day,THETA1);
[SZ50_IH50_day.q, SZ50_IH50_day.Beta,SZ50_IH50_day.fval,SZ50_IH50_day.exitflag]=mvmqcaviar(IH_day,THETA1);
[CSI500_IC500_day.q, CSI500_IC500_day.Beta,CSI500_IC500_day.fval,CSI500_IC500_day.exitflag]=mvmqcaviar(IC_day,THETA1);


%%--------------------计算标准误--------------------
[HS300_IF300_day.se, HS300_IF300_day.TS, HS300_IF300_day.pValue, HS300_IF300_day.VC] = standardErrors(IF_day,THETA1,HS300_IF300_day.Beta, HS300_IF300_day.q);
[SZ50_IH50_day.se, SZ50_IH50_day.TS, SZ50_IH50_day.pValue, SZ50_IH50_day.VC] = standardErrors(IH_day,THETA1,SZ50_IH50_day.Beta,SZ50_IH50_day.q);
[CSI500_IC500_day.se, CSI500_IC500_day.TS, CSI500_IC500_day.pValue, CSI500_IC500_day.VC] = standardErrors(IC_day,THETA1,CSI500_IC500_day.Beta,CSI500_IC500_day.q);

save(['C:\Users\lixup\Desktop\1h\日度溢出估计\结果保存_project803\HS300_IF300_day'],'HS300_IF300_day');
save(['C:\Users\lixup\Desktop\1h\日度溢出估计\结果保存_project803\SZ50_IH50_day'],'SZ50_IH50_day');
save(['C:\Users\lixup\Desktop\1h\日度溢出估计\结果保存_project803\CSI500_IC500_day'],'CSI500_IC500_day');

[IF_IR1_day, IF_IRplusSE1_day, IF_IRminusSE1_day, IF_se1_day] = imref(IF_day, HS300_IF300_day.Beta, 1, THETA1, 1);
[IF_IR2_day, IF_IRplusSE2_day, IF_IRminusSE2_day, IF_se2_day] = imref(IF_day, HS300_IF300_day.Beta, 2, THETA1, 1);
[IH_IR1_day, IH_IRplusSE1_day, IH_IRminusSE1_day, IH_se1_day] = imref(IH_day, SZ50_IH50_day.Beta, 1, THETA1, 1);
[IH_IR2_day, IH_IRplusSE2_day, IH_IRminusSE2_day, IH_se2_day] = imref(IH_day, SZ50_IH50_day.Beta, 2, THETA1, 1);
[IC_IR1_day, IC_IRplusSE1_day, IC_IRminusSE1_day, IC_se1_day] = imref(IC_day, CSI500_IC500_day.Beta, 1, THETA1, 1);
[IC_IR2_day, IC_IRplusSE2_day, IC_IRminusSE2_day, IC_se2_day] = imref(IC_day, CSI500_IC500_day.Beta, 2, THETA1, 1);
