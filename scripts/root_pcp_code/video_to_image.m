clc;
clear all;

dir_name = "experiment_results/yaleB01";
file_name = "/data.mat";

run_data = load(dir_name+file_name);
frameSize=run_data.data.frameSize;
frame_number = size(run_data.data.D,2);

% eigenvalue plot
figure(1)
lw = 2;
[u,s,v] = svd(run_data.L_stable,"econ");
eigenplot_stable = semilogy(diag(s),"r","LineWidth",lw);
hold on;
[u2,s2,v2] = svd(run_data.L_root,"econ");
eigenplot_root = semilogy(diag(s2),"b","LineWidth",lw);
legend([eigenplot_stable, eigenplot_root],["stable PCP","root PCP"]);
ylabel("singular values of L")
fig = gcf;
set( findall(fig, '-property', 'fontsize'), 'fontsize', 15)
saveas(gcf,dir_name+"/eigen_plot.jpeg");

counter = 1;

% eigen_index = [1,2,30,100];
eigen_index = [1,2,30];

for i=1:length(eigen_index)
    counter = counter+1;
    which_eigen = eigen_index(i);
    figure(counter)
    temp = reshape(u2(:,which_eigen),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/singular_vec_%d.jpeg",which_eigen));
end

% frame_index = [1,100,200];
frame_index = [1,20,50];

for i= 1:length(frame_index)
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.data.D(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/original_%d.jpeg",frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.L_stable(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/L_stable_%d.jpeg",frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.L_root(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/L_root_%d.jpeg",frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.S_stable(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/S_stable_%d.jpeg",frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.S_root(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/S_root_%d.jpeg",frame_index(i)));
end





% which_frame = 1
% subplot(2,3,1)
% x1 = reshape(run_data.L_stable(:,which_frame),frameSize);
% imshow(x1,[min(min(x1)) max(max(x1))])
% subplot(2,3,2)
% x2 = reshape(run_data.L_root(:,which_frame),frameSize);
% imshow(x2,[min(min(x2)) max(max(x2))])
% subplot(2,3,3)
% [u,s,v] = svd(run_data.L_stable,"econ");
% semilogy(diag(s),"r")
% hold on;
% [u2,s2,v2] = svd(run_data.L_root,"econ");
% semilogy(diag(s2),"b")
% 
% subplot(2,3,4)
% which_eig = 1;
% temp = reshape(u(:,which_eig),frameSize);
% imshow(temp,[min(min(u(:,which_eig))) max(max(u(:,which_eig)))]);
% subplot(2,3,5)
% which_eig = 30;
% temp = reshape(u(:,which_eig),frameSize);
% imshow(temp,[min(min(u(:,which_eig))) max(max(u(:,which_eig)))]);
% subplot(2,3,6)
% which_eig = 80;
% temp = reshape(u(:,which_eig),frameSize);
% imshow(temp,[min(min(u(:,which_eig))) max(max(u(:,which_eig)))]);