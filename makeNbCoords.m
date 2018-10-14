function params = makeNbCoords(params,display)
% Fixation & Stimulus locations
params.stimRect=[0 0 params.stimSize params.stimSize];
params.fixRect = [display.centerCoords-angle2pix(display,params.stimSize),];
    

% Set up list of x,y coordinates corresponding to angles
Xoffset=centerCoords(1)+ allConditionRand(:,1).*cos(deg2rad(allConditionRand(:,2))); 
Yoffset=centerCoords(2)+ allConditionRand(:,1).*sin(deg2rad(allConditionRand(:,2)));

%fix_rect=[0 0 0 0];
stimPositions=CenterRectOnPoint(params.stimRect,Xoffset,Yoffset); % Center stimulus on all points
end