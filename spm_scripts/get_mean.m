%% Calculate Mean Image
% This is a simple script to calculate the mean from an array of nifti
% images. 
%% Set up0
data_dir = '/scratch/oxmbm-shared/Image-Studies/Basic-MRI-Tau-Staging-Study/MRI/';

csv = readtable(strcat(data_dir, 'Control-MRI.csv'));

output = 'output.nii'; 

%% Load subjects
subject_ids = csv.Subject;
subject_groups = csv.Group;

subjects = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'smwc1', subject_ids, '.nii');

%% Run SPM Batch for mean of images
matlabbatch{1}.spm.util.imcalc.input = subjects;
matlabbatch{1}.spm.util.imcalc.output = output;
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch)