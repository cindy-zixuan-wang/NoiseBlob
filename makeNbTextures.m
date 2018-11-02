function tex = makeNbTextures(display,params,trial,tex)
tex.matSize = angle2pix(display, params.stimSize);
randNoise = imresize(randi(2,params.texSize,params.texSize)-1,[tex.matSize tex.matSize],'nearest');
tex.stimMat{trial} = makeNoiseBlob(display,params,randNoise);
tex.texID(trial) = Screen('MakeTexture',display.w,tex.stimMat{trial});
end