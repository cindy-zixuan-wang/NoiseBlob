function permWB(subjName)
subjNum = length(subjName);
% load correlation
for i = 1:subjNum
    cd(subjName{i});
    load('data_all.mat');
    data_mean(:,3*(i-1)+1:3*(i-1)+3) = [mean(data_all(:,1:2),2,'omitnan'),mean(data_all(:,3:4),2,'omitnan'),mean(data_all(:,5:6),2,'omitnan')];
end

% real difference
realDiff = mean(mean(r_within,1))-mean(mean(r_between,1,'omitnan'),'omitnan')

% load individual data
for i = 1:subjNum
    cd(subj{i});
    load('data_all.mat');
    data_mean(:,3*(i-1)+1:3*(i-1)+3) = [mean(data_all(:,1:2),2),mean(data_all(:,3:4),2),mean(data_all(:,5:6),2)];
    cd ..;
end

% diff distribution
for iteration = 1:2
    permDist(iteration) = randsample(r_within,1)-randsample(r_within,1)
end