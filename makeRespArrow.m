function arrowMat = makeRespArrow(display,params)


arrowTop = params.l_mean*ones(angle2pix(display,params.arrowHeight)/2,angle2pix(display,params.arrowHeight)/2);
[x, y] = meshgrid(1:size(arrowTop,2),1:size(arrowTop,1));
arrowTop(x<=y) = 0;
arrowFull = [arrowTop;flipud(arrowTop)];
lineMat = params.l_mean*ones(angle2pix(display,params.arrowHeight),angle2pix(display,params.lineLength));
lineMat(size(lineMat,1)/2:size(lineMat,1)/2+1,:) = 0;
arrowMat = [lineMat arrowFull];

end