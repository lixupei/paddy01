%%--------------------将原始csv数据转换为mat数据--------------------
clear;
clc;
path='C:\Users\lixup\Desktop\1h\data_csv\';
filename={'CSI300minute.csv';'SZ50minute.csv';'CSI500minute.csv';...
    'IF300minute.csv';'IH50minute.csv';'IC500minute.csv'};
namespace={'CSI300minute';'SZ50minute';'CSI500minute';...
    'IF300minute';'IH50minute';'IC500minute'};
M=length(filename);
for i=1:M
    fid=fopen([path,filename{i}]);
    eval([namespace{i},'= textscan(fid,''%s %f %f %f %f %f %f %f %f %f'',''delimiter'','','', ''HeaderLines'',1);']);    
    fclose(fid);
end

middlename={'time';'open';'close';'high';'low';'volume';'amt';'chg';'pctchg';'preclose'};
N=length(middlename);
for i=1:M
    for j=1:N
        eval([namespace{i},middlename{j},'_all=',namespace{i},'{j};'])
    end
end

save('data_index_future_update')
        







