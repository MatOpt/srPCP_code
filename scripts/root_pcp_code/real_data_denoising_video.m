% dir_name = "video_data/V09";
% data = load(dir_name+"/result");
% frame_size = [size(data.data.temp,1),size(data.data.temp,2)];
% num_frame = data.data.num_of_frames

dir_name = "oct_data";
data = load(dir_name+"/result_full");
frame_size = [data.frame_size(1),data.frame_size(2)];
num_frame = data.frame_size(3);

to_video = zeros([5,size(data.L_root,1),size(data.L_root,2)]);
name_list = ["raw","L","S","L_plus_S","noise"];
to_video(1,:,:) = data.D;
to_video(2,:,:) = data.L_root;
to_video(3,:,:) = data.S_root;
to_video(4,:,:) = data.L_root + data.S_root;
to_video(5,:,:) = data.L_root + data.S_root - data.D;
to_video = to_video - min(to_video,[],"all");
to_video = to_video / max(to_video,[],"all");

% to_video = imadjustn(to_video);

% for i=1:size(name_list,2)
%     VidObj = VideoWriter(dir_name+sprintf("/video_full_%s",name_list(i)),'MPEG-4');
%     VidObj.FrameRate = 15; %set your frame rate
%     open(VidObj);
%     for f = 1:num_frame
%         temp = to_video(i,:,f);
%         temp = reshape(temp,frame_size);
%         writeVideo(VidObj, temp);
%     end
%     close(VidObj);
% end

% frame_num = [50 100 150 200];
frame_num = [30 60 90];
for i=1:size(name_list,2)
    for j = 1:size(frame_num,2)
        f = frame_num(j);
        temp = to_video(i,:,f);
        temp = reshape(temp,frame_size);
        imshow(temp);
        imwrite(temp,dir_name+sprintf("/frame_%d_%s.jpeg",f,name_list(i)));
    end
end

