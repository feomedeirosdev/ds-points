# %%
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path

model_path = Path(__file__).resolve().parents[2]/'models'/'rf_fim_curso.pkl'
model_series = pd.read_pickle(model_path)

db_path = Path(__file__).resolve().parents[2]/'data'/'feature_store.db'
engine = create_engine(f'sqlite:///{db_path}')

etl_path = Path(__file__).resolve().parents[2]/'src'/'predict/etl.sql'
with open(etl_path, 'r') as file:
   query = file.read()

df = pd.read_sql_query(query, engine)

pred = model_series['model'].predict_proba(df[model_series['features']])
proba_churn = pred[:,1]

df_predict = pd.DataFrame({
   "dtRef": df['dtRef'],
   "idCustomer": df['idCustomer'],
   "prob_churn": proba_churn
})

df_predict.sort_values('prob_churn', ascending=False).reset_index(drop=True)


# %%
