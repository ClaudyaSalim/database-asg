use OOVEO_Salon



-- Nomor 1
select MAX(Price) as [Maximum Price], MIN(Price) as [Minimum Price], 
cast(round(avg(price),0) as decimal(10,2)) as [Average Price]  from MsTreatment



-- Nomor 2
select 
StaffPosition,
left(StaffGender, 1) as [Gender],
cast('Rp. ' + cast(cast(AVG(StaffSalary) as decimal(10,2))as varchar) as varchar)as [Average Salary]
from MsStaff
group by StaffPosition, StaffGender



-- Nomor 3
select convert(varchar, TransactionDate, 107) as [TransactionDate], 
COUNT(TransactionDate) as [Total Transaction per Day]
from HeaderSalonServices
group by TransactionDate



-- Nomor 4
select 
upper(CustomerGender) as [Customer Gender],
count(TransactionDate) as [Total Transaction]
from HeaderSalonServices as hss
join MsCustomer as c on c.CustomerId = hss.CustomerId
group by CustomerGender



-- Nomor 5
select 
TreatmentTypeName,
COUNT(TransactionId) as [Total Transaction]
from DetailSalonServices as dss
join MsTreatment as t on t.TreatmentId = dss.TreatmentId
join MsTreatmentType as tt on tt.TreatmentTypeId = t.TreatmentTypeId
group by TreatmentTypeName
order by [Total Transaction] desc



-- Nomor 6
select
CONVERT(varchar, TransactionDate, 106) as [Date],
cast ('Rp. ' + cast(cast(sum (Price) as decimal(10,2))as varchar) as varchar) as [Revenue per Day]
from HeaderSalonServices as hss
join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
join MsTreatment as t on t.TreatmentId = dss.TreatmentId
group by TransactionDate
having SUM(Price) between 1000000 and 5000000



-- Nomor 7
select
replace(tt.TreatmentTypeId, 'TT0', 'Treatment Type ') as [ID],
TreatmentTypeName,
cast (cast(count(TreatmentName) as varchar) + ' Treatment' as varchar) as [Total Treatment per Type]
from MsTreatmentType as tt
join MsTreatment as t on t.TreatmentTypeId = tt.TreatmentTypeId
group by TreatmentTypeName, tt.TreatmentTypeId
having count(TreatmentName) > 5
order by count(TreatmentName) desc



-- Nomor 8
select
LEFT(StaffName, CHARINDEX(' ', StaffName, 1)) as [StaffName],
dss.TransactionId as [TransactionID],
COUNT(dss.TreatmentId) as [Total Treatment per Transaction]
from HeaderSalonServices as hss
join MsStaff as s on s.StaffId = hss.StaffId
join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
group by dss.TransactionId, StaffName



-- Nomor 9
select TransactionDate, CustomerName, TreatmentName, Price from HeaderSalonServices as hss
join MsCustomer as c on c.CustomerId = hss.CustomerId
join MsStaff as s on s.StaffId = hss.StaffId
join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
join MsTreatment as t on t.TreatmentId = dss.TreatmentId
where 
DATENAME(weekday,TransactionDate) = 'Thursday' and
StaffName like ('%Ryan%')
order by TransactionDate, CustomerName



-- Nomor 10
select TransactionDate, CustomerName, sum(Price) as [TotalPrice] from HeaderSalonServices as hss
join MsCustomer as c on c.CustomerId = hss.CustomerId
join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
join MsTreatment as t on t.TreatmentId = dss.TreatmentId
where DAY(TransactionDate) > 20
group by TransactionDate, CustomerName
order by TransactionDate