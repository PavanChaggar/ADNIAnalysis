% Set directory to mbmgroup-refs
parcellation_file = '/scratch/oxmbm-shared/Code-Repositories/ADNIAnalysis/Data/mni_parcellations/mni-parcellation-scale1_atlas.nii';

% Set output directory
output_directory = '/scratch/oxmbm-shared/Image-Studies/Basic-MRI-Tau-Staging-Study/regional_masks/';


if ~exist(output_directory, 'dir')
    mkdir(output_directory)
end

% Read parcellation file 
MNI_parcellation = spm_vol(parcellation_file);

% Get full data array
image_matrix = spm_read_vols(MNI_parcellation);

% Get number of regions present in parcellation
n_regions = max(image_matrix, [], 'all');

for index = 1:n_regions
    
    % output file name 
    output_file = [output_directory, sprintf('mask_region_%d.nii', index)];
    
    % mask condition 
    f = sprintf('i1==%d', index);
    
    spm_imcalc(parcellation_file, output_file, f, 'mask');
end 