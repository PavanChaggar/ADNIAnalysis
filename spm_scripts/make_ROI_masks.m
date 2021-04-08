%% Script to make ROI masks from a parcellation nifti image

%% User specify
% Set directory to parcellation
parcellation_file = '/scratch/oxmbm-shared/Code-Repositories/ADNIAnalysis/Data/mni_parcellations/mni-parcellation-scale1_atlas.nii';

% Set output directory
output_directory = '/scratch/oxmbm-shared/Image-Studies/Basic-MRI-Tau-Staging-Study/regional_masks/';


%% Processing 

% Check the output directory exists and if not then create it
if ~exist(output_directory, 'dir')
    mkdir(output_directory)
end

% Read parcellation file 
MNI_parcellation = spm_vol(parcellation_file); %spm_vol is command to read in nifti image with data and metadata

% Get full data array
image_matrix = spm_read_vols(MNI_parcellation); %spm_read_vols gets the data matrix 

% Get number of regions present in parcellation
n_regions = max(image_matrix, [], 'all'); % max value of in the image matrix should correspond to the number of ROIs

for index = 1:n_regions
    
    % output file name 
    output_file = [output_directory, sprintf('mask_region_%d.nii', index)];
    
    % mask condition 
    % create a binary mask where i1 == region value 
    f = sprintf('i1==%d', index);
    
    % spm_imcalc is used to perform calculations on nifti images 
    % https://github.com/spm/spm12/blob/master/spm_imcalc.m
    % this will apply the function `f` to the input image and save as the output image. 
    spm_imcalc(parcellation_file, output_file, f, 'mask');
end 