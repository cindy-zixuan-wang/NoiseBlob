function gabor = makeGabor(display,params)

outer = angle2pix(display, params.stimSize);

xx = linspace(-params.stimSize, params.stimSize, (outer * 2));
[x, y] = meshgrid(xx);

gauss = exp( -(x.^2+y.^2)./(2*params.gaussSD^2));

sinGrating=sin(x*2*pi*params.gaborSF+params.gaborPhase);

gratingMat = repmat(params.l_mean+(params.l_mean*params.stimContrast*sinGrating),[1 1 3]);
gratingMat(:,:,4) = 255.*gauss(:,:,1);

gabor = cast(gratingMat,'uint8');

end