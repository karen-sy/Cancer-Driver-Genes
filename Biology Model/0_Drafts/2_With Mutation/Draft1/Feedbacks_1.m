%file holds feedback equations 


%% feedback from drivers

beta = 1e-5; %feedback from 'do'; indirect measurement of "selective advantage" conferred by oncogene mutation
gamma = 1e-5; %feedback from 'dt'; '' by tumor suppressor mutation

v2 = v2 * (1+ 1/(1 + (beta*(y(3)))^2)); %replication

a2 = a2 * (1 / (1 + (gamma*(y(3)))^2)); %EDIT: think about "selective advantage" (growth-death)--- for a0 and a1 too

%% feedback from normal cells
% "cell control mechanism"; growing y(3) => control "k" on v0 
% (slowing normal cell div --> can prevent them mutating)




