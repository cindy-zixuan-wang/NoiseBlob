function analyzeNbWithGabor(subjName) %correlate NoiseBlob with Gabor
for subj = 1:length(subjName)    
    % load data
    cd(subjName{subj});
    load('data_all.mat');
    data_mean_1{subj} = mean(data_all,2);
    cd ..;
    dataByDay{subj}(:,1:3) = [mean(data_all(:,1:2),2),mean(data_all(:,3:4),2),mean(data_all(:,5:6),2)];
    
    cd(['/Users/zixuan/Box/Position ZW/diffEcc/Gabor/Results/',subjName{subj}]);
    load('data_all.mat');
    data_mean_2{subj} = mean(data_all,2);
    cd('/Users/zixuan/Box/Position ZW/diffEcc/NoiseBlob/Results');
    dataByDay{subj}(:,4:6) = [mean(data_all(:,1:2),2),mean(data_all(:,3:4),2),mean(data_all(:,5:6),2)];
    save('analyzeNbWithGabor.mat');
    % within-subject correlation
    % bootstrapping
    for iteration = 1:1000
        dataSample =  [dataByDay{subj}(:,randsample(3,3)),dataByDay{subj}(:,randsample(4:6,3))];          
        [r(1),p(iteration,1)]=corr(dataSample(:,1),dataSample(:,4));
        [r(2),p(iteration,2)]=corr(dataSample(:,2),dataSample(:,5));
        [r(3),p(iteration,3)]=corr(dataSample(:,3),dataSample(:,6));
        mean_z(iteration) = mean((log(1+r)-log(1-r))/2);
        r_within(iteration) = tanh(mean_z(iteration));
    end
    r_bootstrap(subj) = mean(r_within);
end
r_mean_within = mean(r_bootstrap)

% between-subject correlation
    % between-subject correlation
    for i = 1:subj
        for j = 1:subj
        [r_btw,p_btw] = corr(data_mean_1{i},data_mean_2{j});
        btwExpBtwSubjZ(i,j) = (log(1+r_btw)-log(1-r_btw))/2;
            if i == j
                 btwExpBtwSubjZ(i,j) = NaN;
            end
        end
    end
r_mean_btw = tanh(mean(btwExpBtwSubjZ(:),'omitnan'))
r_se_btw = tanh(std(btwExpBtwSubjZ(:),'omitnan')/sqrt(length(subjName)))

save('analyzeNbWithGabor.mat');
end