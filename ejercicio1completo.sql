WITH promedio as (
SELECT  p.SupplierID ,YEAR(o.OrderDate)as Anio, month(o.OrderDate) as mes , AVG(p.Price * od.Quantity) as solucion
		FROM example.Orders as o inner join example.OrderDetails as od on o.OrderID = od.OrderID 
		inner join example.Products as p on od.ProductID = p.ProductoID
		group by p.SupplierID ,YEAR(o.OrderDate), month(o.OrderDate)
),
venta as (
SELECT  o.CustomerID, year(o.OrderDate) as Anio ,month(o.OrderDate) as mes,SUM(p.Price * od.Quantity) as ventas
		FROM example.Orders as o inner join example.OrderDetails as od on o.OrderID = od.OrderID 
		inner join example.Products as p on od.ProductID = p.ProductoID
		group by o.CustomerID , year(o.OrderDate) , month(o.OrderDate)
)
SELECT  o.CustomerID, c.CustomerName, s.SupplierID, s.SupplierName, MONTH(o.OrderDate) as mes, year(o.OrderDate) as [year]
		,SUM(p.Price * od.Quantity) as total 
		,CASE WHEN SUM(p.Price * od.Quantity) > pr.solucion THEN 1 ELSE 0 END as SuperoPromedio
		,SUM(p.Price * od.Quantity)/v.ventas as PorcentajeVentaMensual
FROM example.Orders as o inner join example.OrderDetails as od on o.OrderID = od.OrderID 
	inner join example.Customers as c on o.CustomerID = c.CustomerID 
	inner join example.Products as p on od.ProductID = p.ProductoID
	inner join example.Suppliers as s on p.SupplierID = s.SupplierID 
	left join promedio as pr on (s.SupplierID = pr.SupplierID) and (year(o.OrderDate) = pr.Anio) and (MONTH(o.OrderDate) = pr.mes)
	inner join venta   as v  on (o.CustomerID = v.CustomerID)  and (year(o.OrderDate) = v.Anio)  and (MONTH(o.OrderDate) = v.mes)
group by  o.CustomerID, c.CustomerName ,s.SupplierID, s.SupplierName , year(o.OrderDate), MONTH(o.OrderDate) , pr.solucion , v.ventas