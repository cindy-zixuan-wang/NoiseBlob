function tex = makeNbTexuture(display,params,trial,tex)
tex.matSize = 2*angle2pix(display, params.stimSize);
randNoise = imresize(randi(2,params.texSize,params.texSize)-1,[tex.matSize tex.matSize],'nearest');
stimMat = makeNoiseBlob(display,params,randNoise);
stimTmp = Screen('MakeTexture',display.w,stimMat);
tex.texID(trial) = stimTmp;
end