%% feedbacks

%1) driver to driver
v3 = v3 * (1+(alpha))^(do*(t*v3)) ; %more (oncogene) drivers = higher div rate 
a3 = a3 * (1-(alpha))^(dt*(t*v3)); %more (tumor suppressor) drivers = lower death rate

%2) passenger to passenger
a2 = a2 * (1+(beta))^(p*(t*v2)); %more passengers = more apoptosis of passengers  

%3) between oxygen and cells
A = @(k) an*(1 - k/(2-k));  %O2 -> 'additional' death rate of cells
F = @(j,k) j*k; %add. O2 entering through angiogenesis

%4) normal cell controls




