function [return_data,cell_data]=price_to_return(price_data)
%Input: ��clean_data���������ݾ���(����time open close volume amt)
%Output: ����ʱ�䡢���̼۸������ʡ����̼۸������ʵľ���
%cell_data��ÿ��cellΪһ��Ĵ�������ݾ���
%��������Ҫ�����ǵõ�ÿ��9:30-11:29 13:00-15:00�ķ���������
%�ر�ע�⣺û��11:30���ӵ���������
%ȷ������ָ��������������Լ�õ��������ʳ��ȡ�ʱ��ڵ��һ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP1;��ÿһ������ݻ��ֵ�һ��cell��
time=price_data(:,1);% yyyy-mm-dd HH:MM:SS
date=unique(fix(time));%�������� yyyy-mm-dd 
day_num1=size(date,1);
each_data=cell(day_num1,1);
for i=1:day_num1
    each_data{i}=price_data(min(find(time>=date(i)+1e-10)):max(find(time<date(i)+1-1e-10)),:);
end
if ~all(cellfun(@(x) size(unique(fix(x(:,1))),1),each_data)==1)
    error('��ÿ�����ݷָ����õ�each_data����')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP2:�ų�2016/01/04��2016/01/07�۶����������
breaker_day1=datenum('2016-01-04');
breaker_day2=datenum('2016-01-07');
location1=find(date==breaker_day1 | date==breaker_day2);
each_data(location1)=[];
date(location1)=[];
day_num=size(date,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����9:30-15:30�ڵķ���Ƶ������
each_fulldata=cell(size(each_data,1),1);
for i=1:day_num
    %����each_data{i}���N*5����
    opentime1_value=datenum('2016-01-01 09:30:00')-datenum('2016-01-01 00:00:00');%9:30��Ӧ��ֵ
    closetime1_value=datenum('2016-01-01 11:30:00')-datenum('2016-01-01 00:00:00');%11:30��Ӧ��ֵ
    opentime2_value=datenum('2016-01-01 13:00:00')-datenum('2016-01-01 00:00:00');%13:00��Ӧ��ֵ
    closetime2_value=datenum('2016-01-01 15:00:00')-datenum('2016-01-01 00:00:00');%15:00��Ӧ��ֵ
    eachminute_value=datenum('2016-01-01 09:31:00')-datenum('2016-01-01 09:30:00');%ÿ����ʱ�����Ķ�Ӧ��ֵ
%STEP3:�����ݲ��룬ʹ�ôӿ�ʼ����β��ÿ���Ӷ�������
    morning_number=round((closetime1_value-(datenum(each_data{i}(1,1))-datenum(date(i))))/eachminute_value);
    %ע�⣬�����о���11:30�ֵ����ݣ�����morning_numberû��+1
    afternoon_number=round(((datenum(each_data{i}(end,1))-datenum(date(i)))-opentime2_value)/eachminute_value)+1;
    if morning_number<0 || afternoon_number<1
        error('���ֵ�һ��������11:30֮�󣬻����һ�����ݳ�����13:00֮ǰ�Ĵ�������');
    end
    each_fulldata{i}=zeros(morning_number+afternoon_number,5);
    each_fulldata{i}(1,:)=each_data{i}(1,:);
    for j=2:morning_number
        each_fulldata{i}(j,1)=each_fulldata{i}(j-1,1)+eachminute_value;
        if min(round(abs(each_fulldata{i}(j,1)-each_data{i}(:,1))/eachminute_value))==0
            %��j�ʵ�ʱ����each_data�д���
            location=find(round(abs(each_fulldata{i}(j,1)-each_data{i}(:,1))/eachminute_value)==0);
            if isempty(location)
                error('locationΪ��ֵ');
            end
            
            each_fulldata{i}(j,:)=each_data{i}(location,:);
        else
            %��j�ʵ�ʱ����each_data�в�����,Ѱ�����������ǰһ������
            location=max(find(each_data{i}(:,1)<= each_fulldata{i}(j,1)));
            if isempty(location)
                error('locationΪ��ֵ');
            end  
            each_fulldata{i}(j,2:3)=each_data{i}(location,2:3);%open and close price
            each_fulldata{i}(j,4:5)=[0,0];%volume and amt 
        end
    end
    
    each_fulldata{i}(morning_number+afternoon_number,:)=each_data{i}(end,:);%���һ�ʵ�ʱ�������
    for k=1:afternoon_number-1
        each_fulldata{i}(end-k,1)=each_fulldata{i}(end-k+1,1)-eachminute_value;
        if min(round(abs(each_fulldata{i}(end-k,1)-each_data{i}(:,1))/eachminute_value))==0
            %��end-k�ʵ�ʱ����each_data�д���
            location=find(round(abs(each_fulldata{i}(end-k,1)-each_data{i}(:,1))/eachminute_value)==0);
            if isempty(location)
                error('locationΪ��ֵ');
            end            
            each_fulldata{i}(end-k,:)=each_data{i}(location,:);
        else
            %��end-k�ʵ�ʱ����each_data�в�����,Ѱ�����������ǰһ������
            location=max(find(each_data{i}(:,1)<= each_fulldata{i}(end-k,1)));
            if isempty(location)
                error('locationΪ��ֵ');
            end  
            each_fulldata{i}(end-k,2:3)=each_data{i}(location,2:3);
            each_fulldata{i}(end-k,4:5)=[0,0];
        end
    end    
 %�õ�each_fulldata{i}���ӿ�ͷ��11:29,13:00����β,ÿ���Ӷ�������.       
 
%STEP4:���ͷβ������ֹʱ�������9:30��15:00�����������Ϊeach_fulldata{i}������each_data{i}
    if round((each_fulldata{i}(1,1)-date(i)-opentime1_value)/eachminute_value)<0
        %��һ�ʽ������ݷ�����9:30֮ǰ
        front_more=round((-each_fulldata{i}(1,1)+date(i)+opentime1_value)/eachminute_value);%����9:30����������
        each_fulldata{i}(1:front_more,:)=[];
    elseif round((each_fulldata{i}(1,1)-date(i)-opentime1_value)/eachminute_value)>0
        %��һ�ʽ������ݷ�����9:30֮��
        front_loss=round(-opentime1_value-date(i)+each_fulldata{i}(1,1)/eachminute_value);
        insert_value=zeros(front_loss,5);
        insert_value(:,1)=(date(i)+opentime1_value:eachminute_value:each_fulldata{i}(1,1)-1e-6)';
        insert_value(:,2:3)=repmat(each_fulldata{i}(1,2:3),front_loss,1);
        each_fulldata{i}=[insert_value;each_fulldata{i}];
    end
    
    if round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value)>0
        %���һ�ʽ��׷�����15:00��
        behind_more=round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value);
        each_fulldata{i}(end-behind_more+1:end,:)=[];
    elseif round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value)<0
        %���һ�ʽ��׷�����15:00ǰ
        behind_loss=round((closetime2_value-each_fulldata{i}(end,1)+date(i))/eachminute_value);
        insert_value2=zeros(behind_loss,5);
        insert_value2(:,1)=(each_fulldata{i}(end,1)+eachminute_value:eachminute_value:date(i)+closetime2_value+1e-6);
        insert_value2(:,2:3)=repmat(each_fulldata{i}(end,2:3),behind_loss,1);
        each_fulldata{i}=[each_fulldata{i};insert_value2];
    end
    if round((each_fulldata{i}(1,1)-date(i)-opentime1_value)/eachminute_value)~=0 
        warning([datestr(date(i),'yyyy-mm-dd'),'����ʱ�䲻�ԣ�']);
    end
    if round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value)~=0
        warning([datestr(date(i),'yyyy-mm-dd'),'����ʱ�䲻�ԣ�']);
    end
    if length(each_fulldata{i})~=241
        warning([datestr(date(i),'yyyy-mm-dd'),'�����������ԣ�']);
    end
end
cell_data=each_fulldata;%�õ�������ÿ����������,9:30-11:29 13:00-15:00��241������

%STEP5:��ÿ��price����ת��Ϊ��������������
%r_t=log(P_t)-log(P_(t-1))

cell_openreturn=cellfun(@(x) diff(log(x(:,2))),cell_data,'UniformOutput',0);%���̼�������
cell_closereturn=cellfun(@(x) diff(log(x(:,3))),cell_data,'UniformOutput',0);%���̼�������
cell_time=cellfun(@(x) x(2:end,1),cell_data,'UniformOutput',0);
%��ÿ��cell�����ݵ���
openreturn=cell_openreturn{1};
closereturn=cell_closereturn{1};
timestamp=cell_time{1};
for i=2:size(cell_openreturn,1)
    openreturn=[openreturn;cell_openreturn{i}];
    closereturn=[closereturn;cell_closereturn{i}];
    timestamp=[timestamp;cell_time{i}];
end

return_data=[timestamp,openreturn,closereturn];       

end