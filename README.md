# Pipeline for ADNI analysis
Documentation and example data for the mathematical brain modelling group software and pipelines for the analysis of ADNI brain imaging data. 

The software included in this repository is for the analysis of brain ADNI MRI and PET data.
The pipeline starts with an input of raw MRI and PEt images and transforms them to
scalar valued summaries on a connectome.

# Useage
## Install
You will need to clone the repo before being able to use it.

`git clone https://github.com/PavanChaggar/ADNIAnalysis.git`

and install the dependencies. At present these include the MATLAB package SPM and the python package pandas. To install these, follow these instructions. 

#### SPM

SPM is a MATLAB toolbox and therefore requires MATLAB to run! To install MATLAB, see the MathWork [website](https://uk.mathworks.com/products/get-matlab.html?s_tid=gn_getml) for the appropriate installation. Note, university students can often access this through their institutions. 

To run SPM, you will need to download the SPM package, which can be found on the SPM [website](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/). 

Once this is done, you can run SPM by opening MATLAB and running the following on the command line: \
`addpath('path/to/SPM)`\
`savepath`

#### Python

It is advise to set up a virtual environment for a particular python project. This will keep packages downloaded for this project seperate to your global python environment. To do this, run the following commands. 

First, from the terminal `cd` into the cloned directory, i.e. ADNIAnalysis, once there run: 
`python3 -m venv env` 

This will create a directory called `env` which contains a local python configuration. To activate this, run: 
`source env/bin/activate`

This will activate the python version you just created. Next, you will need to install `pandas`, which can be done using: 
`pip install pandas` 

This completes the setting up process. Next is the step by step guide on how to run the pipeline.

## Step-by-Step

### Organising data
The package has been designed for the analysis of ADNI data. The first step, therefore,
is to download ADNI data and the csv file corresponding to the downloaded data.

Once this has been obtained, use the script `./python_scripts/ADNI_directory_organisation.py`
to organise the data into a format that is useable with the matlab scripts.

To use ADNI_directory_organisation.py, first open the file in a text editor and edit
the following lines of code to specify the desired inputs.

```
# set path to download directory location
download_dir = '/Users/pavanchaggar/Downloads/ADNI/'

# set path to ADNI data csv file
subject_csv = '/Users/pavanchaggar/Downloads/MRI_6_01_2020.csv'

# set target output path
target_file_path = '/Users/pavanchaggar/Documents/ADNI/'
```

Once this has been completed, you can run the script by (note that you will need to have your python environment activated with `pandas` installed): 

`python3 ADNI_directory_organisation.py`

### MATLAB Processing

The MATLAB scripts should be used in the following order:
##### MRI
1) `spm_smri_preprocessing.m`
2) `spm_smri_glm_ttest.m`
##### PET
1) `spm_smri_preprocessing.m`
2) `spm_pet_preprocessing.m`
3) `spm_pet_preprocessing_step2.m`
4) `spm_pet_glm_ttest.m`

Each script requires some user input. Thus, before running each script, open them using
MATLAB and edit the required fields listed under:
`%% USER SPECIFY`

Once the required paths have been specified, the MATLAB scripts can be run.

To sumarise the results of the analysis on a connectome, use the MATLAB script
`parcellation_analysis.m`. The ouput of this will be a csv containing the mean
values of each intensity/t value for each region, depending on the input file.
