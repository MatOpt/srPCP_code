root_dir = "experiment_results/varying_mu";
dir_name = root_dir+"/varying_sigma2";
file_name = "/data.mat";
data = load(dir_name+file_name);

result = mean(data.err_all_root,3);
result = diag(1./min(result,[],2))*result;
% % % % tt = "||(L,S)-(L*,S*)||_F";

% result = mean(data.err_all_root_relative,3);
% % % % % tt = "||(L,S)-(L*,S*)||_F/||(L*,S*)||_F";

y = data.sigma_list;
ylb = "\sigma";

heatmap(data.mu_coef_list, y, result)
xlabel("\mu coefficient")
ylabel(ylb)
% title(tt)

fig = gcf;
set( findall(fig, '-property', 'fontsize'), 'fontsize', 14)
