select 
   t1.idCustomer,
   t1.PointsCustomer,
   t1.flEmail,
   t2.idTransaction,
   t2.dtTransaction,
   t2.pointsTransaction,
   t3.idTransactionCart,
   t3.NameProduct,
   t3.QuantityProduct
   
from customers as t1

left join transactions as t2
on t1.idCustomer = t2.idCustomer

left join transactions_product as t3
on t2.idTransaction = t3.idTransaction

limit 10