WITH tb_pontos_d AS (

   SELECT
      idCustomer,
      sum(pointsTransaction) AS saldoPoints,
      sum(CASE WHEN pointsTransaction > 0 AND dtTransaction >= date('{date}', '-7 days') THEN pointsTransaction ELSE 0 END) AS pointsAcumuladosD7,
      sum(CASE WHEN pointsTransaction < 0 AND dtTransaction >= date('{date}', '-7 days') THEN pointsTransaction ELSE 0 END) AS pointsResgatadosD7,
      sum(CASE WHEN pointsTransaction > 0 AND dtTransaction >= date('{date}', '-14 days') THEN pointsTransaction ELSE 0 END) AS pointsAcumuladosD14,
      sum(CASE WHEN pointsTransaction < 0 AND dtTransaction >= date('{date}', '-14 days') THEN pointsTransaction ELSE 0 END) AS pointsResgatadosD14,
      sum(CASE WHEN pointsTransaction > 0 AND dtTransaction >= date('{date}', '-21 days') THEN pointsTransaction ELSE 0 END) AS pointsAcumuladosD21,
      sum(CASE WHEN pointsTransaction < 0 AND dtTransaction >= date('{date}', '-21 days') THEN pointsTransaction ELSE 0 END) AS pointsResgatadosD21,
      sum(CASE WHEN pointsTransaction > 0 THEN pointsTransaction ELSE 0 END) AS pointsAcumulados,
      sum(CASE WHEN pointsTransaction < 0 THEN pointsTransaction ELSE 0 END) AS pointsResgatados

   FROM transactions

   WHERE dtTransaction < '{date}'
   AND dtTransaction >= date('{date}', '-28 days')

   GROUP BY idCustomer

), tb_vida AS (

   SELECT
      t1.idCustomer,
      sum(t2.pointsTransaction) AS saldoPoints,
      sum(CASE WHEN t2.pointsTransaction > 0 THEN t2.pointsTransaction ELSE 0 END) AS pointsAcumuladosVida,
      sum(CASE WHEN t2.pointsTransaction < 0 THEN t2.pointsTransaction ELSE 0 END) AS pointsResgatadosVida,
      cast( (max(julianday('{date}') - date(dtTransaction)) + 1) AS INT) AS diasVida

   FROM tb_pontos_d AS t1

   LEFT JOIN transactions as t2
   ON t1.idCustomer = t2.idCustomer

   WHERE t2.dtTransaction < '{date}'

   GROUP BY t1.idCustomer

), tb_join AS (

   SELECT 
      t1.*,
      t2.saldoPoints,
      t2.pointsAcumuladosVida,
      t2.pointsResgatadosVida,
      1.0 * t2.pointsAcumuladosVida / t2.diasVida AS pointsPorDia

   FROM tb_pontos_d AS t1

   LEFT JOIN tb_vida as t2
   ON t1.idCustomer = t2.idCustomer

)

SELECT
   '{date}' AS dtRef,
   *

FROM tb_join