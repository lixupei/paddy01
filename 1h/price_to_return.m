function [return_data,cell_data]=price_to_return(price_data)
%Input: 经clean_data处理后的数据矩阵(包含time open close volume amt)
%Output: 包含时间、开盘价格收益率、收盘价格收益率的矩阵
%cell_data的每个cell为一天的处理后数据矩阵
%本函数主要工作是得到每日9:30-11:29 13:00-15:00的分钟收益率
%特别注意：没有11:30分钟的数据所以
%确保三个指数、三个主力合约得到的收益率长度、时间节点均一致
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP1;将每一天的数据划分到一个cell中
time=price_data(:,1);% yyyy-mm-dd HH:MM:SS
date=unique(fix(time));%日期数列 yyyy-mm-dd 
day_num1=size(date,1);
each_data=cell(day_num1,1);
for i=1:day_num1
    each_data{i}=price_data(min(find(time>=date(i)+1e-10)):max(find(time<date(i)+1-1e-10)),:);
end
if ~all(cellfun(@(x) size(unique(fix(x(:,1))),1),each_data)==1)
    error('将每日数据分割所得的each_data有误！')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STEP2:排除2016/01/04和2016/01/07熔断两天的数据
breaker_day1=datenum('2016-01-04');
breaker_day2=datenum('2016-01-07');
location1=find(date==breaker_day1 | date==breaker_day2);
each_data(location1)=[];
date(location1)=[];
day_num=size(date,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%生成9:30-15:30内的分钟频率数据
each_fulldata=cell(size(each_data,1),1);
for i=1:day_num
    %处理each_data{i}这个N*5矩阵
    opentime1_value=datenum('2016-01-01 09:30:00')-datenum('2016-01-01 00:00:00');%9:30对应数值
    closetime1_value=datenum('2016-01-01 11:30:00')-datenum('2016-01-01 00:00:00');%11:30对应数值
    opentime2_value=datenum('2016-01-01 13:00:00')-datenum('2016-01-01 00:00:00');%13:00对应数值
    closetime2_value=datenum('2016-01-01 15:00:00')-datenum('2016-01-01 00:00:00');%15:00对应数值
    eachminute_value=datenum('2016-01-01 09:31:00')-datenum('2016-01-01 09:30:00');%每分钟时间间隔的对应数值
%STEP3:将数据补齐，使得从开始到结尾中每分钟都有数据
    morning_number=round((closetime1_value-(datenum(each_data{i}(1,1))-datenum(date(i))))/eachminute_value);
    %注意，数据中均无11:30分的数据，所以morning_number没有+1
    afternoon_number=round(((datenum(each_data{i}(end,1))-datenum(date(i)))-opentime2_value)/eachminute_value)+1;
    if morning_number<0 || afternoon_number<1
        error('出现第一个数据在11:30之后，或最后一个数据出现在13:00之前的错误情形');
    end
    each_fulldata{i}=zeros(morning_number+afternoon_number,5);
    each_fulldata{i}(1,:)=each_data{i}(1,:);
    for j=2:morning_number
        each_fulldata{i}(j,1)=each_fulldata{i}(j-1,1)+eachminute_value;
        if min(round(abs(each_fulldata{i}(j,1)-each_data{i}(:,1))/eachminute_value))==0
            %第j笔的时间在each_data中存在
            location=find(round(abs(each_fulldata{i}(j,1)-each_data{i}(:,1))/eachminute_value)==0);
            if isempty(location)
                error('location为空值');
            end
            
            each_fulldata{i}(j,:)=each_data{i}(location,:);
        else
            %第j笔的时间在each_data中不存在,寻找离其最近的前一笔数据
            location=max(find(each_data{i}(:,1)<= each_fulldata{i}(j,1)));
            if isempty(location)
                error('location为空值');
            end  
            each_fulldata{i}(j,2:3)=each_data{i}(location,2:3);%open and close price
            each_fulldata{i}(j,4:5)=[0,0];%volume and amt 
        end
    end
    
    each_fulldata{i}(morning_number+afternoon_number,:)=each_data{i}(end,:);%最后一笔的时间和数据
    for k=1:afternoon_number-1
        each_fulldata{i}(end-k,1)=each_fulldata{i}(end-k+1,1)-eachminute_value;
        if min(round(abs(each_fulldata{i}(end-k,1)-each_data{i}(:,1))/eachminute_value))==0
            %第end-k笔的时间在each_data中存在
            location=find(round(abs(each_fulldata{i}(end-k,1)-each_data{i}(:,1))/eachminute_value)==0);
            if isempty(location)
                error('location为空值');
            end            
            each_fulldata{i}(end-k,:)=each_data{i}(location,:);
        else
            %第end-k笔的时间在each_data中不存在,寻找离其最近的前一笔数据
            location=max(find(each_data{i}(:,1)<= each_fulldata{i}(end-k,1)));
            if isempty(location)
                error('location为空值');
            end  
            each_fulldata{i}(end-k,2:3)=each_data{i}(location,2:3);
            each_fulldata{i}(end-k,4:5)=[0,0];
        end
    end    
 %得到each_fulldata{i}，从开头到11:29,13:00到结尾,每分钟都有数据.       
 
%STEP4:清除头尾，将起止时间调整到9:30和15:00。分析对象变为each_fulldata{i}而不是each_data{i}
    if round((each_fulldata{i}(1,1)-date(i)-opentime1_value)/eachminute_value)<0
        %第一笔交易数据发生在9:30之前
        front_more=round((-each_fulldata{i}(1,1)+date(i)+opentime1_value)/eachminute_value);%超出9:30的样本个数
        each_fulldata{i}(1:front_more,:)=[];
    elseif round((each_fulldata{i}(1,1)-date(i)-opentime1_value)/eachminute_value)>0
        %第一笔交易数据发生在9:30之后
        front_loss=round(-opentime1_value-date(i)+each_fulldata{i}(1,1)/eachminute_value);
        insert_value=zeros(front_loss,5);
        insert_value(:,1)=(date(i)+opentime1_value:eachminute_value:each_fulldata{i}(1,1)-1e-6)';
        insert_value(:,2:3)=repmat(each_fulldata{i}(1,2:3),front_loss,1);
        each_fulldata{i}=[insert_value;each_fulldata{i}];
    end
    
    if round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value)>0
        %最后一笔交易发生在15:00后
        behind_more=round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value);
        each_fulldata{i}(end-behind_more+1:end,:)=[];
    elseif round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value)<0
        %最后一笔交易发生在15:00前
        behind_loss=round((closetime2_value-each_fulldata{i}(end,1)+date(i))/eachminute_value);
        insert_value2=zeros(behind_loss,5);
        insert_value2(:,1)=(each_fulldata{i}(end,1)+eachminute_value:eachminute_value:date(i)+closetime2_value+1e-6);
        insert_value2(:,2:3)=repmat(each_fulldata{i}(end,2:3),behind_loss,1);
        each_fulldata{i}=[each_fulldata{i};insert_value2];
    end
    if round((each_fulldata{i}(1,1)-date(i)-opentime1_value)/eachminute_value)~=0 
        warning([datestr(date(i),'yyyy-mm-dd'),'开盘时间不对！']);
    end
    if round((each_fulldata{i}(end,1)-date(i)-closetime2_value)/eachminute_value)~=0
        warning([datestr(date(i),'yyyy-mm-dd'),'收盘时间不对！']);
    end
    if length(each_fulldata{i})~=241
        warning([datestr(date(i),'yyyy-mm-dd'),'样本个数不对！']);
    end
end
cell_data=each_fulldata;%得到处理后的每日总体数据,9:30-11:29 13:00-15:00共241个数据

%STEP5:将每日price序列转换为对数收益率序列
%r_t=log(P_t)-log(P_(t-1))

cell_openreturn=cellfun(@(x) diff(log(x(:,2))),cell_data,'UniformOutput',0);%开盘价收益率
cell_closereturn=cellfun(@(x) diff(log(x(:,3))),cell_data,'UniformOutput',0);%收盘价收益率
cell_time=cellfun(@(x) x(2:end,1),cell_data,'UniformOutput',0);
%把每个cell的数据叠加
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