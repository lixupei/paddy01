%%--------------------main_5min--------------------
% %----------加载数据----------
% clc;
% clear;
% PATH='C:\Users\lixup\Desktop\1h\data_mat\';
% load([PATH,'logreturn_CSI500_1hour.mat']);
% load([PATH,'logreturn_HS300_1hour.mat']);
% load([PATH,'logreturn_IC500_1hour.mat']);
% load([PATH,'logreturn_IF300_1hour.mat']);
% load([PATH,'logreturn_IH50_1hour.mat']);
% load([PATH,'logreturn_SZ50_1hour.mat']);
% 
% load([PATH,'logreturn_CSI500_5min.mat']);
% load([PATH,'logreturn_HS300_5min.mat']);
% load([PATH,'logreturn_IC500_5min.mat']);
% load([PATH,'logreturn_IF300_5min.mat']);
% load([PATH,'logreturn_IH50_5min.mat']);
% load([PATH,'logreturn_SZ50_5min.mat']);
% 
% % %----------所有数据按列排列----------
% logreturn_CSI500_1hour=logreturn_CSI500_1hour(:);
% logreturn_HS300_1hour=logreturn_HS300_1hour(:);
% logreturn_IC500_1hour=logreturn_IC500_1hour(:);
% logreturn_IF300_1hour=logreturn_IF300_1hour(:);
% logreturn_IH50_1hour=logreturn_IH50_1hour(:);
% logreturn_SZ50_1hour=logreturn_SZ50_1hour(:);
% logreturn_CSI500_5min=logreturn_CSI500_5min(:);
% logreturn_HS300_5min=logreturn_HS300_5min(:);
% logreturn_IC500_5min=logreturn_IC500_5min(:);
% logreturn_IF300_5min=logreturn_IF300_5min(:);
% logreturn_IH50_5min=logreturn_IH50_5min(:);
% logreturn_SZ50_5min=logreturn_SZ50_5min(:);
% 
% IF_1hour=4*[logreturn_HS300_1hour,logreturn_IF300_1hour];
% IH_1hour=4*[logreturn_SZ50_1hour,logreturn_IH50_1hour];
% IC_1hour=4*[logreturn_CSI500_1hour,logreturn_CSI500_1hour];
% 
% frequency2=5;
% IF_5min=48*[logreturn_HS300_5min,logreturn_IF300_5min];
% IH_5min=48*[logreturn_SZ50_5min,logreturn_IH50_5min];
% IC_5min=48*[logreturn_CSI500_5min,logreturn_IC500_5min];
% 
% %--------------------计算日内效应----------
% THETA1=0.05;frequency=5;
% for i=1:2
%     each_quantile_IF(:,i)=intrayQuantile(IF_5min(:,i),THETA1,frequency);%各子区间的平均分位数
%     each_quantile_IH(:,i)=intrayQuantile(IH_5min(:,i),THETA1,frequency);
%     each_quantile_IC(:,i)=intrayQuantile(IC_5min(:,i),THETA1,frequency);
%     
% end
% days=length(IF_5min)/(240/frequency);
% St_IF_5min=repmat(each_quantile_IF,days,1);
% St_IC_5min=repmat(each_quantile_IC,days,1);
% St_IH_5min=repmat(each_quantile_IH,days,1);
% 
% [total_IF1_5min.q, total_IF1_5min.Beta, total_IF1_5min.fval, total_IF1_5min.exitflag] = intramvmqcaviar1(IF_5min,THETA1,St_IF_5min);
% [total_IF1_5min.se, total_IF1_5min.TS, total_IF1_5min.pValueTS, total_IF1_5min.VC] = intrastandardErrors1(IF_5min, THETA1, total_IF1_5min.Beta, total_IF1_5min.q,St_IF_5min);
% 
% [total_IC1_5min.q, total_IC1_5min.Beta, total_IC1_5min.fval, total_IC1_5min.exitflag] = intramvmqcaviar1(IC_5min,THETA1,St_IC_5min);
% [total_IC1_5min.se, total_IC1_5min.TS, total_IC1_5min.pValueTS, total_IC1_5min.VC] = intrastandardErrors1(IC_5min, THETA1, total_IC1_5min.Beta, total_IC1_5min.q,St_IC_5min);
% 
% [total_IH1_5min.q, total_IH1_5min.Beta, total_IH1_5min.fval, total_IH1_5min.exitflag] = intramvmqcaviar1(IH_5min,THETA1,St_IH_5min);
% [total_IH1_5min.se, total_IH1_5min.TS, total_IH1_5min.pValueTS, total_IH1_5min.VC] = intrastandardErrors1(IH_5min, THETA1, total_IH1_5min.Beta, total_IH1_5min.q,St_IH_5min);
% 
% PATH1='C:\Users\lixup\Desktop\1h\结果保存\';
% save([PATH1,'total_IF1_5min'], 'total_IF1_5min')
% save([PATH1,'total_IC1_5min'], 'total_IC1_5min')
% save([PATH1,'total_IH1_5min'], 'total_IH1_5min')

clear;
clc;
PATH_5min='C:\Users\lixup\Desktop\1h\5分钟数据保存\';
load([PATH_5min,'IF300_5min_logreturn']);
load([PATH_5min,'IF300index_5min_logreturn']);
load([PATH_5min,'IH50_5min_logreturn']);
load([PATH_5min,'IH50index_5min_logreturn']);
load([PATH_5min,'IC500_5min_logreturn']);
load([PATH_5min,'IC500index_5min_logreturn']);

IF_5min=48*[IF300index_5min_logreturn,IF300_5min_logreturn];
IH_5min=48*[IH50index_5min_logreturn,IH50_5min_logreturn];
IC_5min=48*[IC500index_5min_logreturn,IC500_5min_logreturn];

%--------------------计算日内效应----------
THETA1=0.05;frequency=5;
for i=1:2
    each_quantile_IF(:,i)=intrayQuantile(IF_5min(:,i),THETA1,frequency);%各子区间的平均分位数
    each_quantile_IH(:,i)=intrayQuantile(IH_5min(:,i),THETA1,frequency);
    each_quantile_IC(:,i)=intrayQuantile(IC_5min(:,i),THETA1,frequency);
    
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

PATH1='C:\Users\lixup\Desktop\1h\结果保存2\';
save([PATH1,'total_IF1_5min'], 'total_IF1_5min');
save([PATH1,'total_IC1_5min'], 'total_IC1_5min');
save([PATH1,'total_IH1_5min'], 'total_IH1_5min');
