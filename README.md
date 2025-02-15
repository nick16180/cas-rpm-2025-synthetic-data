# CAS RPM 2025 Synthetic Data

Code to support the presentation about synthetic data.

The steps to recreate the data are as follows:

## Python

Run each step00X python file in the python folder. Python is used to download, train the models, and then create the data.

Environment setup:

- Using Ubuntu 24.04 LTS on a machine with these specs:
  - AMD Ryzen 5 4500
  - 48 GB RAM
- Using uv for dependency management, so make sure to install that.

Run the following to set up the environment - these might take a while.

```bash
uv venv
uv pip install requests pandas openpyxl sdv jupyter lightgbm scikit-learn matplotlib statsmodels
```

## Data Sources

- Kaggle
  - kaggle.com/datasets/mlg-ulb/creditcardfraud
    - Large enough to be interesting, has class imbalances.
- FEMA
  - fema.gov/openfema-data-page/disaster-declarations-summaries-v2
    - Geographical and temporal data are interesting.
- UCI Machine Learning Repository
  - archive.ics.uci.edu/dataset/2/adult
  - archive.ics.uci.edu/dataset/186/wine+quality
    - Both are well known and used for tests like these. Can be used for classification or regression.

## Interpreting CTGAN Output

GANs improve by using minimizing their generator (G) and discriminator (D) loss functions. Loss value plots give insight in how these are working:

- G loss improves/stabilizes over time, D loss stays around zero:
  - This is good! If the D cannot distinguish well, then the G is working well.
  - G is producing better data and D can classify, but it has a hard time because G is working well.
- G loss and D loss do not stabilize.
  - This means the GAN is not effectively learning patterns in the data.


For more information:

[Demystifying the CTGAN Loss Function](https://github.com/sdv-dev/SDV/discussions/980)

https://www.kdnuggets.com/2023/04/unveiling-potential-ctgan-harnessing-generative-ai-synthetic-data.html

https://sdv.dev/blog/interpreting-ctgan-progress/

https://arxiv.org/pdf/2108.03235

https://sustainabilitymethods.org/index.php/How_To_Create_Synthetic_Data_with_CTGAN

https://developers.google.com/machine-learning/gan/loss

https://neptune.ai/blog/gan-loss-functions

http://arxiv.org/pdf/1907.00503

https://www.kaggle.com/code/ashishkumarak/conditional-gans-synthetic-data-generator

https://github.com/Team-TUD/CTAB-GAN