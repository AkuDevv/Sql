INSERT INTO job_history  
VALUES (102  
       , TO_DATE('13-01-2001', 'dd-MM-yyyy')  
       , TO_DATE('24-07-2006', 'dd-MM-yyyy')  
       , 'IT_PROG'  
       , 60);  
  
INSERT INTO job_history  
VALUES (101  
       , TO_DATE('21-09-1997', 'dd-MM-yyyy')  
       , TO_DATE('27-10-2001', 'dd-MM-yyyy')  
       , 'AC_ACCOUNT'  
       , 110);  
  
INSERT INTO job_history  
VALUES (101  
       , TO_DATE('28-10-2001', 'dd-MM-yyyy')  
       , TO_DATE('15-03-2005', 'dd-MM-yyyy')  
       , 'AC_MGR'  
       , 110);  
  
INSERT INTO job_history  
VALUES (201  
       , TO_DATE('17-02-2004', 'dd-MM-yyyy')  
       , TO_DATE('19-12-2007', 'dd-MM-yyyy')  
       , 'MK_REP'  
       , 20);  
  
INSERT INTO job_history  
VALUES  (114  
        , TO_DATE('24-03-2006', 'dd-MM-yyyy')  
        , TO_DATE('31-12-2007', 'dd-MM-yyyy')  
        , 'ST_CLERK'  
        , 50  
        );  
  
INSERT INTO job_history  
VALUES  (122  
        , TO_DATE('01-01-2007', 'dd-MM-yyyy')  
        , TO_DATE('31-12-2007', 'dd-MM-yyyy')  
        , 'ST_CLERK'  
        , 50  
        );  
  
INSERT INTO job_history  
VALUES  (200  
        , TO_DATE('17-09-1995', 'dd-MM-yyyy')  
        , TO_DATE('17-06-2001', 'dd-MM-yyyy')  
        , 'AD_ASST'  
        , 90  
        );  
  
INSERT INTO job_history  
VALUES  (176  
        , TO_DATE('24-03-2006', 'dd-MM-yyyy')  
        , TO_DATE('31-12-2006', 'dd-MM-yyyy')  
        , 'SA_REP'  
        , 80  
        );  
  
INSERT INTO job_history  
VALUES  (176  
        , TO_DATE('01-01-2007', 'dd-MM-yyyy')  
        , TO_DATE('31-12-2007', 'dd-MM-yyyy')  
        , 'SA_MAN'  
        , 80  
        );  
  
INSERT INTO job_history  
VALUES  (200  
        , TO_DATE('01-07-2002', 'dd-MM-yyyy')  
        , TO_DATE('31-12-2006', 'dd-MM-yyyy')  
        , 'AC_ACCOUNT'  
        , 90  
        );  

-- enable integrity constraint to DEPARTMENTS
ALTER TABLE departments   
  ENABLE CONSTRAINT dept_mgr_fk;

-- procedure to limit edit of EMPLOYEES to normal office hours
CREATE OR REPLACE PROCEDURE secure_dml  
IS  
BEGIN  
  IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'  
        OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN  
	RAISE_APPLICATION_ERROR (-20205,   
		'You may only make changes during normal office hours');  
  END IF;  
END secure_dml; 
/

-- trigger on EMPLOYEES to invoke the SECURE_DML procedure
CREATE OR REPLACE TRIGGER secure_employees  
  BEFORE INSERT OR UPDATE OR DELETE ON employees  
BEGIN  
  secure_dml;  
END secure_employees; 
/

-- disable SECURE_EMPLOYEES trigger so data can be used at any time (given that this is a sample schema)
ALTER TRIGGER secure_employees DISABLE;

-- procedure to add a row to the JOB_HISTORY table
CREATE OR REPLACE PROCEDURE add_job_history  
  (  p_emp_id          job_history.employee_id%type  
   , p_start_date      job_history.start_date%type  
   , p_end_date        job_history.end_date%type  
   , p_job_id          job_history.job_id%type  
   , p_department_id   job_history.department_id%type   
   )  
IS  
BEGIN  
  INSERT INTO job_history (employee_id, start_date, end_date,   
                           job_id, department_id)  
    VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);  
END add_job_history; 
/

-- row trigger to call the ADD_JOB_HISTORY procedure when data is updated in the job_id or department_id columns in the EMPLOYEES table
CREATE OR REPLACE TRIGGER update_job_history  
  AFTER UPDATE OF job_id, department_id ON employees  
  FOR EACH ROW  
BEGIN  
  add_job_history(:old.employee_id, :old.hire_date, sysdate,   
                  :old.job_id, :old.department_id);  
END; 
/

-- Beginning of comments on tables and columns
COMMENT ON TABLE regions   
IS 'Regions table that contains region numbers and names. Contains 4 rows; references with the Countries table.'


COMMENT ON COLUMN regions.region_id  
IS 'Primary key of regions table.'


COMMENT ON COLUMN regions.region_name  
IS 'Names of regions. Locations are in the countries of these regions.'


COMMENT ON TABLE locations  
IS 'Locations table that contains specific address of a specific office, warehouse, and/or production site of a company. Does not store addresses or locations of customers. Contains 23 rows; references with the departments and countries tables. '


COMMENT ON COLUMN locations.location_id  
IS 'Primary key of locations table'


COMMENT ON COLUMN locations.street_address  
IS 'Street address of an office, warehouse, or production site of a company. Contains building number and street name'


COMMENT ON COLUMN locations.postal_code  
IS 'Postal code of the location of an office, warehouse, or production site of a company. '


COMMENT ON COLUMN locations.city  
IS 'A not null column that shows city where an office, warehouse, or production site of a company is located. '


COMMENT ON COLUMN locations.state_province  
IS 'State or Province where an office, warehouse, or production site of a company is located.'


COMMENT ON COLUMN locations.country_id  
IS 'Country where an office, warehouse, or production site of a company is located. Foreign key to country_id column of the countries table.'


COMMENT ON TABLE departments  
IS 'Departments table that shows details of departments where employees work. Contains 27 rows; references with locations, employees, and job_history tables.'


COMMENT ON COLUMN departments.department_id  
IS 'Primary key column of departments table.'


COMMENT ON COLUMN departments.department_name  
IS 'A not null column that shows name of a department. Administration, Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public Relations, Sales, Finance, and Accounting. '


COMMENT ON COLUMN departments.manager_id 
IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.'


COMMENT ON COLUMN departments.location_id  
IS 'Location id where a department is located. Foreign key to location_id column of locations table.'


COMMENT ON TABLE job_history  
IS 'Table that stores job history of the employees. If an employee  changes departments within the job or changes jobs within the department,  new rows get inserted into this table with old job information of the employee. Contains a complex primary key: employee_id+start_date. Contains 25 rows. References with jobs, employees, and departments tables.'


COMMENT ON COLUMN job_history.employee_id  
IS 'A not null column in the complex primary key employee_id+start_date. Foreign key to employee_id column of the employee table'


COMMENT ON COLUMN job_history.start_date  
IS 'A not null column in the complex primary key employee_id+start_date.  Must be less than the end_date of the job_history table. (enforced by constraint jhist_date_interval)'


COMMENT ON COLUMN job_history.end_date  
IS 'Last day of the employee in this job role. A not null column. Must be greater than the start_date of the job_history table.  (enforced by constraint jhist_date_interval)'


COMMENT ON COLUMN job_history.job_id  
IS 'Job role in which the employee worked in the past; foreign key to job_id column in the jobs table. A not null column.'


COMMENT ON COLUMN job_history.department_id 
IS 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table'


COMMENT ON TABLE countries  
IS 'country table. Contains 25 rows. References with locations table.'


COMMENT ON COLUMN countries.country_id  
IS 'Primary key of countries table.'


COMMENT ON COLUMN countries.country_name  
IS 'Country name'


COMMENT ON COLUMN countries.region_id  
IS 'Region ID for the country. Foreign key to region_id column in the departments table.'


COMMENT ON TABLE jobs  
IS 'jobs table with job titles and salary ranges. Contains 19 rows. References with employees and job_history table.'


COMMENT ON COLUMN jobs.job_id  
IS 'Primary key of jobs table.'


COMMENT ON COLUMN jobs.job_title  
IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT'


COMMENT ON COLUMN jobs.min_salary  
IS 'Minimum salary for a job title.'


COMMENT ON COLUMN jobs.max_salary  
IS 'Maximum salary for a job title'


