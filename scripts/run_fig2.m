clear;
clc;
warning off;
addpath(genpath(pwd));
addpath(genpath('./root_pcp_code'))
addpath(genpath("../src"))

str = '../data/VBM4D_rawRGB/';
fig_list = ["M0001","M0005","M0008","M0009","M0010","M0016","M0017","M0020"];
for j = 1:length(fig_list)
    fig = strcat(str,fig_list(j));
    files = dir(strcat(fig,'*.jpg'));
    number_files = length(files);
    n2 = number_files;
    info = imfinfo([str,files(1).name]);
    m = info.Width;
    n = info.Height;
    n1 = m * n;
    Im = zeros(n1,number_files);
    for i=1:number_files
        rgb = imread([str,files(i).name]);
        grayim = im2double(rgb2gray(rgb));
        grayim = imresize(grayim,[m,n]);
        I = reshape(grayim,[],1);
        Im(:,i) = I;
    end

    % run Alt
    lambda = 1/sqrt(n1);
    mu = sqrt(n2/2);
    options.tol = 1e-5;
    %test of continue
    options.update_method = 'overparametrized';
    % tic;
    [Lbar,Sbar,obj,iter,runhist] = AltMin(Im,lambda,mu,options);
    if j == 1; basketball_rank = runhist.L_rank; end
    if j == 2; windmill_rank = runhist.L_rank; end
    if j == 3; tabletennis_rank = runhist.L_rank; end
    if j == 4; billiards_rank = runhist.L_rank; end
    if j == 5; street_rank = runhist.L_rank; end
    if j == 6; store_rank = runhist.L_rank; end
    if j == 7; teaset_rank = runhist.L_rank; end
    if j == 8; flag_rank = runhist.L_rank; end
end

colors = [
    0, 0.4470, 0.7410;
    0.8500, 0.3250, 0.0980;
    0.9290, 0.6940, 0.1250;
    0.4940, 0.1840, 0.5560;
    0.4660, 0.6740, 0.1880;
    0.3010, 0.7450, 0.9330;
    0.6350, 0.0780, 0.1840;
    0.0000, 0.0000, 0.0000
];
lineStyles = {'-', ':', '--', '-.', '-.', '--', '-', ':'};  
markers = {'none', 'none', 'none', 'none', 'none', 'none', 'none', 'none'};


figure;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

plot(billiards_rank,'LineStyle',lineStyles{1},'Color',colors(1,:),'marker',markers{1},'linewidth',2); hold on
plot(store_rank,'LineStyle',lineStyles{2},'Color',colors(2,:),'marker',markers{2},'linewidth',2); hold on
plot(teaset_rank,'LineStyle',lineStyles{3},'Color',colors(3,:),'marker',markers{3},'linewidth',2); hold on
plot(tabletennis_rank,'LineStyle',lineStyles{4},'Color',colors(4,:),'marker',markers{4},'linewidth',2); hold on
plot(basketball_rank,'LineStyle',lineStyles{5},'Color',colors(5,:),'marker',markers{5},'linewidth',2); hold on
plot(windmill_rank,'LineStyle',lineStyles{6},'Color',colors(6,:),'marker',markers{6},'linewidth',2); hold on
plot(street_rank,'LineStyle',lineStyles{7},'Color',colors(7,:),'marker',markers{7},'linewidth',2); hold on
plot(flag_rank,'LineStyle',lineStyles{8},'Color',colors(8,:),'marker',markers{8},'linewidth',2); hold on
xlim([0,80])
xlabel("Iterations ($i$)",'FontSize',10)
ylabel("${\rm Rank}\,(L^i)$",'FontSize',10)
% Add title without bold formatting
title("Rank Identification",'FontSize',12)

% Add legend with optimal position
lgd = legend("billiards","store","tea set","table tennis","basketball player","windmill","street","flag",'FontSize',10);
set(lgd,'Location','northeast','NumColumns',2)  % This will automatically choose the best location for the legend
img = gcf;
print(img,'-depsc','-r900','../result/rank_identification.eps');