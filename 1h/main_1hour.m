%%--------------------main_1hour--------------------

%----------加载数据----------
clc;
clear;
PATH='C:\Users\lixup\Desktop\1h\data_mat\';
load([PATH,'logreturn_CSI500_1hour.mat']);
load([PATH,'logreturn_HS300_1hour.mat']);
load([PATH,'logreturn_IC500_1hour.mat']);
load([PATH,'logreturn_IF300_1hour.mat']);
load([PATH,'logreturn_IH50_1hour.mat']);
load([PATH,'logreturn_SZ50_1hour.mat']);

load([PATH,'logreturn_CSI500_5min.mat']);
load([PATH,'logreturn_HS300_5min.mat']);
load([PATH,'logreturn_IC500_5min.mat']);
load([PATH,'logreturn_IF300_5min.mat']);
load([PATH,'logreturn_IH50_5min.mat']);
load([PATH,'logreturn_SZ50_5min.mat']);


% %----------所有数据按列排列----------
logreturn_CSI500_1hour=logreturn_CSI500_1hour(:);
logreturn_HS300_1hour=logreturn_HS300_1hour(:);
logreturn_IC500_1hour=logreturn_IC500_1hour(:);
logreturn_IF300_1hour=logreturn_IF300_1hour(:);
logreturn_IH50_1hour=logreturn_IH50_1hour(:);
logreturn_SZ50_1hour=logreturn_SZ50_1hour(:);
logreturn_CSI500_5min=logreturn_CSI500_5min(:);
logreturn_HS300_5min=logreturn_HS300_5min(:);
logreturn_IC500_5min=logreturn_IC500_5min(:);
logreturn_IF300_5min=logreturn_IF300_5min(:);
logreturn_IH50_5min=logreturn_IH50_5min(:);
logreturn_SZ50_5min=logreturn_SZ50_5min(:);

IF_1hour=4*[logreturn_HS300_1hour,logreturn_IF300_1hour];
IH_1hour=4*[logreturn_SZ50_1hour,logreturn_IH50_1hour];
IC_1hour=4*[logreturn_CSI500_1hour,logreturn_CSI500_1hour];

frequency2=5;
IF_5min=48*[logreturn_HS300_5min,logreturn_IF300_5min];
IH_5min=48*[logreturn_SZ50_5min,logreturn_IH50_5min];
IC_5min=48*[logreturn_CSI500_5min,logreturn_IC500_5min];

%--------------------计算日内效应----------
THETA1=0.05;frequency=60;
for i=1:2
    each_quantile_IF(:,i)=intrayQuantile(IF_1hour(:,i),THETA1,frequency);%各子区间的平均分位数
    each_quantile_IH(:,i)=intrayQuantile(IH_1hour(:,i),THETA1,frequency);
    each_quantile_IC(:,i)=intrayQuantile(IC_1hour(:,i),THETA1,frequency);
    
end
days=length(IF_1hour)/(240/frequency);
St_IF=repmat(each_quantile_IF,days,1);
St_IC=repmat(each_quantile_IC,days,1);
St_IH=repmat(each_quantile_IH,days,1);

[total_IF1.q, total_IF1.Beta, total_IF1.fval, total_IF1.exitflag] = intramvmqcaviar1(IF_1hour,THETA1,St_IF);
[total_IF1.se, total_IF1.TS, total_IF1.pValueTS, total_IF1.VC] = intrastandardErrors1(IF_1hour, THETA1, total_IF1.Beta, total_IF1.q,St_IF);

[total_IC1.q, total_IC1.Beta, total_IC1.fval, total_IC1.exitflag] = intramvmqcaviar1(IC_1hour,THETA1,St_IC);
[total_IC1.se, total_IC1.TS, total_IC1.pValueTS, total_IC1.VC] = intrastandardErrors1(IC_1hour, THETA1, total_IC1.Beta, total_IC1.q,St_IC);

[total_IH1.q, total_IH1.Beta, total_IH1.fval, total_IH1.exitflag] = intramvmqcaviar1(IH_1hour,THETA1,St_IH);
[total_IH1.se, total_IH1.TS, total_IH1.pValueTS, total_IH1.VC] = intrastandardErrors1(IH_1hour, THETA1, total_IH1.Beta, total_IH1.q,St_IH);