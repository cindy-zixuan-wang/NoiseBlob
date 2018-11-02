function analyzeNbSensitivity(subjName,secNum)
%% Type 1: std between sections
% load data
cd(subjName)
load('data_all.mat')
errorData = data_all;
% for section = 1:secNum
%     tmp_mat{section}=csvread([subjName,'_',num2str(section),'data_output.csv']);
%     tmp_mat{section}(1,:)=[];
%     errorData(:,section) = tmp_mat{section}(:,3);
% end

% calculate mean error
% meanError = mean(errorData,2);
% save('data_mean.mat','meanError')
% meanError = abs(meanError);

% caclulate error variance
stdError = std(errorData,0,2);

% % correlation
% [r,p] = corr(meanError,stdError)
% 
% % draw plot
% figure;
% hold on
% scatter(meanError,stdError)
% fitline = polyfit(meanError,stdError,1)
% plot(meanError,fitline(1)*meanError+fitline(2))

% draw plot
figure;
hold on;
for ecc = 2:5
    plot(7.5:7.5:360,stdError(48*(ecc-1)+1:48*ecc,:));
end
close(gcf);

figure;
% plot(7.5:7.5:360,mean([stdError(1:48,1),stdError(49:96,1),stdError(97:144,1),stdError(145:192,1),stdError(193:240,1)],2))
plot(7.5:7.5:360,mean([stdError(49:96,1),stdError(97:144,1),stdError(145:192,1),stdError(193:240,1)],2))
close(gcf);
% save the std data
save('std_sections.mat','stdError');

%% Type 2: std across trials
% load data
load('allTrials.mat');
for section = 1:secNum
    allTrials{section} =  allTrials{section}';
    data(:,(2*section-1):2*section) = [allTrials{section}(:,1:2);allTrials{section}(:,3:4);...
        allTrials{section}(:,5:6);allTrials{section}(:,7:8);allTrials{section}(:,9:10)];
end
% caclulate error variance
stdErrorAll = std(data,0,2);

% plot
figure;
hold on;
for ecc = 2:5
    plot(7.5:7.5:360,stdErrorAll(48*(ecc-1)+1:48*ecc,:));
end
saveas(gcf,[subjName,'_acuityAllLoc_Trialwise'],'png');
% close(gcf);

% mean std across different ecc
meanSTD = mean([stdErrorAll(1:48,1),stdErrorAll(49:96,1),stdErrorAll(97:144,1),stdErrorAll(145:192,1),stdErrorAll(193:240,1)],2);
%meanSTD = mean([stdErrorAll(49:96,1),stdErrorAll(97:144,1),stdErrorAll(145:192,1),stdErrorAll(193:240,1)],2);
figure;
plot(7.5:7.5:360,meanSTD);
hold on;
scatter([90:90:360],meanSTD([12:12:48],1));
saveas(gcf,[subjName,'_acuityAllAngles_Trialwise'],'png');
% close(gcf);

    
cd ..;
end