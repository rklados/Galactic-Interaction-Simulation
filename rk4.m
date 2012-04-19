function xout = rk4 (x, t, tau, funct, param)

% 4th order Runge-Kutta
% based on rk4 in Numerical Methods for Physics, 2E

half_tau = .5*tau;

F1 = feval(funct, x, t, param);

t_half = t + half_tau;

%xtemp will be passed to next Fn
xTemp = x + half_tau*F1;

F2 = feval(funct, xTemp, t_half, param);
xTemp = x + half_tau*F2;

F3 = feval(funct, xTemp, t_half, param);
t_full = t + tau;
xTemp = x + tau*F3;

F4 = feval(funct, xTemp, t_full, param);

xout = x + (tau/6)*(F1 + 2*F2 + 2*F3 + F4);

return;