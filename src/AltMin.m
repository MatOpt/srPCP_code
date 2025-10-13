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
maxtime = 3600*5;
breakyes = 0;
obj = 0;
succL = 100;
succS = 100;
svd_time = 0;
sorting_time = 0;
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
    fprintf('\n iter|  obj       gap     rank_L time');
    fprintf('\n--------------------------------');
end
%% main loop
for iter = 1:maxiter
    %% update S
    Sold = S;
    tic;
    S = UpdateS(D - L,lambda/mu);
    sorting_time = sorting_time + toc;
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
    runhist.sorting_time(iter) = sorting_time;
    runhist.svd_time(iter) = svd_time;
    

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
            fprintf('\n%5.0d| % 5.3f %2.2e %5d %5.1f\n',iter,obj,T,L_rank,ttime);
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
end
