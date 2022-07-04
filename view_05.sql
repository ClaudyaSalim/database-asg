use OOVEO_Salon



-- Nomor 1
go
create view ViewBonus as
	select stuff(CustomerId, 1, 2, 'BN') as [BinusId], CustomerName from MsCustomer
	where LEN(CustomerName)>10
go

-- select * from ViewBonus



-- Nomor 2
go
create view ViewCustomerData as
	select 
	SUBSTRING(CustomerName, 1, CHARINDEX(' ', CustomerName)) as [Name], 
	CustomerAddress as [Address], 
	CustomerPhone as [Phone]
	from MsCustomer
	where CustomerName like ('% %')
go

-- select * from ViewCustomerData



-- Nomor 3
go
create view ViewTreatment as
	select TreatmentName, TreatmentTypeName, 'Rp. ' + cast(Price as varchar) as [Price] from MsTreatment as t
	join MsTreatmentType as tt on tt.treatmentTypeId = t.treatmenttypeId
	where 
	TreatmentTypeName = 'Hair Treatment' and
	Price between 450000 and 800000
go

-- select * from ViewTreatment



-- Nomor 4
go
create view ViewTransaction as
	select StaffName, CustomerName, convert(varchar,TransactionDate,106) as [TransactionDate], PaymentType from HeaderSalonServices as hss
	join MsCustomer as c on c.CustomerId = hss.CustomerId
	join MsStaff as s on s.StaffId = hss.StaffId
	where day(TransactionDate) between 21 and 25 and
	PaymentType = 'Credit'
go

-- select * from ViewTransaction



-- Nomor 5
go
create view ViewBonusCustomer as
	select 
	REPLACE(hss.CustomerId, 'CU', 'BN') as [BonusId],
	lower ( reverse (SUBSTRING(reverse(customerName), 1, charindex(' ', reverse(CustomerName))))) as [Name],
	DATENAME(weekday, TransactionDate) as [Day], 
	convert(varchar, TransactionDate,101) as [TransactionDate] 
	from HeaderSalonServices as hss
	join MsCustomer as c on c.CustomerId = hss.CustomerId
	where CustomerName like ('% %') and
	CustomerName like ('%a')
go

-- select * from ViewBonusCustomer



-- Nomor 6
go
create view ViewTransactionByLivia as
	select hss.TransactionId, convert(varchar, TransactionDate,107) as [Date], TreatmentName from HeaderSalonServices as hss
	join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
	join MsTreatment as t on t.TreatmentId = dss.TreatmentId
	join MsStaff as s on s.StaffId = hss.StaffId
	where DAY(TransactionDate) = 21 and
	StaffName like ('Livia Ashianti')
go

-- select * from ViewTransactionByLivia



-- Nomor 7
go
alter view ViewCustomerData as
	select 
	right(CustomerId, 3) as [ID],
	CustomerName as [Name],  
	CustomerAddress as [Address], 
	CustomerPhone as [Phone]
	from MsCustomer
	where CustomerName like ('% %')
go

-- select * from ViewCustomerData



-- Nomor 8
go
create view ViewCustomer as
	select CustomerId, CustomerName, CustomerGender from MsCustomer
	go
	insert into ViewCustomer values('CU006', 'Cristian', 'Male')
go

-- select * from ViewCustomer



-- Nomor 9
delete from ViewCustomerData
where ID = '005'

select * from ViewCustomerData



-- Nomor 10
drop view ViewCustomerData