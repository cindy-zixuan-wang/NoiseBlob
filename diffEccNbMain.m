clear all;close all

%set random number stream if haven't done so already
% currentStream = RandStream.getDefaultStream;
% if currentStream.Seed==0
% stream = RandStream('mt19937ar','Seed',sum(100*clock));
% RandStream.setDefaultStream(stream);
% end
rng('Shuffle');
HideCursor;
AssertOpenGL;
KbName('UnifyKeyNames')
Screen('Preference', 'SuppressAllWarnings', 0);
Screen('Preference','SkipSyncTests',1);

%get stimulus parameters
[params,display] = getNbParams;
%load history struct
history = makeNbHistory;

Screen('BlendFunction', display.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% BackupCluts;

priorityLevel = MaxPriority(display.w);
Priority(priorityLevel);

%make textures
tex = makeNbTextures(display,params);
params = makeNbCoords(params,display);
Screen(display.w, 'TextSize',params.textSize);
Screen(display.w,'DrawText','Press Space Bar to begin',50,50,255);
Screen('Flip',display.w);

[keyIsDown,seconds,keyCode] = KbCheck(-1);
while ~keyCode(KbName('space'))
    [keyIsDown,seconds,keyCode] = KbCheck(-1);
end

for trial =  1:params.nTrials %loop of all trials
    
   history = doNbTrial(params,display,tex,history,trial);
    
  
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

history.all_trials = [params.all_trials,history.mouse_x',history.mouse_y'];


Screen('CloseAll');
ShowCursor;
Priority(0);

mkdir(params.filename);
save([params.subjID '.mat'],'display','history','params','tex');
cd(params.curFolder);