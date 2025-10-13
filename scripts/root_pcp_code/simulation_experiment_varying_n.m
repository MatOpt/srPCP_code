% L: singular values ~ 1, ||L||_F^2 ~ r
% ||S||_F^2 ~ prob_S*n1*n2*max_S^2
% ||Z||_F^2 ~ n1*n2*sigma^2
% prob_S: probability of (i,j) in support of S_0
% max_S: magnitude of S_0, assuming random sign
% sigma: entrywise standard deviation of noise in Z, assuming Gaussian noise
clc;
clear all;

prob_S = 0.1; 
max_S = 0.05; 
sigma = 0.01;
rho_L = 0.1;

lambda_poisson = 3;


root_dir = "experiment_results/varying_dimension";
dir_name = root_dir+"/experiment1";
mkdir(dir_name);
file_name = "/data.mat";
n_list = 200:100:1000;

num_run = 20;
[err_L_stable,err_S_stable,err_all_stable, err_L_root,err_S_root,err_all_root, time_stable,time_root] = deal(zeros([length(n_list),num_run]));

for i_n = 1:length(n_list)
    fprintf("testing %d/%d, n = %f",i_n,length(n_list),n_list(i_n));
    for i_run = 1:num_run
        % generate L, S, Z
        n = n_list(i_n);
        n1 = n;
        n2 = n;
        r = round(n*rho_L);
        U = randn(n1,r)/sqrt(n1);
        V = randn(n2,r)/sqrt(n2);
        L = U*V';
        S = (rand(n1,n2)<prob_S).*(2*(rand(n1,n2)<0.5)-1)*max_S;
% % %         Gaussian Noise
        Z = randn(n1,n2)*sigma;
% % %         Poisson Noise
%         poisson_scale = sigma/sqrt(lambda_poisson+lambda_poisson^2);
%         Z = poissrnd(lambda_poisson,n1,n2)*poisson_scale;
% % %         Uniform Noise
%         Z = (rand(n1,n2)-0.5)*2*sqrt(3)*sigma;
        D = L+S+Z;
        lambda = 1/sqrt(n1);
        
        % run stable PCP
        start_stable = tic;
        [L_stable, S_stable] = stable_pcp(D, lambda, 1/sigma/sqrt(n)/2);
        time_stable(i_n,i_run) = toc(start_stable);
        err_L_stable(i_n,i_run) = norm(L-L_stable,"fro");
        err_S_stable(i_n,i_run) = norm(S-S_stable,"fro");
        err_all_stable(i_n,i_run) = sqrt(err_L_stable(i_n,i_run)^2+err_S_stable(i_n,i_run)^2);
        
        
        % run root PCP
        start_root = tic;
        [L_root, S_root] = root_pcp(D, lambda, sqrt(n2/2));
        time_root(i_n,i_run) = toc(start_root);
        err_L_root(i_n,i_run) = norm(L-L_root,"fro");
        err_S_root(i_n,i_run) = norm(S-S_root,"fro");
        err_all_root(i_n,i_run) = sqrt(err_L_root(i_n,i_run)^2+err_S_root(i_n,i_run)^2);
        
    end
end

save(dir_name+file_name)