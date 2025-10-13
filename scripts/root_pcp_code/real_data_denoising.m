clc;
clear all;

dir_name = "video_data";
name_of_data = ["V01"];

for i=1:length(name_of_data)
    file_name = dir_name+"/"+name_of_data(i);
    data = load(file_name+"/data");
    D = data.data;
    [n1,n2]= size(D);
    lambda = 1/sqrt(max(n1,n2));
    [L_root, S_root] = root_pcp(D, lambda, sqrt(min(n1,n2)/2));
    save(file_name+"/result");
end