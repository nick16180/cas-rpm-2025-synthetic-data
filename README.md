# CAS RPM 2025 Synthetic Data

Code to support the presentation about synthetic data.

The steps to recreate the data are as follows:

## Python/R

Environment setup:

- Using Ubuntu 24.04 LTS on a machine with these specs:
  - AMD Ryzen 5 4500
  - 48 GB RAM
- Using uv for dependency management, so make sure to install that.

Run the following to set up the environment - these might take a while.

```bash
uv venv
uv pip install requests pandas openpyxl sdv jupyter lightgbm scikit-learn matplotlib
```

For R, nothing notable was used, just a standard R Studio and R installation.

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

## Main CTGAN parameters

- epoch: In CTGAN, an "epoch" refers to a single complete pass through the entire training dataset, where the generator and discriminator neural networks are trained once on all the data, allowing them to learn and improve their ability to create realistic synthetic data; essentially, each epoch represents one iteration of the training process, with more epochs leading to a potentially better fit to the real data. 

- batch sizes: In CTGAN, "batch size" refers to the number of data samples used to update the model parameters during each training iteration, essentially determining how many data points are processed together in a single step of the generative adversarial network (GAN) training process; a larger batch size means more data is used to calculate the gradient for each update, potentially leading to faster training but requiring more memory. 

## CTGAN Quality metrics

- Column Shapes: The statistical similarity between the real and synthetic data for single columns of data. This is often called the marginal distribution of each column.

- Column Pair Trends: The statistical similarity between the real and synthetic data for pairs of columns. This is often called the correlation or bivariate distributions of the columns.

- Overall Score: Average of the above.

## Interpreting CTGAN Output

GANs improve by using minimizing their generator (G) and discriminator (D) loss functions. Loss value plots give insight in how these are working:

- G loss improves/stabilizes over time, D loss stays around zero:
  - This is good! If the D cannot distinguish well, then the G is working well.
  - G is producing better data and D can classify, but it has a hard time because G is working well.
- G loss and D loss do not stabilize:
  - This means the GAN is not effectively learning patterns in the data.


## For more information:

https://github.com/sdv-dev/SDV/discussions/980

https://www.kdnuggets.com/2023/04/unveiling-potential-ctgan-harnessing-generative-ai-synthetic-data.html

https://sdv.dev/blog/interpreting-ctgan-progress/

https://arxiv.org/pdf/2108.03235

https://sustainabilitymethods.org/index.php/How_To_Create_Synthetic_Data_with_CTGAN

https://developers.google.com/machine-learning/gan/loss

https://neptune.ai/blog/gan-loss-functions

http://arxiv.org/pdf/1907.00503

https://www.kaggle.com/code/ashishkumarak/conditional-gans-synthetic-data-generator

https://github.com/Team-TUD/CTAB-GAN