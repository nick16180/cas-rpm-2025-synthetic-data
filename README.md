# CAS RPM 2025 Synthetic Data

Code to support the presentation about synthetic data.

The steps to recreate the data are as follows:

## Python

Run each step00X python file in the python folder. Python is used to download, train the models, and then create the data.

Environment setup:

- Using Ubuntu 24.04 LTS on a machine with these specs:
  - Intel Core i7-8650U
  - 16 GB RAM
- Using uv for dependency management, so make sure to install that.

Run the following to set up the environment - these might take a while.

```bash
uv venv
uv pip install requests pandas openpyxl sdv jupyter 
```

## R

Run the R files to do the modeling and additional tests.

## Data Sources

- Kaggle
  - kaggle.com/datasets/mlg-ulb/creditcardfraud
- FEMA
  - fema.gov/openfema-data-page/disaster-declarations-summaries-v2
- UCI Machine Learning Repository
  - archive.ics.uci.edu/dataset/2/adult
  - archive.ics.uci.edu/dataset/186/wine+quality
