--Exercice 1:

DECLARE
    a NUMBER := 1;
    b NUMBER := 2;
    c NUMBER := 0;
BEGIN
    dbms_output.put_line('avant la permutation a='|| a || ' b=' || b);
    c := a;
    a := b;
    b := c;
    dbms_output.put_line('apres la permutation a='|| a || ' b=' || b);
END;

 -- Exercice 2:

 DECLARE
    a NUMBER := 10;

BEGIN
    dbms_output.put_line('le nombre a='|| a);
    a := fact(a);
    dbms_output.put_line('la factorielle de a='|| a);
END;

CREATE FUNCTION fact (n IN NUMBER) 
     RETURN NUMBER 
     IS BEGIN 
           if n = 0 then 
                return (1) ; 
           else 
                return ((n * fact (n-1))) ;  
           end if ; 
         END ;

 --Exercice 3:

DECLARE
    v_max NUMBER:=0;
BEGIN
    SELECT MAX(department_id)+10 into v_max FROM Departments;
    INSERT INTO Departments VALUES(v_max,'Gaming',205,1700);
END;

 --Exercice 4:

 DECLARE
    v_max NUMBER:=0;
BEGIN
    SELECT MAX(department_id) into v_max FROM Departments;
    dbms_output.put_line(v_max);
END;

 --Exercice 5:

 SELECT * FROM Departments WHERE department_id = 280

  --Exercice 6:

  DECLARE
    v_max NUMBER:=0;
BEGIN
    SELECT MAX(department_id)+10 into v_max FROM Departments;
    UPDATE Departments
        SET location_id = 2500
    WHERE department_id = v_max;

END;

 --Exercice 7:

 accept last_name varchar(20) prompt 'Enter last name: ';

DECLARE
    v_lastname VARCHAR(20);
    v_res Employees.manager_id%TYPE;
BEGIN
    v_lastname := '&last_name';
    SELECT manager_id INTO v_res FROM Employees WHERE last_name = v_lastname;

END;

 --Exercice 8:

 DECLARE

v_empno employees.employee_id%TYPE;
v_ename employees.last_name%TYPE;
v_ehiredate employees.hire_date%TYPE;

CURSOR emp_cursor IS
SELECT employee_id, last_name, hire_date
FROM employees
ORDER BY hire_date DESC;
BEGIN
OPEN emp_cursor;
LOOP
FETCH emp_cursor INTO v_empno, v_ename, v_ehiredate;
EXIT WHEN emp_cursor%ROWCOUNT > 10 OR
emp_cursor%NOTFOUND;
DBMS_OUTPUT.PUT_LINE (TO_CHAR(v_empno)
||' '|| v_ename || ' ' || v_ehiredate);

END LOOP;
CLOSE emp_cursor;

END ;
-- Exercice9
declare
employee_count int :=0;
begin 
    select count(employee_id) into employee_count from employees where department_id = 30;
    dbms_output.put_line('Nombre des emplyees dans departement 30 est : ' || employee_count);
end;
-- Exercice10

declare 
v_salary employees.salary%type;
v_last_name employees.last_name%type;
v_first_name employees.first_name%type;
v_employee_id employees.employee_id%type;
cursor employees_cursor is select employee_id,first_name, last_name, salary from employees;
begin
    open employees_cursor;
    loop
    fetch employees_cursor into v_employee_id,v_first_name,v_last_name,v_salary;
    if v_salary<3000 
    then 
    update employees 
    set salary = v_salary + 500
    where employee_id = v_employee_id;
    dbms_output.put_line(v_first_name || ' ' || v_last_name || '''' || 's salary updated');
    else 
    dbms_output.put_line(v_first_name || ' ' || v_last_name || ' earns ' || v_salary);
    end if;
    exit when employees_cursor%notfound;
    end loop;
    close employees_cursor;
end;

-- Exercice 11
-------------Part1
-- 1)   
select NomS, Horaire from Salle where titre = 'Les misérables'
-- 2)
select acteur from Film 
group by acteur 
having  count(Titre) = (select count(titre) from Film);
-- 3)
select spectateur from Vu v group by spectateur 
having count(titre) = (select count(titre) from Aime where v.spectateur = Amateur);
-------------Part2
declare 
n_film int =: 0;
v_realisateur Producteur.Producteur%TYPE;
cursor realisateurs_cursor is select distinct Realisateur from realisateur;
begin
    open realisateurs_cursor;
    if realisateurs_cursor%notfound
    then 
    dbms_output.put_line('Pas de films disponibles !!');
    else 
    loop
        fetch realisateurs_cursor into v_realisateur;
        select count(Titre) into n_film from Film f1 where exists(select * from Film f2 where f1.realisateur = f2.realisateur);
        dbms_output.put_line('Le réalisateur :' || v_realisateur || ' à réalisé ' || n_film || 'films ');
    exit when realisateurs_cursor%notfound;
    end loop;
    end if;
    
end;

