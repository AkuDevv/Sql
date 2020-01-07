
------- EXERCICE 1 

-- Q1 
create table DEPT (
    DEPTNO int PRIMARY KEY,
    DNAME varchar(50),
    Loc varchar(50),
    CONSTRAINT CHECK_DNAME CHECK (DNAME IN ('ACCOUNTING','RESEARCH','SALES','OPERATIONS'))
);
-- Q2
insert into DEPT values(10,'ACCOUNTING','NEW-YORK');
insert into DEPT values(20,'RESEARCH','DALLAS');
insert into DEPT values(30,'SALES','CHICAGO');
insert into DEPT values(40,'OPERATIONS','BOSTON');
-- Q3
CREATE TABLE EMP AS SELECT * FROM SCOTT.EMP;
-- Q4
-- Il ne fonctionne pas, car y a deja un ligne avec EMPNO 7369 (EMPNO est unique)
-- Q5
Rollback
-- Q6
alter table emp 
add constraint PK_EMP PRIMARY KEY (EMPNO);
alter table emp add
    constraint FK_EMP FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO);
-- Q7
--Remarques : on ne peut pas inserer ces tuples --> (7369, 'WILSON', 'MANAGER', 7839, TO_DATE('17-11-91','DD-MM-YY'), 3500.00, 600.00, 10) : une ligne avec EMPNO est
--                                                    deja existé sachant que EMPNO est notre PRIMARY KEY
--                                              --> (7657, 'WILSON', 'MANAGER', 7839, '17/11/91', 3500.00,
--                                                  600.00, 10) : on a deja ajouté une ligne avec ce EMPNO 7657 alors on ne peut pas les ajoutés si on ne change pas le primary key EMPNO
-- Est le tuple (7657, 'WILSON','MANAGER', 7839, '17/11/91', 3500.00, 600.00, 50) n'est ajouté pas a cause que y a pas un element avec DEPTNO 50 dans la table DEPT 
-- Aussi, il faut transformer les dates dans les tuples en utilisant (EX : TO_DATE('17/11/91','DD/MM/YY'))
-- Q8
select * from emp where empno= 7369; --> Resultas : 7369	SMITH	CLERK	7902	17-DEC-80	800	 - 	20
select * from emp where empno= 7657; -->Resultas : 7657	WILSON	MANAGER	7000	17-NOV-91	3500	600	10

--------- EXERCICE 2 ( Mise à jour de la base de données )
-- Q1
update DEPT 
SET LOC = 'PITTSBURGH'
where dname='SALES' and loc='CHICAGO';
-- Q2 
update EMP 
SET SAL = SAL* 1.10
where (COMM / SAL) > 0.5;
-- Q3 
update EMP 
SET COMM = (select AVG(COMM) as avgg from emp) 
where COMM is NULL and HIREDATE < TO_DATE('01/01/82','DD/MM/YY');
select * from emp;
-- Q4 
ROLLBACK;
-- Q5
-- Problem d'integroté contrainte car le deptno est une clé etramgaiere dans la table EMP

------- EXERCICE 3 ( Interrogation de la base de données ) 

-- Q1
column ENAME HEADING 'Employee|Name';
column SAL HEADING 'Salary';
column COMM HEADING 'Commision';

select ename, sal, comm, sal+comm from emp
where job='SALESMAN';

-- Q2 
select ename from emp
where job='SALESMAN'
order by (comm/sal) desc;

-- Q3 
select ename, from emp
where job='SALESMAN' and (comm/sal) < 0.25 ;

-- Q4 
select count(empno) from emp
where deptno = 10;
-- Q5 
select * from emp
where comm is not null;
-- Q6 
select count(distinct JOB) from emp;
-- Q7 
select avg(sal),job from emp group by job;
-- Q8 
select sum(sal) from emp;
-- Q9 
select ename as Nom_Emplyee,dname as Department_Name  from emp , dept where emp.deptno = dept.deptno;
-- Q10 
select ename as Nom_Emplyee,job,sal as Salary from emp where sal = (select max(sal) from emp);
-- Q11 
select ename as Nom_Emplyee from emp where sal > (select sal from emp where ename = 'JONES');
-- Q12 
select ename as Nom_Emplyee from emp where JOB =  (select JOB from emp where ename = 'JONES');
-- Q13 
select ename as Nom_Emplyee from emp where MGR = (select MGR from emp where ename = 'CLARK');
-- Q14 
select ename as Nom_Emplyee from emp where JOB =  (select JOB from emp where ename = 'TURNER') and MGR = (select MGR from emp where ename = 'TURNER');
-- Q15 
select ename as Nom_Emplyee from emp where HIREDATE < (select MIN(HIREDATE) from emp where deptno = 10);
-- Q16 
select ename as Nom_Emplyee,(select ename from emp where empno = e.mgr ) as Employee_Manager from emp e;
-- Q17 
select ename as Nom_Emplyee from emp e where deptno <> (select deptno from emp where empno = e.mgr);
 

