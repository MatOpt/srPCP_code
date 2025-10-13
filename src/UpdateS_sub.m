%% min_s ||s-a||_2 + lambda*||s||_1, given a \in R^n
%% Input nonzero vector a satisfying a1>=a2>=...>=an>=0, 
%%       parameter lambda satisfying 1/sqrt(nnz(a)) < lambda < norm(a,'inf')/norm(a,2)
%% Output s: optimal solution
%%        k: nnz(s)
%%        obj: objective value
%%        normdiff: ||s-a||_2
function [normdiff,k,s] = UpdateS_sub(a,lambda,check)
if ~exist('check','var')
    check = 0;
end
if check
    if min(a) < 0
        fprintf('a should be nonnegative\n');
        a = abs(a);
    end
    if ~issorted(a,'descend') 
        fprintf('a should be in a descending order'); 
        a = sort(a,'descend');
    end

end
a0 = nnz(a);
% trivial cases
if a0 == 0 
    fprintf('a is a zero vector\n'); 
    s = zeros(length(a),1); 
    k = 0; 
    normdiff = 0; 
    return;
elseif lambda <= 1/sqrt(a0) 
    s = a;
    k = a0;
    normdiff = 0;
    return;
elseif lambda >= a(1)/norm(a,2)%norm(a,'inf')/norm(a,2)
    s = zeros(length(a),1);
    k = 0;
    normdiff = norm(a,2);    
    return;
end
% nontrivial cases
% search k
l2 = lambda^2;
kbar = floor(1/l2);
if kbar == 1/l2
    kbar = kbar - 1;
end
asquare = a.^2;
sa = cumsum(asquare,'reverse');
tk = sqrt(sa(1:(kbar+1))./(1/l2 - (0:kbar)'));
seq = a(1:(kbar+1)) - tk;
seq = sign(seq);
k = find(diff(seq) < 0,1);
if isempty(k)
    fprintf('failed to find k\n');
end
normdiff = tk(k+1)/lambda;
s = max(a - tk(k+1),0);
end
