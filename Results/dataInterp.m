% data interpolation
clear;
clc;
subjList = {'WZX','LSC','JJ','JT','WS'};
for i = 1:length(subjList)
    cd(subjList{i});
    load('data_all.mat');
    for section = 1:6
        for ecc = 1:5
            data_new{i}(192*ecc-191:192*ecc,section) = interp1([0:7.5:360],[data_all(48*ecc,section);data_all(48*ecc-47:48*ecc,section)],[1.875:1.875:360]);
        end
    end
    data_interp(:,1)=repmat([1.875:1.875:360]',5,1);
    data_interp(:,2) = [2*ones(192,1);4*ones(192,1);6*ones(192,1);8*ones(192,1);10*ones(192,1)];
    data_interp(:,3) = mean(data_new{i},2);
    csvwrite('data_interp.csv',data_interp,1,0);
    cd ..;
end