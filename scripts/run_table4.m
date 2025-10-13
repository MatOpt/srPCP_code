clear all;
clc;
warning off;
addpath(genpath(pwd));
addpath(genpath('./root_pcp_code'))
addpath(genpath("../src"))
output_filepath = "../results/table4_result.txt";
if ~exist(output_filepath,'file')
    fid = fopen(output_filepath,"w");
    fclose(fid);
end
fid = fopen(output_filepath,"a");
%%%%%read the vedio%%%%%%%%%%%%%%%
str = '../data/VBM4D_rawRGB/';
fig_list = ["M0001","M0005","M0010","M0020"];
fprintf(fid,"Name  Time  dim  svd  order rank");
for j = 1:length(fig_list)
    fig = strcat(str,fig_list(j));
    files = dir(strcat(fig,'*.png'));
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

    fprintf('the overparametrized method')
    options.update_method = 'overparametrized';
    % tic;
    tstart0 = clock;
    [Lbaro,Sbaro,objo,itero,runhisto] = AltMin(Im,lambda,mu,options);

    t0 = etime(clock,tstart0);
    fprintf(fid,fig_list(i));
    fprintf(fid,'  %d  %d  %d   %d  %d \n',t0,n2,runhisto.svd_time(end), ...
        runhisto.order_time(end),runhisto.L_rank(end));


    % other solver
    fprintf('the base method')
    options.update_method = 'base';
    % tic;
    tstart1 = clock;
    [Lbar,Sbar,obj,iter,runhist] = AltMin(Im,lambda,mu,options);

    t1 = etime(clock,tstart1);
    fprintf(fid,fig_list(i));
    fprintf(fid,'  %d  %d  %d   %d  %d \n',t1,n2,runhist.svd_time(end), ...
        runhist.sorting_time(end),runhist.L_rank(end));
end