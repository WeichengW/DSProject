# Predicting Gold Prices: A Data-Driven Approach Using Linear Regression, PCA, and Random Forest Models

# Project Overview
# This project aims to predict daily gold prices using a combination of data analysis 
# and machine learning techniques, including correlation analysis, Principal Component 
# Analysis (PCA), Random Forest models, and linear regression. By exploring the relationships 
# between different economic indicators and gold prices, this project seeks to develop 
# a reliable prediction model with strong out-of-sample performance.

# Table of Contents
# - Project Overview
# - Data
# - Project Structure
# - Installation
# - Usage
# - Methodology
# - Results
# - Contributors
# - License

# Data
# The data used for this project is in the 'Gold Price Prediction.csv' file, which contains 
# historical gold prices and various economic indicators. The dataset includes variables 
# like past gold prices, moving averages, inflation rates, treasury yields, and financial 
# market indices (e.g., S&P 500, VIX, DXY).

# Project Structure
# The project is structured as follows:
# - 'data/': Contains the 'Gold Price Prediction.csv' file.
# - 'scripts/': Contains R scripts for data preprocessing, PCA analysis, random forest 
#   modeling, linear regression, and model evaluation.
# - 'results/': Contains output files such as the correlation matrix heatmap, PCA plots, 
#   feature importance charts, and model evaluation metrics.
# - 'README.md': Project description and usage instructions.

# Installation
# To replicate this project, follow these steps:
# 1. Clone this repository to your local machine:
#    git clone https://github.com/your-repo/predicting-gold-prices.git
# 2. Install the required R packages:
#    install.packages(c("tidyverse", "randomForest", "reshape2"))

# Usage
# 1. Set your working directory to the 'scripts/' folder:
#    setwd("/path/to/scripts/")
# 2. Load and run the 'gold_price_prediction.R' script:
#    source("gold_price_prediction.R")
# 3. The script will perform the following tasks:
#    - Load and preprocess the data.
#    - Create a correlation matrix heatmap.
#    - Conduct PCA and visualize the explained variance.
#    - Train a Random Forest model and assess feature importance.
#    - Fit a linear regression model with interactions and transformations.
#    - Evaluate the model's out-of-sample performance metrics (MSE, RMSE, R-squared).

# Methodology
# The project follows these steps:
# 1. Data Preprocessing: Cleaning and preparing data for analysis, including handling 
#    missing values and separating the data into training and testing sets.
# 2. Exploratory Data Analysis: Generating a correlation matrix heatmap to identify key 
#    relationships between variables.
# 3. Principal Component Analysis (PCA): Reducing dimensionality and visualizing the variance 
#    explained by each principal component.
# 4. Random Forest Modeling: Building a Random Forest model to capture non-linear interactions 
#    and identify significant predictors.
# 5. Linear Regression Modeling: Developing a linear regression model with interaction terms 
#    to improve prediction accuracy.
# 6. Model Evaluation: Assessing the model’s out-of-sample performance using metrics such as 
#    MSE, RMSE, and R-squared.

# Results
# The final model achieves accurate predictions with strong out-of-sample performance metrics:
# - Mean Squared Error (MSE): 439.19
# - Root Mean Squared Error (RMSE): 20.96 usd/oz
# - R-squared (OOS): 0.954

# These metrics demonstrate the model’s ability to generalize well to unseen data. The analysis 
# also highlights the most influential predictors, such as recent gold prices, treasury yields, 
# and market indices.

# Contributors
# - Hayden Virtue
# - Helen Hao
# - Iris Liu
# - Victor Zhao
# - Weicheng Wang (First Author)

# License
# This project is the original work of Hayden Virtue, Helen Hao, Iris Liu, Victor Zhao, and Weicheng Wang.
# It is intended solely for demonstration purposes in resumes and portfolios.
# Any use, reproduction, or distribution of this project without explicit permission from the authors is prohibited.

