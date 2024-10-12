### Data Science for Business - Final Project - Predicting Gold Price
### Members: Weicheng Wang (FIRST AUTHOR), Hayden Virtue, Helen Hao, Iris Liu, Victor Zhao
### Section A, Team 46
### DATE: 10/11/2024

### ----------------------------[PART 0] ENVIRONMENT & DATA SET UP -----------------------------###

setwd()
getwd()

library(tidyverse)
install.packages("randomForest", dependencies = TRUE)
library(randomForest)
install.packages("glmnet", dependencies = TRUE)
library(glmnet)
library(reshape2)

data <- read.csv("Gold Price Prediction.csv")

n <- nrow(data)

# Split the data into two halves (first half for training, second half for testing)
first_half <- data[1:(n %/% 2), ]
second_half <- data[(n %/% 2 + 1):n, ]

# Select numeric columns only for correlation analysis
numeric_columns <- data |> select(where(is.numeric))


### ----------------------------[PART 1] CORRELATION MATRIX HEATMAP (EDA) ----------------------------- ###

# Compute the correlation matrix
correlation_matrix <- cor(numeric_columns, use = "complete.obs")

correlation_long <- melt(correlation_matrix)

# Correlation heatmap plotting
ggplot(correlation_long, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = round(value, 2)), size = 3) + 
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = '', y = '', title = "Correlation Matrix Heatmap with Values")


### ---------------------------[PART 2] LASSO REGRESSION FOR VARIABLE SELECTION -----------------###

# Prepare data for LASSO regression (remove rows with NA values)
lasso_clean <- na.omit(first_half)

# Define the predictor variables (x) and the response variable (y)
x <- model.matrix(Price.Today ~ Price.2.Days.Prior + Price.1.Day.Prior +
                    Price.Change.Ten + Std.Dev.10 + Twenty.Moving.Average + 
                    Fifty.Day.Moving.Average + Monthly.Inflation.Rate + X200.Day.Moving.Average +
                    EFFR.Rate + Volume + Treasury.Par.Yield.Month + Treasury.Par.Yield.Two.Year + 
                    `Treasury.Par.Yield.Curve.Rates..10.Yr.` + DXY + SP.Open + VIX + Crude, 
                  data = lasso_clean)[,-1]

y <- lasso_clean$Price.Today

# Fit a LASSO model using cross-validation to find the OPTIMAL lambda
set.seed(123)
lasso_model <- cv.glmnet(x, y, alpha = 1, family = "gaussian")
plot(lasso_model)

# Extract the BEST lambda value and fit the final LASSO model
best_lambda <- lasso_model$lambda.min
final_lasso_model <- glmnet(x, y, alpha = 1, lambda = best_lambda)

lasso_coefficients <- coef(final_lasso_model)

# Convert the coefficients to a matrix and then extract the names of non-zero coefficients
lasso_coefficients_matrix <- as.matrix(lasso_coefficients)

# Extract the names of features with non-zero coefficients
selected_features <- rownames(lasso_coefficients_matrix)[lasso_coefficients_matrix != 0]

# Display the selected features (we could potentially use as our final predictive model variables)

cat("Selected features by LASSO:\n")
print(selected_features)

###--------------------------------[PART 3] RANDOM FOREST ANALYSIS -------------------------------------###

# Prepare the data for random forest (remove rows with NA values)
forest_clean <- na.omit(first_half)

# Fit a random forest model to identify feature importance
model_forest <- randomForest(Price.Today ~ Price.2.Days.Prior + Price.1.Day.Prior +
                               Price.Change.Ten + Std.Dev.10 + Twenty.Moving.Average + 
                               Fifty.Day.Moving.Average + Monthly.Inflation.Rate + X200.Day.Moving.Average +
                               EFFR.Rate + Volume + Treasury.Par.Yield.Month + Treasury.Par.Yield.Two.Year + 
                               `Treasury.Par.Yield.Curve.Rates..10.Yr.` + DXY + SP.Open + VIX + Crude,
                             data = forest_clean)

print(model_forest)

# Extract and visualize feature importance
importance_values <- importance(model_forest)
importance_df <- as.data.frame(importance_values)
importance_df$Feature <- rownames(importance_df)

ggplot(importance_df, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Feature Importance in Random Forest Model",
       x = "Features",
       y = "IncNodePurity") +
  theme_minimal()

### ---------------------------[PART 4] MODEL TRAINING USING SELECTED FEATURES ------------------------###

# Use selected features in a linear regression model
model <- lm(log(Price.Today) ~ log(Price.1.Day.Prior*DXY) + 
                             Twenty.Moving.Average*Crude + SP.Open + 
                             Treasury.Par.Yield.Two.Year + DXY, 
                           data = first_half)

summary(model)

# Check model assumptions
hist(residuals(model), breaks = 20)
plot(fitted.values(model), residuals(model))
plot(first_half$Price.Today, residuals(model))

###---------------------------[PART 5] OUT-OF-SAMPLE METRICS ANALYSIS------------------------###

# Predict on the second_half using our final predictive model
predicted_values <- exp(predict(model, newdata = second_half))

# Actual values from second_half of the data
actual_values <- second_half$Price.Today

# Calculate Out-Of-Sample (OOS) metrics for our final predictive model
mse <- mean((actual_values - predicted_values)^2)

rmse <- sqrt(mse)

sst <- sum((actual_values - mean(actual_values))^2)

sse <- sum((actual_values - predicted_values)^2)

r_squared <- 1 - (sse / sst)

# Print OOS metrics for the final predictive model
cat("Out-Of-Sample Metrics (LASSO-Selected Model):\n")
cat("OOS MSE:", mse, "\n")
cat("OOS RMSE:", rmse, "\n")
cat("OOS R-squared:", r_squared, "\n")

