# Make sure to have these installed
# install.packages("data.table")
# install.packages("dplyr")
# install.packages("broom")
# install.packages("ROCR")

library(data.table)
library(dplyr)
library(broom)
library(ROCR)

INPUT_FOLDER <- "~/workspace/cas-rpm-2025-synthetic-data/data/input"
OUTPUT_FOLDER <- "~/workspace/cas-rpm-2025-synthetic-data/data/output"

ifolder <- file.path(INPUT_FOLDER, "UCI_adult")
ofolder <- file.path(OUTPUT_FOLDER, "UCI_adult")

mod_df <- fread(file.path(ofolder, "real_df_model.csv"))
syn_df <- fread(file.path(ofolder, "syn_df.csv"))
val_df <- fread(file.path(ofolder, "real_df_validation.csv"))

# Simple data transformations
mod_df[, Income_CategoryI := ifelse(Income_Category == "<=50K", 0, 1)]
syn_df[, Income_CategoryI := ifelse(Income_Category == "<=50K", 0, 1)]
val_df[, Income_CategoryI := ifelse(Income_Category == "<=50K", 0, 1)]

# Set up model for real data
model1 <- glm(
  Income_CategoryI ~
    age +
    workclass +
    education +
    education_num +
    marital_status +
    occupation +
    relationship +
    race +
    sex +
    native_country +
    minutes_per_week +
    log(I(1 + abs(capital_gain - capital_loss))),
  family = binomial(link = "logit"),
  data = mod_df
)

# Repeat for synthetic data
model2 <- update(model1, data = syn_df)

# Attached predicted probs
z <- predict(model1, newdata = val_df, type = "response")
val_df[, Income_Category_model1p := z]

z <- predict(model2, newdata = val_df, type = "response")
val_df[, Income_Category_model2p := z]

# Find best cutoff for real data
predictions <- prediction(val_df$Income_Category_model1p, val_df$Income_CategoryI)

t1 <- performance(predictions, "sens")
t2 <- performance(predictions, "spec")
plot(
  t1@x.values[[1]], t1@y.values[[1]],
  type = "l", lwd = 2,
  ylab = "Specificity", xlab = "Cutoff"
)
par(new = TRUE)
plot(
  t2@x.values[[1]], t2@y.values[[1]],
  type = "l", lwd = 2, col = 'red',
  ylab = "", xlab = ""
)
mtext("Specificity", side = 4, padj = -2, col = 'red')

# Find value where the curves meet
sens <- cbind(t1@x.values[[1]], t1@y.values[[1]])
spec <- cbind(t2@x.values[[1]], t2@y.values[[1]])
i <- which.min(apply(sens, 1, function(x) min(colSums(abs(t(spec) - x)))))
sens[i, 1]
spec[i, 1]

# Repeat for synthetic
predictions <- prediction(val_df$Income_Category_model2p, val_df$Income_CategoryI)

t1 <- performance(predictions, "sens")
t2 <- performance(predictions, "spec")
plot(
  t1@x.values[[1]], t1@y.values[[1]],
  type = "l", lwd = 2,
  ylab = "Specificity", xlab = "Cutoff"
)
par(new = TRUE)
plot(
  t2@x.values[[1]], t2@y.values[[1]],
  type = "l", lwd = 2, col = 'red',
  ylab = "", xlab = ""
)
mtext("Specificity", side = 4, padj = -2, col = 'red')

# Find value where the curves meet
sens <- cbind(t1@x.values[[1]], t1@y.values[[1]])
spec <- cbind(t2@x.values[[1]], t2@y.values[[1]])
i <- which.min(apply(sens, 1, function(x) min(colSums(abs(t(spec) - x)))))
sens[i, 1]
spec[i, 1]

# Predict labels, produce confusion matrix
val_df[, Income_Category_model1I := ifelse(Income_Category_model1p <= .262, 0, 1)]
val_df[, Income_Category_model2I := ifelse(Income_Category_model2p <= .405, 0, 1)]

model1_conf <- val_df %>%
  group_by(
    actual = Income_CategoryI, predicted = Income_Category_model1I
  ) %>%
  summarize(
    count = n()
  )

model2_conf <- val_df %>%
  group_by(
    actual = Income_CategoryI, predicted = Income_Category_model2I
  ) %>%
  summarize(
    count = n()
  )

# Output everything
model1 %>%
  tidy() %>%
  as.data.table() %>%
  fwrite(file.path(ofolder, "model1_summary.csv"))

model2 %>%
  tidy() %>%
  as.data.table() %>%
  fwrite(file.path(ofolder, "model2_summary.csv"))

model1_conf %>%
  fwrite(file.path(ofolder, "model1_confusionmatrix.csv"))

model2_conf %>%
  fwrite(file.path(ofolder, "model2_confusionmatrix.csv"))

