function circleMat = makeRespCircle(display,params)

outer = angle2pix(display, params.circle_size/2);

xx = linspace(-params.circle_size/2, params.circle_size/2, outer*2);
[x, y] = meshgrid(xx);

radiusMat = sqrt(x.^2+y.^2);

circleMat(:,:,1:2) = repmat(zeros(size(radiusMat)),[1 1 2]);
circleMat(:,:,3:4) = repmat(255.*(radiusMat<params.circle_size/2),[1 1 2]);

circleMat = cast(circleMat,'uint8');

end