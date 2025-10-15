clear all;
clc;
warning off;
addpath(genpath(pwd));
addpath(genpath('./root_pcp_code'))
addpath(genpath("../src"))

%%%%%read the vedio%%%%%%%%%%%%%%%
str = '../data/VBM4D_rawRGB/M0005/';
files = dir(strcat(str,'*.png'));
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

%%%%%%%%%%%%%%%%%%%%%%%%%%base
options.update_method = 'base';
fprintf('the base method');
% tic;
tstart1 = clock;
[Lbar,Sbar,obj,iter,runhist] = AltMin(Im,lambda,mu,options);
t1 = etime(clock,tstart1);
fprintf('the base method time = %2.1f, obj = %8.3f',t1,obj);


%save result
filepath = "../results/windmill";
D30 = imadjust(reshape(Im(:,30),n,m));
D60 = imadjust(reshape(Im(:,60),n,m));
D90 = imadjust(reshape(Im(:,90),n,m));
L30 = imadjust(reshape(Lbar(:,30),n,m));
L60 = imadjust(reshape(Lbar(:,60),n,m));
L90 = imadjust(reshape(Lbar(:,90),n,m));
S30 = imadjust(reshape(Sbar(:,30),n,m));
S60 = imadjust(reshape(Sbar(:,60),n,m));
S90 = imadjust(reshape(Sbar(:,90),n,m));
LS30 = L30 + S30;
LS60 = L60 + S60;
LS90 = L90 + S90;
Z30 = D30 - LS30;
Z60 = D60 - LS60;
Z90 = D90 - LS90;
imwrite(D30,filepath+"origin30.png");
imwrite(D60,filepath+"origin60.png");
imwrite(D90,filepath+"origin90.png");
imwrite(L30,filepath+"Lbar30.png");
imwrite(L60,filepath+"Lbar60.png");
imwrite(L90,filepath+"Lbar90.png");
imwrite(S30,filepath+"Sbar30.png");
imwrite(S60,filepath+"Sbar60.png");
imwrite(S90,filepath+"Sbar90.png");
imwrite(LS30,filepath+"LSbar30.png");
imwrite(LS60,filepath+"LSbar60.png");
imwrite(LS90,filepath+"LSbar90.png");
imwrite(Z30,filepath+"Z30.png");
imwrite(Z60,filepath+"Z60.png");
imwrite(Z90,filepath+"Z90.png");