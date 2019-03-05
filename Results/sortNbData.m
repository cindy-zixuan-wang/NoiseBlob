function sortedData = sortNbData(subjList)
if ~exist('subjList')
%     subjList = {'WZX','JT','WS','JJ','LSC'};
     subjList = {'WZX'};
end
for subj = 1:length(subjList)
    cd(subjList{subj});
    for section = 1:6
        load([subjList{subj},'_',num2str(section),'.mat']);
        xyMat = [history.mouse_x',history.mouse_y',params.all_trials];
        xyMat = sortrows(xyMat,4);
        xyMat_target = [params.Xoffset,params.Yoffset,params.all_trials];
        xyMat_target = sortrows(xyMat_target,4);
        
        for ecc = 1:5
            xMat = sortrows(xyMat(96*(ecc-1)+1:96*ecc,[1,3]),2);
            yMat = sortrows(xyMat(96*(ecc-1)+1:96*ecc,[2,3]),2);
            
            xMat_target = sortrows(xyMat_target(96*(ecc-1)+1:96*ecc,[1,3]),2);
            yMat_target = sortrows(xyMat_target(96*(ecc-1)+1:96*ecc,[2,3]),2);
              for ang = 1:48
                    xMat_sort{section,subj}(ang,ecc) = mean(xMat(2*(ang-1)+1:2*ang,1));
                    yMat_sort{section,subj}(ang,ecc) = mean(yMat(2*(ang-1)+1:2*ang,1));
                    sortedData.targetX(ang,ecc) = mean(xMat_target(2*(ang-1)+1:2*ang,1));
                   sortedData.targetY(ang,ecc) = mean(yMat_target(2*(ang-1)+1:2*ang,1));
              end
        end
    end
    
    % section
    for section =1:6
            sortedData.sortedAllX(:,section) = xMat_sort{section,subj}(:);
            sortedData.sortedAllY(:,section) = yMat_sort{section,subj}(:);
    end
sortedData.sortedMeanX = mean(sortedData.sortedAllX(:,1:6),2);
sortedData.sortedMeanY = mean(sortedData.sortedAllY(:,1:6),2);
sortedData.targetX = sortedData.targetX(:);
sortedData.targetY = sortedData.targetY(:);

% % plot
% figure;
% hold on;
% for ecc = 1:5
%     H = plot(sortedData.targetX([48*(ecc-1)+1:48*ecc,48*(ecc-1)+1]),sortedData.targetY([48*(ecc-1)+1:48*ecc,48*(ecc-1)+1]));
%     set(H,'Color',[0.2 0.2 0.2], 'LineWidth',0.75,'LineStyle','--');
% end

% % scatter(params.Xoffset,params.Yoffset);
% for ecc = 1:5
%     H = plot(sortedData.sortedMeanX([48*(ecc-1)+1:48*ecc,48*(ecc-1)+1]),sortedData.sortedMeanY([48*(ecc-1)+1:48*ecc,48*(ecc-1)+1]));
%     set(H,'Color',[.6 .35 0], 'LineWidth',2,'LineStyle','-');
% end

% 
% saveas(gcf,'overlapMap.png');

% connection
meanRespAngle =rad2deg(atan2((sortedData.sortedMeanY-display.centerCoords(2)), sortedData.sortedMeanX-display.centerCoords(1)));
meanRespAngle(meanRespAngle<0) = 360 + meanRespAngle(meanRespAngle<0);
angErrors = meanRespAngle - repmat([7.5:7.5:360]',5,1);
for i = 1:length(angErrors)
    if abs(angErrors(i)) >= 180
        angErrors(i) = (1-2*(angErrors(i)>0))*(360-abs(angErrors(i)));
    end
end
mean_positive = mean(angErrors(angErrors>=0));
std_positive  = std(angErrors(angErrors>=0));
max_positive = max(angErrors(angErrors>=0));
min_positive = min(angErrors(angErrors>=0));
mean_negative = mean(angErrors(angErrors<0));
std_negative  = std(angErrors(angErrors<0));
max_negative = max(angErrors(angErrors<0));
min_negative = min(angErrors(angErrors<0));

for i = 1:length(angErrors)
    if angErrors(i) >= 0
        standardizedErrors(i) = (angErrors(i)-min_positive)/(max_positive - min_positive);
    else
        standardizedErrors(i) = (angErrors(i)-min_negative)/(max_negative - min_negative);
    end
end
figure;
for i = 97:144
%     H = plot([sortedData.sortedMeanX(i),sortedData.targetX(i)],[sortedData.sortedMeanY(i),sortedData.targetY(i)]);
    if angErrors(i) >= 0
        lineColor = [1,1-standardizedErrors(i),1-standardizedErrors(i)];
    else
        lineColor = [1-standardizedErrors(i),1-standardizedErrors(i),1];
    end
    d = 6;
    k = (sortedData.targetX(i)-sortedData.sortedMeanX(i))/(sortedData.targetY(i)-sortedData.sortedMeanY(i));
    y = [sortedData.targetY(i)-d/sqrt((1/k)^2+1),sortedData.targetY(i)+d/sqrt((1/k)^2+1)];
    x = -(y-sortedData.targetY(i))./k+sortedData.targetX(i);
    H=fill([sortedData.sortedMeanX(i,1),x],[sortedData.sortedMeanY(i,1),y],lineColor);
    set(H,'EdgeColor',[1 1 1]);
    hold on;
    H=plot([sortedData.sortedMeanX(i,1),x(1)],[sortedData.sortedMeanY(i,1),y(1)]);
    set(H,'Color',[0 0 0],'LineWidth',1);
    H=plot([sortedData.sortedMeanX(i,1),x(2)],[sortedData.sortedMeanY(i,1),y(2)]);
    set(H,'Color',[0 0 0],'LineWidth',1);
    if i <49
        lineWidth = 3;
    elseif i <97
        lineWidth = 5;
    elseif i < 145
        lineWidth = 7;
    elseif i < 193
        lineWidth = 8;
    else
        lineWidth = 9;
    end
%     lineColor = [.5 .5 .5];
%     lineWidth = 3;
%     set(H,'Color',lineColor,'LineWidth',lineWidth);
end
cd ..;
% saveas(gcf,[subjList{subj},'_triMap.png']);
end
% save('allAna.mat');
end