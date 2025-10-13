clear all;
clc;
warning off;
addpath(genpath(pwd));
addpath(genpath('./root_pcp_code'))
addpath(genpath("../src"))
output_filepath = "../results/table2_result.txt";
if ~exist(output_filepath,'file')
    fid = fopen(output_filepath,"w");
    fclose(fid);
end
fid = fopen(output_filepath,"a");
rng(1);
para = [10000,20,1e-1,1.395;
        10000,20,1e-2,1.395;
        10000,20,1e-3,1.42;
        10000,20,1e-4,1.45;
        10000,50,1e-1,1.28;
        10000,50,1e-2,1.38;
        10000,50,1e-3,1.4;
        10000,50,1e-4,1.41;
        20000,20,1e-1,1.4;
        20000,20,1e-2,1.405;
        20000,20,1e-3,1.42;
        20000,20,1e-4,1.44;
        20000,50,1e-1,1.39;
        20000,50,1e-2,1.39;
        20000,50,1e-3,1.341;
        20000,50,1e-4,1.41;
        50000,20,1e-1,1.405;
        50000,20,1e-2,1.405;
        50000,20,1e-3,1.413;
        50000,20,1e-4,1.415;
        50000,50,1e-1,1.402;
        50000,50,1e-2,1.402;
        50000,50,1e-3,1.41;
        50000,50,1e-4,1.413;
];
fprintf(fid,"method   dim   r   noise      obj   time   svd    order\n");
for i = 1:size(para,1)
        n1 = para(i,1);
        n2 = n1;
        r = para(i,2);
        sigma = para(i,3);
        prob_S = 0.1; 
        max_S = 0.05; 
        S = (rand(n1,n2)<prob_S).*(2*(rand(n1,n2)<0.5)-1)*max_S;
        % low rank L
        U = randn(n1,r)/sqrt(n1);
        V = randn(n2,r)/sqrt(n2);
        L = U*V';
        % noise

        Z = sigma*randn(n1,n2);
        % D
        D = L +S+ Z; 

        lambda = 1/sqrt(n1);
        mu = sqrt(n2/2)/para(i,4);
        % mu = (n1*n2)^(1/4)/sqrt(2);
        options.tol = 1e-6;

% %%%%%%%%%%%%%%%%%%%%%%%%%%base
        options.update_method = 'base';
        fprintf('the base method');
        % tic;
        tstart1 = clock;
        [Lbar,Sbar,obj,iter,runhist] = AltMin(D,lambda,mu,options);
        t1 = etime(clock,tstart1);
        fprintf(fid,"base   %d   %d   %1.0e   %5.2f  %d   %d   %d \n",n1,r,sigma,obj,round(t1),...
            round(runhist.svd_time(end)),round(runhist.sorting_time(end)));

        options.update_method = 'overparametrized';
        % options.updateS_method = 'mask';
        fprintf('the overparametrized method');
        % tic;
        tstart2 = clock;
        [Lbar,Sbar,obj,iter,runhist] = AltMin(D,lambda,mu,options);

        t2 = etime(clock,tstart2);

        fprintf(fid,"over   %d   %d   %1.0e   %5.2f  %d   %d   %d \n",n1,r,sigma,obj,round(t2),...
            round(runhist.svd_time(end)),round(runhist.sorting_time(end)));
    
        % % other solver
    
        tstart3 = clock;
        [L2,S2,~,runhist_pcp] = root_pcp(D,lambda,mu);
        t3 = etime(clock,tstart3);

        fprintf(fid,"ADMM   %d   %d   %1.0e   %5.2f  %d   %d   %d \n",n1,r,sigma,...
            runhist_pcp.obj(end),round(t3),0,0);

  end

