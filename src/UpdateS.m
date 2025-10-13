%% min_S \|S-A\|_F + lambda \|S\|_1 
%% given A: n1*n2 matrix 
function [S] = UpdateS(A,lambda)
[n1,n2] = size(A);
a = A(:);
signa = sign(a);
absa = abs(a);
a = sort(absa,'descend');
[t,~,~] = UpdateS_sub(a,lambda);
S = reshape(max(absa - lambda*t,0).*signa,n1,n2);
end
