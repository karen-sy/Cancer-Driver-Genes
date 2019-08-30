function [model] = SVMtrain(X, y, C, tol)

%% initialize
m = size(X,1);
alpha = zeros(m,1);
b = 0;
E = zeros(m,1); %E(k) caches error btwn svm output and true label at point[k]

examineAll = 1;
y(y==0) = -1;

%% Kernel (linear)
K = @(x1,x2) x1 * x2' ; 
%wTx = ((alpha.*y)'* K(X,X))'; 
w = ((alpha.*y)'* X)'; 

%% Get alphas
%assume while exit = 0

for idx_i = 1:m  %(1): find alpha1
    f = X*w + b;
    if examineAll == 1 %scan over whole set
        examine_old = 1; 
        if (alpha(idx_i)==0 && y(idx_i)* f(idx_i) >=1) ...
                || (0<alpha(idx_i)<C && y(idx_i)*f(idx_i) == 1) ...
                || (alpha(idx_i)==C && y(idx_i)*f(idx_i) <=1)
            continue;
        else
            i = idx_i; %point (i) for alpha_i found
        end
        
    elseif examineAll == 0 %scan only non-bound sols (multipliers are NEITHER 0 or C)
        examine_old = 0; 
        if (0<alpha(idx_i)<C && y(idx_i)*f(idx_i) == 1)
            examineAll = 1; %next iteration: examine all training examples
            continue; %to next idx_i
        else
            i = idx_i; 
        end      
    end
   
    if E(i)>= 0
        [~,j] = min(E); %point (j) for alpha_j found
    else
        [~,j] = max(E);
    end
    
    alph1 = alpha(i); %lagrange multiplier for point 1
    alph2 = alpha(j); %lagrange multiplier for point 2
    y1 = y(i); %'right answer' for point 1
    y2 = y(j); %'right answer' for point 2
    s = y1*y2;
    
    E1 = f(i)-y(i) ;  
    E2 = f(j)-y(j);
    

    %get L,H
    if y1 ~= y2
        L = max(0,alph2-alph1); H = min(C,C+alph2-alph1);
    else
        L = max(0,alph2+alph1-C); H = min(C,alph2+alph1);
    end
    
    if L==H
        if examine_old == 0 %if this was 'examine nonbound only' run
            examineAll = 1; %switch to 'examine all'
        end
        continue;
    end
       
    k11 = K(X(i,:), X(i,:)); k12 = K(X(i,:), X(j,:)); k22 = K(X(j,:), X(j,:)); 
    eta = 2*k12-k11-k22;
    
    if (eta<0)
        a2 =  alph2 - y2*(E1-E2)/eta; %compute new value for alpha(j)
        a2 = min(a2,H); a2 = max(a2,L); %clip to be within [L,H]
    else
        gamma = alph1+s*alph2; %a constant that depends on previous values of a1,a2,s
        v1 = f(1)- (y1*alph1*K(X(1,:),X(i,:))-y2*alph2*K(X(2,:),X(1,:)));
        v2 = f(2) - (y1*alph1*K(X(1,:),X(2,:))-y2*alph2*K(X(2,:),X(2,:)));
        
        obj = @(a2) gamma-s*a2 + a2 - 0.5*k11*(gamma-s*alph2)^2 -0.5*k22*(alph2)^2 -s*k12*(gamma-s*a2)*a2 ...
              - y1(gamma-s*a2)*v1 - y2*a2*v2 + Wconstant;
        
        Lobj = obj(L); %objective function at a2 = L
        Hobj = obj(H); %objective function at a2 = H
        if Lobj > Hobj + tol
            a2 = L;
        elseif Lobj < Hobj - tol  
            a2 = H;
        else
            a2 = alph2;
        end
    end
    
    if a2 < 1e-8
        a2 = 0;
    elseif a2 > (C-1e-8)
        a2 = C;
    end
    
    if (abs(a2-alph2) < eps*(a2+alph2+eps)) %check if change in alpha is significant        
        if examine_old == 0 %if this was 'examine nonbound only' run
            examineAll = 1; %switch to 'examine all'
        end
        continue; 
    end
    
    %determine final a1
    a1 = alph1+(y1*y2)*(alph2-a2);
    
    %update threshold (b) to reflect change in lagrange multipliers
    b_old = b; 
    b1 = b - E1 ...
        - y1 * (a1 - alph1) *  K(X(i,:),X(j,:))' ...
        - y2 * (a2 - alph2) *  K(X(i,:),X(j,:))';
    b2 = b - E2 ...
        - y1 * (a1 - alph1) *  K(X(i,:),X(j,:))' ...
        - y2 * (a2 - alph2) *  K(X(j,:),X(j,:))';
    
    %compute b
    if (0 < a1 && a1 < C) %alpha(i) within bound
        b = b1;
    elseif (0 < a2 && a2 < C) %alpha(j) within bound
        b = b2;
    else 
        b = (b1+b2)/2;
    end
    
    
    %update weight vector to reflect change in a1,a2 (linear svm case)
    w = w + y1*(a1-alph1)*X(i,:) + y2*(a2-alph2)*X(j,:); 


    %update error cache using new Lagrange multipliers
    for k = 1:(m-2)
        if ~(k==i || k == j)
            E(k) = E(k) + y1*(a1-alph1)*K(X(i,:),X(k,:))+y2*(a2-alph2)*K(X(j,:),X(k,:)) - (b_old-b); %+-b?
        end
    end
    
    %store a1 in alpha array
    alpha(i) = a1; 
    %store a2 in alpha array
    alpha(j) = a2;
 
if examine_old == 1 %if this was a 'examine all' run
    examineAll = 0; %switch to examining only nonbound alpha
else %scan_old == 0
    examineAll = 0; %continue examining only nonbound alpha
end

disp(idx_i)

end
fprintf('done! \n')

%save model

idx = alpha > 0;
model.X= X(idx,:);
model.y= y(idx);
model.b= b;
model.alphas= alpha(idx);
model.w = ((alpha.*y)'* X)'; 


end



