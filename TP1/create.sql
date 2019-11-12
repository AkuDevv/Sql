REM   Script: HR Objects and Data For Live SQL
REM   This script will create a the HR Sample Schema objects and data in your local schema.  If you want just query-only, you can instead use the HR sample schema by referencing hr.regions, etc.  To drop the objects once created, you can run "Drop HR Sample Schema" - 
https://livesql.oracle.com/apex/livesql/file/content_GWKN7QJBHHC8F1RJTEB47AFOY.html.  Please note that this schema was initially created in 2000 and last updated March 19, 2015 so the constructs are not necessarily what we would recommend today.

-- Copyright
begin  
   dbms_output.put_line('Copyright (c) 2018, Oracle and/or its affiliates.  All rights reserved.  '); 
   dbms_output.put_line('Permission is hereby granted, free of charge, to any person obtaining '); 
   dbms_output.put_line('a copy of this software and associated documentation files (the '); 
   dbms_output.put_line('"Software"), to deal in the Software without restriction, including '); 
   dbms_output.put_line('without limitation the rights to use, copy, modify, merge, publish, '); 
   dbms_output.put_line('distribute, sublicense, and/or sell copies of the Software, and to '); 
   dbms_output.put_line('permit persons to whom the Software is furnished to do so, subject to '); 
   dbms_output.put_line('the following conditions: '); 
   dbms_output.put_line(' '); 
   dbms_output.put_line('The above copyright notice and this permission notice shall be '); 
   dbms_output.put_line('included in all copies or substantial portions of the Software. '); 
   dbms_output.put_line(' '); 
   dbms_output.put_line('THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, '); 
   dbms_output.put_line('EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF '); 
   dbms_output.put_line('MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND '); 
   dbms_output.put_line('NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE '); 
   dbms_output.put_line('LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION '); 
   dbms_output.put_line('OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION '); 
   dbms_output.put_line('WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. '); 
end; 
/

-- REGIONS table holds region information for locations
-- HR.LOCATIONS table has a foreign key to this table. 
CREATE TABLE regions  
    ( region_id      NUMBER   
                     CONSTRAINT region_id_nn NOT NULL 
    ,                CONSTRAINT reg_id_pk  
                        PRIMARY KEY (region_id) 
    , region_name    VARCHAR2(25)   
    );

-- COUNTRIES table holds country information for customers and company locations. 
-- OE.CUSTOMERS table and HR.LOCATIONS have a foreign key to this table.
CREATE TABLE countries   
    ( country_id      CHAR(2)   
                      CONSTRAINT country_id_nn NOT NULL 
    ,                 CONSTRAINT country_c_id_pk   
        	         PRIMARY KEY (country_id) 
    , country_name    VARCHAR2(40)   
    , region_id       NUMBER   
    ,                 CONSTRAINT countr_reg_fk  
        	         FOREIGN KEY (region_id)  
          	         REFERENCES regions (region_id)   
    )   
    ORGANIZATION INDEX;

-- LOCATIONS table holds address information for company departments. 
-- HR.DEPARTMENTS has a foreign key to this table. 
CREATE TABLE locations  
    ( location_id    NUMBER(4)  NOT NULL 
                     CONSTRAINT loc_id_pk  
       		        PRIMARY KEY  
    , street_address VARCHAR2(40)  
    , postal_code    VARCHAR2(12)  
    , city           VARCHAR2(30)  
	             CONSTRAINT loc_city_nn  NOT NULL  
    , state_province VARCHAR2(25)  
    , country_id     CHAR(2)  
    ,                CONSTRAINT loc_c_id_fk  
       		        FOREIGN KEY (country_id)  
        	        REFERENCES countries(country_id) 
    );

-- Useful for any subsequent addition of rows to LOCATIONS table 
-- Starts with 3300 
CREATE SEQUENCE locations_seq  
 START WITH     3300  
 INCREMENT BY   100  
 MAXVALUE       9900  
 NOCACHE  
 NOCYCLE;

-- DEPARTMENTS table holds company department information. 
-- HR.EMPLOYEES and HR.JOB_HISTORY have a foreign key to this table.
CREATE TABLE departments  
    ( department_id    NUMBER(4) 
                       CONSTRAINT dept_id_pk  
       		          PRIMARY KEY 
    , department_name  VARCHAR2(30)  
	               CONSTRAINT dept_name_nn  NOT NULL  
    , manager_id       NUMBER(6)  
    , location_id      NUMBER(4)  
    ,                  CONSTRAINT dept_loc_fk  
       		          FOREIGN KEY (location_id)  
        	          REFERENCES locations (location_id)  
    );

-- Useful for any subsequent addition of rows to DEPARTMENTS table
-- Starts with 280 
CREATE SEQUENCE departments_seq  
 START WITH     280  
 INCREMENT BY   10  
 MAXVALUE       9990  
 NOCACHE  
 NOCYCLE;

-- JOBS table holds the different names of job roles within the company. 
-- HR.EMPLOYEES has a foreign key to this table. 
CREATE TABLE jobs  
    ( job_id         VARCHAR2(10)  
                     CONSTRAINT job_id_pk  
      		        PRIMARY KEY 
    , job_title      VARCHAR2(35)  
	             CONSTRAINT job_title_nn  NOT NULL  
    , min_salary     NUMBER(6)  
    , max_salary     NUMBER(6)  
    );

-- EMPLOYEES table holds the employee personnel  information for the company. 
-- HR.EMPLOYEES has a self referencing foreign key to this table.
CREATE TABLE employees  
    ( employee_id    NUMBER(6)  
                     CONSTRAINT emp_emp_id_pk  
                        PRIMARY KEY 
    , first_name     VARCHAR2(20)  
    , last_name      VARCHAR2(25)  
	             CONSTRAINT emp_last_name_nn  NOT NULL  
    , email          VARCHAR2(25)  
	             CONSTRAINT emp_email_nn  NOT NULL  
    , CONSTRAINT     emp_email_uk  
                     UNIQUE (email)  
    , phone_number   VARCHAR2(20)  
    , hire_date      DATE  
	             CONSTRAINT emp_hire_date_nn  NOT NULL  
    , job_id         VARCHAR2(10)  
	             CONSTRAINT emp_job_nn  NOT NULL  
    , salary         NUMBER(8,2)  
                     CONSTRAINT emp_salary_min  
                        CHECK (salary > 0)  
    , commission_pct NUMBER(2,2)  
    , manager_id     NUMBER(6)  
    ,                CONSTRAINT emp_manager_fk  
                        FOREIGN KEY (manager_id)  
                        REFERENCES employees 
    , department_id  NUMBER(4)  
    ,                CONSTRAINT emp_dept_fk  
                        FOREIGN KEY (department_id)  
                        REFERENCES departments 
    );

-- The foreign key can now be created to the EMPLOYEES table.
ALTER TABLE departments  
   ADD (CONSTRAINT dept_mgr_fk  
      	FOREIGN KEY (manager_id)  
      	REFERENCES employees (employee_id)  
    );

-- Useful for any subsequent addition of rows to employees table.
-- Starts with 207  
CREATE SEQUENCE employees_seq  
 START WITH     207  
 INCREMENT BY   1  
 NOCACHE  
 NOCYCLE;

-- JOB_HISTORY table holds the history of jobs that employees have held in the past.
-- HR.JOBS, HR_DEPARTMENTS, and HR.EMPLOYEES have a foreign key to this table.
CREATE TABLE job_history  
    ( employee_id   NUMBER(6)  
	            CONSTRAINT jhist_employee_nn  NOT NULL  
    ,               CONSTRAINT jhist_emp_fk  
                       FOREIGN KEY (employee_id)  
                       REFERENCES employees  
    , start_date    DATE  
	            CONSTRAINT jhist_start_date_nn  NOT NULL  
    , end_date      DATE  
	            CONSTRAINT jhist_end_date_nn  NOT NULL  
    , job_id        VARCHAR2(10)  
	            CONSTRAINT jhist_job_nn  NOT NULL  
    ,               CONSTRAINT jhist_job_fk  
                       FOREIGN KEY (job_id)  
                       REFERENCES jobs  
    , department_id NUMBER(4)  
    ,               CONSTRAINT jhist_dept_fk  
                       FOREIGN KEY (department_id)  
                       REFERENCES departments 
    , CONSTRAINT    jhist_emp_id_st_date_pk  
                       PRIMARY KEY (employee_id, start_date) 
    , CONSTRAINT    jhist_date_interval  
                       CHECK (end_date > start_date)  
    ) ;

-- EMP_DETAILS_VIEW joins the employees, jobs, departments, jobs, countries, and locations table to provide details about employees.
CREATE OR REPLACE VIEW emp_details_view  
  (employee_id,  
   job_id,  
   manager_id,  
   department_id,  
   location_id,  
   country_id,  
   first_name,  
   last_name,  
   salary,  
   commission_pct,  
   department_name,  
   job_title,  
   city,  
   state_province,  
   country_name,  
   region_name)  
AS SELECT  
  e.employee_id,   
  e.job_id,   
  e.manager_id,   
  e.department_id,  
  d.location_id,  
  l.country_id,  
  e.first_name,  
  e.last_name,  
  e.salary,  
  e.commission_pct,  
  d.department_name,  
  j.job_title,  
  l.city,  
  l.state_province,  
  c.country_name,  
  r.region_name  
FROM  
  employees e,  
  departments d,  
  jobs j,  
  locations l,  
  countries c,  
  regions r  
WHERE e.department_id = d.department_id  
  AND d.location_id = l.location_id  
  AND l.country_id = c.country_id  
  AND c.region_id = r.region_id  
  AND j.job_id = e.job_id   
WITH READ ONLY;
