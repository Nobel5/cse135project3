INSERT INTO precols(stateid,productid,subtotal) 
(
SELECT states.id AS stateid, products.id AS productid ,SUM(sales.quantity*sales.price) AS subtotal
FROM  (sales JOIN users ON sales.uid=users.id) RIGHT OUTER JOIN
 (states FULL OUTER JOIN products ON true) ON sales.pid=products.id AND users.state=states.name
  GROUP BY stateid, productid
  ORDER BY stateid);