


function [ returner ] = main2(initial_d, initial_v, numPart)
fprintf('Begin: D=%g V=%g\n', initial_d, initial_v);
%reset variables:
clear galaxy CM_state;
%clear plot screen:
clf;
%make sure we keep plots before clear:
hold on;

returner = cell(2);
loadflag = 0;
rand('twister', 8021);


tau = 1; %timestep;
drop = 10; %drop a jpg ever x frames
if (initial_v > .05)
    tau = .5;
    drop = drop*2;
end
total_time = 0;


%loop until (prompt?)
loop_end = 10000;

%plot environment:
set(gcf, 'NextPlot', 'replacechildren');
ylim('manual');
xlim('manual');

%Define Constants:
G = 6.673*10^-11;


%If loading from previous iterations...
%if (loadflag == 1)
%    load('savestate50.mat', 'galaxy', 'CM_state', 'loop_end');
%   
%    loop_start = loop_end + 1;
%    loop_end = loop_start + loop_end;
   
%else
    
    loop_start = 1;
   
    
%Central Mass Variables: 
CM_state = cell(2);
CM_state{1}.mass = 10000000*G;
CM_state{2}.mass = 10000000*G;

CM_state{1}.r = [100 100];
CM_state{2}.r = [(100+initial_d) 180];

CM_state{1}.velo = [0,0];
CM_state{2}.velo = [0,-initial_v];


%generate planets around each galaxy:
galaxy = cell(2);
galaxy{1}.particle = generate_planets(numPart(1), CM_state{1});
galaxy{2}.particle = generate_planets(numPart(2), CM_state{2});

%end


% OPTIMIZE THIS BY HAVING GENERATE_PLANETS RETURN IT IN THE FIRST PLACE
P = zeros(numPart(1)+ numPart(2), 4);
%create big planet matrix:
        for g=1:numPart(1)
            P(g,:) = P(g,:) + galaxy{1}.particle{g}.state;
        end
        for g=1:numPart(2)
            P(g+numPart(1),:) = P(g+numPart(1),:) + galaxy{2}.particle{g}.state;
        end

%item = xml(loop_end);

%Main Loop:
for i=loop_start:loop_end

        P = rk4(P, total_time, tau, 'Vcalculate', CM_state);
    %debug: display iteration:
    if (mod(i, 50) == 0)
    fprintf('loop: %g\n', i);
    end
   
    
    %Update CM position:
        %center of mass:
        GCM.r = (CM_state{1}.mass*CM_state{1}.r + CM_state{2}.mass*CM_state{2}.r) ...
            /(CM_state{1}.mass+CM_state{2}.mass);
        GCM.mass = (CM_state{1}.mass*CM_state{2}.mass)/(CM_state{1}.mass + CM_state{2}.mass);
%         CM_state = cell(size(CM_state,2), 2);
    for k=1:size(CM_state,2)
        fprintf('k: %g\n', k);
    %update both central masses:
       x = [CM_state{k}.r(1) CM_state{k}.r(2) CM_state{k}.velo(1) CM_state{k}.velo(2)];
        x = rk4(x, total_time, tau, 'calculate_CM', GCM);
            
        CM_state{k}.r = [x(1) x(2)];
        CM_state{k}.velo = [x(3) x(4)];
        
       
        disp(CM_state{k});
    end

  
%end
    
    %total_time:
    total_time = total_time + tau;
	
        
        %OPTIMIZE by dropping more frames? writing every 5? less?
        %Will save the plot as a jpeg in images folder 
        if (mod((i+(drop-1)),drop) == 0)
        
        %eval(doPlot(CM_state, P));
    	       
        %axis([20 240 0 200]);
        %%throwPlot(CM_state, P, numPart);
            
            
        filename = sprintf('images/%g-%g/test%05.0f.jpg',initial_d, initial_v, i);
        %%saveas(gcf, filename, 'jpg');           

        end
        %%dlmwrite('super_file.txt', [P; CM_state{1}.r, CM_state{1}.velo; CM_state{2}.r,CM_state{2}.velo], '-append', 'roffset',1);
        %if (mod(i,200) == 0)
        %save('savestate51.mat', 'galaxy', 'CM_state', 'i');
        %end
  
   %break if reaches 4r:
    if ((i*initial_v > 30) && (norm(CM_state{2}.r - CM_state{1}.r) > 81))
        fprintf('Limit Reached.\n')
        returner{1} = P;
        returner{2} = CM_state;
        return;
    end
       
end
 
returner{1} = P;
returner{2} = CM_state;

end

function plotString = doPlot(CM_state, P)
    %concatenation of plot string, will add each thing to be 
    % plotted, and then eval at the end of loop:
    plotString = 'plot(0,0,''.''';
    color(1) = 'r';
    color(2) = 'b';

    % OPTIMIZE BY HAVING SOME SORT OF MATRIX PLOT?
    % OPTIMIZE BY ONLY PLOTTING WHEN DROPPING IMAGES?
    %loop for plotting:
        for g=1:size(P, 1)
           
        plotString = strcat(plotString, ', ', int2str(P(g,1)), ',', int2str(P(g,2)), ', ''.',color(1),'''');
        %add particle to xml
      %  Part = [P(g,1),P(g,2)];
      %  item.newItem(item, 'particle', g, Part);
        end
    
    
    %Loop through each galaxy:
    %(2 galaxies)    
    for j=1:size(CM_state,2)
    %concatenation of plot string, will add each thing to be 
    % plotted, and then eval at the end of loop:
    
    plotString = strcat(plotString, ', ', num2str(CM_state{j}.r(1)), ',',  num2str(CM_state{j}.r(2)), ', ''o',color(j),'''');
    end
    
    %generate this plot from string:
     plotString = strcat(plotString, ',''MarkerFaceColor'',''k'');');
     
end

function success = throwPlot(CM_state, P, numPart)
color(1) = 'r';
    color(2) = 'b';    
    clf;
    hold on;
    disp(numPart);
    disp(size(P));
    plot(P(1:numPart(1),1), P(1:numPart(1),2), strcat('.',color(1)));
    plot(P(numPart(1)+1:numPart(2)+numPart(1),1), P(numPart(1)+1:numPart(2)+numPart(1), 2), strcat('.',color(2)));
    axis([20 240 0 200]);
end