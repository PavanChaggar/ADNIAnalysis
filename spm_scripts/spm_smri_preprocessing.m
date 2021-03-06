%% SPM SMRI Processing ---------------------------------------------------------
% SPM processing pipeline performing:
% 1. Segmentation
% 2. Create Dartel Template
% 3. Normalise to MNI space
% 4. Compute tissue volumes
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

clear all

%% USER SPECIFY  ---------------------------------------------------------------
% path to ADNI directory
data_dir = '/home/sabs-r3/Documents/atrophy_analysis/Data/LMCI_MRI/';

% path to SPM directory
spm_path = '/home/sabs-r3/Documents/MATLAB/spm12'

% ADNI csv file names

group1_csv_name = 'LMCI_MRImatched_ABTAUPET_6_14_2020.csv'
group2_csv_name = 'CN_PETmatched_MRI_6_14_2020.csv'

%% PROCESSING (DO NOT NEED TO CHANGE)  -----------------------------------------

group1_csv_path = strcat(data_dir, group1_csv_name);
group2_csv_path = strcat(data_dir, group2_csv_name);

group1_csv = readtable(group1_csv_path);
group2_csv = readtable(group2_csv_path);
all_csv = [group1_csv; group2_csv];

subject_ids = all_csv.('Subject');

subject_groups = all_csv.('Group');

% list containing paths to subject nii images
subjects = strcat(data_dir, subject_groups, '_', subject_ids, '/', subject_ids, '.nii');

mat_files = strcat(data_dir, subject_groups, '_', subject_ids, '/', subject_ids, '_seg8.mat');

rc1 = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'rc1', subject_ids, '.nii');
rc2 = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'rc2', subject_ids, '.nii');

tissue_vol_output = strcat(data_dir, 'tissue_vols.csv');

DARTEL_template = strcat(data_dir, subject_groups(1), '_', subject_ids(1), '/', 'Template_6.nii');

flow_fields = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'u_rc1', subject_ids, '_Template.nii');

c1 = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'c1', subject_ids, '.nii');
%% SPM Batch Processing

matlabbatch{1}.spm.spatial.preproc.channel.vols = subjects;
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = strcat(spm_path, 'tpm/TPM.nii,1');
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = strcat(spm_path, '/tpm/TPM.nii,2');
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = strcat(spm_path, '/tpm/TPM.nii,3');
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = strcat(spm_path, '/tpm/TPM.nii,4');
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = strcat(spm_path,'/tpm/TPM.nii,5');
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = strcat(spm_path,'/tpm/TPM.nii,6');
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.vox = NaN;
matlabbatch{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                              NaN NaN NaN];

matlabbatch{2}.spm.util.tvol.matfiles = mat_files;
matlabbatch{2}.spm.util.tvol.tmax = 3;
matlabbatch{2}.spm.util.tvol.mask = strcat(spm_path,'/tpm/mask_ICV.nii,1');
matlabbatch{2}.spm.util.tvol.outf = tissue_vol_output;
                                          
% Create Dartel template
matlabbatch{3}.spm.tools.dartel.warp.images{1} = rc1;
matlabbatch{3}.spm.tools.dartel.warp.images{2} = rc2;
matlabbatch{3}.spm.tools.dartel.warp.settings.template = 'Template';
matlabbatch{3}.spm.tools.dartel.warp.settings.rform = 0;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{3}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{3}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{3}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{3}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{3}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{3}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{3}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{3}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{3}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{3}.spm.tools.dartel.warp.settings.optim.its = 3;
matlabbatch{4}.spm.tools.dartel.mni_norm.template(1) = DARTEL_template;
matlabbatch{4}.spm.tools.dartel.mni_norm.data.subjs.flowfields = flow_fields;
matlabbatch{4}.spm.tools.dartel.mni_norm.data.subjs.images{1} = c1;
matlabbatch{4}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{4}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{4}.spm.tools.dartel.mni_norm.preserve = 1;
matlabbatch{4}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];

spm_jobman('run',matlabbatch)
