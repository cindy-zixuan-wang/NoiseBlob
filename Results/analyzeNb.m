function analysis=analyzeNb(subjName,sec)
%% load
if ~exist('subjName','var')
    subjName = 'WZX';
end
if ~exist('sec','var')
    sec = 6;
end
cd(subjName);
for section = 1:sec
load([subjName,'_',num2str(section),'.mat']);

%% Angular Error
% angular correction
analysis.angErrors = history.respAngle'-params.all_trials(:,1);
for i = 1:length(analysis.angErrors)
    if abs(analysis.angErrors(i)) >= 180
        analysis.angErrors(i) = (1-2*(analysis.angErrors(i)>0))*(360-abs(analysis.angErrors(i)));
    end
end

% clear outliers
analysis.angErrorsSD = std(analysis.angErrors);
analysis.angErrorsMean = mean(analysis.angErrors);
% analysis.angErrors(analysis.angErrors> (analysis.angErrorsMean + 3*analysis.angErrorsSD)) = analysis.angErrorsMean;
% analysis.angErrors(analysis.angErrors< (analysis.angErrorsMean - 3*analysis.angErrorsSD)) = analysis.angErrorsMean;

% calculate mean angular errors
analysis.angErrorsMat = [analysis.angErrors,params.all_trials(:,1)];
analysis.angErrorsMat = sortrows(analysis.angErrorsMat,2);
for i = 1:48
    tmpMat_2{i} = analysis.angErrorsMat(2*i-1:2*i,1);
    analysis.angErrorsMean(i) = mean(tmpMat_2{i},'omitnan');
end


% % draw angular error plot
% plot(params.stimAngles,analysis.angErrorsMean);
% 
% % save figure
% savefig([subjName,'_',num2str(section),'_angErrorsPlot']);
% close(gcf);

%% Eccentricity Error
% different eccentricity
analysis.stimEccAll = params.all_trials(:,2);
pixelsPerDeg = mean([display.numPixels(1)/(2*rad2deg(atan(display.dimensions(1)/2/display.distance))),...
    display.numPixels(2)/(2*rad2deg(atan(display.dimensions(2)/2/display.distance)))]);
analysis.respEcc = sqrt((history.mouse_x-display.centerCoords(1)).^2+(history.mouse_y-display.centerCoords(2)).^2)/pixelsPerDeg;
analysis.eccErrors = analysis.respEcc' - analysis.stimEccAll;

% clear outliers
analysis.eccErrorsSD = std(analysis.eccErrors);
analysis.eccErrorsMean = mean(analysis.eccErrors);
analysis.eccErrors(analysis.eccErrors> (analysis.eccErrorsMean + 3*analysis.eccErrorsSD)) = NaN;
analysis.eccErrors(analysis.eccErrors< (analysis.eccErrorsMean - 3*analysis.eccErrorsSD)) = NaN;

% calculate mean ecc errors
analysis.eccErrorsMat = [analysis.eccErrors,analysis.stimEccAll];
analysis.eccErrorsMat = sortrows(analysis.eccErrorsMat,2);
for i = 1:length(params.stimEcc)
    tmpMat{i} = analysis.eccErrorsMat(analysis.eccErrorsMat(:,2)==2*i);
    analysis.eccErrorsMean(i) = mean(tmpMat{i},'omitnan');
end
clear tmpMat;
% 
% % draw ecc error plot
% scatter(params.stimEcc,analysis.eccErrorsMean);
% 
% % save figure
% savefig([subjName,'_',num2str(section),'_eccErrorsPlot']);
% close(gcf);


%% Angular Error with Different Eccentricities
% angular errors with different eccs
analysis.errorsMat = [analysis.angErrors,analysis.stimEccAll];
analysis.condMat = [params.all_trials(:,1),analysis.stimEccAll];
trialMat = [analysis.angErrors,params.all_trials(:,1),analysis.stimEccAll];
trialMat = sortrows(trialMat,3);
analysis.errorsMat = sortrows(analysis.errorsMat,2);
analysis.condMat = sortrows(analysis.condMat,2);
for i = 1:length(params.stimEcc)
    tmpMat{i}(:,1) = analysis.errorsMat((96*(i-1)+1:96*i),1);
    tmpMat{i}(:,2) = analysis.condMat((96*(i-1)+1:96*i),1);
    tmpMat{i} = sortrows(tmpMat{i},2);
    for j = 1:48
        allTrials{i}(j,(2*section-1):2*section) = tmpMat{i}(tmpMat{i}(:,2)==7.5*j);
%         analysis.diffEccErrorsMean(i,j) = mean(allTrialsSorted((2*i-1):2*i,j),'omitnan');
        analysis.diffEccErrorsMean(i,j) = mean(allTrials{i}(j,(2*section-1):2*section),'omitnan');
    end
end
save('angAllTrials.mat','allTrials');
analysis.diffEccErrorsMeanNew = analysis.diffEccErrorsMean';
for i = 1:240/48
    tmp_3(:,i)=2*i*ones(1,48);
end
analysis.allEccs = tmp_3(:);
analysis.allAngles = repmat([7.5:7.5:360]',5,1);
analysis.saveMattrix = [analysis.allAngles,analysis.allEccs,analysis.diffEccErrorsMeanNew(:)];
if isfile('data_all.mat')
    load('data_all.mat');
    data_all(:,section) = analysis.saveMattrix(:,3);
else
    data_all(:,section) = analysis.saveMattrix(:,3);
end
save('data_all.mat','data_all');

% % draw diff ecc ang error plot
% figure;
% hold on;
% for figNum = 1:length(params.stimEcc)
%     plot(params.stimAngles,analysis.diffEccErrorsMean(figNum,:)');
% end
% % save figure
% savefig([subjName,'_',num2str(section),'_angDiffEccErrorsPlot']);
% close(gcf);

%% Ecc Error with Different Eccentricities
analysis.errorsMatNew = [analysis.eccErrors,analysis.stimEccAll];
analysis.condMatNew = [params.all_trials(:,1),analysis.stimEccAll];
trialMat = [analysis.eccErrors,params.all_trials(:,1),analysis.stimEccAll];
trialMat = sortrows(trialMat,3);
analysis.errorsMatNew = sortrows(analysis.errorsMatNew,2);
analysis.condMatNew = sortrows(analysis.condMatNew,2);
for i = 1:length(params.stimEcc)
    tmpMat{i}(:,1) = analysis.errorsMatNew((96*(i-1)+1:96*i),1);
    tmpMat{i}(:,2) = analysis.condMatNew((96*(i-1)+1:96*i),1);
    tmpMat{i} = sortrows(tmpMat{i},2);
    for j = 1:48
        allTrials_ecc{i}(j,(2*section-1):2*section) = tmpMat{i}(tmpMat{i}(:,2)==7.5*j);
%         analysis.diffEccErrorsMean(i,j) = mean(allTrialsSorted((2*i-1):2*i,j),'omitnan');
        analysis.wholeEccErrorsMean(i,j) = mean(allTrials_ecc{i}(j,(2*section-1):2*section),'omitnan');
    end
end
save('eccAllTrials.mat','allTrials_ecc');

% save all ecc errors together
analysis.wholeEccErrorsMeanNew = analysis.wholeEccErrorsMean';
if isfile('data_all_ecc.mat')
    load('data_all_ecc.mat');
    data_all_ecc(:,section) = analysis.wholeEccErrorsMeanNew(:);
else
    data_all_ecc(:,section) = analysis.wholeEccErrorsMeanNew(:);
end
save('data_all_ecc.mat','data_all_ecc');

save([subjName,'_',num2str(section),'AllAnalysisVars'])
end    

%% draw final plots
% draw diff ecc ang error plot
figure;
hold on;
load('data_')
for figNum = 1:length(params.stimEcc)
    plot(params.stimAngles,analysis.diffEccErrorsMean(figNum,:)');
end
% save figure
savefig([subjName,'_',num2str(section),'_angDiffEccErrorsPlot']);
close(gcf);



%% sort out all trials
%% save one subject's data together
% ang errors
data_mean(:,3) = mean(data_all,2,'omitnan');
data_mean(:,1:2) = analysis.saveMattrix(:,1:2);
csvwrite(['ang_data_mean.csv'],data_mean,1,0);
    
% ecc errors
data_mean_ecc(:,3) = mean(data_all_ecc,2,'omitnan');
data_mean_ecc(:,1:2) = analysis.saveMattrix(:,1:2);
csvwrite(['ecc_data_mean.csv'],data_mean_ecc,1,0);
cd ..;
end