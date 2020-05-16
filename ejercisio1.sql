SELECT  o.CustomerID , MONTH(o.OrderDate) as mes, year(o.OrderDate) as [yea] , c.CustomerName , s.SupplierID , s.SupplierName ,SUM(p.Price * od.Quantity) as total 
,CASE WHEN SUM(p.Price * od.Quantity)> (
		SELECT  AVG(p2.Price * od2.Quantity) 
		FROM example.Orders as o2 inner join example.OrderDetails as od2 on o2.OrderID = od2.OrderID 
		inner join example.Products as p2 on od2.ProductID = p2.ProductoID
		where p2.SupplierID = s.SupplierID and month(o2.OrderDate) = month(o.OrderDate) and year(o2.OrderDate) = year(o.OrderDate)
		group by p2.SupplierID , year(o2.OrderDate) , month(o2.OrderDate)
) THEN 1 ELSE 0 END as SuperoPromedio
,SUM(p.Price * od.Quantity)/(
		SELECT  SUM(p1.Price * od1.Quantity) 
		FROM example.Orders as o1 inner join example.OrderDetails as od1 on o1.OrderID = od1.OrderID 
		inner join example.Products as p1 on od1.ProductID = p1.ProductoID
		where o1.CustomerID = o.CustomerID and month(o1.OrderDate) = month(o.OrderDate) and year(o1.OrderDate) = year(o.OrderDate)
		group by o1.CustomerID , year(o1.OrderDate) , month(o1.OrderDate)
) as PorcetajeVentaMensual

FROM example.Orders as o inner join example.OrderDetails as od on o.OrderID = od.OrderID 
inner join example.Customers as c on o.CustomerID = c.CustomerID inner join example.Products as p on od.ProductID = p.ProductoID
inner join example.Suppliers as s on p.SupplierID = s.SupplierID 
group by  o.CustomerID, c.CustomerName ,s.SupplierID, s.SupplierName , year(o.OrderDate), MONTH(o.OrderDate)