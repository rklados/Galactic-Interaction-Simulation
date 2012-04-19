
 
clear all;
for d=5:5:20
    for v=.01:.02:.07
 %d = 5;
 %v = .07;
 
 %number of particles around each central mass:
%(also specified in calculate_captures.m)
numPart(1) = 1000;
numPart(2) = 1000;

        data = main2(d, v, numPart);
        %data = main(d, .03);
        galaxy = data{1};
        CM_state = data{2};
        
        totals = calculate_captures(galaxy, CM_state, numPart);
        
        filename_state = sprintf('data/savestate-%g-%g.mat',d,v);
        save(filename_state, 'galaxy', 'CM_state', 'totals');
        
        filename_total = sprintf('data/totals-%g-%g.txt',d,v);
        gal1cap = totals{1}.capture;
        gal1loss = totals{1}.loss;
        gal2cap = totals{2}.capture;
        gal2loss = totals{2}.loss;
        
        save(filename_total,'gal1cap','gal1loss','gal2cap','gal2loss','-ASCII');
    end %end for velocity
end %end for distance

