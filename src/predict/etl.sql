SELECT
   t1.dtRef,
   t1.idCustomer,
   t1.recenciaDias,
   t1.frequenciaDias,
   t1.valorPoints,
   t1.idadeBaseDias,
   t1.tempoBaseDias,
   t1.flEmail,

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

FROM  fs_general AS t1

LEFT JOIN fs_horario AS t3
ON t1.idCustomer = t3.idCustomer
AND t1. dtRef = t3.dtRef

LEFT JOIN fs_products AS t4
ON t1.idCustomer = t4.idCustomer
AND t1.dtRef = t4.dtRef

WHERE t1.dtRef = date('2024-07-04')