clc;
clear all;

root_dir_name = "video_data";

dir_name = root_dir_name+"/"+"V01";
num_of_frames = 112;
temp = importdata(dir_name+"/001.jpg");
a = ceil(size(temp,1)/8*7);
b = ceil(size(temp,2)/5*4);
temp = temp(1:10:a,1:10:b,:);


% dir_name = root_dir_name+"/"+"V04";
% num_of_frames = 113;
% temp = importdata(dir_name+"/001.jpg");
% a = ceil(size(temp,1)/5*4);
% b = ceil(size(temp,2)/5);
% temp = temp(1:10:a,b:10:end,:);

% dir_name = root_dir_name+"/"+"V09";
% num_of_frames = 113;
% temp = importdata(dir_name+"/001.jpg");
% temp = temp(1:12:end,1:12:end,:);

frame_size = size(temp(:,:,1));
data = zeros([frame_size(1)*frame_size(2),num_of_frames]);
for i=1:num_of_frames
    i
    if i<=9
        file_name = dir_name + "/"+sprintf("00%d.jpg",i);
    else
        if i<=99
            file_name = dir_name + "/"+sprintf("0%d.jpg",i);
        else
            file_name = dir_name + "/"+sprintf("%d.jpg",i);
        end
    end
    image = imread(file_name);
    image = im2double(image);
    image = rgb2gray(image);
    image = image(1:10:a,1:10:b,:);
    data(:,i) = image(:);
end
save(dir_name+"/data_more");