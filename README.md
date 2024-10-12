Forecasting Gold Prices Using Economic Indicators and Historical Data
Project Overview
This project aims to predict gold prices through a hybrid approach utilizing LASSO, Random Forest, and Linear Regression techniques. By leveraging historical price data and various economic indicators, our model provides insights crucial for investors, institutions, and policymakers.

Team Members
Hayden Virtue
Helen Hao
Iris Liu
Victor Zhao
Weicheng Wang
Affiliation
Duke University - Fuqua School of Business
Course: DECISION 520Q: Data Science for Business
Final Team Project

Table of Contents
Introduction
Business Problem
Data Description
Data Analysis Approaches
Modeling Approach and Evaluation
Decision and Recommendations
Conclusion
Introduction
Executive Summary
Gold price forecasting is essential for strategic decision-making. Our model incorporates recent price movements, stock market indices, and exchange rates to achieve an out-of-sample R² of 0.954, MSE of 439.19, and RMSE of 20.96 USD/OZ. Future improvements may include integrating real-time data sources and advanced time series analysis.

Business Problem
Gold is viewed as a safe investment during economic uncertainty. However, its effectiveness depends on various economic factors. This project explores the relationship between gold prices and key economic indicators, aiding investors and policymakers in decision-making.

Data Description
We utilized a dataset containing daily historical gold prices from March 1, 2022, to August 7, 2024. Key features included historical prices, changes over specified periods, and various economic indicators. The dataset was split into training and testing segments to evaluate model performance.

Data Analysis Approaches
Exploratory Data Analysis (EDA)
A correlation matrix heatmap was generated to identify relationships between gold prices and economic indicators, highlighting key predictors.

Modeling Approach and Evaluation
LASSO Regression Model
LASSO was employed for feature selection, preventing overfitting by shrinking less relevant predictors to zero.

Random Forest Model
Random Forest analysis ranked variables based on their importance, aiding in feature selection.

Linear Regression Model
The final linear regression model achieved high predictive accuracy with selected features from previous analyses. Interaction terms were included to capture combined effects influencing gold prices.

Model Evaluation
The model's performance was evaluated using out-of-sample metrics:

OOS MSE: 439.19
OOS RMSE: 20.96 USD/OZ
OOS R²: 0.954
Decision and Recommendations
We recommend using the linear regression model for short-term price forecasting. However, the model's reliance on historical data may limit its accuracy during significant market shifts.

Conclusion
This project developed a robust predictive model for gold prices, revealing key relationships with economic indicators. Future research could enhance the model's accuracy by integrating real-time data and employing advanced analytical methods.

Technologies Used
R
LASSO Regression
Random Forest
Linear Regression
Disclaimer
This report and other case-related materials presented on this page are FOR DEMONSTRATION USE ONLY. No part of this case may be copied or used without the permission of the original authors.
