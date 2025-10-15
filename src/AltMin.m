%% Alternating minimization for solving the 
%% square root principle component pursuit (srPCP) problem
%% min_{L,S} \|L\|_* + lambda \|S\|_1 + mu \|L+S-D\|_F
%% D is a given n1*n2 matrix, WLOG assume n1 >= n2
%% lambda > 0, mu > 0 are given penalty parameters
%% \| \|_* nuclear norm, \| \|_1 \ell_1 norm, \| \|_F Frobenius norm
%%
%% AltMin: Copyright (c) 2021
%% Yangjing Zhang 27 Dec 2021
%%
function [L,S,obj,iter,runhist] = AltMin(D,lambda,mu,options)
[n1,n2] = size(D);
fprintf('\n-------------Alternating minimization for srPCP-------------');
if n1 < n2
    D = D';
    tmp = n1;
    n1 = n2;
    n2 = tmp;
    fprintf('\nConsider Transpose of D');
end
tstart = clock;
%% options
tol = 1e-6;
printyes = 1;
maxiter = 1000;
maxtime = 3600*5;%  an hour
breakyes = 0;
obj = 0;
succL = 100;
succS = 100;
svd_time = 0;
order_time = 0;
option_L.test_rank = [];
if exist('options','var')
    if isfield(options,'tol'); tol = options.tol; end
    if isfield(options,'printyes'); printyes = options.printyes; end
    if isfield(options,'maxiter'); maxiter = options.maxiter; end
    if isfield(options,'maxtime'); maxtime = options.maxtime; end
end
%% options of update L 
% options_L.L_rank = 20;
option_L.L_rank = int64(n2 / 1000) + 1;
option_L.acceleration_rank = 0;
option_L.update_method = 'base';
if isfield(options,'L_rank'); option_L.L_rank = options.L_rank; end
if isfield(options,'update_method'); option_L.update_method = options.update_method; end
%% initialization 
if ~exist('L','var') || ~exist('S','var')
    L = zeros(n1,n2); S = zeros(n1,n2);
end
if printyes
    fprintf('\n (n1,n2)=(%d,%d),lambda=%2.2e,mu=%2.2e,tol=%2.2e',n1,n2,lambda,mu,tol);
    fprintf('\n iter|objective value  gap rank_L time');
    fprintf('\n--------------------------------');
end
%% main loop
for iter = 1:maxiter
    %% update S
    Sold = S;
    tic;
    S = UpdateS(D - L,lambda/mu);
    order_time = order_time + toc;
    %% update L
    Lold = L;
    tic;
    [L,L_nuc_norm,L_rank] = UpdateL(D - S,1/mu,option_L);
    svd_time = svd_time +   toc;
    option_L.L_rank = L_rank;
    %% compute obj, check termination
    objold = obj;
    obj = L_nuc_norm + lambda*sum(abs(S(:))) + mu*norm(L + S - D,'fro');
    ttime = etime(clock,tstart);
    runhist.obj(iter) = obj;
    runhist.ttime(iter) = ttime;
    runhist.L_rank(iter) = L_rank;
    runhist.S_nnz(iter) = nnz(S);
    runhist.order_time(iter) = order_time;
    runhist.svd_time(iter) = svd_time;
    
    % n1_start = 100;
    % n2_start = 1;
    % m = 50;
    % if iter == 10
    %     X_origin = (S(n1_start:n1_start+m,n2_start:n2_start+m)~=0);
    % end
    % if iter > 10
    %     X_origin = change_S(X_origin,S,m,n1_start,n2_start);
    % end

    if iter == maxiter
        breakyes = 2;
        msg = 'max iter achieved';
    end
    if etime(clock,tstart) > maxtime
        breakyes = 3;
        msg = 'time out';
    end
    % [U,S1,V] = svd(L);
    % T(iter) = norm(U*V' + mu * (L + S - D)/norm(L+S-D,'fro'));
    T = norm(-(L-D+S)/norm(L-D+S,'fro') + (L-D+Sold)/norm(L-D+Sold,'fro'),'fro');
    T = mu*T / (1 + norm(L,'fro'));
    runhist.T(iter) = T;
    eta_frac = prox_l1(S-mu * (L+S-D)/norm(L+S-D,'fro'),lambda);
    eta = norm(S-eta_frac,'fro') / max([1,norm(L,'fro'),norm(S,'fro')]);
    runhist.eta(iter) = eta;
    succ_obj = abs(objold - obj)/(obj + 1);
    if (iter > 5) && (eta < tol)
        breakyes = 1;
        msg = 'successive change<tol';
    end
    if printyes
        if rem(iter,10) == 1 || breakyes
            fprintf('\n%5.0d| % 5.8f %2.2e %5d %5.1f\n',iter,obj,T,L_rank,ttime);
        end
    end
    if breakyes
        if printyes 
            fprintf('\n %d iterations, ',iter);
            fprintf('%s\n',msg); 
        end
        runhist.succ = max([succ_obj,succL,succS]);
        runhist.iter = iter;
        break;
    end
end
% runhist.Schange = X_origin;
end

function X = change_S(X_origin,S,m,n1_start,n2_start)
%X: 0表示S在该位置始终为 0,1表示S在该位置始终为非0,2表示S在该位置有变动
n1_end = n1_start + m;
n2_end = n2_start + m;
S1 = S(n1_start:n1_end,n2_start:n2_end);
X = 2 * ones(size(X_origin));  % 默认设为2
% 情况1: X_origin为1且S1不为0
mask1 = (X_origin == 1) & (S1 ~= 0);
X(mask1) = 1;
% 情况2: X_origin为0且S1为0
mask2 = (X_origin == 0) & (S1 == 0);
X(mask2) = 0;
end
