
function xout = Vcalculate(P, t, params)

    % number rows in planet matrix is number of planets:
    numPlanets = size(P, 1);
    
    A = zeros(numPlanets, 2);
    
    % X will just be the x,y coordinates of all planets
    X = P(:,[1,2]);
    
    % loop over each galaxy:
    for i=1:size(params,2)
        % CM matrix to calculate distance to planets:
        CM = ones(numPlanets, 1)*params{i}.r;
        
               
        % D = the distances to each planet (norm(params{i}.r - r)
        D = sqrt(sum(abs(CM - X).^2,2));
        % D2 = the matrix of mass * dist^-3:
        D2 = (params{i}.mass*D.^(-3));
% add the acceleration from this galaxy to the full array:        
        A = A + [D2 D2].*(CM - X);
    end

    % V is just the velocities of the planets:
    V = P(:,[3,4]);
    xout = [V A];
end