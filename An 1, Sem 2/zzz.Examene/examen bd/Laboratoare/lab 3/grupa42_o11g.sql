--5 lab 2

select last_name
from employees
where mod(round(sysdate-hire_date),7)=0;

--6 lab 2

select employee_id, last_name, salary, round(salary * 1.15, 2) "Salariu nou", round(salary * 1.15 / 100, 2) "Numar sute"
from employees
where mod(salary, 1000) != 0;

-- !=  <=>  ^=  <=>  <>

--7 lab 2

SELECT last_name, RPAD(to_char(hire_date), 20, 'X')
FROM employees
WHERE commission_pct is not null;
 
--8 lab 2

SELECT TO_CHAR(SYSDATE+30, 'MONTH DD YYYY HH24:MI:SS') "Data"
FROM DUAL;

--10 lab 2
--a

SELECT TO_CHAR(SYSDATE + 12/24, 'MONTH DD YYYY HH24:MI:SS') "Data"
FROM DUAL;

--b

SELECT TO_CHAR(SYSDATE + 5/60/24, 'MONTH DD YYYY HH24:MI:SS') "Data"
FROM DUAL;

--13 lab 2

select last_name, NVL(to_char(commission_pct),'Fara comision') "Comision"
from employees;

--14 lab 2

SELECT last_name, salary, commission_pct
FROM employees
WHERE salary + salary * NVL(commission_pct, 0) > 10000;

--15 lab 2

SELECT last_name, job_id, salary, DECODE(job_id, 'IT_PROG', salary * 1.1, 'ST_CLERK', salary * 1.15, 'SA_REP', salary * 1.2, salary) "Salariu renegociat"
FROM employees;

--Sau

SELECT last_name, job_id, salary,
     CASE job_id WHEN 'IT_PROG' THEN salary* 1.1
                 WHEN 'ST_CLERK' THEN salary* 1.15
                 WHEN 'SA_REP' THEN salary* 1.2
    ELSE salary
    END "Salariu renegociat"
FROM employees;



--!!!!!!!JOIN

select * from departments;

select * from employees;


--16 lab 2

select employee_id, department_name
from employees e, departments d; -- produs cartezian


select employee_id, department_name
from employees e, departments d
where e.department_id = d.department_id; -- 106 angajati din totalul de 107

select employee_id, last_name
from employees
where department_id is null; -- grant nu are departament

--(+) afiseaza deficitul de informatie
--vrem sa afisam si angajatii fara departament

select employee_id, department_name
from employees e, departments d
where e.department_id = d.department_id(+);

--vrem sa afisam si departamentele fara angajati

select employee_id, department_name
from employees e, departments d
where e.department_id(+) = d.department_id;


--ALIAS


select employee_id, department_name, e.department_id
from employees e, departments d
where e.department_id = d.department_id;

--SAU VARIANTA 2

--II. Condi?ia de Join este scris? �n FROM
--Utiliz?m ON:

select employee_id, department_name
from employees e join departments d on (e.department_id = d.department_id);

--Utiliz?m USING � atunci c�nd avem coloane cu acela?i nume:

select employee_id,department_name
from employees e join departments d using(department_id);


--17 lab 2

select e.job_id, job_title
from jobs j, employees e
where department_id = 30 and e.job_id = j.job_id;

--18 lab 2

SELECT last_name, department_name, location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id AND commission_pct is not null;

--19 lab 2

select last_name, job_title, department_name
from employees e, jobs j, departments d, locations l
where e.job_id = j.job_id and
      e.department_id = d.department_id and
      d.location_id = l.location_id and
      city = 'Oxford';

--20 lab 2

SELECT ang.employee_id Ang#, ang.last_name Angajat, sef.employee_id Mgr#, sef.last_name Manager
FROM employees ang, employees sef
WHERE ang.manager_id = sef.employee_id;

--21 lab 2

SELECT ang.employee_id Ang#, ang.last_name Angajat, sef.employee_id Mgr#, sef.last_name Manager
FROM employees ang, employees sef
WHERE ang.manager_id = sef.employee_id(+);

--22 lab 2

select ang.last_name, ang.department_id, coleg.last_name
from employees ang, employees coleg
where ang.department_id = coleg.department_id and ang.employee_id != coleg.employee_id;

--24 lab 2

select ang.last_name "Nume ang", ang.hire_date "Data ang", gates.last_name "Nume Gates", gates.hire_date "Data Gates"
from employees ang, employees gates
where initcap(gates.last_name) = 'Gates' and ang.hire_date > gates.hire_date;

--tema: ex 23, 25

--23 lab 2

select e.last_name, e.job_id, j.job_title, d.department_name, e.salary, e.department_id
from employees e, jobs j, departments d
where e.job_id = j.job_id and (e.department_id = d.department_id); -- nu stiu cum fac sa-l includ si salariatii care nu au departament

--25 lab 2

select sal.last_name Angajat, sal.hire_date Data_ang, man.last_name Manager, man.hire_date Data_mgr
from employees sal, employees man
where sal.manager_id = man.employee_id and sal.hire_date < man.hire_date;


select *
from employees;