function [noiseBlob randNoise] = makeNoiseBlob(display,params,randNoise)

outer = angle2pix(display, params.stimSize);

xx = linspace(-params.stimSize, params.stimSize, (outer * 2));
[x, y] = meshgrid(xx);

gauss = exp( -(x.^2+y.^2)./(2*params.gaussSD^2));

% imgMat(:,:,4) = 255.*gauss(:,:,1);
% imgMat = imgMat.*repmat(gauss,[1 1 3]);
imgMat = repmat(params.l_mean+(params.l_mean*params.stimContrast*2.*gauss.*(randNoise-.5)),[1 1 3]);
imgMat(:,:,4) = 255.*((sqrt(x.^2+y.^2))<params.circMaskRadius);

randNoise = circshift(randNoise,[angle2pix(display,params.texShift) angle2pix(display,params.texShift)]); %shift it for the next frame
noiseBlob = cast(imgMat,'uint8');


end