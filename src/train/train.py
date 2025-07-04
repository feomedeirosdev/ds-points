# %%
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine
from sklearn import model_selection
from feature_engine import encoding
from sklearn.ensemble import RandomForestClassifier
from sklearn import pipeline
from sklearn import metrics
import datetime

# %%

def report_metrics(y_true, y_proba, cohort=0.5):

   y_pred = (y_proba[:,1] > cohort).astype(int)

   acc = metrics.accuracy_score(y_true, y_pred)
   auc = metrics.roc_auc_score(y_true, y_proba[:,1])
   precision = metrics.precision_score(y_true, y_pred)
   recall = metrics.recall_score(y_true, y_pred)

   res = {
      "Acurácia": acc,
      "AUC": auc,
      "Precisão": precision,
      "Recall": recall,
   }

   return res

db_path = Path(__file__).resolve().parents[2]/'data'/'feature_store.db'
engine = create_engine(f'sqlite:///{db_path}')

with open('abt.sql', 'r') as file:
   query = file.read()

df = pd.read_sql(query, engine)

to_remove = ['dtRef', 'idCustomer', 'flChurn', 'productMaxQtde']
df = df.astype({col: float for col in df.columns if col not in to_remove})

df_oot = df[df['dtRef'] == df['dtRef'].max()]
df_base = df[df['dtRef'] < df['dtRef'].max()]

target = 'flChurn'
features = df_base.columns[3:].tolist()

y = df_base[target]
X = df_base[features]

X_train, X_test, y_train, y_test = (
   model_selection.train_test_split(
   X,
   y,
   test_size=0.2,
   random_state=42,
   stratify=y
))

cat_features = X_train.select_dtypes(include=['object']).columns.tolist()
num_features = X_train.select_dtypes(exclude=['object']).columns.tolist()

# Criação dos passos da pipeline
onehot = encoding.OneHotEncoder(
   variables=cat_features,
   drop_last=True)

model = RandomForestClassifier(
   n_estimators=100,
   min_samples_leaf=1,
   random_state=42,

   criterion='gini',
   max_depth=None,
   min_samples_split=2,
   min_weight_fraction_leaf=0.0,
   max_features='sqrt',
   max_leaf_nodes=None,
   min_impurity_decrease=0.0,
   bootstrap=True,
   oob_score=False,
   n_jobs=None,
   verbose=0,
   warm_start=False,
   class_weight=None,
   ccp_alpha=0.0,
   max_samples=None,
)

params = {
    'n_estimators': [100, 300, 500],  # 1000 é overkill na maioria dos casos
    'min_samples_leaf': [1, 5, 10, 25],  # Inclui valor baixo (1) que pode capturar detalhes
    'criterion': ['gini', 'log_loss'],  # 'log_loss' > 'entropy' no scikit-learn mais recente (probabilístico)
    'max_depth': [None, 8, 12, 16],  # None = árvore completa; útil pra comparar
    'max_features': ['sqrt', 'log2'],  # Importante pra controlar variância e aleatoriedade
    'class_weight': [None, 'balanced']  # Crucial se as classes forem desbalanceadas
}


grid = model_selection.GridSearchCV(
   model, 
   param_grid=params,
   cv=3,
   scoring='roc_auc',
   n_jobs=-2
   )

# criação da pipeline
model_pipeline = pipeline.Pipeline([
   ('One Hot Encode', onehot),
   ('Modelo', grid)
])

## Ajuste de modelo com pipeline
# model_pipeline.fit(X_train, y_train)

# Aplicação do modelo em diferentes bases
y_train_proba = model_pipeline.predict_proba(X_train)
y_test_proba = model_pipeline.predict_proba(X_test)
y_oot_proba = model_pipeline.predict_proba(df_oot[features])

# %%
report_train = report_metrics(y_train, y_train_proba)
report_test = report_metrics(y_test, y_test_proba) 
report_oot = report_metrics(df_oot[target], y_oot_proba)

df_metrics = pd.DataFrame([report_train, report_test, report_oot], index=['Train', 'Test', 'Oot'])
df_metrics

# %%
model_series = pd.Series({
   "model": model_pipeline,
   "features": features,
   "metrics": df_metrics,
   "dt_train": datetime.datetime.now()
})

# %%
model_series['model']

# %%
model_series['features']

# %%
model_series['metrics']

# %%
model_series['dt_train']

# %%
model_path = Path(__file__).resolve().parents[2]/"models"/"rf_fim_curso.pkl"
model_series.to_pickle(model_path)

