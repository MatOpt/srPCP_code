
clear;
clc;
data_base_path = fullfile('..', 'data', 'VBM4D_rawRGB');
results_path = fullfile('..', 'results');
if ~exist(results_path, 'dir'), mkdir(results_path); end

% Add necessary paths explicitly
addpath(genpath('./root_pcp_code'));
addpath(genpath("../src"));

% Define datasets with clear names and corresponding folder names
datasets = {
    'basketball player', 'M0001';
    'windmill',          'M0005';
    'table tennis',      'M0008';
    'billiards',         'M0009';
    'street',            'M0010';
    'store',             'M0016';
    'tea set',           'M0017';
    'flag',              'M0020'
};
num_datasets = size(datasets, 1);
results_rank = cell(1, num_datasets); 

for j = 1:num_datasets
    dataset_name = datasets{j, 1};
    folder_name = datasets{j, 2};
    
    fprintf('Processing dataset: %s (%s)...\n', dataset_name, folder_name);
    
    % Construct full path to image files
    image_folder = fullfile(data_base_path, folder_name);
    files = dir(fullfile(image_folder, '*.png'));
    
    if isempty(files)
        warning('No PNG files found in folder: %s. Skipping.', image_folder);
        continue; % Skip to the next dataset
    end
    
    number_files = length(files);
    n2 = number_files;
    
    % Read first image to get dimensions
    info = imfinfo(fullfile(image_folder, files(1).name));
    m = info.Width;
    n = info.Height;
    n1 = m * n;
    
    % Pre-allocate matrix for the image sequence
    Im = zeros(n1, number_files);
    
    % Load all images in the sequence
    for i = 1:number_files
        rgb = imread(fullfile(image_folder, files(i).name));
        grayim = im2double(rgb2gray(rgb));
        grayim = imresize(grayim,[m,n]);
        I = reshape(grayim,[],1);
        Im(:,i) = I;
    end

    % --- Run Algorithm ---
    lambda = 1 / sqrt(n1);
    mu = sqrt(n2 / 2);
    options.tol = 1e-5;
    options.update_method = 'overparametrized';
    
    [~, ~, ~, ~, runhist] = AltMin(Im, lambda, mu, options);
    

    results_rank{j} = runhist.L_rank;
end


colors = lines(num_datasets); 
lineStyles = {'-', ':', '--', '-.', '-', ':', '--', '-.'}; % Can be extended if needed
markers = 'none'; % Same for all plots

figure;
hold on;
grid on;
box on;


for j = 1:num_datasets

    if ~isempty(results_rank{j})
        plot(results_rank{j}, ...
             'LineStyle', lineStyles{mod(j-1, length(lineStyles)) + 1}, ...
             'Color', colors(j, :), ...
             'Marker', markers, ...
             'LineWidth', 2);
    end
end
hold off;

set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaulttextinterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

xlim([0, 80]);
xlabel("Iterations ($k$)", 'FontSize', 12);
ylabel("Rank$(L_k)$", 'FontSize', 12);
title("Rank Identification Across Datasets", 'FontSize', 14);

legend_names = datasets(:, 1);
lgd = legend(legend_names, 'FontSize', 10, 'Location', 'northeast', 'NumColumns', 2);


output_filename = fullfile(results_path, 'rank_identification.eps');
fprintf('Saving figure to: %s\n', output_filename);
print(gcf, '-depsc', '-r900', output_filename);
