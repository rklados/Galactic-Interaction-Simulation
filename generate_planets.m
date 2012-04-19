function [ particle ] = generate_planets( numPart, CM_state)
%GENERATE_PLANETS Creates nPart particles in a stable orbit around CM_r
%   galaxy{1}.particles = generate_plantes(10, CM_state);
particle = cell(numPart);

%Create particles initial state:
for g = 1:numPart
    
%Random distribution of particles:
rmax = 19;
%r is a percentage of rmax
r = 1 + rmax*rand;
theta = 2*pi*rand;
%x^2 is a percentage of r^2
%x2 = r^2*rand;
%y2 = r^2 - x2;

%random plus/min:
%pmx = 2*rand-1;
%pmy = 2*rand-1;
%if (pmx > 0)
%    pmx = 1;
%else pmx = -1;
%end
%if (pmy > 0)
%    pmy = 1;
%else pmy = -1;
%end

%x = sqrt(x2)*pmx;
%y = sqrt(y2)*pmy;
x = r*cos(theta);
y = r*sin(theta);
r = [(CM_state.r(1)+ x) (CM_state.r(2)+ y)];

%Guarantee orthogonality, tangent to connecting radius:
% v_x = -r_y; v_y = r_x;
radial_vector = (CM_state.r - r);
orthogonal_vector = [-radial_vector(2), radial_vector(1)];

distance_i = norm(radial_vector);

%acceleration from primary CM:
accel = (CM_state.mass/distance_i^3)^(1/2);

%Initial Velocity for particle.
% Will begin in a stable, circular orbit around First Central Mass:
velo = (accel*orthogonal_vector) + CM_state.velo;

particle{g}.state = [r(1), r(2), velo(1), velo(2)];
end

end