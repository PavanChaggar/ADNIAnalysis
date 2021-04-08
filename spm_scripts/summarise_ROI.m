%% Script to retrieve mean and std for a collection of ROIs
% Set directory to mbmgroup-refs

%% User specify
%image you want to summarise
target_image = 'path to target image'

% Set output directory
output_directory = 'output directory'

% roi directory
roi_directory = '/scratch/oxmbm-shared/Image-Studies/Basic-MRI-Tau-Staging-Study/regional_masks/';

%% Processing 
% Read parcellation file 
MNI_parcellation = spm_vol(parcellation_file);

% Get full data array
image_matrix = spm_read_vols(MNI_parcellation);

% Get number of regions present in parcellation
n_regions = max(image_matrix, [], 'all');

% create empty vectors to store means and stds
means = zeros(n_regions,1);
stds = zeros(n_regions, 1);

for index = 1:n_regions
    roi = [roi_directory, sprintf('mask_region_%d.nii', index)] %make a string pointing to the ROI file
    roi_mask = spm_vol(roi) % load the mask image

    % functions given to spm_summarise can be any matlab function
    means(index,1) = spm_summarise(target_image, roi_mask, 'mean'); % calculate mean of target image where mask == 1
    stds(index,1) = spm_summarise(target_image, roi_mask, 'std'); % calculate std of target image where mask == 1
end 

regional_means_filename = [output_directory, 'regional_means.csv']
writematrix(means, regional_means_filename)

regional_stds_filename = [output_directory, 'regional_stds.csv']
writematrix(stds, regional_stds_filename)