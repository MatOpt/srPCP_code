clc;
clear all;

n=300;
prob_S = 0.1; 
max_S = 0.05; 
rho_L = 0.1;

root_dir = "experiment_results/varying_mu";
dir_name = root_dir+"/varying_sigma2";
mkdir(dir_name);
file_name = "/data.mat";
% mu_coef_list = 0.1:0.1:1;
% sigma_list = 0.005:0.005:0.03;
mu_coef_list = 0.5:0.05:1;
sigma_list = 0.005:0.005:0.05;

num_run = 10;
[err_L_root,err_S_root,err_all_root] = deal(zeros([length(sigma_list),length(mu_coef_list),num_run]));
[err_L_root_relative,err_S_root_relative,err_all_root_relative] = deal(zeros([length(sigma_list),length(mu_coef_list),num_run]));

for i_sigma = 1:length(sigma_list)
    fprintf("testing %d/%d, sigma = %f",i_sigma,length(sigma_list),sigma_list(i_sigma));
    for i_run = 1:num_run
        % generate L, S, Z
        n1 = n;
        n2 = n;
        r = round(n*rho_L);
        U = randn(n1,r)/sqrt(n1);
        V = randn(n2,r)/sqrt(n2);
        L = U*V';
        S = (rand(n1,n2)<prob_S).*(2*(rand(n1,n2)<0.5)-1)*max_S;
        Z = randn(n1,n2)*sigma_list(i_sigma);
        D = L+S+Z;
        lambda = 1/sqrt(n1);
                
        
        % run root PCP
        for i_mu=1:length(mu_coef_list)
            [L_root, S_root] = root_pcp(D, lambda, sqrt(n2)*mu_coef_list(i_mu));
            err_L_root(i_sigma,i_mu,i_run) = norm(L-L_root,"fro");
            err_S_root(i_sigma,i_mu,i_run) = norm(S-S_root,"fro");
            err_all_root(i_sigma,i_mu,i_run) = sqrt(err_L_root(i_sigma,i_mu,i_run)^2+err_S_root(i_sigma,i_mu,i_run)^2);
            err_L_root_relative(i_sigma,i_mu,i_run) = norm(L-L_root,"fro")/norm(L,"fro");
            err_S_root_relative(i_sigma,i_mu,i_run) = norm(S-S_root,"fro")/norm(S,"fro");
            err_all_root_relative(i_sigma,i_mu,i_run) = err_all_root(i_sigma,i_mu,i_run)/sqrt(norm(L,"fro")^2+norm(S,"fro")^2);
        end
        
    end
end

save(dir_name+file_name)