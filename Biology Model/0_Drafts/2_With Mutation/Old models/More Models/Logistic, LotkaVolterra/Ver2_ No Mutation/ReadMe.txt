%Review of Lotka-Volterra ver.2:
    %(no normal converting to cancer) (aka "SIMPLE LOGISTIC")
%default parameters stored in LotkaParamsTwo.mat

%% 
%1a) changing c1,c2 changes total cell carrying capacity (different from cp = 50)
  %because oxygen (and its intake) is what defines carry cap anyways
  
%1b) however, c1 and c2 aren't "competition terms" between normal/cancer cells 
  %because there is no true 'interaction' between the two populations (no normal-->cancer). 
  %In other words, if v1=v2 and a1=a2, the two populations' growth dynamics will be the same
  %even if c1 is not equal to c2. Changes to c1,c2 only will change the
  %total cell carrying capacity (see 1a). 
  
%2) can NOT change dynamics (by manipulating v, a, c, k, ...)
 %...after steady state is reached (logistic term settles to 0)

