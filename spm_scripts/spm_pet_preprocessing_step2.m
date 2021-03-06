%% SPM PET preprocessing -------------------------------------------------------
%  SPM pipepiline performing:
%  1. Create cerebellum mask
%  2. Calculate SUVR based on cerebellum reference
%  3. Brain Extraction
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

%% USER SPECIFY  ---------------------------------------------------------------
% path to ADNI directory
data_dir = '/Volumes/Pavan_SSD/AD_PET/CN/PET/';

% path to ADNI csv file containing subject information
csv_path = strcat(data_dir, '/CN_MRImatched_PET_6_16_2020.csv');

% path to spm directory
spm_path = '/Volumes/Pavan_SSD/matlab_pkgs/spm12/'

%% PROCESSING (DO NOT NEED TO CHANGE)  -----------------------------------------
brain_mask_path = strcat(spm_path, 'tpm/mask_ICV.nii');

brain_mask = spm_vol(brain_mask_path);

% output path for tissue volumes
csv = readtable(csv_path);

subject_ids = csv.('Subject');

subject_groups = csv.('Group');

% list containing paths to subject nii images
subjects = strcat(data_dir, subject_groups, '_', subject_ids, '/', subject_ids, '.nii');
suvr_output = strcat(data_dir, subject_groups, '_', subject_ids, '/suvr_', subject_ids, '.nii');
skullstrip_output = strcat(data_dir, subject_groups, '_', subject_ids, '/ss_suvr_', subject_ids, '.nii');

output = 'cerebellum_mask.nii';
if ~exist(output)
    tpm = spm_vol(strcat(spm_path, 'tpm/labels_Neuromorphometrics.nii'));
    f = 'i1 >= 38 & i1 <= 41 ';
    cerebellar_mask = spm_imcalc(tpm, output, f, 'mask');
end

for i = 1:length(subject)
    img = spm_vol(subjects{i});
    reference = spm_summarise(img,cerebellar_mask, 'mean');
    f1 = sprintf('i1.-%d', reference);
    suvr_img = spm_imcalc(img, suvr_output{i}, f1);
    f2 = 'i1*i2';
    spm_imcalc([suvr_img,brain_mask],skullstrip_output{i},f2)
end


