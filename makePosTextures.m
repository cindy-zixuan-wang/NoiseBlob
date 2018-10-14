function tex = makePosTextures(display,params)

% outer = angle2pix(display, params.gratingRadius);
% xx = linspace(-params.gratingRadius, params.gratingRadius, (outer * 2));
% [x_grid, y_grid] = meshgrid(xx);

% for nFrame = 1:params.gaborFrames
%     if params.noiseBlob == 1
%         [stim.gabor_soft.(genvarname(['frame' num2str(nFrame)])) randnoise] = makeBlobTexture(display,params,randnoise);
%     else
%         stim.gabor_soft.(genvarname(['frame' num2str(nFrame)])) = makeGaborTexture(display,params,randnoise);
%     end
%
%
% end

tex.matSize = 2*angle2pix(display, params.stimSize);

if params.stimType == 1 %gabor
    nUniqueFrames = params.gaborFrames;
elseif params.stimType==2 % noise for blob
    if params.noiseType == 1
        randNoise = imresize(rand(params.texSize),[tex.matSize tex.matSize],'nearest');
    else
        randNoise = imresize(randi(2,params.texSize,params.texSize)-1,[tex.matSize tex.matSize],'nearest');
    end
    nUniqueFrames = size(randNoise,1)/angle2pix(display,params.texShift);
end
% randNoise = 255*ones(size(randNoise(:,:,1)));

for nFrame = 1:nUniqueFrames
    if params.stimType == 1 %gabor
        stimMat = makeGabor(display,params);
        params.gaborPhase = params.gaborPhase + params.phaseInterval; %phase in radians
    elseif params.stimType == 2 %textured blob
        [stimMat randNoise] = makeNoiseBlob(display,params,randNoise);
    end
    stimTmp = Screen('MakeTexture',display.w,stimMat);
    %     stim.(['f' num2str(nFrame)]) = stimMat;
    tex.texID(nFrame) = stimTmp;
end

% set up matrix of frames to show
firstFrame = randi(nUniqueFrames,[params.nTrials,1,params.nStim]);%randomly select first frame
%first motion direction
tex.frameOrder = rem(repmat(firstFrame,1,max(params.stimFramesShown))+repmat((0:max(params.stimFramesShown)-1),[params.nTrials,1,params.nStim])-1,nUniqueFrames)+1;

for s = 1:params.nStim %for each Gabor
    %moving in opposite direction
    tex.frameOrder(params.all_trials(3,:)==-1,:,s)=fliplr(tex.frameOrder(params.all_trials(3,:)==-1,:,s));
    
    if params.stimType==1 %gabor phase reversal
        flickerFrames =  repmat([repmat(tex.frameOrder(params.all_trials(3,:)==0,1,s),1,params.gaborFrames/2) ...
            repmat(rem(tex.frameOrder(params.all_trials(3,:)==0,1,s)+params.gaborFrames/2-1,nUniqueFrames)+1,1,params.gaborFrames/2)],1,ceil(max(params.stimFramesShown)/(params.gaborFrames)));
        
    else %texture flicker
        nTextures = ceil(max(params.stimFramesShown)/(params.gaborFrames/2));%number of unique flickered textures
        flickerIndices =  sort(repmat(1:nTextures,1,params.gaborFrames/2)); %index list
        flickerIndices = ones(1,max(params.stimFramesShown));
        randFrames = randi(nUniqueFrames,sum(params.all_trials(3,:)==0),nTextures); %random frame numbers
        flickerFrames =randFrames(:,flickerIndices);
    end
    
    tex.frameOrder(params.all_trials(3,:)==0,:,s)= flickerFrames(:,1:max(params.stimFramesShown));
end

arrowMat = makeRespArrow(display,params);
tex.arrow = Screen('MakeTexture',display.w,arrowMat);

circleMat = makeRespCircle(display,params);
tex.circle = Screen('MakeTexture',display.w,circleMat);

if params.showMask==1
for m = 1:params.nTrials
    maskTmp = 255.*(randi(2,ceil(display.screenRect(4)/params.maskElementSize),ceil(display.screenRect(3)/params.maskElementSize))-1);
    maskTmp = imresize(maskTmp,params.maskElementSize,'nearest');
    maskTmp = maskTmp(1:display.screenRect(4),1:display.screenRect(3));
    tex.mask(m) = Screen('MakeTexture',display.w,maskTmp);
    
end
end

end