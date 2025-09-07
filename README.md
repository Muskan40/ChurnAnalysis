***

# ChurnAnalysis

End-to-end customer churn project data modeling in SQL Server, feature engineering and prediction with **Random Forest**, and business reporting in **Power BI**.
The repo includes the full pipeline (SQL → Python/ML → Excel extracts → Power BI) plus a ready-to-refresh PBIX.

***

## Repository structure

```
ChurnAnalysis/
├── ChurnAnalysis.pbix            # Power BI dashboard (multiple pages)
├── ChurnPrediction.ipynb         # ML notebook (Random Forest churn model)
├── SSMStoExcel.ipynb             # Utility to export SQL tables/views to Excel
├── db_Churn_data.xlsx            # Cleaned data snapshot used by PBI / ML
├── Predictions.csv               # Sample model output (scored customers)
├── SQLQuery1.sql                 # DB/Tables (create & load helpers)
├── SQLQuery2.sql                 # Cleansing / transformations
├── SQLQuery3.sql                 # Views (e.g., vw_ChurnData, vw_JoinData)
├── SQLQuery4.sql                 # Ad-hoc analysis & QA checks
└── README.md
```

> Tip: the PBIX expects the same field names as in `db_Churn_data.xlsx` / the SQL views. If you change schema names, update Power BI queries and relationships accordingly.

---

## Project Goals  

- **Develop an end-to-end ETL process** to extract, transform, and load customer data into a database for analysis.  
- **Design and publish an interactive Power BI dashboard** to visualize customer data across multiple dimensions:  
  - Demographics  
  - Geography  
  - Payment & Account Information  
  - Services Subscribed  
- **Analyze churner profiles** to uncover patterns and identify areas where targeted marketing campaigns can be implemented.  
- **Build a robust churn dataset** optimized for both predictive modeling and business intelligence reporting.  
- **Implement and evaluate a Random Forest classifier** to predict future customer churn with measurable accuracy.  
- **Integrate machine learning insights into Power BI**, including:  
  - Overall churn KPIs and trends  
  - Segmentation and drill-down views  
  - Key churn drivers (feature importance)  
  - A dedicated **Prediction page** with scored outputs from the model.  
   

---

## Tech stack

* **SQL Server** (data model, cleaning, & analytics views)
* **Python 3** (pandas, scikit-learn), Jupyter
* **Power BI Desktop** (interactive dashboards,DAX)
* **Excel/CSV** as interchange format between SQL/ML/PBI

---

## Quick start

### 1) Setup the environment

```bash
# Create a fresh environment (recommended)
python -m venv .venv
# Activate it (Windows)
.venv\Scripts\activate
# macOS/Linux:
# source .venv/bin/activate

pip install -U pip
pip install pandas scikit-learn numpy matplotlib seaborn openpyxl
```

### 2) Create the SQL database (optional but recommended)

1. Open **SQL Server Management Studio (SSMS)**.
2. Run `SQLQuery1.sql` to create the **db\_Churn** database and core tables.
3. Load your raw data (or import from `db_Churn_data.xlsx`).
4. Run `SQLQuery2.sql` for cleaning/standardization logic.
5. Run `SQLQuery3.sql` to create reusable views:

   * `vw_ChurnData` – model-ready feature set
   * `vw_JoinData` – enriched, reportable dataset
6. Use `SQLQuery4.sql` for ad-hoc validation checks.

> Don’t have SQL Server? You can work directly off **db\_Churn\_data.xlsx** in Power BI and the ML notebook.

### 3) Train the model and generate predictions

Open **`ChurnPrediction.ipynb`** and run cells end-to-end:

* Loads data (from SQL view or the Excel snapshot)
* Splits into train/test
* Encodes categorical features; scales numeric if required
* Trains a **RandomForestClassifier**
* Evaluates (Accuracy/Precision/Recall/F1/ROC-AUC)
* Exports scored customers to **`Predictions.csv`**

> If the classes are imbalanced, the notebook includes options like `class_weight='balanced'` or SMOTE (if added) — keep an eye on **Recall** for the Churn=1 class.

### 4) Exporting from SQL to Excel (for Power BI)

If your PBIX should read from Excel instead of live SQL, use **`SSMStoExcel.ipynb`** to export all required tables/views to `.xlsx` sheets with consistent names.

---

## Power BI report

Open **`ChurnAnalysis.pbix`**. The report includes (typical pages):

* **Overview** – Key churn KPIs, total customers, churn rate, recent trend
* **Segments** – Churn by age band, tenure, product holdings, geography
* **Drivers** – Feature importance / explanatory visuals
* **Prediction** – Imports **`Predictions.csv`** and lets you:

  * Filter **high-risk** customers
  * Slice by segments to target retention actions

### Refresh / Data source notes

* If using the Excel snapshot: point your PBIX queries at `db_Churn_data.xlsx` and `Predictions.csv`.
* If using SQL Server: change the data source to your server/db and map to `vw_ChurnData` / `vw_JoinData`.
* After re-training, **replace `Predictions.csv`** and refresh the report.

---

## Modeling details (Random Forest)

> The notebook contains the exact code; below is the approach you’ll find there.

**Pre-processing**

* Train/test split (e.g., 80/20, stratified on target)
* Categorical: one-hot encoding (or ordinal mapping if applicable)
* Numeric: optional scaling/box-cox or winsorization if outliers dominate
* Optional: class imbalance handling (`class_weight='balanced'`)

**Model**

```python
from sklearn.ensemble import RandomForestClassifier

rf = RandomForestClassifier(
    n_estimators=300,
    max_depth=None,
    min_samples_split=2,
    min_samples_leaf=1,
    random_state=42,
    n_jobs=-1,
    class_weight='balanced'  # if needed
)

rf.fit(X_train, y_train)
y_pred = rf.predict(X_test)
y_prob = rf.predict_proba(X_test)[:, 1]
```

**Evaluation**

* Accuracy, **Precision/Recall/F1** (macro & for class=1)
* ROC-AUC and PR-AUC
* Confusion matrix
* Feature importances → visualized in the notebook / report

**Output**

* `Predictions.csv` with columns like:

  * `CustomerID`, `Churn_Prob`, `Churn_Pred`, and selected features
* This file is used by the report’s **Prediction** page

---

## End-to-end workflow

1. **Ingest** data to SQL or Excel
2. **Clean & engineer** (SQL scripts → views)
3. **Model** in Python → write `Predictions.csv`
4. **Publish** dashboards (Power BI)
5. **Iterate**: monitor metrics, retrain periodically, refresh PBIX

---

## What this project delivers

* A **repeatable pipeline** to go from raw customer data to actionable churn insights
* A supervised ML model (**Random Forest**) to **predict future churners**
* An interactive **Power BI** dashboard to **monitor churn**, **explore segments**, and **prioritize outreach** using the model’s scores
* Utilities to bridge **SQL ⇄ Excel ⇄ Power BI**

---

## How to adapt to your data

* Map your field names to the expected ones (e.g., `CustomerID`, `Churn`/`Exited`, `Age`, `Gender`, `Tenure`, `Balance`, `NumProducts`, `HasCrCard`, `IsActiveMember`, `Geography`, etc.)
* Update SQL views and Power BI relationships accordingly
* Tune RF hyperparameters / add additional models (XGBoost, LightGBM) if you need more lift

---

## Requirements

* **Power BI Desktop**
* **Python 3.9+** with:

  * `pandas`, `numpy`, `scikit-learn`, `openpyxl`, `matplotlib`, `seaborn`
* **SQL Server** (optional if working from Excel only)

---

## Credits & notes

* All data and artifacts in this repo are for demonstration/learning.
* Feature names and schemas are intentionally generic so you can plug in your own data with minimal changes.

---

## Questions / improvements

Open an issue or start a discussion in the repo — happy to help you extend this into a production-grade churn solution (automated refresh, MLOps, CI/CD for PBIX, etc.).




