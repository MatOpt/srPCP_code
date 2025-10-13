dir_name = "experiment_results/hall";
file_name = "/data_3.mat";

run_data = load(dir_name+file_name);
frameSize=run_data.data.frameSize;
frame_number = size(run_data.data.D,2);
% 
frame_data_list = zeros([5,size(run_data.data.D,1),size(run_data.data.D,2)]);
frame_data_list(1,:,:)= run_data.data.D;
frame_data_list(2,:,:)= run_data.L_root;
frame_data_list(3,:,:)= run_data.S_root;
frame_data_list(4,:,:)= run_data.L_stable;
frame_data_list(5,:,:)= run_data.S_stable;
name_list = ["original","L_root","S_root","L_stable","S_stable"];

for i=1:5
    frame_data = frame_data_list(i,:,:);
    VidObj = VideoWriter(dir_name+"/"+name_list(i),'MPEG-4');
    frame_data =frame_data-min(min(frame_data));
    frame_data = frame_data/max(max(frame_data));
    VidObj.FrameRate = 15; %set your frame rate
    open(VidObj);
    for f = 1:frame_number
        writeVideo(VidObj, reshape(frame_data(1,:,f),frameSize));
    end
    close(VidObj);
end
        