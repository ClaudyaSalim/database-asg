use OOVEO_Salon



-- Nomor 1
go
create procedure sp1 
(
	@CuId varchar(10)
)
as (
	select CustomerId, CustomerName, CustomerGender, CustomerAddress from MsCustomer
	where CustomerId = @CuId
)
go

--exec sp1 'CU001'



-- Nomor 2
go
create procedure sp2
(
	@CuName varchar(50)
)
as 
	begin
	if len(@CuName)%2=1
		select 'Character Length of Customer Name is an Odd Number' 
	else
		select c.CustomerId, CustomerName, CustomerGender, TransactionId, TransactionDate from MsCustomer as c
		join HeaderSalonServices as hss on hss.CustomerId = c.CustomerId
		where CustomerName like ('%'+ @CuName + '%')
	end
go

--exec sp2 'Elysia Chen'
--exec sp2 'Fran'



-- Nomor 3
go
create procedure sp3
(
	@SID varchar(5), @SName varchar(50), @SGender varchar(10), @SPhone varchar(15)
)
as 

	update MsStaff
	set 
	StaffName = @SName, 
	StaffGender = @SGender, 
	StaffPhone = @SPhone
	where StaffId = @SID

	select * from MsStaff
	where exists (
		select * from MsStaff
		where StaffId = @SID
	)

	select 'Staff does not exists'
	where not exists (
		select * from MsStaff
		where StaffId = @SID
	)
go

--exec sp3 'SF005', 'Ryan Nixon', 'M', '08567756123'
--exec sp3 'SF008', 'Ryan Nixon', 'M', '08567756123'



-- Nomor 4
go
create trigger trig1 on mscustomer
instead of update
as
	select * from inserted as i
	where i.CustomerId in (
		select CustomerId from MsCustomer as c
		where c.CustomerId = i.CustomerId
	)
	union
	select * from MsCustomer as c
	where c.CustomerId in (
		select CustomerId from inserted as i
		where c.CustomerId = i.CustomerId
	)
go

Update MsCustomer SET CustomerName = 'Franky Quo' WHERE CustomerId = 'CU002'



-- Nomor 5
go
create trigger trig2 on mscustomer
after insert
as
	delete top(1) from MsCustomer
go

--select * from MsCustomer

--INSERT INTO MsCustomer VALUES('CU006','Yogie soesanto', 'Male', '085562133000', 'Pelsakih Street no 52')

--select * from MsCustomer



-- Nomor 6
go
create trigger trig3 on mscustomer
after delete
as
	declare @CuId varchar(5), @CuName varchar(50), @CuGender varchar(10), @CuPhone varchar(13), @CuAddress varchar(100)
	if OBJECT_ID('Removed', 'table') is not null
		begin
		insert into removed select * from deleted
		end
	else
	begin
		select * into removed from deleted
	end
	select * from Removed
go

--DELETE FROM MsCustomer WHERE CustomerId = 'CU003'



-- Nomor 7
go
declare @NameStaff varchar (50)

declare cur1 cursor
for
select StaffName from MsStaff

open cur1

fetch next from cur1
into @NameStaff

while @@FETCH_STATUS = 0
	begin
		
		if LEN(@NameStaff)%2=0
		begin
			print 'The length from StaffName ' + @NameStaff + ' is an even number'
		end
		else
		begin
			print 'The length from StaffName ' + @NameStaff + ' is an odd number'
		end

		fetch next from cur1 into @NameStaff
	end

close cur1

deallocate cur1
go



-- Nomor 8
go
create procedure sp4 
(
@NameLike varchar(50)
)
as
	declare @NameStaff varchar(50), @PositionStaff varchar(50)
	declare FindSName cursor
	for
	select StaffName, StaffPosition from MsStaff
	
	open FindSName

	fetch next from FindSName into @NameStaff, @PositionStaff

	while @@FETCH_STATUS = 0
	begin 
		if @NameStaff like ('%'+@NameLike+'%')
		begin
			print 'StaffName : ' + @NameStaff + ' Position : ' + @PositionStaff
		end
		fetch next from FindSName into @NameStaff, @PositionStaff
	end

	close FindSName
	deallocate FindSName
go

-- EXEC sp4 'a'



-- Nomor 9
go
create procedure sp5
(@IDCustomer varchar(6))
as
	declare @NameCustomer varchar(50), @TransactionDate varchar (15)
	declare FindCustomerTreatment cursor
	for select CustomerName, cast(TransactionDate as varchar) from MsCustomer as c
	join HeaderSalonServices as hss on hss.CustomerId = c.CustomerId
	where hss.TransactionId in (
		select TransactionId from DetailSalonServices
		where cast(RIGHT(TreatmentId, 1) as int)%2 = 0
	) and
	c.CustomerId = @IDCustomer

	open FindCustomerTreatment

	fetch next from FindCustomerTreatment into @NameCustomer, @TransactionDate

	while @@FETCH_STATUS = 0
	begin
		print 'Customer Name : ' + @NameCustomer + ' Transaction Date is ' + @TransactionDate
		fetch next from FindCustomerTreatment into @NameCustomer, @TransactionDate
	end
	
	close FindCustomerTreatment
	deallocate FindCustomerTreatment
go

-- EXEC sp5 'CU002'



-- Nomor 10
drop proc sp1, sp2, sp3, sp4, sp5
drop trigger trig1, trig2, trig3