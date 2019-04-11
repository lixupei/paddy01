function [cell_time_day_5minute,cell_close_day_5minute,logreturn_day_5minute]=intra_5minuteindex_logreturn(date_start,date_end,time_all,close_all)
% [cell_time_day_5minute,cell_close_day_5minute,logreturn_day_5minute]=intra_5minuteindex_logreturn(date_start,date_end,time_all,close_all)
%time_all:时间   close_all:高频收益率数据
if length(time_all)~=length(close_all)
    disp('Warning:The dimension of time and close must consistent!')
end

date_start=datenum(date_start);
date_end=datenum(date_end);
time_all=datenum(time_all);
    
location_start = min(find(floor(time_all)==date_start));
location_end =  max(find(floor(time_all)==date_end));

date_choose=time_all(location_start:location_end+1);
close_choose=close_all(location_start:location_end+1);

time_vec=datevec(date_choose);
j=1;k=1;
time_day={};
close_day={};

for i=1:length(date_choose)-1
    if time_vec(i,3)==time_vec(i+1,3)
       time_day{k,j}= time_vec(i,:);
       close_day{k,j}=close_choose(i,:);
       k=k+1;
    end
    if time_vec(i,3)~=time_vec(i+1,3)
       time_day{k,j}= time_vec(i,:);
       close_day{k,j}=close_choose(i,:);
       j=j+1;
       k=1;
    end
    if i==length(time_all)-1
       time_day{k,j}= time_vec(i+1,:);
       close_day{k,j}=close_choose(i+1,:);
    end
end 

[row,column]=size(time_day);

location_choose=0:5:55;

for j=1:column
    k=1;
    for i=1:row
        if time_day{i,j}(4)==9&&ismember(time_day{i,j}(5),location_choose(7:end))
           cell_time_day_5minute{k,j}=time_day{i,j};
           cell_close_day_5minute{k,j}=close_day{i,j};
           k=k+1;
        end
        if time_day{i,j}(4)==10&&ismember(time_day{i,j}(5),location_choose)
           cell_time_day_5minute{k,j}=time_day{i,j};
           cell_close_day_5minute{k,j}=close_day{i,j};
           k=k+1;
        end
        if time_day{i,j}(4)==11&&ismember(time_day{i,j}(5),[location_choose,29])
            cell_time_day_5minute{k,j}=time_day{i,j};
            cell_close_day_5minute{k,j}=close_day{i,j};
            k=k+1;
        end
        if time_day{i,j}(4)==13&&ismember(time_day{i,j}(5),location_choose(2:end))
            cell_time_day_5minute{k,j}=time_day{i,j};
            cell_close_day_5minute{k,j}=close_day{i,j};
            k=k+1;
        end
        if time_day{i,j}(4)==14&&ismember(time_day{i,j}(5),location_choose)
            cell_time_day_5minute{k,j}=time_day{i,j};
            cell_close_day_5minute{k,j}=close_day{i,j};
            k=k+1;
        end
        if time_day{i,j}(4)==15&&ismember(time_day{i,j}(5),location_choose)
            cell_time_day_5minute{k,j}=time_day{i,j};
            cell_close_day_5minute{k,j}=close_day{i,j};
            k=k+1;
        end        
    end
end
double_close_day_5minute=cell2mat(cell_close_day_5minute);
for j=1:column
    logreturn_day_5minute(:,j)=log(double_close_day_5minute(2:end,j))-log(double_close_day_5minute(1:end-1,j));
end
end

    