create database Assignment1

use Assignment1

-- Nomor 1

create table MsCustomer
(
CustomerId char(5) NOT NULL,
CustomerName varchar(50),
CustomerGender varchar(10),
CustomerPhone varchar(13),
CustomerAddress varchar(100),

constraint customer_pk
	primary key (CustomerId),

	constraint check_cs_id
	check (CustomerId like 'CU[0-9][0-9][0-9]'),

constraint check_cs_gender
	check (CustomerGender like 'Male' or CustomerGender like 'Female')
)



create table MsStaff
(
StaffId char(5) NOT NULL,
StaffName varchar(50),
StaffGender varchar(10),
StaffPhone varchar(13),
StaffAddress varchar(100),
StaffSalary numeric(11,2),
StaffPosition varchar(20),

constraint staff_pk
	primary key (StaffId),

	constraint check_staff_id
	check (StaffId like 'SF[0-9][0-9][0-9]'),

constraint check_staff_gender
	check (StaffGender like 'Male' or StaffGender like 'Female')
)



create table MsTreatmentType(
TreatmentTypeId char(5) not null,
TreatmentTypeName char(50),

constraint treatment_type_pk
	primary key(TreatmentTypeId),

constraint check_treatment_type_id
	check(TreatmentTypeId like 'TT[0-9][0-9][0-9]')

)



create table MsTreatment(
TreatmentId char(5) not null,
TreatmentTypeId char(5) not null,
TreatmentName varchar(50),
Price numeric (11,2),

constraint treatment_pk
	primary key(TreatmentId),

constraint treatment_type_fk
	foreign key(TreatmentTypeId) references MsTreatmentType(TreatmentTypeId),

constraint check_treament_id
	check(TreatmentId like 'TM[0-9][0-9][0-9]')
)



create table HeaderSalonServices(
TransactionId char(5) not null,
CustomerId char(5) not null,
StaffId char(5) not null,
TransactionDate date,
PaymentType varchar(20),

constraint header_pk
	primary key(TransactionId),

constraint customer_id_fk
	foreign key(CustomerId) references MsCustomer(CustomerId),

constraint staff_id_fk
	foreign key(StaffId) references MsStaff(StaffId),

constraint check_transaction_id
	check(TransactionId like 'TR[0-9][0-9][0-9]')
)



-- nomor 1 dan nomor 3
create table DetailSalonServices(
TransactionId char(5) not null,
TreatmentId char(5) not null,

constraint transaction_id_fk
	foreign key(TransactionId) references HeaderSalonServices(TransactionId),

constraint treatment_id_fk
	foreign key(TreatmentId) references MsTreatment(TreatmentId),
)



-- nomor 2
drop table DetailSalonServices



-- lanjut nomor 3
alter table DetailSalonServices
add primary key(TransactionId)

alter table DetailSalonServices
add primary key(TreatmentId)



-- nomor 4
alter table MsStaff
nocheck constraint check_staff_id

alter table MsStaff
nocheck constraint check_staff_gender

alter table MsStaff
add constraint check_staff_name check(len(StaffName)<21 and len(StaffName)>4)

alter table MsStaff
drop check_staff_name



-- nomor 5
alter table MsTreatment
add Description_Treatment varchar(100)

alter table MsTreatment
drop column Description_Treatment