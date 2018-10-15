function display = getNbDisplay(params)
display.screens = Screen('Screens');
display.screenNumber = max(display.screens);

display.white = WhiteIndex(display.screenNumber);
display.black = BlackIndex(display.screenNumber);
display.gray = round((display.white+display.black)/2);
display.darkGray = round(display.white/3+display.black*2/3);


Screen('Preference', 'SuppressAllWarnings', 0);

switch params.computer
    case 1 %testing booth
        display.numPixels = [1024 768];
%         display.dimensions = [34.29 25.78]; %cm %for NEW MONITOR
        skipSyncIndex = 0;
        display.dimensions = [35.75 26]; %booth 6 1024 x 768 at 100 Hz
        display.distance = 57; %cm of viewing distance
        display.cmapDepth = 8;
        display.refresh = 100;        
        Screen('Resolution', display.screenNumber, display.numPixels(1), display.numPixels(2), display.refresh);
        
    case 2 %laptop
        display.numPixels = [1024 768];
%         display.dimensions = [34.29 25.78];
        skipSyncIndex = 1;
        display.dimensions = [35.75 26]; %booth 6 1024 x 768 at 100 Hz
        display.distance = 57; %cm of viewing distance
        display.cmapDepth = 8;
        display.refresh = 100;        
        Screen('Resolution', display.screenNumber, display.numPixels(1), display.numPixels(2));
        
end

Screen('Preference','SkipSyncTests',skipSyncIndex);
display.pixelSize = mean(display.dimensions./display.numPixels);
[display.w,display.screenRect]=Screen('OpenWindow',display.screenNumber,display.gray);
display.centerCoords = display.screenRect(3:4)/2;
[display.flipInterval,display.nrValidSamples,display.stddev]= Screen('GetFlipInterval', display.w);

end