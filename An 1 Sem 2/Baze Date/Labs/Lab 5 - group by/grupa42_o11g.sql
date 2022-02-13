--lab 3
10. Folosind subcereri, s? se afi?eze numele ?i data angaj?rii pentru salaria?ii care au fost angaja?i dup? Gates.

SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
                    FROM employees
                    WHERE INITCAP(last_name)='Gates');
                    
11. Folosind subcereri, scrie?i o cerere pentru a afi?a numele ?i salariul pentru to?i colegii (din acela?i departament) lui Gates. Se va exclude Gates.
Se poate înlocui operatorul IN cu = ???
Se va inlocui Gates cu King

--subcerere care determina id-ul de departament in care lucreaza gates

select department_id 
from employees
where initcap(last_name)='Gates';

--cerere principala

select last_name, salary
from employees
where department_id = (select department_id 
                        from employees
                        where initcap(last_name)='Gates')
    and initcap(last_name) != 'Gates';

--Se va inlocui Gates cu King

select last_name, salary
from employees
where department_id in (select department_id 
                        from employees
                        where initcap(last_name)='King')
    and initcap(last_name) != 'King';


--OBSERVATIE: Operatorul = poate fi inlocuit cu IN (nu si invers)

12. Folosind subcereri, s? se afi?eze numele ?i salariul angaja?ilor condu?i direct de 
pre?edintele companiei (acesta este considerat angajatul care nu are manager).

select last_name, salary
from employees
where manager_id = (select employee_id
                    from employees
                    where manager_id is null);


13. Scrie?i o cerere pentru a afi?a numele, codul departamentului ?i salariul
angaja?ilor al c?ror cod de departament ?i salariu coincid cu codul departamentului ?i
salariul unui angajat care câ?tig? comision.

SELECT last_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, salary
                                  FROM employees
                                  WHERE commission_pct is not null);


14. S? se afi?eze codul, numele ?i salariul tuturor angaja?ilor al c?ror salariu este mai
mare decât salariul mediu.

SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary)
                FROM employees);


15. Scrieti o cerere pentru a afi?a angaja?ii care câ?tig? (salariul plus comision) mai mult
decât oricare func?ionar (job-ul con?ine ?irul "CLERK"). Sorta?i rezultatele dupa salariu,
în ordine descresc?toare.

SELECT last_name, salary + NVL(commission_pct,0) * salary VENIT
FROM employees
WHERE salary + NVL(commission_pct,0) * salary > (SELECT max(salary + NVL(commission_pct,0) * salary)
                                              FROM employees
                                              WHERE lower(job_id) like '%clerk%')
ORDER BY salary desc;

--var 2

SELECT last_name, salary + NVL(commission_pct,0) * salary VENIT
FROM employees
WHERE salary + NVL(commission_pct,0) * salary > all(SELECT salary + NVL(commission_pct,0) * salary
                                              FROM employees
                                              WHERE lower(job_id) like '%clerk%')
ORDER BY salary desc;

16. Scrie?i o cerere pentru a afi?a numele angajatilor, numele departamentului ?i
salariul angaja?ilor care nu câ?tig? comision, dar al c?ror ?ef direct câ?tig? comision.

SELECT last_name, department_name, salary
FROM employees e JOIN departments d USING (department_id)
WHERE commission_pct is null and e.manager_id IN (SELECT manager_id
                                                  FROM employees
                                                  WHERE commission_pct is not null);



17. S? se afi?eze numele angajatilor, departamentul, salariul ?i job-ul tuturor
angaja?ilor al c?ror salariu ?i comision coincid cu salariul ?i comisionul unui angajat din
Oxford.

SELECT last_name, department_id, salary, job_id, employee_id
FROM employees
WHERE (nvl(commission_pct, -1), salary) IN (SELECT nvl(commission_pct, -1), salary
                                            FROM employees e JOIN departments d ON (e.department_id = d.department_id)
                                                             JOIN locations l ON (l.location_id = d.location_id)
                                            WHERE initcap(l.city)='Oxford');

--lab 4

2. S? se afi?eze cel mai mare salariu, cel mai mic salariu, suma ?i media salariilor
tuturor angaja?ilor. Eticheta?i coloanele Maxim, Minim, Suma, respectiv Media. Sa se
rotunjeasca media salariilor.

SELECT MAX(salary) Maxim, MIN(salary) Minim, SUM(salary) Suma, round(AVG(salary)) Media
FROM employees;


3. S? se modifice problema 2 pentru a se afi?a minimul, maximul, suma ?i media
salariilor pentru FIECARE job.

SELECT job_id, MAX(salary) Maxim, MIN(salary) Minim, SUM(salary) Suma, round(AVG(salary)) Media
FROM employees
GROUP BY job_id; 

4. S? se afi?eze num?rul de angaja?i pentru FIECARE departament.

SELECT COUNT(*), d.department_id
FROM employees e right join departments d on (e.department_id = d.department_id)
GROUP BY d.department_id;

5. S? se determine num?rul de angaja?i care sunt ?efi. Etichetati coloana “Nr.
manageri”.
? De ce am folosit cuvântul cheie DISTINCT? Ce am fi ob?inut dac? îl omiteam?

SELECT COUNT(distinct(manager_id))
FROM employees;
 

6. S? se afi?eze diferen?a dintre cel mai mare si cel mai mic salariu. Etichetati
coloana “Diferenta”.

SELECT MAX(SALARY) - MIN(salary) Diferenta
FROM employees;

TEMA:

8. S? se afi?eze codul ?i numele angaja?ilor care au salariul mai mare decât salariul mediu din firm?. Se va sorta rezultatul în ordine descresc?toare a salariilor.

SELECT employee_id, first_name, last_name
FROM employees
WHERE salary > (SELECT AVG(salary)
                 FROM employees)
ORDER BY salary DESC; 

10. Pentru departamentele in care salariul maxim dep??e?te 3000$, s? se ob?in? codul, numele acestor departamente ?i salariul maxim pe departament.

SELECT department_id,department_name, (SELECT max(salary)
                                        FROM employees 
                                            GROUP BY department_id)
FROM departments
WHERE (SELECT max(salary)
        FROM employees 
        GROUP BY department_id) > 3000;












