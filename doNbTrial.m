function history = doNbTrial(params,display,tex,history,trial)

HideCursor;
% Show fixation dot
Screen('FillOval', display.w, display.black, params.fixLoc); %fixation dot
Screen('Flip', display.w);
WaitSecs(params.ITI); 

% Draw stimulus and fixation
Screen('FillOval', display.w, display.black, params.fixLoc); %fixation dot
Screen('DrawTexture', display.w, tex.texID(trial), params.stimRect(trial,:), params.stimLoc(trial,:)); %last argument is angle in degrees 
Screen('Flip', display.w); 
WaitSecs(params.stimDur);

Screen('FillOval', display.w, display.darkGray, params.fixLoc); %fixation dot
Screen('Flip', display.w);
WaitSecs(params.ISI);

%% Get subject response
SetMouse(params.centerCoords(1),params.centerCoords(2),display.w);

% Draw the response dot
Screen('DrawDots', display.w, display.centerCoords',angle2pix(display,params.respDotSize), display.white, [0 0], 1);
Screen('FillOval', display.w, display.darkGray, params.fixLoc); %fixation dot
Screen('Flip', display.w);

% Trial rt
trialStart=GetSecs;

buttons = [];
% Get mouse position 
while ~any(buttons) % wait for press
    [x,y,buttons] = GetMouse(display.w);
    % Draw circle in new location
    Screen('DrawDots', display.w, [x; y],angle2pix(display,params.respDotSize), display.white, [0 0], 1);
    % Fixation dot
    Screen('FillOval', display.w, display.darkGray, params.fixLoc); %fixation dot
    Screen('Flip', display.w);    
end
while any(buttons) % wait for release
    [x,y,buttons] = GetMouse(display.w);
end
% Get trial times
history.rt(end+1)=GetSecs-trialStart;
history.mouse_x(end+1)=x; 
history.mouse_y(end+1)=y;
history.respAngle(end+1)=rad2deg(atan2((y-display.centerCoords(2)), x-display.centerCoords(1)));

end
