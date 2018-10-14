 function [params,display] = getPosParams

params.subjID = input('Enter subject ID: ','s');
params.cursorResponse = input('Central arrow (0), cursor (1), constrained cursor (2), PowerMate(3), or key adjustment (4) response? ');
params.refDots = input('Custom ref dots(2), random reference dots(1) or none(0)?: ');
params.constrainedRef = 0;
if params.refDots == 2;
    params.customLocs = input('Input dot locations:','s');
    params.customLocs = str2num(params.customLocs);
    params.nRefDots = length(params.customLocs);
elseif params.refDots == 1
    params.nRefDots = input('Enter # of dots: ');
    params.constrainedRef = input('Constrained (1) or unconstrained (0) on wheel?');
else
    params.nRefDots=15;
end

if params.refDots>0
    params.constantDots = input('Constant dots (1) or brief(0)?: ');
end

if params.cursorResponse == 0 
    params.angleInc = 1;
elseif params.cursorResponse == 4
    params.angleInc = .5;
end

params.showMask = input('Mask on (1) or off (0)? ');
params.maskElementSize = 6; %px
params.maskDur = .5;

%detect which computer is being used
[~,comp_name] = system('hostname');
if strcmp(comp_name(1:5) ,'Zixua') %laptop
    params.computer = 2;
else
    params.computer = 1;
end

display = getPosDisplay(params);

params.textSize = 24;

%luminance parameters
params.l_mean = display.gray;
params.noiseBg = 0; %1 for noise background, 0 for solid background
params.offset = 1;

%fixation parameters
params.fix_size = .25; %diameter (deg)
params.circle_size = .35; %diameter
params.refDotSize = .3;%1;%.3; %diameter
params.refDotColor = [255 255 255];

params.refDur = .2;
params.refISI = .2;
%stimulus parameters
params.stimType = 2;% 1 for Gabor, 2 for textured blob
params.noiseType = 2;%1 for low contrast, not binary, 2 for high contrast, binary
if params.noiseType == 1
    params.stimContrast = .85;%gabor or texture contrast (maximum)
else
    params.stimContrast = 1;
end

params.gaussSD = 1;%.1;%1;%*(9.5/7);%deg
params.stimSize = 5;%5*(9.5/7); %width of half the texture (deg)
params.nStim = 4;%number of textures
params.circMaskRadius = 3.25; %deg
params.stimAngles = linspace(0,360,params.nStim+1); %angles relative to the center of the screen
% params.stimAngles = linspace(0,360,params.nStim+1)+45; %angles relative to the center of the screen
params.stimAngles = params.stimAngles(1:params.nStim);
params.whichStim = 1; %which stimuli are actually shown
% params.whichStim = 3; %which stimuli are actually shown
% params.eccUVF = linspace(-30,-30,8); %replaced this with angles
% params.eccUVF = linspace(-180,180,49);
params.eccUVF = linspace(-180,180,49);
% params.eccUVF = linspace(0,180,26);
% params.eccUVF = linspace(-60,30,10);
% params.eccUVF = linspace(-150,-60,10);
% params.eccUVF = linspace(-90,0,10);

% params.eccUVF = linspace(-150,-60,10);
params.eccUVF = params.eccUVF(1:end-1);
params.eccLVF = [min(params.eccUVF) max(params.eccUVF)];
params.stimEcc = 7;%9.5;%7;

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
params.texShift = sqrt((((params.gaborTF/params.gaborSF)/display.refresh)^2)/2);%deg
params.texSize = 50; %number of elements on each side of random number matrix (will be scaled up to match size of texture)


if params.stimType == 1
    params.stimOrientations = [45 135 45 135];
else
    params.stimOrientations = [0 90 0 90];
end


params.lineLength = 1.25;
params.arrowHeight = .4;



% if params.noiseBlob == 1
%     params.gratingRadius = params.gratingRadius*2;
% end

% motion conditions
% params.motion_cond = [0 -1 1]0; %static, inward, outward
params.motion_cond = [0 0 0];

%duration parameters
params.ITI = 1;
params.ISI = .5;
params.stimDurMot = .05;%2;%.05;%2;%.05;%1;%.05;%.25;%4;%.150; % duration stimulus is up
params.stimDurStatic = .05;%2;%.05;%2;%.05;%1;%.05;%.25;%4;
params.allStaticDurs = [.05 .05];%[2 2];%[.05 .05];%[2 2];%[.05 .05];%[1 1];%[.05 .05];%[.25 .25];%[.25 4];
params.stimFramesShown = [params.stimDurStatic/(1/display.refresh) params.stimDurMot/(1/display.refresh) params.stimDurMot/(1/display.refresh)];

% set up experiment table
stimConds = fullfact([length(params.eccLVF) length(params.eccUVF) length(params.motion_cond)]); %unique stimulus conditions
params.trialsPerCond = 2;%2;%2;%5;%4;%2;%5

params.all_trials =repmat(stimConds',1,params.trialsPerCond);
params.all_trials = [params.eccLVF(params.all_trials(1,:)); params.eccUVF(params.all_trials(2,:)); params.motion_cond(params.all_trials(3,:))];
trialOrder = randperm(length(params.all_trials));
params.all_trials = params.all_trials(:,trialOrder);

if params.constrainedRef == 1
    params.all_trials = [params.all_trials; params.all_trials(2,randperm(size(params.all_trials(2,:),2)))];
end

params.nTrials = length(params.all_trials);
params.breakFrequency = 50;

params.all_durs = (repmat(fliplr(params.allStaticDurs),1,params.nTrials/length(params.allStaticDurs)));
params.all_frames = round(params.all_durs/(1/display.refresh));

now = fix(clock);
pathname = pwd;
lastslash = find(pathname == '/',1,'last');
folder = pathname(lastslash+1:end);
params.filename = [params.subjID '_' folder '_' num2str(now(1)) num2str(now(2)) num2str(now(3)) '_' num2str(now(4)) num2str(now(5))];


end