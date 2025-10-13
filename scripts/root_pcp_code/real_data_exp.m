clc;
clear all;

dir_name = "real_data";

% name_of_data = ["hall","lights","restaurant","yaleB01","yaleB02","yaleB03","yaleB04","yaleB05","yaleB06","yaleB08"]

% name_of_data = ["hall","lights"];
% noise_level_list = 0:30:150;

name_of_data = ["yaleB01","yaleB02","yaleB03"];
noise_level_list = 0:10:40;

for i=1:length(name_of_data)
    file_name = sprintf("/%s.mat",name_of_data(i));
    save_dir = sprintf("experiment_results/%s",name_of_data(i));
    mkdir(save_dir)
    data = load(dir_name+file_name);
    L_plus_S = data.D;
    [n1 n2]= size(L_plus_S);
    lambda = 1/sqrt(max(n1,n2));
    
    for j=1:length(noise_level_list)
        fprintf("testing file %s, noise %d/%d = %d",name_of_data(i),j,length(noise_level_list),noise_level_list(j));
        
        Z = randn(n1,n2)*noise_level_list(j);
        D = L_plus_S + Z;
        
        start_stable = tic;
        [L_stable, S_stable] = stable_pcp(D, lambda, 1/noise_level_list(j)/(sqrt(n1)+sqrt(n2)));
        time_stable = toc(start_stable);
    
    
        start_root = tic;
        [L_root, S_root] = root_pcp(D, lambda, sqrt(min(n1,n2)/2));
        time_root = toc(start_root);

        save(save_dir+sprintf("/data_%d.mat",j));
    end
end