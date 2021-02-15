%% SPM General Linear Model -----------------------------------------------
% SPM General Linear Model set up t-test
% 1. Factorial Design
% 2. Model Estimation
% 3. Define Contrasts 
% 4. Output Contrast results
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
clear all

%% USER SPECIFY  ---------------------------------------------------------------
% path to ADNI directory
data_dir = '/home/sabs-r3/Documents/atrophy_analysis/Data/LMCI_MRI/';

% ADNI csv file names
group1_csv_name = 'LMCI_MRImatched_ABTAUPET_6_14_2020.csv'
group2_csv_name = 'CN_PETmatched_MRI_6_14_2020.csv'

% Group labels
Group1_label = 'LMCI'
Group2_label = 'CN'

%% PROCESSING (DO NOT NEED TO CHANGE)  -----------------------------------------
group1_csv_path = strcat(data_dir, group1_csv_name);
group2_csv_path = strcat(data_dir, group2_csv_name);


%% PROCESSING (DO NOT NEED TO CHANGE)  -----------------------------------------

group1_csv = readtable(group1_csv_path);
group2_csv = readtable(group2_csv_path);
csv = [group1_csv; group2_csv];


% get subject IDs and groups
subject_ids = csv.Subject;
subject_groups = csv.Group;

% make path string structure
group1 = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'smwc1', subject_ids, '.nii');
group2 = strcat(data_dir, subject_groups, '_', subject_ids, '/', 'smwc1', subject_ids, '.nii');

% create masks for groups and edit group arrays
group1_mask = string(csv.Group) == Group1_label;
group2_mask = string(csv.Group) == Group2_label;

group1 = group1(group1_mask);
group2 = group2(group2_mask);

% Load tissue volumes
tissue_vol_output = strcat(data_dir, 'tissue_vols.csv');
tissue_vols = readtable(tissue_vol_path, 'Delimiter',',');

%% SPM Batch processing
matlabbatch{1}.spm.stats.factorial_design.dir = {data_dir};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = group1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = group2;
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_user.global_uval = tissue_vols{:,2}+tissue_vols{:,3}+tissue_vols{:,4};
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 2;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Group1 > Group2';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.results.conspec.titlestr = '';
matlabbatch{4}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{4}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{4}.spm.stats.results.conspec.extent = 0;
matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{4}.spm.stats.results.units = 1;
matlabbatch{4}.spm.stats.results.export{1}.csv = true;

spm_jobman('run',matlabbatch)
