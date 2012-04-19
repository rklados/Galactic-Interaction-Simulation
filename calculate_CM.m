function [ xout ] = calculate_CM( x, t, params )
%CALCULATE_CM Summary of this function goes here
%   Detailed explanation goes here

%x = CM_state{k}
%params = GCM - center of mass

r = [x(1) x(2)];
v = [x(3) x(4)];

distance = norm(params.r - r);
%for relative acceleration, mass1 is stationary while mass2 
%undergoes double the acceleration.
acc = (params.mass/distance^3)*(params.r - r);

xout = [v(1) v(2) acc(1) acc(2)];

end
