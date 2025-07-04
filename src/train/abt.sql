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
   OR t1.dtRef = date('2024-07-04', '-28 days')

   ORDER BY 1, 2

)

SELECT
   t1.*,

   t2.recenciaDias,
   t2.frequenciaDias,
   t2.valorPoints,
   t2.idadeBaseDias,
   t2.tempoBaseDias,
   t2.flEmail,

   t3.qtdePointsManha,
   t3.qtdePointsTarde,
   t3.qtdePointsNoite,
   t3.pctPointsManha,
   t3.pctPointsTarde,
   t3.pctPointsNoite,
   t3.qtdeTransactionsManha,
   t3.qtdeTransactionsTarde,
   t3.qtdeTransactionsNoite,
   t3.pctTransactionsManha,
   t3.pctTransactionsTarde,
   t3.pctTransactionsNoite,

   t4.qtdeChatMessage,
   t4.qtdeListadepresença,
   t4.qtdePresençaStreak,
   t4.qtdeRLover,
   t4.qtdeResgatarPonei,
   t4.qtdeAirflowLover,
   t4.qtdeTrocaDePontosStreamElements,
   t4.qtdeChurn_5pp,
   t4.qtdeChurn_2pp,
   t4.qtdeChurn_10pp,
   t4.pointsChatMessage,
   t4.pointsListaDePresença,
   t4.pointsPresençaStreak,
   t4.pointsRLover,
   t4.pointsResgatarPonei,
   t4.pointsAirflowLover,
   t4.pointsTrocaDePontosStreamElements,
   t4.pointsChurn_5pp,
   t4.pointsChurn_2pp,
   t4.pointsChurn_10pp,
   t4.pctChatMessage,
   t4.pctListaDePresença,
   t4.pctPresençaStreak,
   t4.pctRLover,
   t4.pctResgatarPonei,
   t4.pctAirflowLover,
   t4.pctTrocaDePontosStreamElements,
   t4.pctChurn_5pp,
   t4.pctChurn_2pp,
   t4.pctChurn_10pp,
   t4.avgChatLive,
   t4.productMaxQtde

FROM tb_fl_churn AS t1

LEFT JOIN fs_general AS t2
ON t1.idCustomer = t2.idCustomer
AND t1. dtRef = t2.dtRef

LEFT JOIN fs_horario AS t3
ON t1.idCustomer = t3.idCustomer
AND t1. dtRef = t3.dtRef

LEFT JOIN fs_products AS t4
ON t1.idCustomer = t4.idCustomer
AND t1.dtRef = t4.dtRef
