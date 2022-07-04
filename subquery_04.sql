use OOVEO_Salon



-- Nomor 1
select TreatmentId, TreatmentName from MsTreatment
where TreatmentId in ('TM001', 'TM002')



-- Nomor 2
select TreatmentName, Price from MsTreatment as t
where t.TreatmentTypeId in (
	select TreatmentTypeId from MsTreatmentType as tt
	where tt.TreatmentTypeName not in('Hair Treatment', 'Message / Spa')
)



-- Nomor 3
select CustomerName,CustomerPhone, CustomerAddress from MsCustomer as c
where 
len(CustomerName) > 8 and
c.CustomerId in (
	select CustomerId from HeaderSalonServices as hss
	where datename(WEEKDAY, hss.TransactionDate) = 'Friday'
)



-- Nomor 4
select TreatmentTypeName, TreatmentName, Price from MsTreatment as t
join MsTreatmentType as tt on tt.TreatmentTypeId = t.TreatmentTypeId
where t.TreatmentId in (
	select TreatmentId from DetailSalonServices as dss
	join HeaderSalonServices as hss on hss.TransactionId = dss.TransactionId
	where hss.CustomerId in (
		select CustomerId from MsCustomer
		where CustomerName like ('%Putra%') and DAY(TransactionDate) = 22
	)
)



-- Nomor 5
select StaffName, CustomerName, convert(varchar, TransactionDate, 107) as [TransactionDate] from HeaderSalonServices as hss
join MsCustomer as c on c.CustomerId = hss.CustomerId
join MsStaff as s on s.StaffId = hss.StaffId
where exists(
	select * from DetailSalonServices as dss
	where CONVERT(int, right(TreatmentId, 1))%2 = 0 and
	dss.TransactionId = hss.TransactionId
)



-- Nomor 6
select CustomerName, CustomerPhone, CustomerAddress from MsCustomer as c
where exists(
	select * from HeaderSalonServices as hss
	where hss.CustomerId = c.CustomerId and 
	exists(
		select * from MsStaff as s
		where LEN(StaffName)%2 = 1 and
		s.StaffId = hss.StaffId
	)
)



-- Nomor 7
select 
right(StaffId, 3) as [ID],
StaffName
from MsStaff as s
where StaffName like ('% % %') and
exists (
	select * from HeaderSalonServices as hss
	where hss.StaffId = s.StaffId and
	hss.CustomerId in (
		select CustomerId from MsCustomer as c
		where CustomerGender not like ('Male')
	)
)



-- Nomor 8
select TreatmentTypeName, TreatmentName, Price 
from (
	select avg(Price) as [Average] from MsTreatment
) as [subaverage], 
MsTreatmentType as tt
join MsTreatment as t on t.TreatmentTypeId = tt.TreatmentTypeId
where Price > Average



-- Nomor 9
select StaffName, StaffPosition, StaffSalary 
from MsStaff,
(
	select MAX(StaffSalary) as [Highest], MIN(StaffSalary) as [Lowest] from MsStaff
) as [subquery]
where StaffSalary = Highest or StaffSalary = Lowest



-- Nomor 10
with header as(
		select COUNT(TreatmentId) as [Counts], hss.CustomerId from HeaderSalonServices as hss
		join DetailSalonServices as dss on dss.TransactionId = hss.TransactionId
		join MsCustomer as c on c.CustomerId = hss.CustomerId
		group by hss.TransactionId, hss.CustomerId
)

select CustomerName, CustomerPhone, CustomerAddress, [Count Treatments]
from MsCustomer as c,
(
	select CustomerId, Counts as [Count Treatments] from header, (
		select MAX(counts) as [MaxTreatments] from header
	) as [Maximum]
	where Counts = Maximum.[MaxTreatments]
) as [MaxCustomer]
where c.CustomerId = MaxCustomer.CustomerId