function [ XX, YY ] = draw_circle( X, Y, R )
%
%   
 theta = linspace(0,2*pi);
 XX = R*cos(theta) + X;
 YY = R*sin(theta) + Y;
end

