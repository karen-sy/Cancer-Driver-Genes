indices = [];
y = find(SyntheticY(cvp_training) == 3);
for i = 1:length(y)
x = y(i);
[~,idx]= sort(K(:,x));
idx = idx(end:-1:1);
a = SyntheticY(idx);
indices = [indices;find(a == 3)];

end
hist(indices);