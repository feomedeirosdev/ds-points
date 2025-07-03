from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy import text
from sqlalchemy import exc
import datetime
from tqdm import tqdm
import argparse

def import_query(path):
   with open(path, 'r') as file:
      return file.read()

def date_range(start, stop):
   dt_start = datetime.datetime.strptime(start, '%Y-%m-%d')
   dt_stop = datetime.datetime.strptime(stop, '%Y-%m-%d')
   dates = []
   while dt_start <= dt_stop:
      dates.append(dt_start.strftime('%Y-%m-%d'))
      dt_start += datetime.timedelta(days=1)
   return dates

def insert_date(query, table, dt):
   query_fmt = query.format(date=dt)
   df = pd.read_sql_query(query_fmt, ORIGIN_ENGINE)

   with TARGET_ENGINE.begin() as conn:
      try:
         state = f"SELECT name FROM sqlite_master WHERE type='table' AND name='{table}'"
         conn.execute(text(state))
      except exc.OperationalError as err:
         print(f"Tabela {table} ainda não existe, criando e executando...")

   df.to_sql(table, TARGET_ENGINE, index=False, if_exists='append')

now = datetime.datetime.now().strftime('%Y-%m-%d')

parser = argparse.ArgumentParser()
parser.add_argument('--feature_store', '-f', help="Nome da Feature Store", type=str)
parser.add_argument('--start', '-s', help="Data de Início", default=now)
parser.add_argument('--stop', '-t', help="Data de Fim", default=now)
args = parser.parse_args()

DB_PATH = Path(__file__).resolve().parents[2]/'data'/'database.db' 
ORIGIN_ENGINE = create_engine(f'sqlite:///{DB_PATH}')

DB_FEATURE_STORE = Path(__file__).resolve().parents[2]/'data'/'feature_store.db'
TARGET_ENGINE = create_engine(f'sqlite:///{DB_FEATURE_STORE}')

query = import_query(f'{args.feature_store}.sql')
dates = date_range(args.start, args.stop)

for date in tqdm(dates):
   insert_date(query, args.feature_store, date)
