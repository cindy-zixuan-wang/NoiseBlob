function [params,display] = getNbParams

params.subjID = input('Enter subject ID: ','s');
params.subjSession = input('Enter session number: ');
params.computer = input('Enter testing computer: 1 for booth, 2 for laptop ');

%stimulus parameters
params.gaussSD = 0.75;%.1;%1;%*(9.5/7);%deg
params.stimSize = 5;%5*(9.5/7); %width of half the texture (deg)
params.circMaskRadius = 2.44; %deg
stimAngle = 7.5;
params.stimAngles = stimAngle:stimAngle:360; %angles relative to the center of the screen
params.stimEcc = 2:2:10;%9.5;%7;

display = getNbDisplay(params);
%gabor parameters
params.gaborSF = .5;%%cpd
params.gaborPhase = 0; %initial phase in radians
params.gaborTF = 5;%5 temporal frequency (Hz)
params.phaseInterval = 2*pi*(params.gaborTF/display.refresh); %phase shift in radians per frame
params.gaborDur = (1/display.refresh)*round((2*pi)/(params.phaseInterval)); %duration of entire cycle;don't change this
params.gaborFrames = (params.gaborDur/(1/display.refresh));
% params.halfCycle = params.gaborFrames/2+1;
params.cycleDur = ((pi/params.phaseInterval)*(1/display.refresh)); %time it takes to complete one cycle

%textured blob parameters
params.texSize = 50; %number of elements on each side of random number matrix (will be scaled up to match size of texture)
params.textSize = 25;
%duration parameters
params.ITI = 1;
params.ISI = .5;
params.stimDur = .05;%2;%.05;%2;%.05;%1;%.05;%.25;%4;

% size parameters
params.fixSize = 0.3;
params.respDotSize = 0.45;

% set up experiment table
stimConds = fullfact([length(params.stimAngles) length(params.stimEcc)]); %unique stimulus conditions
params.trialsPerCond = 2;%2;%2;%5;%4;%2;%5
params.all_trials =repmat(stimConds,params.trialsPerCond,1);
params.all_trials(:,1) = params.stimAngles(params.all_trials(:,1));
params.all_trials(:,2) = params.stimEcc(params.all_trials(:,2));
params.all_trials = params.all_trials(randperm(size(params.all_trials,1)),:);
params.nTrials = length(params.all_trials);
params.breakFrequency = 60;

% key map
KbName('UnifyKeyNames')

% save pathway
params.curFolder = pwd;
params.filename = ['Results/' params.subjID];
end