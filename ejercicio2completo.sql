create table example.settings(
[Key] varchar(20) not null,
[Value] int not null
)

INSERT INTO example.settings([Key],[Value]) values ('anio', 1997);

create table example.fact_summary(
CustomerID int not null,
CustomerName varchar(50) not null,
SupplierID int not null,
SupplierName varchar(50) not null,
mes int null,
[year] int null,
total int null,
SuperoPromedio int null,
PorcentajeVentaMensual decimal (12,8) not null
);

create procedure example.SP_FULIAR_SUMMARY
as
begin
declare @anio int;
set @anio = (select [Value]from example.settings where [Key] = 'anio');

WITH promedio as (
SELECT  p.SupplierID ,YEAR(o.OrderDate)as Anio, month(o.OrderDate) as mes , AVG(p.Price * od.Quantity) as solucion
		FROM example.Orders as o inner join example.OrderDetails as od on o.OrderID = od.OrderID 
		inner join example.Products as p on od.ProductID = p.ProductoID
		where YEAR(o.OrderDate) = @anio
		group by p.SupplierID ,YEAR(o.OrderDate), month(o.OrderDate)
),
venta as (
SELECT  o.CustomerID, year(o.OrderDate) as Anio ,month(o.OrderDate) as mes,SUM(p.Price * od.Quantity) as ventas
		FROM example.Orders as o inner join example.OrderDetails as od on o.OrderID = od.OrderID 
		inner join example.Products as p on od.ProductID = p.ProductoID
		where YEAR(o.OrderDate) = @anio
		group by o.CustomerID , year(o.OrderDate) , month(o.OrderDate)
)
insert into example.fact_summary 

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
	where YEAR(o.OrderDate) = @anio
group by  o.CustomerID, c.CustomerName ,s.SupplierID, s.SupplierName , year(o.OrderDate), MONTH(o.OrderDate) , pr.solucion , v.ventas

end
