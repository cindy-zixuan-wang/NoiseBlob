function n=angle2pix(display,ang)
%ANGLE2PIX
%n=angle2pix(display,ang)
%returns width of square in pixels for visual angle ang
pixPerDeg = mean([display.numPixels(1)/(2*rad2deg(atan(display.dimensions(1)/2/display.distance))),...
    display.numPixels(2)/(2*rad2deg(atan(display.dimensions(2)/2/display.distance)))]);
n=round(ang*pixPerDeg);
