% all kinds of correlation for angular errors
clear all;
clc;
subj = {'LSC','WZX','JJ','JT','WS'};
subjNum = length(subj);
% load data & calculate real mean
for i = 1:subjNum
    cd(subj{i});
    load('data_all.mat');
%     load('data_all_ecc.mat');
%     data_all = data_all_ecc;
    dataAllSubj(:,i) = mean(data_all,2);
    dataByDay{i}(:,1:3) = [mean(data_all(:,1:2),2),mean(data_all(:,3:4),2),mean(data_all(:,5:6),2)];
    dataBySection{i}(:,1:6) = data_all;
    cd ..;
end
%% Within-subject correlation
% trial-wise

% section-wise

% day-wise
% all data
clear r p z;
for i = 1:subjNum
    [r(i,1),p(i,1)]=corr(dataByDay{i}(:,1),dataByDay{i}(:,2));
    [r(i,2),p(i,2)]=corr(dataByDay{i}(:,1),dataByDay{i}(:,3));
    [r(i,3),p(i,3)]=corr(dataByDay{i}(:,2),dataByDay{i}(:,3));
end
z = (log(1+r)-log(1-r))/2;
zWithinDayAll = z; %each subj in a row
meanWithinDayAll = tanh(mean(mean(z,1,'omitnan'),'omitnan'));

% all data but fovea
clear r p z;
for i = 1:subjNum
    [r(i,1),p(i,1)]=corr(dataByDay{i}(49:end,1),dataByDay{i}(49:end,2));
    [r(i,2),p(i,2)]=corr(dataByDay{i}(49:end,1),dataByDay{i}(49:end,3));
    [r(i,3),p(i,3)]=corr(dataByDay{i}(49:end,2),dataByDay{i}(49:end,3));
end
z = (log(1+r)-log(1-r))/2;
meanWithinDayNoFovea = tanh(mean(mean(z,1,'omitnan'),'omitnan'));

% every ecc
clear r p z;
for i = 1:subjNum
    for ecc = 1:5
        [r(3*ecc-2,i),p(3*ecc-2,i)]=corr(dataByDay{i}((48*ecc-47):48*ecc,1),dataByDay{i}((48*ecc-47):48*ecc,2));
        [r(3*ecc-1,i),p(3*ecc-1,i)]=corr(dataByDay{i}((48*ecc-47):48*ecc,1),dataByDay{i}((48*ecc-47):48*ecc,3));
        [r(3*ecc,i),p(3*ecc,i)]=corr(dataByDay{i}((48*ecc-47):48*ecc,2),dataByDay{i}((48*ecc-47):48*ecc,3));
    end
end
z = (log(1+r)-log(1-r))/2;
for ecc = 1:5
    meanWithinDayEcc(ecc) = tanh(mean(mean(z((3*ecc-2):3*ecc,:),1,'omitnan'),'omitnan'));
end

%% Between-subject correlation
% day-wise
% all data
clear r p z;
for i = 1:subjNum
    for j = 1:subjNum
        if i<j
            for  day_1 = 1:3
                for day_2 = 1:3
                    [r{i,j}(day_1,day_2),p{i,j}(day_1,day_2)]=corr(dataByDay{i}(:,day_1),dataByDay{j}(:,day_2));
                end
            end          
            z{i,j} = (log(1+r{i,j})-log(1-r{i,j}))/2;
            meanFisherZ(i,j) = mean(mean(z{i,j},1,'omitnan'),'omitnan');
        else
            meanFisherZ(i,j) = NaN;
        end
    end
end
meanBtwDayAll = tanh(mean(mean(meanFisherZ,'omitnan'),'omitnan'));

% subject-wise
% all data
clear r p z;
for i = 1:subjNum
    for j = 1:subjNum
        [r(i,j),p(i,j)]=corr(dataAllSubj(:,i),dataAllSubj(:,j));
        if i>=j
            r(i,j)=NaN;
            p(i,j)=NaN;
        end
    end
end
z = (log(1+r)-log(1-r))/2;
meanFisherZ = mean(mean(z,1,'omitnan'),'omitnan');
meanBtwSubjAll = tanh(meanFisherZ);
% no fovea
clear r p z;
for i = 1:subjNum
    for j = 1:subjNum
        [r(i,j),p(i,j)]=corr(dataAllSubj(49:end,i),dataAllSubj(49:end,j));
        if i>=j
            r(i,j)=NaN;
            p(i,j)=NaN;
        end
    end
end
z = (log(1+r)-log(1-r))/2;
meanFisherZ = mean(mean(z,1,'omitnan'),'omitnan');
meanBtwSubjNoFovea = tanh(meanFisherZ);
% every ecc
clear r p z;
for i = 1:subjNum
    for j = 1:subjNum
        for ecc = 1:5
            if i < j
                [r{ecc}(i,j),p{ecc}(i,j)]=corr(dataAllSubj(48*ecc-47:48*ecc,i),dataAllSubj(48*ecc-47:48*ecc,j));   
            else
                r{ecc}(i,j) = NaN;
            end
            z{ecc} = (log(1+r{ecc})-log(1-r{ecc}))/2;
        end
    end
end
for ecc = 1:5
    meanFisherZ(ecc) = mean(mean(z{ecc},1,'omitnan'),'omitnan');
end
meanBtwSubjEcc = tanh(meanFisherZ);

%% Bootstrap
% Day-wise
% Within
clear zSample r p z
for iteration = 1:1000
    for subj = 1:subjNum
        zSample(subj,:) = zWithinDayAll(subj,randsample(3,3,true));
    end
    bootWithinDayAll(iteration) = tanh(mean(mean(zSample,1,'omitnan'),'omitnan'));
end
bootWithinDayAll_sorted = sort(bootWithinDayAll);
meanBootWithinDayAll = mean(bootWithinDayAll);
CIBootWithinDayAll = bootWithinDayAll_sorted([iteration*0.025,iteration*0.975]);
errBarWithinDayAll = abs(CIBootWithinDayAll-meanBootWithinDayAll);
% Between
clear zSample r p z
for iteration = 1:1000   
    for subj = 1:subjNum
        sampleDataByDay{subj} = dataByDay{subj}(:,randsample(3,3,true));
    end
    for i = 1:subjNum
        for j = 1:subjNum
            if i<j
                for  day_1 = 1:3
                    for day_2 = 1:3
                        [r{i,j}(day_1,day_2),p{i,j}(day_1,day_2)]=corr(sampleDataByDay{i}(:,day_1),sampleDataByDay{j}(:,day_2));
                    end
                end          
                z{i,j} = (log(1+r{i,j})-log(1-r{i,j}))/2;
                meanFisherZ(i,j) = mean(mean(z{i,j},1,'omitnan'),'omitnan');
            else
                meanFisherZ(i,j) = NaN;
            end
        end
    end
    bootBtwDayAll(iteration) = tanh(mean(mean(meanFisherZ,1,'omitnan'),'omitnan'));
end
bootBtwDayAll_sorted = sort(bootBtwDayAll);
meanBootBtwDayAll = mean(bootBtwDayAll);
CIBootBtwDayAll = bootBtwDayAll_sorted([iteration*0.025,iteration*0.975]);
errBarBtwDayAll = abs(CIBootBtwDayAll-meanBootBtwDayAll);
% p value
bootDiffDistribution = bootWithinDayAll-bootBtwDayAll;
bootPValue = sum(bootDiffDistribution>0)/length(bootDiffDistribution);
if bootPValue < .5
    bootTwoTailedP = bootPValue*2;
else
    bootTwoTailedP = (1-bootPValue)*2;
end
% plot
h = bar([meanBootWithinDayAll,meanBootBtwDayAll]);
h.FaceColor = [0.75,0.75,0.75];
h.EdgeColor = 'none';
hold on;
H=errorbar([1,2],[meanBootWithinDayAll,meanBootBtwDayAll],...
    [errBarWithinDayAll(1),errBarBtwDayAll(1)],...
    [errBarWithinDayAll(2),errBarBtwDayAll(2)]);
H.LineStyle ='none';
H.Color = [0 0 0];
ax = gca;
ax.XTickLabel = {'Within-subject','Between-subject'};
ax.YLabel.String = 'Correlation (Pearson R)';
ax.Title.String='Exp 1B Results';
text(1.5, .76,'Error bar represents bootstrapping 95% CI');
% saveas(gcf,'Exp1BEccResults','png');
saveas(gcf,'Exp1BAngResults','png');