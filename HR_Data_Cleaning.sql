-- hr_dashboard isminde veritanının oluşturulması
create database hr_dashboard;

use hr_dashboard;

-- hr tablosundaki verilerin getirilmesi
select * from hr;

-- hr tablosundaki kolon bilgilerinin alınması
DESCRIBE hr;

-- DATA CLEANING--

select birthdate from hr;

set sql_safe_updates = 0;

-- birthdate kolonundaki değerlerin date formatına çevrilmesi
update hr 
set birthdate = case
when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
else null
end;

-- birthdate kolonun veri tipinin date olarak güncellenmesi
alter table hr
modify column birthdate date;

select birthdate from hr;

-- hire_date kolonunun date formatına çevrilmesi
update hr 
set hire_date = case
when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
else null
end;

-- hire_date kolonunun veri tipinin date olarak güncellenmesi
alter table hr 
modify column hire_date DATE;

select hire_date from hr;

select termdate from hr;

-- termdate kolonunda boş değerlerin NULL olarak güncellenmesi
update hr 
set termdate= null
where termdate = '';

-- termdate kolonunun date formatına çevrilmesi
update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d'))
where termdate is not null and termdate != '';

-- termdate kolonunun date veri tipine çevrilmesi
alter table hr 
MODIFY COLUMN termdate DATE;

select termdate from hr;

-- age adında yeni bir kolon eklenmesi
alter table hr 
add column age int;

-- bu kolonun şimdiki tarih - birthdate olarak hesaplanması
update hr 
set age = timestampdiff(year, birthdate, CURDATE());

-- en yaşlı ve en genç aşların belirlenmesi
select 
min(age) as en_genç,
max(age) as en_yaşlı
from hr;

-- 18 yaşından küçük bireylerin belirlenmesi
select count(*)
from hr
where age< 18;