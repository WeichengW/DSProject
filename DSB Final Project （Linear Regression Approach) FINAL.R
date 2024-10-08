### Data Science for Business - Final Project - Predicting Gold Price (Linear Regression Model Appraoch)
### Members: Weicheng Wang (First Author), Hayden Virtue, Helen Hao, Iris Liu, Victor Zhao
### Section A, Team 46
### DATE: 10/7/2024


### ----------------------------[PART 0] ENVIRONMENT & DATA SET UP -----------------------------###

setwd()
getwd()

library(tidyverse)
install.packages("randomForest", dependencies = T)
library(randomForest)
library(reshape2)

data <- read.csv("Gold Price Prediction.csv")

## Let's separate our data into two parts (we use the 1st half of the entire data to train our model, 
### then use 2nd half of the data to assess the Out Of Sample metrics)

# Get the number of rows in the dataset
n <- nrow(data)

# Split into two halves
first_half <- data[1:(n %/% 2), ]
second_half <- data[(n %/% 2 + 1):n, ]

# Select numeric columns only
numeric_columns <- data |>
  select(where(is.numeric))


### ----------------------------[PART 1] CORRELATION MATRIX HEATMAP ----------------------------- ###

# Select numeric columns only
numeric_columns <- data %>%
  select(where(is.numeric))

# Compute the correlation matrix
correlation_matrix <- cor(numeric_columns, use = "complete.obs")

# Convert the correlation matrix to long format using melt
correlation_long <- melt(correlation_matrix)

ggplot(correlation_long, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = round(value, 2)), size = 3) + 
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = '', y = '', title = "Correlation Matrix Heatmap with Values")


###------------------------------[PART 2] Principal Component Analysis----------------------------------###

library(ggplot2)
library(dplyr)

# Step 1: Select numeric predictors for PCA (excluding the dependent variable)
pca_data <- first_half |>
  select(-Price.Today) |> 
  select(where(is.numeric)) |> 
  na.omit() 

# Step 2: Standardize the data
pca_data_scaled <- scale(pca_data)

# Step 3: Run PCA
pca_result <- prcomp(pca_data_scaled, center = TRUE, scale. = TRUE)

# Step 4: Get the variance explained by each principal component
explained_variance <- pca_result$sdev^2
explained_variance <- explained_variance / sum(explained_variance) * 100  # In percentage

# Create a scree plot for variance explained by each principal component
ggplot(data = data.frame(PC = 1:length(explained_variance), Variance = explained_variance), 
       aes(x = PC, y = Variance)) +
  geom_bar(stat = "identity", fill = "gray", alpha = 0.7) +
  labs(title = "PCA: Variance Explained by Principal Components",
       x = "Principal Components",
       y = "Percentage of Variance Explained") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold"),
        axis.title = element_text(size = 14))

# Step 5: Get the contributions of variables to the first few principal components (i.e. PC1)
# Extract the loadings (contributions of each variable to the principal components)
loadings <- as.data.frame(pca_result$rotation)

# Focus on contributions to PC1 (or adjust to other PCs as needed)
loadings$Variable <- rownames(loadings)
loadings <- loadings |>
  mutate(Contribution = abs(PC1)) |>
  arrange(desc(Contribution))

# Step 6: Create a bar plot for top contributing variables to PC1
ggplot(loadings, aes(x = reorder(Variable, -Contribution), y = Contribution)) +
  geom_bar(stat = "identity", fill = "gray", alpha = 0.7) +
  labs(title = "Top Variables Contributing to PC1",
       x = "Variables",
       y = "Absolute Contribution to PC1") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold"),
        axis.title = element_text(size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1)) 


###----------------------------------[PART 3] Random Forest Analysis-------------------------------------###

# Prepare the data for random forest (check for NA's)
sum(is.na(first_half))
colSums(is.na(first_half))
forest_clean <- na.omit(first_half)

# random forest model 
model_forest <- randomForest(Price.Today ~ Price.2.Days.Prior + Price.1.Day.Prior +
                               Price.Change.Ten + Std.Dev.10 + Twenty.Moving.Average + 
                               Fifty.Day.Moving.Average + Monthly.Inflation.Rate + X200.Day.Moving.Average +
                               EFFR.Rate + Volume + Treasury.Par.Yield.Month + Treasury.Par.Yield.Two.Year + 
                               `Treasury.Par.Yield.Curve.Rates..10.Yr.` + DXY + SP.Open + VIX + Crude,
                             data = forest_clean)

print(model_forest)

# Random Forest & Feature Importance Map

importance_values <- importance(model_forest)
importance_df <- as.data.frame(importance_values)
importance_df$Feature <- rownames(importance_df)

# Feature and IncNodePurity are extracted from importance_values

# Visualization of Random Forest
ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Feature Importance in Random Forest Model",
       x = "Features",
       y = "IncNodePurity") +
  theme_minimal()


###---------------------------[PART 4] Model Training & Out-Of-Sample (OOS) Metrics Analysis------------------------###

model1 <- lm(log(Price.Today) ~ log(Price.1.Day.Prior*DXY) + Twenty.Moving.Average*Crude + SP.Open + Treasury.Par.Yield.Two.Year          
             + SP.Open + DXY, data = first_half)
summary(model1) # BEST MODEL SO FAR (IN TERMS OF OUT OF SAMPLE METRICS)

# Check the assumptions
hist(residuals(model1), breaks = 20)
plot(fitted.values(model1), residuals(model1))
plot(first_half$Price.Today, residuals(model1))

### Ok, now we have our model, and we can assess our Out Of Sample metrics of our model by using the second half of the data:

# Predict on the second_half using model1
predicted_values <- exp(predict(model1, newdata = second_half))

# Actual values from second_half
actual_values <- second_half$Price.Today


# Calculate Out-Of-Sample (OOS) metrics

# 1. Mean Squared Error (MSE)
mse <- mean((actual_values - predicted_values)^2)

# 2. Root Mean Squared Error (RMSE)
rmse <- sqrt(mse)

# 3. R-squared (R2) for OOS
sst <- sum((actual_values - mean(actual_values))^2)  # Total Sum of Squares
sse <- sum((actual_values - predicted_values)^2)     # Sum of Squared Errors
r_squared <- 1 - (sse / sst)

# Print OOS metrics
cat("Out-Of-Sample Metrics:\n")
cat("OOS MSE:", mse, "\n")
cat("OOS RMSE:", rmse, "\n")
cat("OOS R-squared:", r_squared, "\n")



