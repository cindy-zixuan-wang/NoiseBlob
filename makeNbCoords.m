function params = makeNbCoords(params,display)
% Fixation & Stimulus locations
params.stimRect=[0 0 angle2pix(display,params.stimSize) angle2pix(display,params.stimSize)];
params.fixLoc = [display.centerCoords-angle2pix(display,params.fixSize/2),...
    display.centerCoords+angle2pix(display,params.fixSize/2)];

% Set up list of x,y coordinates corresponding to angles
params.Xoffset=display.centerCoords(1)+ angle2pix(display,params.all_trials(:,2)).*cos(deg2rad(params.all_trials(:,1))); 
params.Yoffset=display.centerCoords(2)+ angle2pix(display,params.all_trials(:,2)).*sin(deg2rad(params.all_trials(:,1)));

% stimuli locations
params.stimLoc=CenterRectOnPoint(params.stimRect,params.Xoffset,params.Yoffset); % Center stimulus on all points
end