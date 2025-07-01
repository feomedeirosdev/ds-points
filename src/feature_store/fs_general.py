import pandas as pd
from sqlalchemy import create_engine

db_path = '../../data/database.db'
engine = create_engine(f'sqlite:///{db_path}')

customers = pd.read_sql_table('customers', engine)
transactions =pd.read_sql_table('transactions', engine)
transactions_product =pd.read_sql_table('transactions_product', engine)

# convertendo para datetime
transactions['dtTransaction'] = pd.to_datetime(transactions['dtTransaction'])

# capturando só a data (sem hora)
transactions['dt_date'] = transactions['dtTransaction'].dt.date


df = (
   transactions
   .groupby('dt_date')
   .size()
   .reset_index(name='count')
   .sort_values(by='dt_date', ascending=False)
   )

print(df)
