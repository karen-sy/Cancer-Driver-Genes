%Review of Lotka-Volterra ver.3:
    %(WITH normal cells converting to cancer)
 
%% 
%1a) increasing c1 (everything else constant): slower cancer growth (time to convergence); 
 %normal cells converge at similar times. see C1graph.png (ignore 'whole' legend)
%1b) increasing c2 ('' '' constant): decreasing carry capacity (with
 %decreasing 'order' too though); the 'gap' between N,M are thus reduced (cancer selective adv decreases) 
 %see C2graph.png (ignore 'whole' legend)

%2) increasing mut (and thus gamma,p1,p2) or r (cell cycle rate)
 %both changes speed up dynamic going to steady state (see Mutgraph.png,
 %Rgraph.png)
 
%3) increasing delta1
 %normals die faster, cancer grows slower

%4) increasing delta2
 %normal cells "peak" higher then decrease steeply (delta2Graph1; ignore legend);
 %cancer cells "shoot straight up" less, but this depletes less oxygen, allowing the 
 %cancer cells with such high delta2's to achieve steady state quicker in
 %the long run (see delta2Graph2)
 
%5) changing dynamics in between? **
 %after TOTAL reaches steady but not both populations: yes
 %after TOTAL and exactly N=0.0 & M = 50.0 (at t = large #): no --> this may be unconvincing.
 %e.g. even if delta2 (M death rate) is set high, the logistic term equaling
 %zero prevents any changes to the system (M's decerasing in #)