function dist=KLDiv(P,Q)
%  dist = KLDiv(P,Q) Kullback-Leibler divergence of two discrete probability
%  distributions
%  P and Q  are automatically normalised to have the sum of one on rows
% have the length of one at each 
% P =  n x nbins
% Q =  1 x nbins or n x nbins(one to one)
% dist = n x 1

rng default;

[row1, ~] = (find(~isfinite(P))); 
[row2, ~] = (find(~isfinite(Q)));

P = P(setdiff(1:size(P,1),row1),:);
Q = Q(setdiff(1:size(Q,1),row2),:);


% checkpt
if size(P,2)~=size(Q,2)
    error('the number of columns in P and Q should be the same');
end
if sum(~isfinite(P(:))) + sum(~isfinite(Q(:)))
   error('the inputs contain non-finite values!') 
end

%% make sizes equal
rng default;
if size(Q,1) > size(P,1)
    idx = randperm(size(Q,1),size(P,1));
    Q = Q(idx,:);
else
    idx = randperm(size(P,1),size(Q,1));
    P = P(idx,:);
end

%% normalizing the P and Q
P = P';
Q = Q';
epsilon = 1e-10; 

if size(Q,1)==1
    Q = Q ./sum(Q) + epsilon;
    P = P ./repmat(sum(P,2),[1 size(P,2)]) + epsilon;
    temp =  P.*log(P./repmat(Q,[size(P,1) 1]));
    temp(isnan(temp)) = 10^-10;% resolving the case when P(i)==0
    dist = sum(temp,2);  
    
elseif size(Q,1)==size(P,1)
    Q = Q ./repmat(sum(Q,2),[1 size(Q,2)]) + epsilon;
    P = P ./repmat(sum(P,2),[1 size(P,2)]) + epsilon;
    temp =  P.*log(P./Q);
    temp(isnan(temp))=10^-10; % resolving the case when P(i)==0
    dist = sum(temp,2);
end
end