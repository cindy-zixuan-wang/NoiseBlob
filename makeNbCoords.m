function params = makeNbCoords(params,display)
% Fixation & Stimulus locations
params.stimRect=[0 0 params.stimSize params.stimSize];
params.fixLoc = [display.centerCoords-angle2pix(display,params.fixSize/2),...
    display.centerCoords+angle2pix(display,params.fixSize/2)];

% Set up list of x,y coordinates corresponding to angles
params.Xoffset=display.centerCoords(1)+ params.all_trials(:,1).*cos(deg2rad(params.all_trials(:,2))); 
params.Yoffset=display.centerCoords(2)+ params.all_trials(:,1).*sin(deg2rad(params.all_trials(:,2)));

% stimuli locations
params.stimLoc=CenterRectOnPoint(params.stimRect,params.Xoffset,params.Yoffset); % Center stimulus on all points
end