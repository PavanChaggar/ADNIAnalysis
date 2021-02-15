%% SPM General Linear Model -----------------------------------------------
% SPM General Linear Model set up t-test
% 1. Factorial Design
% 2. Model Estimation
% 3. Define Contrasts 
% 4. Output Contrast results
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
clear all
spm('Defaults','PET')

%% USER SPECIFY  ---------------------------------------------------------------
% path to ADNI directory
root_dir = '/Volumes/Pavan_SSD/Connectome_atrophy/Data/LMCI/';

modality = 'tauPET';

group1_csv_name = 'LMCI_MRImatched_ABTAUPET_6_14_2020.csv'
group2_csv_name = 'CN_PETmatched_MRI_6_14_2020.csv'

% Group labels
group1_label = 'CN'
group2_label = 'LMCI'

%% PROCESSING (DO NOT NEED TO CHANGE)  -----------------------------------------

% stats directory
stat_dir = strcat(root_dir, modality, '_stats/');

group1_csv_path = strcat(data_dir, group1_csv_name);
group2_csv_path = strcat(data_dir, group2_csv_name);

group1_csv = readtable(group1_csv_path);
group2_csv = readtable(group2_csv_path);
csv = [group1_csv; group2_csv]

% get subject IDs and groups
subject_ids = csv.Subject;

subject_groups = csv.Group;

% make path string structure
subjects = strcat(root_dir, subject_groups, '/', group, '/', subject_groups, '_', subject_ids, '/', 'ss_suvr_', subject_ids, '.nii');

% create masks for groups and edit group arrays
group1_mask = string(csv.Group) == group1_label;
group2_mask = string(csv.Group) == group2_label;

group1 = subjects(group1_mask);
group2 = subjects(group2_mask);


tissue_vols_path = strcat(root_dir, 'tissue_vols.csv');
tissue_vols = readtable(tissue_vols_path, 'Delimiter',',');

matlabbatch{1}.spm.stats.factorial_design.dir = {stat_dir};
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
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'g1<g2';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-1 1];
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
matlabbatch{4}.spm.stats.results.export{1}.ps = true;

spm_jobman('run',matlabbatch)

