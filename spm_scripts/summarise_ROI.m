% Set directory to mbmgroup-refs
target_image = 'path to target image'

% Set output directory
output_directory = 'output directory'

% roi directory
roi_directory = '/scratch/oxmbm-shared/Image-Studies/Basic-MRI-Tau-Staging-Study/regional_masks/';

% Read parcellation file 
MNI_parcellation = spm_vol(parcellation_file);

% Get full data array
image_matrix = spm_read_vols(MNI_parcellation);

% Get number of regions present in parcellation
n_regions = max(image_matrix, [], 'all');

means = zeros(n_regions,1);
stds = zeros(n_regions, 1);

for index = 1:n_regions
    roi = [roi_directory, sprintf('mask_region_%d.nii', index)]
    roi_mask = spm_vol(roi)
    means(index,1) = spm_summarise(target_image, roi_mask, 'mean');
    stds(index,1) = spm_summarise(target_image, roi_mask, 'std')
end 

regional_means_filename = [output_directory, 'regional_means.csv']
writematrix(means, regional_means_filename)

regional_stds_filename = [output_directory, 'regional_stds.csv']
writematrix(stds, regional_stds_filename)