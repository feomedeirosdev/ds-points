import pandas as pd
from sqlalchemy import create_engine

db_path = 'data/database.db'
engine = create_engine(f'sqlite:///{db_path}')

customers = pd.read_sql_table('customers', engine)
transactions =pd.read_sql_table('transactions', engine)
transactions_product =pd.read_sql_table('transactions_product', engine)

date_ref = pd.to_datetime('2024-07-04')

transactions['dtTransaction'] = pd.to_datetime(transactions['dtTransaction'])

mask = (transactions['dtTransaction'] < date_ref) & (transactions['dtTransaction'] >= date_ref - pd.Timedelta(days=28))

rfv = (
    transactions[mask]
    .groupby('idCustomer')
    .agg(
        recenciaDias=pd.NamedAgg(column='dtTransaction', aggfunc=lambda x: (date_ref - x.max()).days + 1),
        frequenciaDias=pd.NamedAgg(column='dtTransaction', aggfunc=lambda x: x.dt.date.nunique()),
        valorPoints=pd.NamedAgg(column='pointsTransaction', aggfunc=lambda x: x[x > 0].sum())
    )
    .reset_index()
)


idade = (
    transactions.merge(rfv[['idCustomer']], on='idCustomer')
    .groupby('idCustomer')
    .agg(
        idadeBaseDias=pd.NamedAgg(column='dtTransaction', aggfunc=lambda x: (date_ref - x.min()).days + 1),
        tempoBaseDias=pd.NamedAgg(column='dtTransaction', aggfunc=lambda x: (x.max() - x.min()).days + 1)
    )
    .reset_index()
)


df = (
    rfv.merge(idade, on='idCustomer', how='left')
       .merge(customers[['idCustomer', 'flEmail']], on='idCustomer', how='left')
)

df['dt_ref'] = date_ref

df = df[['dt_ref', 'idCustomer', 'recenciaDias', 'frequenciaDias', 'valorPoints', 'idadeBaseDias', 'tempoBaseDias', 'flEmail']]

print(df.head())
