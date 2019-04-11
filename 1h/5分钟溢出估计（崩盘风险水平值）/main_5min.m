%%--------------------main_5min--------------------
clear;
clc;
PATH_5min='C:\Users\lixup\Desktop\1h\5�������ݱ���\';
PATH_RSK='C:\Users\lixup\Desktop\1h\5���ӹ���������ʵ��ƫ��\�������\';
PATH_interval='C:\Users\lixup\Desktop\1h\1�������ݱ���\����ʱ������\';

load([PATH_interval,'IF300_5min_logreturn']);
load([PATH_interval,'IF300index_5min_logreturn']);
load([PATH_interval,'IH50_5min_logreturn']);
load([PATH_interval,'IH50index_5min_logreturn']);
load([PATH_interval,'IC500_5min_logreturn']);
load([PATH_interval,'IC500index_5min_logreturn']);

load([PATH_interval,'RSK_IF300index']);
load([PATH_interval,'RSK_IF300']);
load([PATH_interval,'RSK_IH50index']);
load([PATH_interval,'RSK_IH50']);
load([PATH_interval,'RSK_IC500index']);
load([PATH_interval,'RSK_IC500']);

IF_5min=48*[IF300index_5min_logreturn,IF300_5min_logreturn];
IH_5min=48*[IH50index_5min_logreturn,IH50_5min_logreturn];
IC_5min=48*[IC500index_5min_logreturn,IC500_5min_logreturn];

%--------------------��������ЧӦ----------
THETA1=0.05;frequency=5;
for i=1:2
    each_quantile_IF(:,i)=intrayQuantile(IF_5min(1:end,i),THETA1,frequency);%���������ƽ����λ��
    each_quantile_IH(:,i)=intrayQuantile(IH_5min(1:end,i),THETA1,frequency);
    each_quantile_IC(:,i)=intrayQuantile(IC_5min(1:end,i),THETA1,frequency);
end
days=length(IF_5min)/(240/frequency);
St_IF_5min=repmat(each_quantile_IF,days,1);
St_IC_5min=repmat(each_quantile_IC,days,1);
St_IH_5min=repmat(each_quantile_IH,days,1);

RSK_IF=[RSK_IF300index,RSK_IF300];
RSK_IH=[RSK_IH50index,RSK_IH50];
RSK_IC=[RSK_IC500index,RSK_IC500];

[total_IF_RSK_5min.q, total_IF_RSK_5min.Beta, total_IF_RSK_5min.fval, total_IF_RSK_5min.exitflag] = intramvmqcaviar_level(IF_5min,THETA1,St_IF_5min,RSK_IF);
[total_IF_RSK_5min.se, total_IF_RSK_5min.TS, total_IF_RSK_5min.pValueTS, total_IF_RSK_5min.VC] = intrastandardErrors_level(IF_5min, THETA1, total_IF_RSK_5min.Beta, total_IF_RSK_5min.q,St_IF_5min,RSK_IF);

[total_IC_RSK_5min.q, total_IC_RSK_5min.Beta, total_IC_RSK_5min.fval, total_IC_RSK_5min.exitflag] = intramvmqcaviar_level(IC_5min,THETA1,St_IC_5min,RSK_IC);
[total_IC_RSK_5min.se, total_IC_RSK_5min.TS, total_IC_RSK_5min.pValueTS, total_IC_RSK_5min.VC] = intrastandardErrors_level(IC_5min, THETA1, total_IC_RSK_5min.Beta, total_IC_RSK_5min.q,St_IC_5min,RSK_IC);

[total_IH_RSK_5min.q, total_IH_RSK_5min.Beta, total_IH_RSK_5min.fval, total_IH_RSK_5min.exitflag] = intramvmqcaviar_level(IH_5min,THETA1,St_IH_5min,RSK_IH);
[total_IH_RSK_5min.se, total_IH_RSK_5min.TS, total_IH_RSK_5min.pValueTS, total_IH_RSK_5min.VC] = intrastandardErrors_level(IH_5min, THETA1, total_IH_RSK_5min.Beta, total_IH_RSK_5min.q,St_IH_5min,RSK_IH);

PATH1='C:\Users\lixup\Desktop\1h\5����������ƣ����̷���ˮƽֵ��\�������_project\';
save([PATH1,'total_IF_RSK_5min'], 'total_IF_RSK_5min');
save([PATH1,'total_IC_RSK_5min'], 'total_IC_RSK_5min');
save([PATH1,'total_IH_RSK_5min'], 'total_IH_RSK_5min');

save([PATH1,'each_quantile_IF'], 'each_quantile_IF');
save([PATH1,'each_quantile_IH'], 'each_quantile_IH');
save([PATH1,'each_quantile_IC'], 'each_quantile_IC');

[IF_IR1_RSK, IF_IRplusSE1_RSK, IF_IRminusSE1_RSK, IF_se1_RSK] = imref(IF_5min, total_IF_RSK_5min.Beta, RSK_IF, 1, THETA1, 1);
[IF_IR2_RSK, IF_IRplusSE2_RSK, IF_IRminusSE2_RSK, IF_se2_RSK] = imref(IF_5min, total_IF_RSK_5min.Beta, RSK_IF, 2, THETA1, 1);
[IH_IR1_RSK, IH_IRplusSE1_RSK, IH_IRminusSE1_RSK, IH_se1_RSK] = imref(IH_5min, total_IH_RSK_5min.Beta, RSK_IH, 1, THETA1, 1);
[IH_IR2_RSK, IH_IRplusSE2_RSK, IH_IRminusSE2_RSK, IH_se2_RSK] = imref(IH_5min, total_IH_RSK_5min.Beta, RSK_IH, 2, THETA1, 1);
[IC_IR1_RSK, IC_IRplusSE1_RSK, IC_IRminusSE1_RSK, IC_se1_RSK] = imref(IC_5min, total_IC_RSK_5min.Beta, RSK_IC, 1, THETA1, 1);
[IC_IR2_RSK, IC_IRplusSE2_RSK, IC_IRminusSE2_RSK, IC_se2_RSK] = imref(IC_5min, total_IC_RSK_5min.Beta, RSK_IC, 2, THETA1, 1);

