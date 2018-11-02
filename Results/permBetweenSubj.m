function permBetweenSubj(subjNum)

subj = {'LSC','WZX','JJ','JT','WS'};

% load data & calculate real mean
for i = 1:subjNum
    cd(subj{i});
    load('data_all.mat');
    dataAllSubj(:,i) = mean(data_all,2);
    dataByDay{i}(:,1:3) = [mean(data_all(:,1:2),2),mean(data_all(:,3:4),2),mean(data_all(:,5:6),2)];
    cd ..;
end



% % simulation
% dataAllSubj = [1:240;240:-1:1;1:240]';

% real mean
for i = 1:subjNum
    for j = 1:subjNum
        [r(i,j),p(i,j)]=corr(dataAllSubj(:,i),dataAllSubj(:,j));
        if i>=j
            r(i,j)=NaN;
            p(i,j)=NaN;
        end
    end
end
save('r_between.mat','r');
z = (log(1+r)-log(1-r))/2;
meanFisherZ = mean(mean(z,1,'omitnan'),'omitnan');
meanCorr = tanh(meanFisherZ)
seCorr = tanh(std(z(:),0,'omitnan')/sqrt(subjNum));

% generate null distribution
% for iteration = 1:10000
%     randPhase = Randi(48,[subjNum,1]);
%     for subj = 1:subjNum
%         for ecc = 1:5
%             if randPhase(subj)>1
%                 data_perm((48*(ecc-1)+1):48*ecc,subj)=vertcat(dataAllSubj(48*(ecc-1)+randPhase(subj):48*ecc,subj),dataAllSubj(48*(ecc-1)+1:48*(ecc-1)+randPhase(subj)-1,subj));
%             else
%                 data_perm(:,subj)=dataAllSubj(:,subj);
%             end
%         end
%     end
%     for i = 1:subjNum
%         for j = 1:subjNum
%             [r_perm(i,j),p_perm(i,j)]=corr(data_perm(:,i),data_perm(:,j));
%             if i>=j
%                 r_perm(i,j)=NaN;
%                 p_perm(i,j)=NaN;
%             end
%         end
%     end
%     z_perm = (log(1+r_perm)-log(1-r_perm))/2;
%     corrPerm(iteration) = tanh(mean(mean(z_perm,1,'omitnan'),'omitnan'));
% end
% 
% % calculate p value
% p_value = sum(corrPerm>meanCorr)/length(corrPerm);
% if p_value > .5
%     two_tailed_p_value = 2*(1-p_value)
% else
%     two_tailed_p_value = 2*p_value
% end
% 
% % plot mean angular errors
% figure;
% hold on;
% colors={[0 1 0],'r','b','y',[.61 .51 .74]};
% for img = 1:subjNum
%     angleErrors(:,img) = mean([dataAllSubj(1:48,img),dataAllSubj(49:96,img),dataAllSubj(97:144,img),dataAllSubj(145:192,img),dataAllSubj(193:240,img)],2);
%     angleErrorsSE(img,:) =  std([dataAllSubj(1:48,img),dataAllSubj(49:96,img),dataAllSubj(97:144,img),dataAllSubj(145:192,img),dataAllSubj(193:240,img)],0,2)/sqrt(subjNum);
%     plot(7.5:7.5:360,angleErrors(:,img));
%     shadedErrorBar(7.5:7.5:360,angleErrors(:,img),angleErrorsSE(img,:),'lineprops',{'markerfacecolor',colors{img}});
% end
% close(gcf);
% % plot mean angular errors on different ecc
% figure;
% hold on;
% for img = 1:subjNum
%     for ecc = 1:5
%         plot(7.5:7.5:360,dataAllSubj(48*(ecc-1)+1:48*ecc,img));
%     end
% end
% close(gcf);
% 
% % plot mean eccentricity errors
% figure;
% hold on;
% for img = 1:subjNum
%     eccErrors(:,img) = mean([dataAllSubj(1:48,img),dataAllSubj(49:96,img),dataAllSubj(97:144,img),dataAllSubj(145:192,img),dataAllSubj(193:240,img)],1);
%     plot(2:2:10,eccErrors(:,img));
% end
% close(gcf);
%     
% % save
% save('corrPermBetween.mat','corrPerm')
end
