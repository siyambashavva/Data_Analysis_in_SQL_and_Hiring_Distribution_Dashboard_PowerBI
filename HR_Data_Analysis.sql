-- SORULAR
use hr_dashboard;
-- 1. What is the gender breakdown of employees in the company?
-- 1. Şirketinizdeki çalışanların cinsiyet dağılımı nedir?

select gender, count(*) as toplam
from hr 
where age >= 18 and termdate is null
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
-- 2. Şirketteki çalışanların ırk/etnik köken dağılımı nedir?

select race, count(*) as toplam
from hr
where age > 18 and termdate is null
group by race
order by toplam desc;

-- 3. What is the age distribution of employees in the company?
-- 3. Şirketteki çalışanların yaş dağılımı nasıldır?

select min(age) as en_genç, max(age) as en_yaşlı
from hr 
where age >= 18 and termdate is null;

select 
case when age >= 18 and age<=24 then '18-24'
	when age >=25 and age <=34 then '25-34'
    when age >=35 and age <= 44 then '35-44'
    when age >=45 and age <= 54 then '45-54'
	when age >55 and age <= 64 then '55-64'
    else '65+'
    end as yaş_grubu, count(*) as toplam
from hr
where age >= 18 and termdate is null 
group by yaş_grubu
order by yaş_grubu;


select 
case when age >= 18 and age<=24 then '18-24'
	when age >=25 and age <=34 then '25-34'
    when age >=35 and age <= 44 then '35-44'
    when age >=45 and age <= 54 then '45-54'
	when age >55 and age <= 64 then '55-64'
    else '65+'
    end as yaş_grubu,gender, count(*) as toplam
from hr
where age >= 18 and termdate is null 
group by yaş_grubu, gender
order by yaş_grubu, gender;


-- 4. How many employees work at headquarters versus remote locations?
-- 4. Genel merkezde kaç çalışan, uzak lokasyonlarda çalışıyor?

select location, count(*) as toplam
from hr
group by location;

-- 5. What is the average length of employment for employees who have been terminated?
-- 5. İşten ayrılan çalışanların ortalama çalışma süresi ne kadardır?

select round(avg(datediff(termdate, hire_date)) / 365,0) as ortalama_çalışma_süresi
from hr
where termdate<= curdate() and termdate is not null and age >=18;



-- 6. How does the gender distribution vary across departments and job titles?
-- 6. Cinsiyet dağılımı bölümlere ve unvanlara göre nasıl değişiyor?


select gender, department, count(*) as toplam
from hr
where termdate is null and age >=18 
group by gender, department
order by department;

-- 7. What is the distribution of job titles across the company?
-- 7. Şirket genelinde görev unvanlarının dağılımı nasıldır?

select jobtitle, count(*) as toplam
from hr
where age >=18 and termdate is null
group by jobtitle
order by jobtitle desc;

-- 8. Which department has the highest turnover rate?
-- 8. İş değişim oranı en yüksek departman hangisidir?

select department, toplam, iş_bitim_sayısı,
iş_bitim_sayısı / toplam as iş_bitim_oranı
from(select department,
count(*)  as toplam,
sum(case when termdate is not null and termdate <= curdate()then 1 else 0 end) as iş_bitim_sayısı
from hr
where age >=18
group by department) as alt_sorgu
order by iş_bitim_oranı desc;


-- 9. What is the distribution of employees across locations by city and state?
-- 9. Çalışanların lokasyonlara göre şehir ve eyaletlere göre dağılımı nasıldır?

select location_state , count(*) as toplam
from hr
group by  location_state
order by toplam desc;


-- 10. How has the company's employee count changed over time based on hire and term dates?
-- 10. Şirketin çalışan sayısı, işe alım ve görev tarihlerine göre zaman içinde nasıl değişti?

select yıl, işe_alınan, işi_biten, 
(işe_alınan - işi_biten) as net_değişim,
round((işe_alınan - işi_biten)/işe_alınan * 100,2) as değişim_oranı
from (select year(hire_date) as yıl, count(*) işe_alınan,
sum(case when hire_date is not null and termdate <= curdate() then 1 else 0 end) as işi_biten
from hr
where age >=18
group by yıl) as alt_sorgu
order by yıl asc;

-- 11. What is the tenure distribution for each department?
-- 11. Bölümlere göre görev dağılımı nasıldır?

select department, round(avg(datediff(termdate,hire_date) / 365),0) as ort_görev_süresi
from hr
where termdate is not null and termdate <= curdate() and age >= 18
group by department;