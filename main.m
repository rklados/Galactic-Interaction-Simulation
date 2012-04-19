


function [ returner ] = main(initial_d, initial_v)
fprintf('Begin: D=%g V=%g\n', initial_d, initial_v);
clear galaxy CM_state;

returner = cell(2);
loadflag = 0;
rand('twister', 8021);

%number of particles around each central mass:
%(also specified in calculate_captures.m)
numPart(1) = 500;
numPart(2) = 500;
tau = 1; %timestep;
drop = 3; %drop a jpg ever x frames
if (initial_v > .05)
    %tau = .5;
    tau = 10;
    drop = 6;
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


item = xml(loop_end);
%Main Loop:
for i=loop_start:loop_end

           
    %debug: display iteration:
    if (mod(i, 50) == 0)
    fprintf('loop: %g\n', i);
    end
    %concatenation of plot string, will add each thing to be 
    % plotted, and then eval at the end of loop:
    plotString = 'plot(0,0,''.''';
    color(1) = 'r';
    color(2) = 'b';
    
    %Loop through each galaxy:
    %(2 galaxies)
    
       
    for j=1:size(CM_state,2)
         
    %concatenation of plot string, will add each thing to be 
    % plotted, and then eval at the end of loop:
    
    plotString = strcat(plotString, ', ', num2str(CM_state{j}.r(1)), ',',  num2str(CM_state{j}.r(2)), ', ''o',color(j),'''');
    
    
        for g=1:numPart(j)
           
    [galaxy{j}.particle{g}.state] = rk4(galaxy{j}.particle{g}.state, total_time, tau, 'calculate', CM_state);
    r = [galaxy{j}.particle{g}.state(1) galaxy{j}.particle{g}.state(2)];
        
        %Add particle to plot string:
        plotString = strcat(plotString, ', ', int2str(r(1)), ',', int2str(r(2)), ', ''.',color(j),'''');
        %add particle to xml
        item.newItem(item, 'particle', g, r);
        end
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
	
    %generate this plot from string:
     plotString = strcat(plotString, ',''MarkerFaceColor'',''k'');');

     eval(plotString)
    	axis([20 240 0 200]);
      
        %Will save the plot as a jpeg in images folder 
        if (mod((i+(drop-1)),drop) == 0)
        filename = sprintf('images/%g-%g/test%05.0f.jpg',initial_d, initial_v, i);
        saveas(gcf, filename, 'jpg');           
        end
        %if (mod(i,200) == 0)
        %save('savestate51.mat', 'galaxy', 'CM_state', 'i');
        %end
  
   %break if reaches 4r:
    if ((i*initial_v > 30) && (norm(CM_state{2}.r - CM_state{1}.r) > 81))
        fprintf('Limit Reached.\n')
        returner{1} = galaxy;
        returner{2} = CM_state;
        return;
    end
       
end
 
returner{1} = galaxy;
returner{2} = CM_state;

end
