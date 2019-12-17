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