function [ total ] = calculate_captures( galaxy, CM_state, numParts )

total{1}.capture = 0;
total{1}.loss = 0;
total{2}.capture = 0;
total{2}.loss = 0;
        
v_cm1 = CM_state{1}.velo;
v_cm2 = CM_state{2}.velo;

%galaxy 1:numParts(1)
    for i=1:numParts(1)
        r = [galaxy(i,1) galaxy(i,2)];
        
        distance1 = norm(CM_state{1}.r - r);
        acc1 = (CM_state{1}.mass/distance1^3)*(CM_state{1}.r - r);
        distance2 = norm(CM_state{2}.r - r);
        acc2 = (CM_state{2}.mass/distance2^3)*(CM_state{2}.r - r);       
        v = [galaxy(i,3) galaxy(i,4)];

    
        %if gal2 has a stronger force influence over the particle:
        if (norm(acc2) > norm(acc1))
            %define escape velocity:
            v_e = ((2*CM_state{2}.mass) / distance2)^(.5);
            %if speed is greater than escape, it's lost:
            if (norm(v - v_cm2) >= v_e)
                total{1}.loss = total{1}.loss + 1;
            else
                total{2}.capture = total{2}.capture + 1;
            end
        else
            %else, find escape velocity of first gal:
            v_e = (2*CM_state{1}.mass / distance1)^(.5);
            if (norm(v - v_cm1) >= v_e)
                total{1}.loss = total{1}.loss + 1;
            end
        end
        
    end
    
    %Galaxy2:
    for i=numParts(1)+1:numParts(1)+numParts(2)
        r = [galaxy(i,1) galaxy(i,2)];
        
        distance1 = norm(CM_state{1}.r - r);
        acc1 = (CM_state{1}.mass/distance1^3)*(CM_state{1}.r - r);
        distance2 = norm(CM_state{2}.r - r);
        acc2 = (CM_state{2}.mass/distance2^3)*(CM_state{2}.r - r);       
        v = [galaxy(i,3) galaxy(i,4)];
    
        %if gal1 has a stronger force influence over the particle:
        if (norm(acc1) > norm(acc2))
            %define escape velocity:
            v_e = ((2*CM_state{1}.mass) / distance1)^(.5);
            %if speed is greater than escape, it's lost:
            if (norm(v - v_cm1) >= v_e)
                total{2}.loss = total{2}.loss + 1;
            else
                total{1}.capture = total{1}.capture + 1;
            end
        else
            %else, find escape velocity of second gal:
            v_e = (2*CM_state{2}.mass / distance2)^(.5);
            if (norm(v - v_cm2) >= v_e)
                total{2}.loss = total{2}.loss + 1;
            end
        end
    end
end