% permutationTest takes scalar m and vectors x and y. m is the number of
% permuatations to iterate over. x and y are the data sets we are testing
% the p value for.

function p = permutationTest(m,x,y)
    allData = [x;y];
    lx = length(x(:,1));
    score = zeros(m,length(allData(1,:))); %threshold
    n = length(allData(:,1));
    for i = 1:m
        permData = allData(randperm(n),:);
        xP = permData(1:lx,:);
        yP = permData(lx+1:end,:);
        score(i,:) = abs(mean(xP)-mean(yP));
    end
    realScore = abs(mean(x)-mean(y));
    p = (sum(score>=realScore)+1)/(m+1);
end