use OOVEO_Salon



-- nomor 1
select * from MsStaff
where StaffGender= 'Female'



-- nomor 2
select StaffName, 'Rp.' + cast(StaffSalary as varchar) as [StaffSalary] from MsStaff
where (StaffName like '%m%') and (StaffSalary >= 10000000)



-- nomor 3
select TreatmentName, Price from MsTreatment as t
join MsTreatmentType as tt on t.TreatmentTypeId = tt.TreatmentTypeId
where tt.TreatmentTypeName in('message / spa', 'beauty care')



-- nomor 4
select StaffName, StaffPosition, convert(varchar, TransactionDate, 107) from MsStaff as s
join HeaderSalonServices as hss on hss.StaffId = s.StaffId
where StaffSalary between 7000000 and 10000000



-- nomor 5
select substring(CustomerName, 1, CHARINDEX(' ', customername)) , left(CustomerGender, 1), PaymentType from MsCustomer as c
join HeaderSalonServices as hss on hss.CustomerId = c.CustomerId
where PaymentType = 'Debit'



-- nomor 6
select 
upper(left(customername, 1) + substring(customername, CHARINDEX(' ', customername)+1, 1)) as [Initial],  
datename(weekday, TransactionDate) as [Day] 
from MsCustomer as c
join HeaderSalonServices as hss on hss.CustomerId = c.CustomerId
where DATEDIFF(DAY, TransactionDate, '2012-12-24') < 3



-- nomor 7
select TransactionDate, right(customername, CHARINDEX(' ', reverse(customername), 1)) as [CustomerName] from MsCustomer as c
join HeaderSalonServices as hss on hss.CustomerId = c.CustomerId
where CustomerName like ('% %') and datename(weekday, TransactionDate)='Saturday'



-- nomor 8
select StaffName, CustomerName, REPLACE(CustomerPhone, '0', '+62') as [CustomerPhone], CustomerAddress from MsCustomer as c
join HeaderSalonServices as hss on hss.CustomerId = c.CustomerId
join MsStaff as s on s.StaffId = hss.StaffId
where (
	CustomerName like ('a%') or
	CustomerName like ('e%') or
	CustomerName like ('i%') or
	CustomerName like ('o%') or
	CustomerName like ('u%')
) and (
StaffName like ('% % %'))



-- nomor 9
select StaffName, TreatmentName, DATEDIFF(DAY, TransactionDate, '2012-12-24') as [Term of Transaction] from HeaderSalonServices as hss
join MsStaff as s on s.StaffId = hss.StaffId
join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
join MsTreatment as t on t.TreatmentId = dss.TreatmentId
where len(TreatmentName) > 20 or TreatmentName like ('% %')



-- nomor 10
select TransactionDate, CustomerName, TreatmentName, CAST(Price as int)*20/100 as [Discount], PaymentType from HeaderSalonServices as hss
join MsCustomer as c on c.CustomerId = hss.CustomerId
join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
join MsTreatment as t on t.TreatmentId = dss.TreatmentId
where DAY(TransactionDate) = 22