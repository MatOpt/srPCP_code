n1 = 100;
n2 = 100;
n = n1;

r = 5;
prob_S = 0.05; % probability of (i,j) in support of S_0
max_S = 0.1; % magnitude of S_0, assuming random sign
sigma = 0.02; % entrywise standard deviation of noise in Z, assuming Gaussian noise

% L: singular values ~ 1, ||L||_F^2 ~ r
% ||S||_F^2 ~ prob_S*n1*n2*max_S^2
% ||Z||_F^2 ~ n1*n2*sigma^2

U = randn(n1,r)/sqrt(n1);
V = randn(n2,r)/sqrt(n2);
L = U*V';
S = (rand(n1,n2)<prob_S).*(2*(rand(n1,n2)<0.5)-1)*max_S;
Z = randn(n1,n2)*sigma;

D = L+S+Z;
lambda = 1/sqrt(n1);

start_stable = tic;
[L_stable, S_stable] = stable_pcp(D, lambda, 1/sigma/sqrt(2*n));
err_L_stable = norm(L-L_stable,"fro");
err_S_stable = norm(S-S_stable,"fro");
runtime_stable = toc(start_stable);

start_root = tic;
[L_root, S_root] = root_pcp(D, lambda, sqrt(n2/2));
err_L_root = norm(L-L_root,"fro");
err_S_root = norm(S-S_root,"fro");
runtime_root = toc(start_root);

