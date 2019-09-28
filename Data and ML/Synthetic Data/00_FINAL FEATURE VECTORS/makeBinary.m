function binary = makeBinary (input)
input(input ~= 1) = 2; %convert tcg and og categories into one "driver" category

if unique(input) == ([1; 2])
binary = input;
end

end
