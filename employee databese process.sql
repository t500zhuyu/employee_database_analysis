use employee_exercise1;

# creating big size table, more than 300,000 rows
CREATE TABLE dept_emp
(
 emp_no INT,
 dept_no text
 );
 

SELECT * FROM dept_emp;

LOAD DATA INFILE 'dept_emp.csv' INTO TABLE dept_emp
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT COUNT(*) as counter
FROM dept_emp;

CREATE TABLE employees
(
 emp_no INT NOT NULL,
 emp_title_id varchar(255) NOT NULL,
 birth_date date NOT NULL,
 first_name varchar(255) NOT NULL,
 last_name varchar(255) NOT NULL,
 sex varchar(255) NOT NULL,
 hire_date date
 );
 
# make the primary key for table employees
# in this case is column emp_no
ALTER TABLE employees
ADD PRIMARY KEY (emp_no);

SELECT * FROM employees;

LOAD DATA INFILE 'employees.csv' INTO TABLE employees
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT COUNT(*) as counter
FROM employees;

CREATE TABLE salaries
(
 emp_no INT,
 salary int
 );
 
ALTER TABLE salaries
MODIFY emp_no INT NOT NULL;

ALTER TABLE salaries
MODIFY salary INT NOT NULL;


SELECT * FROM salaries;

LOAD DATA INFILE 'salaries.csv' INTO TABLE salaries
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT COUNT(*) as counter
FROM salaries;

SELECT COUNT(*) as counter
FROM titles;


CREATE TABLE departments
(
 dept_no varchar(255),
 dept_name varchar(255)
 );

# make the primary key for table departments
# in this case is column dept_no
ALTER TABLE departments
ADD PRIMARY KEY (dept_no);

SELECT * FROM departments;

LOAD DATA INFILE 'departments.csv' INTO TABLE departments
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

CREATE TABLE titles
(
 title_id varchar(255) NOT NULL,
 title varchar(255) NOT NULL
 );
 
ALTER TABLE titles
ADD PRIMARY KEY (title_id);

SELECT * FROM titles;

LOAD DATA INFILE 'titles.csv' INTO TABLE titles
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SET SQL_SAFE_UPDATES = 0;
UPDATE employees
SET birth_date = DATE_FORMAT(STR_TO_DATE(birth_date, '%m/%d/%Y'), '%Y-%m-%d');

SELECT STR_TO_DATE('1963/07/12', '%Y/%m/%d') AS formatted_date;

# make the primary key for table departments
# in this case is column dept_no
ALTER TABLE departments
ADD PRIMARY KEY (dept_no);

ALTER TABLE dept_manager
ADD PRIMARY KEY (dept_no);


# Adding foreign keys

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);


# Queries


# 1°  List the employee number, last name, first name, sex, and salary of each employee.
# dept_emp employees salaries
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');
select employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
from employees
join salaries on employees.emp_no = salaries.emp_no;

select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees e
join salaries s on e.emp_no = s.emp_no;

#List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE YEAR(hire_date) = 1986;

#List the manager of each department along with their department number, department name, employee number, last name, and first name.

select d.dept_no, p.dept_name, e.emp_no, e.last_name, e.first_name
from dept_manager d
join departments p on d.dept_no = p.dept_no
join employees e on e.emp_no = d.emp_no;

#List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

select d.emp_no, d.dept_no, e.last_name, e.first_name, p.dept_name
from employees e
join dept_manager d on e.emp_no = d.emp_no
JOIN departments p ON  d.dept_no = p.dept_no;

#List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';
#List each employee in the Sales department, including their employee number, last name, and first name.
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

select d.emp_no, p.dept_no, e.last_name, e.first_name, p.dept_name
from employees e
join dept_manager d on e.emp_no = d.emp_no
JOIN departments p ON  p.dept_no = d.dept_no
WHERE d.dept_no = 'd007';

#List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT d.emp_no, p.dept_no, e.last_name, e.first_name, p.dept_name
FROM employees e
JOIN dept_manager d ON e.emp_no = d.emp_no
JOIN departments p ON p.dept_no = d.dept_no
WHERE d.dept_no IN ('d007', 'd005');

#List the frequency counts, in descending order, of all the employee last names.
SELECT last_name, COUNT(*) as frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;




