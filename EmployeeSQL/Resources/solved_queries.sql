-- Data analysis queries solved:

-- 1. List the following details of each employee:
-- employee number, last name, first name, sex, and salary.
SELECT 
e.emp_no AS "Employee Number",
e.last_name AS "Last Name",
e.first_name AS "First Name",
e.sex AS "Sex",
s.salary AS "Salary"
FROM employee e
	INNER JOIN salary s
		ON e.emp_no = s.emp_no
/*ORDER BY last_name DESC*/

--2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT
first_name AS "First Name",
last_name AS "Last Name",
hire_date AS "Hire Date"
FROM employee
WHERE extract(year from hire_date) = 1986

-- 3. List the manager of each department with the following information:
-- department number, department name, the manager's employee number, last name, first name.
SELECT
dmj.dept_no AS "Department Number",
d.dept_name AS "Department Name",
dmj.emp_no AS "Manager''s Employee Number",
e.last_name AS "Last Name",
e.first_name AS "First Name"
FROM department_manager_junction dmj
	INNER JOIN department d
		ON dmj.dept_no = d.dept_no
			INNER JOIN employee e
				ON dmj.emp_no = e.emp_no

--- 4. List the department of each employee with the following information:
-- employee number, last name, first name, and department name.
SELECT
e.emp_no AS "Employee Number",
e.last_name AS "Last Name",
e.first_name AS "First Name",
d.dept_name AS "Department Name"
FROM department_employee_junction dej
	INNER JOIN department d
		ON dej.dept_no = d.dept_no
			INNER JOIN employee e
				ON dej.emp_no = e.emp_no

-- 5. List first name, last name, and sex for employees
-- whose first name is "Hercules" and last names begin with "B."
SELECT
first_name AS "First Name",
last_name AS "Last Name",
sex AS "Sex"
FROM employee
WHERE first_name = 'Hercules'
	AND lasT_name LIKE 'B%'


-- 6. List all employees in the Sales department,
-- including their employee number, last name, first name, and department name.
SELECT
e.emp_no AS "Employee Number",
e.last_name AS "Last Name",
e.first_name AS "First Name",
d.dept_name AS "Department Name"
FROM department_employee_junction dej
	INNER JOIN department d
		ON dej.dept_no = d.dept_no
			INNER JOIN employee e
				ON dej.emp_no = e.emp_no
WHERE d.dept_name = 'Sales'


-- 8. In descending order, list the frequency count of employee last names, i.e.,
-- how many employees share each last name.
SELECT
last_name AS "Last Name",
COUNT(last_name) AS "Frequency count of employee last names"
FROM employee
GROUP BY "Last Name"
ORDER BY "Frequency count of employee last names" DESC
