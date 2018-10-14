function noiseBlob = makeNoiseBlob(display,params,randNoise)

outer = angle2pix(display, params.stimSize);
xx = linspace(-params.stimSize, params.stimSize, (outer * 2));
[x, y] = meshgrid(xx);
gauss = exp( -(x.^2+y.^2)./(2*params.gaussSD^2));
imgMat = repmat(display.gray+(display.gray*2.*gauss.*(randNoise-.5)),[1 1 3]);
imgMat(:,:,4) = 255.*((sqrt(x.^2+y.^2))<params.circMaskRadius);
noiseBlob = cast(imgMat,'uint8');
end