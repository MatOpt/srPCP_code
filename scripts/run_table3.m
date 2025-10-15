clear all;
clc;
warning off;
addpath(genpath(pwd));
addpath(genpath('./root_pcp_code'))
addpath(genpath("../src"))
output_filepath = "../results/table3_result.txt";
if ~exist(output_filepath,'file')
    fid = fopen(output_filepath,"w");
    fclose(fid);
end
fid = fopen(output_filepath,"a");

str = '../data/VBM4D_rawRGB/';
fig_list = ["M0005","M0009","M0016","M0017"];
fprintf(fid,"Name  Time  obj   iter  dim\n");
for j = 1:length(fig_list)
    fig = fullfile(str,fig_list(j));
    files = dir(fullfile(fig,'*.png'));
    number_files = length(files);
    n2 = number_files;
    info = imfinfo(fullfile(fig,files(1).name));
    m = info.Width;
    n = info.Height;
    n1 = m * n;
    Im = zeros(n1,number_files);
    for i=1:number_files
        rgb = imread(fullfile(fig,files(i).name));
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

    fprintf('the base method')
    options.update_method = 'base';
    % tic;
    tstart0 = clock;
    [Lbaro,Sbaro,objo,itero,runhisto] = AltMin(Im,lambda,mu,options);

    t0 = etime(clock,tstart0);
    fprintf(fid,fig_list(j));
    fprintf(fid,' %d  %3.3f   %d   %d \n',round(t0),objo,runhisto.iter,n2);


    % other solver
    fprintf('\n\n');
    
    tic;
    [L2,S2,i,runhist_pcp] = root_pcp(Im,lambda,mu);
    t2 = toc;
    obj2 = sum(svd(L2)) + lambda*sum(abs(S2(:))) + mu*norm(L2 + S2 - Im,'fro');
    fprintf(fid,fig_list(j));
    fprintf(fid,' %d  %3.3f   %d   %d \n',round(t2),objo,runhisto.iter,n2);
end