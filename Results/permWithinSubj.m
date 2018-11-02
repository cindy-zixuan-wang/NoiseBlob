function permWithinSubj(subjNum)
subj = {'LSC','WZX','JJ','JT','WS'};

% load data & calculate real mean
for i = 1:subjNum
    cd(subj{i});
    load('data_all.mat');
    data_new(:,3*(i-1)+1:3*(i-1)+3) = [mean(data_all(:,1:2),2,'omitnan'),mean(data_all(:,3:4),2,'omitnan'),mean(data_all(:,5:6),2,'omitnan')];
    [r(i,1),p(i,1)]=corr(data_new(:,3*(i-1)+1),data_new(:,3*(i-1)+2));
    [r(i,2),p(i,2)]=corr(data_new(:,3*(i-1)+1),data_new(:,3*(i-1)+3));
    [r(i,3),p(i,3)]=corr(data_new(:,3*(i-1)+2),data_new(:,3*(i-1)+3));
    cd ..;
end
save('r_with.mat','r');
z = (log(1+r)-log(1-r))/2;
meanCorr = tanh(mean(mean(z,1,'omitnan'),'omitnan'))
seCorr = tanh(std(z(:),0,'omitnan')/sqrt(subjNum))

% generate null distribution
for iteration = 1:10000
    randPhase = Randi(48,[subjNum*3,1]);
    for subj = 1:subjNum
        for ecc = 1:5
            if randPhase(3*(subj-1)+1)>1
                data_perm((48*(ecc-1)+1):48*ecc,3*(subj-1)+1)=vertcat(data_new(48*(ecc-1)+randPhase(3*(subj-1)+1):48*ecc,3*(subj-1)+1),...
                    data_new(48*(ecc-1)+1:48*(ecc-1)+randPhase(3*(subj-1)+1)-1,3*(subj-1)+1));
            else
                data_perm(:,3*(subj-1)+1)=data_new(:,3*(subj-1)+1);
            end
            if randPhase(3*(subj-1)+2)>1
                data_perm((48*(ecc-1)+1):48*ecc,3*(subj-1)+2)=vertcat(data_new(48*(ecc-1)+randPhase(3*(subj-1)+2):48*ecc,3*(subj-1)+2),...
                    data_new(48*(ecc-1)+1:48*(ecc-1)+randPhase(3*(subj-1)+2)-1,3*(subj-1)+2));
            else
                data_perm(:,3*(subj-1)+2)=data_new(:,3*(subj-1)+2);
            end
            if randPhase(3*(subj-1)+3)>1
                data_perm((48*(ecc-1)+1):48*ecc,3*(subj-1)+3)=vertcat(data_new(48*(ecc-1)+randPhase(3*(subj-1)+3):48*ecc,3*(subj-1)+3),...
                    data_new(48*(ecc-1)+1:48*(ecc-1)+randPhase(3*(subj-1)+3)-1,3*(subj-1)+3));
            else
                data_perm(:,3*(subj-1)+3)=data_new(:,3*(subj-1)+3);
            end
        end
    end
    for i = 1:subjNum
        [r_perm(i,1),p_perm(i,1)]=corr(data_perm(:,3*(i-1)+1),data_perm(:,3*(i-1)+2));
        [r_perm(i,2),p_perm(i,2)]=corr(data_perm(:,3*(i-1)+1),data_perm(:,3*(i-1)+3));
        [r_perm(i,3),p_perm(i,3)]=corr(data_perm(:,3*(i-1)+2),data_perm(:,3*(i-1)+3)); 
    end
    z_perm = (log(1+r_perm)-log(1-r_perm))/2;
    corrPerm(iteration) = tanh(mean(mean(z_perm,1)));
end

% calculate p value
p_value = sum(corrPerm>meanCorr)/length(corrPerm);
if p_value > .5
    two_tailed_p_value = 2*(1-p_value)
else
    two_tailed_p_value = 2*p_value
end

    
% save
save('corrPermWithin.mat','corrPerm');
save('data_perm.mat','data_perm');
save('data_new.mat','data_new');

end