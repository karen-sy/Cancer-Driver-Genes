beta = 1e-5;
gamma = 1e-5;
theta = 1e-5;


v1 = v1 * (1+ beta*(x(2))^2); %more mutations = more replication of mutated cells
a1 = a1 * (1 / (1 + (gamma*(x(2)))^2)); %more mutations = less apoptosis of mutated cells

%try
a1 = a1 * (1 / (1 + (theta * x(2))^2)); %mutations = less apoptosis of NORMAL cells 