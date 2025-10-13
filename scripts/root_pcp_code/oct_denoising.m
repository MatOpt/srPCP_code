clc;
clear all;

dir_name = "oct_data";
name_of_data = ["demo_data"];

for i=1:length(name_of_data)
    file_name = dir_name+"/"+name_of_data(i);
    data = load(file_name).im_stack;
    data = data(1:2:end,1:2:end,1:end);
    frame_size = size(data);
    D = reshape(data,[size(data,1)*size(data,2),size(data,3)]);
    [n1,n2]= size(D);
    lambda = 1/sqrt(max(n1,n2));
    [L_root, S_root] = root_pcp(D, lambda, sqrt(min(n1,n2)/2));
    save(dir_name+"/result");
end
