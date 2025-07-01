WITH tb_transactions_product AS (

   SELECT 
      t1.*,
      t2.NameProduct,
      t2.QuantityProduct

   FROM transactions as t1

   LEFT JOIN transactions_product AS t2
   ON t1.idTransaction = t2.idTransaction

   WHERE dtTransaction < '{date}'
   AND dtTransaction >= date('{date}', '-28 days')

), tb_share AS (

   SELECT
      idCustomer,
      sum(CASE WHEN NameProduct = 'ChatMessage' THEN QuantityProduct ELSE 0 END) AS qtdeChatMessage,
      sum(CASE WHEN NameProduct = 'Lista de presença' THEN QuantityProduct ELSE 0 END) AS qtdeListadepresença,
      sum(CASE WHEN NameProduct = 'Presença Streak' THEN QuantityProduct ELSE 0 END) AS qtdePresençaStreak,
      sum(CASE WHEN NameProduct = 'R Lover' THEN QuantityProduct ELSE 0 END) AS qtdeRLover,
      sum(CASE WHEN NameProduct = 'Resgatar Ponei' THEN QuantityProduct ELSE 0 END) AS qtdeResgatarPonei,
      sum(CASE WHEN NameProduct = 'Airflow Lover' THEN QuantityProduct ELSE 0 END) AS qtdeAirflowLover,
      sum(CASE WHEN NameProduct = 'Troca de Pontos StreamElements' THEN QuantityProduct ELSE 0 END) AS qtdeTrocaDePontosStreamElements,
      sum(CASE WHEN NameProduct = 'Churn_5pp' THEN QuantityProduct ELSE 0 END) AS qtdeChurn_5pp,
      sum(CASE WHEN NameProduct = 'Churn_2pp' THEN QuantityProduct ELSE 0 END) AS qtdeChurn_2pp,
      sum(CASE WHEN NameProduct = 'Churn_10pp' THEN QuantityProduct ELSE 0 END) AS qtdeChurn_10pp,

      sum(CASE WHEN NameProduct = 'ChatMessage' THEN pointsTransaction ELSE 0 END) AS pointsChatMessage,
      sum(CASE WHEN NameProduct = 'Lista de presença' THEN pointsTransaction ELSE 0 END) AS pointsListaDePresença,
      sum(CASE WHEN NameProduct = 'Presença Streak' THEN pointsTransaction ELSE 0 END) AS pointsPresençaStreak,
      sum(CASE WHEN NameProduct = 'R Lover' THEN pointsTransaction ELSE 0 END) AS pointsRLover,
      sum(CASE WHEN NameProduct = 'Resgatar Ponei' THEN pointsTransaction ELSE 0 END) AS pointsResgatarPonei,
      sum(CASE WHEN NameProduct = 'Airflow Lover' THEN pointsTransaction ELSE 0 END) AS pointsAirflowLover,
      sum(CASE WHEN NameProduct = 'Troca de Pontos StreamElements' THEN pointsTransaction ELSE 0 END) AS pointsTrocaDePontosStreamElements,
      sum(CASE WHEN NameProduct = 'Churn_5pp' THEN pointsTransaction ELSE 0 END) AS pointsChurn_5pp,
      sum(CASE WHEN NameProduct = 'Churn_2pp' THEN pointsTransaction ELSE 0 END) AS pointsChurn_2pp,
      sum(CASE WHEN NameProduct = 'Churn_10pp' THEN pointsTransaction ELSE 0 END) AS pointsChurn_10pp,

      1.0 * sum(CASE WHEN NameProduct = 'ChatMessage' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctChatMessage,
      1.0 * sum(CASE WHEN NameProduct = 'Lista de presença' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctListaDePresença,
      1.0 * sum(CASE WHEN NameProduct = 'Presença Streak' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctPresençaStreak,
      1.0 * sum(CASE WHEN NameProduct = 'R Lover' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctRLover,
      1.0 * sum(CASE WHEN NameProduct = 'Resgatar Ponei' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctResgatarPonei,
      1.0 * sum(CASE WHEN NameProduct = 'Airflow Lover' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctAirflowLover,
      1.0 * sum(CASE WHEN NameProduct = 'Troca de Pontos StreamElements' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctTrocaDePontosStreamElements,
      1.0 * sum(CASE WHEN NameProduct = 'Churn_5pp' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctChurn_5pp,
      1.0 * sum(CASE WHEN NameProduct = 'Churn_2pp' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctChurn_2pp,
      1.0 * sum(CASE WHEN NameProduct = 'Churn_10pp' THEN QuantityProduct ELSE 0 END) / sum(QuantityProduct) AS pctChurn_10pp,

      1.0 * sum(CASE WHEN NameProduct = 'ChatMessage' THEN QuantityProduct ELSE 0 END) /count(DISTINCT date(dtTransaction)) AS avgChatLive

   FROM tb_transactions_product

   GROUP BY idCustomer

), tb_group AS (

   SELECT 
      idCustomer,
      NameProduct,
      sum(QuantityProduct) AS qtde,
      sum(pointsTransaction) AS points

   FROM tb_transactions_product

   GROUP BY idCustomer, NameProduct

), tb_rn AS (

   SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY idCustomer ORDER BY qtde DESC, points DESC) AS rnQtd

   FROM tb_group

   ORDER BY idCustomer

), tb_produto_max AS (

   SELECT * FROM tb_rn WHERE rnQtd = 1

)

SELECT
   '{date}' AS dt_ref,
   t1.*,
   t2.NameProduct AS productMaxQtde

FROM tb_share AS t1

LEFT JOIN tb_produto_max AS t2
ON t1.idCustomer = t2.idCustomer