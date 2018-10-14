function history = doPosTrial(params,display,tex,history,trial)

HideCursor;
if params.refDots == 1
    if  params.constrainedRef == 0
        dotPos = [randi(display.screenRect(3),params.nRefDots,1)-1-display.screenRect(3)/2 randi(display.screenRect(4),params.nRefDots,1)-1-display.screenRect(4)/2]';
    else
        [dotPos(:,1) dotPos(:,2)] =  pol2cart(deg2rad(params.all_trials(4,trial)),angle2pix(display,params.stimEcc));
        dotPos = dotPos';
    end
elseif params.refDots == 2
    [dotPos(:,1) dotPos(:,2)] =  pol2cart(deg2rad(params.customLocs),angle2pix(display,params.stimEcc));
    dotPos = dotPos';
else
    dotPos = [];
end


if params.refDots && params.constantDots
    Screen('DrawDots',display.w,dotPos,angle2pix(display,params.refDotSize),params.refDotColor,[display.screenRect(3)/2,display.screenRect(4)/2],1);
end

Screen('FillOval',display.w,[0 0 0],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
    display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);

display.vbl=Screen('Flip', display.w);
% params.all_trials(2,trial) = 135;
stimSize = 2*angle2pix(display,params.stimSize); %this is actually the width of the entire texture (just for positioning it properly)
stimCenter = zeros(params.nStim,2);
for stimNum = 1:params.nStim %1 & 2 are bottom gabors, 3 & 4 are top gabors
    if stimNum <= 2
        [stimCenter(stimNum,1) stimCenter(stimNum,2)] =  pol2cart(deg2rad(params.stimAngles(stimNum)+params.all_trials(2,trial)),angle2pix(display,params.stimEcc));
    else
        [stimCenter(stimNum,1) stimCenter(stimNum,2)] =  pol2cart(deg2rad(params.stimAngles(stimNum)+params.all_trials(2,trial)),angle2pix(display,params.stimEcc));
    end
    stimCenter(stimNum,1) = stimCenter(stimNum,1)+display.screenRect(3)/2;
    stimCenter(stimNum,2) = stimCenter(stimNum,2)+display.screenRect(4)/2;
    
    stimCenter(stimNum,1) = round(stimCenter(stimNum,1));
    
    stimCenter(stimNum,2) = round(stimCenter(stimNum,2));
end


stim_pos = [stimCenter(:,1)-stimSize/2 ...
    stimCenter(:,2)-stimSize/2 ...
    stimCenter(:,1)+stimSize/2 ...
    stimCenter(:,2)+stimSize/2];


% if params.all_durs(trial) >1
%     stim_pos(2,[1 3]) = stim_pos(2,[1 3])+20;
%     stim_pos(4,[1 3]) = stim_pos(4,[1 3])-20;
% end

if params.noiseBg==1
    Screen('DrawTexture',display.w,bgTex,[]);
end

if params.refDots && params.constantDots
    Screen('DrawDots',display.w,dotPos,angle2pix(display,params.refDotSize),params.refDotColor,[display.screenRect(3)/2,display.screenRect(4)/2],1);
end
Screen('FillOval',display.w,[0 0 0],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
    display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);

display.vbl = Screen('Flip', display.w,display.vbl+params.ITI-(1/display.refresh));

% history.screen = screen('GetImage',display.w);

for nFrame = 1:params.all_frames(trial)%round(params.stimFramesShown(params.motion_cond==params.all_trials(3,trial))) % loop of all frames
    
    if params.noiseBg==1
        Screen('DrawTexture',display.w,bgTex,[]);
    end
    if params.refDots
        Screen('DrawDots',display.w,dotPos,angle2pix(display,params.refDotSize),params.refDotColor,[display.screenRect(3)/2,display.screenRect(4)/2],1);
    end
    
    
    for nStim = params.whichStim
        Screen('DrawTexture',display.w,tex.texID(tex.frameOrder(trial,nFrame,nStim)),[],stim_pos(nStim,:),params.stimOrientations(nStim));
    end
    
    %    Screen(display.w,'DrawText', num2str(params.all_trials(2,trial)),50,50,255);
    Screen('FillOval',display.w,[0 0 0],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
        display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);
    
    Screen('Flip',display.w);
    if nFrame ==1 tic; end
    
end

if params.noiseBg==1
    Screen('DrawTexture',display.w,bgTex,[]);
end
% Screen('FillOval',display.w,[40 40 40],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
%     display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);
if params.showMask == 1
    Screen('DrawTexture',display.w,tex.mask(trial));
    Screen('Flip', display.w);
    stimDur =  toc
    WaitSecs(params.maskDur-1/display.refresh);
end

if params.refDots && params.constantDots
    Screen('DrawDots',display.w,dotPos,angle2pix(display,params.refDotSize),params.refDotColor,[display.screenRect(3)/2,display.screenRect(4)/2],1);
end

Screen('FillOval',display.w,[40 40 40],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
    display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);

Screen('Flip', display.w);
if params.showMask == 0
    stimDur = toc
end

if params.showMask == 0 && params.refDots
    if params.constantDots == 0
        WaitSecs(params.ISI-1/display.refresh); % commented out for simultaneous version
    end
elseif params.showMask == 0 && params.refDots == 0
    WaitSecs(params.ISI-1/display.refresh);
elseif params.showMask == 1
    WaitSecs(params.ISI-params.maskDur-1/display.refresh);
end

% % commented out for simultaneous version
if params.refDots && params.constantDots
    Screen('DrawDots',display.w,dotPos,angle2pix(display,params.refDotSize),params.refDotColor,[display.screenRect(3)/2,display.screenRect(4)/2],1);
    
    Screen('FillOval',display.w,[40 40 40],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
        display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);
    
    Screen('Flip', display.w);
    
    WaitSecs(params.refDur-1/display.refresh);
    
    Screen('FillOval',display.w,[40 40 40],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
        display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);
    
    Screen('Flip', display.w);
    
    if params.showMask == 0
        WaitSecs(params.ISI-1/display.refresh);
    else
        WaitSecs(params.ISI-params.maskDur-1/display.refresh);
    end
end




if params.cursorResponse == 2
    
    %
    respAngle = randi(359)-180;
    startAngle = respAngle;
    [xShift,yShift] = pol2cart(deg2rad(startAngle),angle2pix(display,params.stimEcc));
    xShift = round(xShift);yShift = round(yShift);
    SetMouse(xShift+display.screenRect(3)/2,yShift+display.screenRect(4)/2,display.w);
    
    %     SetMouse(display.screenRect(3)/2,display.screenRect(4)/2,display.w);
    
    
    ShowCursor(5);
    while 1
        
        %         ShowCursor(5);%
        HideCursor;
        [mouse_x,mouse_y,buttons] = GetMouse(display.w);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [respAngle,respEcc] = cart2pol(pix2angle(display,mouse_x-display.screenRect(3)/2),pix2angle(display,mouse_y-display.screenRect(4)/2));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if buttons(1)
            break;
        end
        %
        %     [respAng,respEcc] = cart2pol(pix2angle(display,mouse_x-display.screenRect(3)/2),pix2angle(display,mouse_y-display.screenRect(4)/2));
        %
        % Screen(display.w,'DrawText',num2str(rad2deg(respAng)),50,50,255);
        %     Screen('Flip',display.w);
        %
        %
        %         %%%%%%%%%%%%%%%%%%%%% special fun version %%%%%%%%%%%%%%%%%%%%%
        [respAng,~] = cart2pol(pix2angle(display,mouse_x-display.screenRect(3)/2),pix2angle(display,mouse_y-display.screenRect(4)/2));
        [xShift,yShift] = pol2cart(respAng,angle2pix(display,params.stimEcc));
        xShift = round(xShift);yShift = round(yShift);
        
        %         if params.refDots == 1
        %             Screen('DrawDots',display.w,dotPos,angle2pix(display,params.refDotSize),params.refDotColor,[display.screenRect(3)/2,display.screenRect(4)/2],1);
        %         end
        
        Screen('FillOval',display.w,[0 0 255],[display.screenRect(3)/2+xShift-angle2pix(display,params.fix_size/2) display.screenRect(4)/2+yShift-angle2pix(display,params.fix_size/2) ...
            display.screenRect(3)/2+xShift+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+yShift+angle2pix(display,params.fix_size/2)]);
        
        Screen('FillOval',display.w,[40 40 40],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
            display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);
        
        
        Screen('Flip',display.w);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        
        %         SetMouse(round(xShift)+display.screenRect(3)/2,round(yShift)+display.screenRect(4)/2,display.w);
        
    end
    mouse_x = xShift+display.screenRect(3)/2;
    mouse_y = yShift+display.screenRect(4)/2;
    
    %     respAngle = NaN;
    %     startAngle = NaN;
    %     HideCursor;
    %
elseif params.cursorResponse == 1
    
    
    SetMouse(display.screenRect(3)/2,display.screenRect(4)/2,display.w);
    
    
    ShowCursor(5);
    while 1
        
        ShowCursor(5);%
        %  HideCursor;
        [mouse_x,mouse_y,buttons] = GetMouse(display.w);
        
        if buttons(1)
            break;
        end
    end
    
    respAngle = NaN;
    startAngle = NaN;
    HideCursor;
elseif params.cursorResponse == 3
    respAngle = randi(359);
    startAngle = respAngle; %start at a random angle
    y = display.numPixels(2)/2; %set mouse y position to halfway down the screen
    SetMouse(startAngle,y); % set mouse position to start point
    
    buttons = 0; %start with no buttons pressed
    prevOutput = 0; %start with 0 assigned to previous mouse position
    
    while ~any(buttons) %wait until button press
        
        [x,y,buttons] = GetMouse; %get mouse position
        respAng = mod(x-params.offset,360)+params.offset; %wrap around values outside of 1-180
        
        if respAng ~= x
            SetMouse(respAng,y); %wrap around cursor position
        end
        
        %only update the display if mouse position has changed
        % (for some reason, mouse clicks via knob presses won't register when updating continuously)
        if respAng ~= prevOutput
            
            [xShift,yShift] = pol2cart(deg2rad(respAng),angle2pix(display,params.stimEcc));
            xShift = round(xShift);yShift = round(yShift);
            
            
            
            Screen('FillOval',display.w,[0 0 255],[display.screenRect(3)/2+xShift-angle2pix(display,params.fix_size/2) display.screenRect(4)/2+yShift-angle2pix(display,params.fix_size/2) ...
                display.screenRect(3)/2+xShift+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+yShift+angle2pix(display,params.fix_size/2)]);
            
            Screen('FillOval',display.w,[40 40 40],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
                display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);
            
            
            Screen('Flip',display.w);
        end
        prevOutput = respAng; %current mouse position becomes previous position
    end
    while any(buttons) %wait for release before continuing
        [~,~,buttons] = GetMouse;
    end
    
    mouse_x = NaN;
    mouse_y = NaN;
else
    
    
    
    respAngle = randi(359)-180;
    
    %     respAngle = params.all_trials(2,trial);%sanity check; make sure to comment this
    startAngle = respAngle;
    [keyIsDown,seconds,keyCode] = KbCheck(-1);
    
    while  ~keyCode(KbName('space'))
        
        [keyIsDown,seconds,keyCode] = KbCheck(-1);
        if keyCode(KbName('LeftArrow'))
            respAngle = respAngle-params.angleInc;
        elseif keyCode(KbName('RightArrow'));
            respAngle = respAngle+params.angleInc;
        end
        
        if params.cursorResponse == 0 % central arrow
            Screen('DrawTexture',display.w,tex.arrow,[],[],respAngle);
        elseif params.cursorResponse == 4 %peripheral dot
            [xShift,yShift] = pol2cart(deg2rad(respAngle),angle2pix(display,params.stimEcc));
            xShift = round(xShift);yShift = round(yShift);
            
            Screen('FillOval',display.w,[0 0 255],[display.screenRect(3)/2+xShift-angle2pix(display,params.fix_size/2) display.screenRect(4)/2+yShift-angle2pix(display,params.fix_size/2) ...
                display.screenRect(3)/2+xShift+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+yShift+angle2pix(display,params.fix_size/2)]);
            
            %             Screen('DrawTexture',display.w,tex.circle,[],[display.screenRect(3)/2+xShift-angle2pix(display,params.circle_size/2) display.screenRect(4)/2+yShift-angle2pix(display,params.circle_size/2) ...
            %                 display.screenRect(3)/2+xShift+angle2pix(display,params.circle_size/2) display.screenRect(4)/2+yShift+angle2pix(display,params.circle_size/2)]);
            %
            %
        end
        
        Screen('FillOval',display.w,[40 40 40],[display.screenRect(3)/2-angle2pix(display,params.fix_size/2) display.screenRect(4)/2-angle2pix(display,params.fix_size/2) ...
            display.screenRect(3)/2+angle2pix(display,params.fix_size/2) display.screenRect(4)/2+angle2pix(display,params.fix_size/2)]);
        
        Screen('Flip',display.w);
    end
    
    
    mouse_x = NaN;
    mouse_y = NaN;
end



history.mouse_x(trial) = mouse_x;
history.mouse_y(trial) = mouse_y;
if params.cursorResponse ~= 1
    history.startAngle(trial) = startAngle;
end
history.respAngle(trial) = respAngle;
history.dotPos(:,:,trial) = dotPos;

end
