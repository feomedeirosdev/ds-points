WITH tb_transaction_hour AS (

   SELECT
      idCustomer,
      pointsTransaction,
      cast(strftime('%H', datetime(dtTransaction, '-3 hours')) AS INT) as hour

   FROM transactions

   WHERE dtTransaction < '{date}'
   AND dtTransaction >= date('{date}', '-28 days')

), tb_share AS (

   SELECT 
      idCustomer,

      sum(CASE WHEN hour >=8 AND hour < 12 THEN abs(pointsTransaction) ELSE 0 END) AS qtdePointsManha,
      sum(CASE WHEN hour >=12 AND hour < 18 THEN abs(pointsTransaction) ELSE 0 END) AS qtdePointsTarde,
      sum(CASE WHEN hour >=18 AND hour <= 23 THEN abs(pointsTransaction) ELSE 0 END) AS qtdePointsNoite,

      1.0 * sum(CASE WHEN hour >=8 AND hour < 12 THEN abs(pointsTransaction) ELSE 0 END) / sum(abs(pointsTransaction)) AS pctPointsManha,
      1.0 * sum(CASE WHEN hour >=12 AND hour < 18 THEN abs(pointsTransaction) ELSE 0 END) / sum(abs(pointsTransaction)) AS pctPointsTarde,
      1.0 * sum(CASE WHEN hour >=18 AND hour <= 23 THEN abs(pointsTransaction) ELSE 0 END) / sum(abs(pointsTransaction)) AS pctPointsNoite,

      sum(CASE WHEN hour >=8 AND hour < 12 THEN 1 ELSE 0 END) AS qtdeTransactionsManha,
      sum(CASE WHEN hour >=12 AND hour < 18 THEN 1 ELSE 0 END) AS qtdeTransactionsTarde,
      sum(CASE WHEN hour >=18 AND hour <= 23 THEN 1 ELSE 0 END) AS qtdeTransactionsNoite,

      1.0 * sum(CASE WHEN hour >=8 AND hour < 12 THEN 1 ELSE 0 END) / sum(1) AS pctTransactionsManha,
      1.0 * sum(CASE WHEN hour >=12 AND hour < 18 THEN 1 ELSE 0 END) / sum(1) AS pctTransactionsTarde,
      1.0 * sum(CASE WHEN hour >=18 AND hour <= 23 THEN 1 ELSE 0 END) / sum(1) AS pctTransactionsNoite

   FROM tb_transaction_hour

   GROUP BY idCustomer

)

SELECT 
   '{date}' As dtRef,
   *

FROM tb_share