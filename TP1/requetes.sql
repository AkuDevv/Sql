 --(4)-------------------------------------------------
--1
select * from employees

--2
select FIRST_NAME, LAST_NAME,SALARY from employees

--3
select FIRST_NAME, LAST_NAME,SALARY from employees
WHERE SALARY > 20000

--4
select FIRST_NAME, LAST_NAME,SALARY from employees
WHERE SALARY < 20000 and SALARY > 6000

--5
select distinct FIRST_NAME, LAST_NAME,SALARY from employees
WHERE SALARY < 20000 and SALARY > 6000 AND (DEPARTMENT_ID = 121 OR DEPARTMENT_ID = 200 OR DEPARTMENT_ID = 201 OR DEPARTMENT_ID = 203)

--6
select distinct FIRST_NAME, LAST_NAME,SALARY from employees E, departments D
where E.DEPARTMENT_ID = D.DEPARTMENT_ID and D.DEPARTMENT_NAME like 'E%'

--7
select first_name,last_name,salary from employees
where job_id != 'AD_VP' and job_id != 'IT_PROG'

--8
select distinct department_id from employees

--9
select department_id,sum(salary) from employees
group by department_id

--(5)-------------------------------------------------------------------------------
--1
select department_id,salary,salary+salary*0.15 as Augmentation from employees


--2
select department_id,salary,salary+salary*0.15 as Augmentation, salary+salary*0.15 - salary as Difference from employees


--3
select department_id,salary from employees
order by department_id,salary desc

--(6)------------------------------------------------------------------------------
--1
select substr(job_title,1,6) from jobs

--2
select first_name,last_name,length(first_name) as Longueur_Nom
from employees

--3
select concat(concat(first_name,' '),last_name) as Full_Name,salary
from employees

--4
select concat('Prenom : ',concat(first_name,concat(' || Nom : ',concat(last_name,concat(' || Salaire : ',salary))))) as Full_Name
from employees

--5
select lower(first_name),upper(last_name) from employees

--6
select first_name,last_name from employees
where first_name = 'David'

--7
select first_name,last_name,TO_CHAR(salary,'999,999,999,999') as Salary
from employees

--8
select first_name,last_name,TO_CHAR(salary,'999,999,999,999')||'$' as Salary
from employees

--9
select first_name,last_name,TO_CHAR(hire_date,'dd/mm/yyyy') as Hire_date
from employees

--10
select first_name,last_name,TO_CHAR(hire_date,'dd/mm/yyyy') as Hire_datee
from employees
where TO_CHAR(to_date(hire_date,'dd/mm/yyyy'),'mm') = 01

--11
select first_name,last_name,months_between(to_date(sysdate,'dd/mm/yyyy'),to_date(hire_date,'dd/mm/yyyy')) as Ancienette
from employees
order by Ancienette desc

--12
select first_name,last_name,to_number(to_char(sysdate,'yyyy'))-to_number(to_char(hire_date,'yyyy')) as Ancienette
from employees
order by Ancienette desc

--(7)------------------------------------------------------------------
--1
select first_name,last_name,department_name from departments D,employees E
where D.department_id = E.department_id

--2
select department_name,first_name,last_name from employees E,departments D
where E.department_id = D.department_id
order by department_name