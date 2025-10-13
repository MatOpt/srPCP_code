root_dir = "experiment_results/varying_sigma";
dir_name = root_dir+"/experiment1";
file_name = "/data.mat";
data = load(dir_name+file_name);
% 
% figure(1)
% line_root = plot(data.sigma_list,mean(data.err_L_root,2),"b.-","MarkerSize",10);
% interval_root = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_L_root,2)'-std(data.err_L_root'),fliplr(mean(data.err_L_root,2)'+std(data.err_L_root'))],"b");
% alpha(interval_root,0.1);
% hold on;
% 
% line_stable = plot(data.sigma_list,mean(data.err_L_stable,2),"r.-","MarkerSize",10);
% interval_stable = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_L_stable,2)'-std(data.err_L_stable'),fliplr(mean(data.err_L_stable,2)'+std(data.err_L_stable'))],"r");
% alpha(interval_stable,0.1);
% hold on;
% legend([line_root,line_stable],["root PCP","stable PCP"]);
% xlabel("\sigma")
% ylabel("||L-L0||_F")
% title("error for L")
% saveas(gcf,dir_name+"/error_L.jpeg");
% 
% figure(2)
% line_root = plot(data.sigma_list,mean(data.err_S_root,2),"b.-","MarkerSize",10);
% interval_root = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_S_root,2)'-std(data.err_S_root'),fliplr(mean(data.err_S_root,2)'+std(data.err_S_root'))],"b");
% alpha(interval_root,0.1);
% hold on;
% 
% line_stable = plot(data.sigma_list,mean(data.err_S_stable,2),"r.-","MarkerSize",10);
% interval_stable = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_S_stable,2)'-std(data.err_S_stable'),fliplr(mean(data.err_S_stable,2)'+std(data.err_S_stable'))],"r");
% alpha(interval_stable,0.1);
% hold on;
% legend([line_root,line_stable],["root PCP","stable PCP"]);
% xlabel("\sigma")
% ylabel("||S-S0||_F")
% title("error for S")
% saveas(gcf,dir_name+"/error_S.jpeg");
% 
% 
% figure(3)
% line_root = plot(data.sigma_list,mean(data.err_all_root,2),"b.-","MarkerSize",10);
% interval_root = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_all_root,2)'-std(data.err_all_root'),fliplr(mean(data.err_all_root,2)'+std(data.err_all_root'))],"b");
% alpha(interval_root,0.1);
% hold on;
% 
% line_stable = plot(data.sigma_list,mean(data.err_all_stable,2),"r.-","MarkerSize",10);
% interval_stable = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_all_stable,2)'-std(data.err_all_stable'),fliplr(mean(data.err_all_stable,2)'+std(data.err_all_stable'))],"r");
% alpha(interval_stable,0.1);
% hold on;
% legend([line_root,line_stable],["root PCP","stable PCP"]);
% xlabel("\sigma")
% ylabel("||(L,S)-(L0,S0)||_F")
% title("recovery error")
% saveas(gcf,dir_name+"/error_all.jpeg");
% 
% figure(4)
% line_root = plot(data.sigma_list,mean(data.time_root,2),"b.-","MarkerSize",10);
% interval_root = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.time_root,2)'-std(data.time_root'),fliplr(mean(data.time_root,2)'+std(data.time_root'))],"b");
% alpha(interval_root,0.1);
% hold on;
% 
% line_stable = plot(data.sigma_list,mean(data.time_stable,2),"r.-","MarkerSize",10);
% interval_stable = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.time_stable,2)'-std(data.time_stable'),fliplr(mean(data.time_stable,2)'+std(data.time_stable'))],"r");
% alpha(interval_stable,0.1);
% hold on;
% legend([line_root,line_stable],["root PCP","stable PCP"],"FontSize",15)
% xlabel("\sigma","FontSize",15)
% ylabel("time (s)","FontSize",15)
% % title("running time")
% saveas(gcf,dir_name+"/time.jpeg");
% 
% 
figure(5)
lw = 2;
ms=30
line_root_L = plot(data.sigma_list,sqrt(mean(data.err_L_root.^2,2)),"b.-","MarkerSize",ms,"LineWidth",lw);
% interval_root_L = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_L_root,2)'-std(data.err_L_root'),fliplr(mean(data.err_L_root,2)'+std(data.err_L_root'))],"b");
% alpha(interval_root_L,0.1);
hold on;

line_stable_L = plot(data.sigma_list,sqrt(mean(data.err_L_stable.^2,2)),"r.-","MarkerSize",ms,"LineWidth",lw);
% interval_stable_L = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_L_stable,2)'-std(data.err_L_stable'),fliplr(mean(data.err_L_stable,2)'+std(data.err_L_stable'))],"r");
% alpha(interval_stable_L,0.1);
hold on;

line_root_S = plot(data.sigma_list,sqrt(mean(data.err_S_root.^2,2)),"b.--","MarkerSize",ms,"LineWidth",lw);
% interval_root_S = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_S_root,2)'-std(data.err_S_root'),fliplr(mean(data.err_S_root,2)'+std(data.err_S_root'))],"b");
% alpha(interval_root_S,0.1);
hold on;

line_stable_S = plot(data.sigma_list,sqrt(mean(data.err_S_stable.^2,2)),"r.--","MarkerSize",ms,"LineWidth",lw);
% interval_stable_S = patch([data.sigma_list,fliplr(data.sigma_list)],[mean(data.err_S_stable,2)'-std(data.err_S_stable'),fliplr(mean(data.err_S_stable,2)'+std(data.err_S_stable'))],"r");
% alpha(interval_stable_S,0.1);
hold on;

legend([line_root_L,line_stable_L,line_root_S,line_stable_S],["L/root PCP","L/stable PCP","S/root PCP","S/stable PCP"],'Location','NorthWest');
xlabel("\sigma")
ylabel("RMS error")
fig = gcf;
set( findall(fig, '-property', 'fontsize'), 'fontsize', 15)

% title("recovery error")
saveas(gcf,dir_name+"/error_L_S.jpeg");