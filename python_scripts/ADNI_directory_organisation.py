import os, fnmatch
import pandas as pd

# USER EDIT:

# set path to download directory location
download_dir = '/Users/pavanchaggar/Downloads/ADNI/'

# set path to ADNI data csv file
subject_csv = '/Users/pavanchaggar/Downloads/MRI_6_01_2020.csv'

# set target output path
target_file_path = '/Users/pavanchaggar/Documents/ADNI/'

# PROCESSIGN
def find(extension, path):
    """Find files with a particular extension in a nested file directory

    Arguments:
        extension {string} -- file extension, for e.g. '*.nii*
        path {string} -- root directory to search

    Returns:
        results  {string} -- string with the path to the files found with the given extension
    """
    result = None
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, extension):
                result = os.path.join(root, name)

    return result


def organise_directory(download_dir, subject_csv, target_file_path):
    """Will find files in a given nested directory and move them to a single directory with one level deep subject specific folders

    Arguments:
        download_dir {string} -- path to downloaded ADNI data
        subject_csv {string} -- string to ADNI data csv
        new_file_path {string} -- path to desired location
    """
    subject_df = pd.read_csv(subject_csv)
    n_subs = len(subject_df)
    for n in range(n_subs):
        sub = subject_df.iloc[n]['Subject']
        group = subject_df.iloc[n]['Group']
        path_sub = download_dir + sub
        image_path = find('*.nii', path_sub)
        new_file_path = target_file_path + group + '_' + sub + '/'
        new_image_path = new_file_path + sub + '.nii'
        if os.path.exists(target_file_path):
            pass
        else:
            os.mkdir(target_file_path)
        
        if os.path.exists(new_file_path):
            pass
        else:
            os.mkdir(new_file_path)


        os.rename(image_path, new_image_path)


organise_directory(download_dir=download_dir, subject_csv=subject_csv,target_file_path=target_file_path)