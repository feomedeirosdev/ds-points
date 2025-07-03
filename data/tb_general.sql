WITH tb_fl_churn AS (

   SELECT 
      t1.dtRef,
      t1.idCustomer,
      -- t2.dtRef AS dtFuturo,
      -- t2.idCustomer AS idFuturo,
      CASE WHEN t2.idCustomer IS NULL THEN 1 ELSE 0 END AS flChurn

   FROM fs_general as t1

   LEFT JOIN fs_general AS t2
   ON t1.idCustomer = t2.idCustomer
   AND t1.dtRef = date(t2.dtRef, '-28 day')

   WHERE t1.dtRef < date('2024-07-04', '-28 days')
   AND strftime('%d', t1.dtRef) = '01'

   ORDER BY 1, 2

)

SELECT * FROM tb_fl_churn