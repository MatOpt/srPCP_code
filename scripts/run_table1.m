clear all;
clc;
warning off;
addpath(genpath(pwd));
addpath(genpath('./root_pcp_code'))
addpath(genpath("../src"))
output_filepath = "../results/table1_result.txt";
if ~exist(output_filepath,'file')
    fid = fopen(output_filepath,"w");
    fclose(fid);
end
fid = fopen(output_filepath,"a");
n_list = [1000,2000,5000,10000];
sigma_list = [1e-1,1e-2,1e-3,1e-4];
fprintf(fid,"method   dim   r   noise     obj   time   etaL  etaS\n");
for i = 1:4
    for j = 1:4
        n1 = n_list(i);
        n2 = n1;
        % sparse S
        prob_S = 0.1; 
        max_S = 0.05; 
        rng(1);
        S = (rand(n1,n2)<prob_S).*(2*(rand(n1,n2)<0.5)-1)*max_S;
        % low rank L
        r = 50;
        U = randn(n1,r)/sqrt(n1);
        V = randn(n2,r)/sqrt(n2);
        L = U*V';
        % noise
        sigma = sigma_list(j);
        Z = sigma*randn(n1,n2);
        % D
        D = L +S+ Z; 

        % our solver
        lambda = 1/sqrt(n1);
        mu = sqrt(n2/2);
        options.tol = 1e-6;
        
% %%%%%%%%%%%%%%%%%%%%%%%%%%base
        options.update_method = 'base';
        fprintf('the base method');
        % tic;
        tstart1 = clock;
        [Lbar,Sbar,obj,iter,runhist] = AltMin(D,lambda,mu,options);
        t1 = etime(clock,tstart1);
        eta_L = norm(Lbar - L,'fro')/(1 + norm(L,'fro'));
        eta_S = norm(Sbar - S,'fro')/(1 + norm(S,'fro'));
        fprintf(fid,"base   %d   %d   %1.0e   %5.2f  %d   %1.2f    %1.2f \n",n1,r,sigma,obj,round(t1),...
            eta_L,eta_S);

        tstart2 = clock;
        [L2,S2,~,runhist_pcp] = root_pcp(D,lambda,mu);
        t2 = etime(clock,tstart2);
        eta_L = norm(L2 - L,'fro')/(1 + norm(L,'fro'));
        eta_S = norm(S2 - S,'fro')/(1 + norm(S,'fro'));
        fprintf(fid,"ADMM   %d   %d   %1.0e   %5.2f  %d  %1.2e    %1.2e\n",n1,r,sigma,...
            runhist_pcp.obj(end),round(t2),eta_L,eta_S);
    end
end