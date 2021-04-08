%% Calculate Mean Image
% This is a simple script to calculate the mean from an array of nifti
% images. 

%% User specify
data_dir = '/scratch/oxmbm-shared/Image-Studies/Basic-MRI-Tau-Staging-Study/MRI/';

csv = readtable(strcat(data_dir, 'Control-MRI.csv'));

output = 'output.nii'; 


%% Processing
subject_ids = csv.Subject;
subject_groups = csv.Group;

% load subjects with their Dartel aligned grey matter images.
subjects = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'smwc1', subject_ids, '.nii');

%% Run SPM Batch for mean of images
% This code was generated using the GUI, accessed by clicking imcalc at the bottom of the main window. 
% Imcalc will check that all of the images are aligned, with the same orientation and with the same voxel size.

matlabbatch{1}.spm.util.imcalc.input = subjects;
matlabbatch{1}.spm.util.imcalc.output = output;
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)'; %calculate the mean of X. These functions can be matlab functions.
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 1; % load images as a matrix as opposed to a list. Image vector expressed as `X`.
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch)