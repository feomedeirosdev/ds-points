from sqlalchemy import create_engine
import pandas as pd

# Caminho para o banco de dados
db_path = '/home/medeiros/Área de trabalho/TrilhaML/10_DS_points/ds-points/data/feature_store.db'

# Cria a engine de conexão
engine = create_engine(f'sqlite:///{db_path}')

# df_customers = pd.read_sql_table('customers', engine)
# df_transactions = pd.read_sql_table('transactions', engine)
# df_transactions_product =pd.read_sql_table('transactions_product', engine)

df = pd.read_sql_table('fs_transacoes', engine)

# df = pd.merge(
#    df_customers,
#    df_transactions,
#    how='left',
#    left_on='idCustomer',
#    right_on='idCustomer',
# )

# df = pd.merge(
#    df,
#    df_transactions_product,
#    how='left',
#    left_on='idTransaction',
#    right_on='idTransaction',
# )

# print(df.head(10))
print(df.shape)