   %% min_L \|L-A\|_F + lambda \|L\|_*
%% given A: n1*n2 matrix
function [L,L_nuc_norm,L_rank] = UpdateL(A,lambda,option_L)
    if strcmp(option_L.update_method,'base')
        [L,L_nuc_norm,L_rank] = updateL_base(A,lambda);
    elseif strcmp(option_L.update_method,'overparametrized')
        [L,L_nuc_norm,L_rank] = updateL_overparametrized(A,lambda,option_L);
    end
end


function [L,L_nuc_norm,L_rank] = updateL_base(A,lambda)
[U,S,V] = svd(A,'econ');
ss = diag(S);
[~,k,sk] = UpdateS_sub(ss,lambda);
L = U(:,1:k)*(sk(1:k).*(V(:,1:k))');
L_nuc_norm = sum(sk(1:k));
L_rank = k;
end

function [L,L_nuc_norm,L_rank] = updateL_overparametrized(A,lambda,option_L)
 a_norm = norm(A,'fro');
[m,n] = size(A);
% r = floor(max(option_L.L_rank,a_norm/a1))/2;%the update of r: r = r * 2;
r = option_L.L_rank/2;
flag = 0;


%%%%%%%%%%%%% update r
while(flag==0)
    if option_L.acceleration_rank == 1
        r = r * 2;
    else
        r = r * 2 + 1;
    end
    max_subspacedimension = max(3* r,15);
    [U,ss,V] = svds(A,r,'largest','SubspaceDimension',max_subspacedimension);

    s = diag(ss);
    [k1,s1,flag] = UpdateS_sub_L(s,lambda,1,a_norm,option_L);
end
if k1 == 0
    L = zeros(m,n);
else
    L = U(:,1:k1)*(s1(1:k1).*(V(:,1:k1))');
end
L_nuc_norm = sum(s1(1:k1));
L_rank = k1;
end

function [k,s,flag] = UpdateS_sub_L(a,lambda,check,A_norm,option_L)
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
n = length(a);
% trivial cases
if a(1) == 0 
    fprintf('a is a zero vector\n'); 
    s = zeros(n,1); 
    k = 0; 
    flag = 1;
    return;
elseif lambda <= 1e-16
    s = a;
    k = n;
    flag =1 ;
    return;
elseif lambda >= a(1)/A_norm%norm(a,'inf')/norm(a,2)
    s = zeros(length(a),1);
    k = 0;  
    flag = 1;
    return;
end
% nontrivial cases

% search k
l2 = lambda^2;
kbar = floor(1/l2);
if kbar == 1/l2
    kbar = kbar - 1;
end
kbar = min(kbar,n-1);
k = 0;
flag = 0;
s = zeros(length(a),1);
for i = 1:kbar
    tmp = A_norm^2 - sum(a(1:i).^2);
    tk = sqrt(tmp / (1/lambda^2 - i));
    if a(i+1) <= tk && a(i) > tk
        k = i;
        flag = 1;
        break;
    end
end
if flag == 0 && option_L.acceleration_rank == 1
    flag = 1;
    k = n;
    tmp = A_norm^2 - sum(a.^2);
    tk = sqrt(tmp / (1/lambda^2 - i));
end

if flag == 1
    s = max(a - tk,0);
end

end
