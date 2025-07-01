WITH tb_transactions AS (

   SELECT *
   FROM transactions

   WHERE dtTransaction < '2024-07-04'
   AND dtTransaction >= date('2024-07-04', '-28 days')

), tb_freq AS (

   SELECT 
      idCustomer,
      count(DISTINCT CASE WHEN dtTransaction > date('2024-07-04', '-7 days') THEN date(dtTransaction) END) AS qtdeDiasD7,
      count(DISTINCT CASE WHEN dtTransaction > date('2024-07-04', '-14 days') THEN date(dtTransaction) END) AS qtdeDiasD14,
      count(DISTINCT CASE WHEN dtTransaction > date('2024-07-04', '-21 days') THEN date(dtTransaction) END) AS qtdeDiasD21,
      count(DISTINCT date(dtTransaction)) AS qtdeDiasVida

   FROM transactions

   GROUP BY idCustomer

), tb_live_minutes AS (

   SELECT
      idCustomer,
      -- datetime(dtTransaction, '-3 hour') AS dtTransaction,
      date(datetime(dtTransaction, '-3 hour')) AS dtTransactionDate,
      min(datetime(dtTransaction, '-3 hour')) AS dtInit,
      max(datetime(dtTransaction, '-3 hour')) AS dtFinal,
      (julianday(max(datetime(dtTransaction, '-3 hour'))) - julianday(min(datetime(dtTransaction, '-3 hour')))) * 24 * 60 AS liveMinutes

   FROM tb_transactions

   GROUP BY 1, 2

), tb_hours AS (

   SELECT
      idCustomer,
      avg(liveMinutes) AS avgLiveMinutes,
      sum(liveMinutes) AS sumLiveMinutes,
      min(liveMinutes) AS minLiveMinutes,
      max(liveMinutes) AS maxLiveMinutes

   FROM tb_live_minutes

   GROUP BY idCustomer

), tb_vida AS (

   SELECT 
      idCustomer,
      count(DISTINCT idTransaction) AS qtdeTransacaoVida,
      count(DISTINCT idTransaction) / max( julianday(dtTransaction) - julianday('2014-07-04') ) AS avgTransactionDias
   FROM transactions 
   WHERE dtTransaction < '2024-07-04'
   GROUP BY idCustomer

), tb_join AS (

   SELECT 
      t1.*,
      t2.avgLiveMinutes,
      t2.sumLiveMinutes,
      t2.minLiveMinutes,
      t2.maxLiveMinutes,
      t3.qtdeTransacaoVida,
      t3.avgTransactionDias

   FROM tb_freq AS t1

   LEFT JOIN tb_hours AS t2
   ON t1.idCustomer = t2.idCustomer

   LEFT JOIN tb_vida AS t3

)

SELECT 
   '2024-07-04' AS dtRef,
   *

FROM tb_join