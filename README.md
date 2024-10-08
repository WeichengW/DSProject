**Predicting Gold Prices: A Data-Driven Approach Using Linear Regression, PCA, and Random Forest Models**

**Overview**  
This project predicts daily gold prices using correlation analysis, Principal Component Analysis (PCA), Random Forest models, and linear regression. It aims to identify key relationships between economic indicators and gold prices to create a reliable prediction model with strong out-of-sample performance.

**Table of Contents**
- Overview
- Data
- Structure
- Usage
- Methodology
- Results
- Contributors
- License

**Data**  
The dataset, `Gold Price Prediction.csv`, includes historical gold prices and economic indicators like moving averages, inflation rates, treasury yields, and market indices (e.g., S&P 500, VIX, DXY).

**Structure**
- `data/`: Contains `Gold Price Prediction.csv`
- `scripts/`: R scripts for data analysis, modeling, and evaluation
- `results/`: Outputs like correlation heatmaps, PCA plots, feature importance charts
- `README.md`: Project details

**Usage**  
1. Set the working directory to `scripts/`.  
2. Run the script:  
   `source("gold_price_prediction.R")`  
3. The script will preprocess data, perform PCA, train models, and evaluate predictions.

**Methodology**
1. Data cleaning and splitting into training and testing sets.
2. Exploratory analysis with a correlation heatmap.
3. PCA for dimensionality reduction.
4. Random Forest for feature importance.
5. Linear regression with interaction terms.
6. Evaluation using MSE, RMSE, and R-squared.

**Results**  
The model provides accurate predictions with:
- MSE: 439.19
- RMSE: 20.96 usd/oz
- R-squared (OOS): 0.954

**Contributors**
- Hayden Virtue
- Helen Hao
- Iris Liu
- Victor Zhao
- Weicheng Wang (First Author)

**License**  
This project is the original work of the authors and is for demonstration purposes in resumes and portfolios only. Reproduction or distribution without permission is prohibited.
