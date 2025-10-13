clc;
clear all;

% dir_name = "experiment_results/hall";
% % sigma_list = 0:30:120;
% % frame_index = [1,20,50];

dir_name = "experiment_results/yaleB03";
sigma_list = 0:10:40;
frame_index = [1,20,40];


[time_stable time_root err_L_stable err_S_stable err_L_root err_S_root] = deal(zeros([1 5]));
file_name = "/data_1.mat";
run_data = load(dir_name+file_name);
frameSize = run_data.data.frameSize;
L0 = (run_data.L_root+run_data.L_stable)/2;
S0 = (run_data.S_root+run_data.S_stable)/2;

j=1;
err_L_stable(j) = norm(run_data.L_stable - L0,"fro");
err_L_root(j) = norm(run_data.L_root - L0,"fro");
err_S_stable(j) = norm(run_data.S_stable - S0,"fro");
err_S_root(j) = norm(run_data.S_root - S0,"fro");
time_stable(j) = run_data.time_stable;
time_root(j) = run_data.time_root;


counter = 0;

for i= 1:length(frame_index)
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.D(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/original_sigma_%d_frame_%d.jpeg",1,frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.L_stable(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/L_stable_sigma_%d_frame_%d.jpeg",1,frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.L_root(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/L_root_sigma_%d_frame_%d.jpeg",1,frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.S_stable(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/S_stable_sigma_%d_frame_%d.jpeg",1,frame_index(i)));
    
    counter = counter+1;
    figure(counter);
    temp = reshape(run_data.S_root(:,frame_index(i)),frameSize);
    temp = temp - min(min(temp));
    temp = temp/max(max(temp));
    imshow(temp);
    imwrite(temp,dir_name+sprintf("/S_root_sigma_%d_frame_%d.jpeg",1,frame_index(i)));
end

for j=2:5
    file_name = sprintf("/data_%d.mat",j);
    run_data = load(dir_name+file_name);
    err_L_stable(j) = norm(run_data.L_stable - L0,"fro");
    err_L_root(j) = norm(run_data.L_root - L0,"fro");
    err_S_stable(j) = norm(run_data.S_stable - S0,"fro");
    err_S_root(j) = norm(run_data.S_root - S0,"fro");
    time_stable(j) = run_data.time_stable;
    time_root(j) = run_data.time_root;
    for i= 1:length(frame_index)
        counter = counter+1;
        figure(counter);
        temp = reshape(run_data.D(:,frame_index(i)),frameSize);
        temp = temp - min(min(temp));
        temp = temp/max(max(temp));
        imshow(temp);
        imwrite(temp,dir_name+sprintf("/original_sigma_%d_frame_%d.jpeg",j,frame_index(i)));
    
        counter = counter+1;
        figure(counter);
        temp = reshape(run_data.L_stable(:,frame_index(i)),frameSize);
        temp = temp - min(min(temp));
        temp = temp/max(max(temp));
        imshow(temp);
        imwrite(temp,dir_name+sprintf("/L_stable_sigma_%d_frame_%d.jpeg",j,frame_index(i)));
    
        counter = counter+1;
        figure(counter);
        temp = reshape(run_data.L_root(:,frame_index(i)),frameSize);
        temp = temp - min(min(temp));
        temp = temp/max(max(temp));
        imshow(temp);
        imwrite(temp,dir_name+sprintf("/L_root_sigma_%d_frame_%d.jpeg",j,frame_index(i)));
    
        counter = counter+1;
        figure(counter);
        temp = reshape(run_data.S_stable(:,frame_index(i)),frameSize);
        temp = temp - min(min(temp));
        temp = temp/max(max(temp));
        imshow(temp);
        imwrite(temp,dir_name+sprintf("/S_stable_sigma_%d_frame_%d.jpeg",j,frame_index(i)));
    
        counter = counter+1;
        figure(counter);
        temp = reshape(run_data.S_root(:,frame_index(i)),frameSize);
        temp = temp - min(min(temp));
        temp = temp/max(max(temp));
        imshow(temp);
        imwrite(temp,dir_name+sprintf("/S_root_sigma_%d_frame_%d.jpeg",j,frame_index(i)));
    end
end

ms = 30;
lw=2;
counter = counter+1;
figure(counter)
line_root_L = plot(sigma_list,err_L_root,"b.-","MarkerSize",ms,"LineWidth",lw);
hold on;
line_stable_L = plot(sigma_list,err_L_stable,"r.-","MarkerSize",ms,"LineWidth",lw);
hold on;
line_root_S = plot(sigma_list,err_S_root,"b.--","MarkerSize",ms,"LineWidth",lw);
hold on;
line_stable_S = plot(sigma_list,err_S_stable,"r.--","MarkerSize",ms,"LineWidth",lw);
hold on;
legend([line_root_L,line_stable_L,line_root_S,line_stable_S],["L/root PCP","L/stable PCP","S/root PCP","S/stable PCP"],'Location','NorthWest');
xlabel("\sigma")
ylabel("RMS error")
fig = gcf;
set( findall(fig, '-property', 'fontsize'), 'fontsize', 15)
saveas(gcf,dir_name+"/error_L_S.jpeg");

time_stable
time_root
err_L_stable/norm(L0,"fro")
err_S_stable/norm(S0,"fro")
err_L_root/norm(L0,"fro")
err_S_root/norm(S0,"fro")