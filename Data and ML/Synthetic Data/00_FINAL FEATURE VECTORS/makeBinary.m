function binary = makeBinary (input)
neg = find(input == 1);
pos = find(input ~= 1); %convert tcg and og categories into one "driver" category

input(neg) = 0;
input(pos) = 1;

binary = input;


end
