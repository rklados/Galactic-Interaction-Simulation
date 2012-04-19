% Calculate
% takes an input of r, v, CM., calculates acceleration and 
% returns new values of dr and dv:

%"x" is actually a matrix of [r(), v()]...

%needs to return what will be "() = () + tau*xout" 

function xout = calculate(x, t, params)

%unfortunately, for speed will need to hard code state vector:
% will need to re-code for multiple dimensions
r = [x(1) x(2)];
v = [x(3) x(4)];
acceleration = [0 0];

for i=1:size(params,2)
    distance = norm(params{i}.r - r);
       
    acc = (params{i}.mass/distance^3)*(params{i}.r - r);

    acceleration = acceleration + acc;
end
    
%return matrix... will have eg.: [v(1), v(2), a(1), a(2)]...

xout = [v(1) v(2) acceleration(1) acceleration(2)];

end
