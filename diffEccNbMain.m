clear all;
close all

rng('Shuffle');
HideCursor();
AssertOpenGL;

%get stimulus parameters
[params,display] = getNbParams;
%load history struct
history = makeNbHistory;

% BackupCluts;
priorityLevel = MaxPriority(display.w);
Priority(priorityLevel);
%load color look up table
load('CLUT_Booth3_1024x768_100hz_17_Oct_2018');
Screen('LoadNormalizedGammaTable',display.w,clut,1);

% coordinates
params = makeNbCoords(params,display);

% welcome
Screen(display.w, 'TextSize',params.textSize);
Screen(display.w,'DrawText','Press Space Bar to begin',50,50,255);
Screen('Flip',display.w);
[keyIsDown,seconds,keyCode] = KbCheck(-1);
while ~keyCode(KbName('space'))
    [keyIsDown,seconds,keyCode] = KbCheck(-1);
end

%% experiment
tex = struct;
for trial =  1:params.nTrials %loop of all trials
   % make textures
   tex = makeNbTextures(display,params,trial,tex);
   % make history
   history = doNbTrial(params,display,tex,history,trial);
   
   % take a rest
    if rem(trial,params.breakFrequency) == 0 && trial~=params.nTrials
        Screen(display.w, 'TextSize',params.textSize);
        Screen(display.w,'DrawText',[num2str(trial) ' out of ' num2str(params.nTrials) ' trials complete. Press Space Bar to continue'],50,50,255);
        display.vbl = Screen('Flip', display.w);
        WaitSecs(.5)
        [keyIsDown,seconds,keyCode] = KbCheck(-1);
        while ~keyCode(KbName('space'))
            [keyIsDown,seconds,keyCode] = KbCheck(-1);
        end
    end
end
% end experiment
Screen('CloseAll');
ShowCursor;
Priority(0);

%% save results
mkdir(params.filename);
cd(params.filename);
save([params.subjID,'_',num2str(params.subjSession),'.mat'],'display','history','params','tex');
cd(params.curFolder);