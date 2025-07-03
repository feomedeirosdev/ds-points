WITH tb_rfv AS (

   SELECT
      idCustomer,
      cast((julianday('{date}') - max(julianday(dtTransaction)) + 1) AS INT) AS recenciaDias,
      count(DISTINCT date(dtTransaction)) AS frequenciaDias,
      sum(CASE WHEN pointsTransaction > 0 THEN pointsTransaction END) AS valorPoints

   FROM transactions

   WHERE dtTransaction < '{date}'
   AND dtTransaction >= date('{date}', '-28 days')

   GROUP BY idCustomer

), tb_idade AS (

   SELECT
      t1.idCustomer,
      CAST(( julianday('{date}') - min(julianday(t2.dtTransaction)) + 1 ) AS INT) AS idadeBaseDias,
      CAST(( max(julianday(t2.dtTransaction)) - min(julianday(t2.dtTransaction)) + 1 ) AS INT) AS tempoBaseDias

   FROM tb_rfv AS t1

   LEFT JOIN transactions AS t2
   ON t1.idCustomer = t2.idCustomer

   GROUP BY t1.idCustomer

)

SELECT
   '{date}' AS dtRef,
   t1.*,
   t2.idadeBaseDias,
   t2.tempoBaseDias,
   t3.flEmail

FROM tb_rfv AS t1

LEFT JOIN tb_idade AS t2
ON t1.idCustomer= t2.idCustomer

LEFT JOIN customers AS t3
ON t1.idCustomer = t3.idCustomer

