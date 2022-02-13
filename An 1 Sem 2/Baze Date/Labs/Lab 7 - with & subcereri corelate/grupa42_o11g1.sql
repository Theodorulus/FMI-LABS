--lab 5

0. a) S? se afi?eze informa?ii despre angaja?ii al c?ror salariu dep??e?te valoarea medie a
salariilor colegilor s?i de departament.

SELECT last_name, salary, department_id
FROM employees e
WHERE salary > (SELECT AVG(salary)
                FROM employees
                WHERE department_id = e.department_id);
                
b) Analog cu cererea precedent?, afi?ându-se ?i numele departamentului ?i media salariilor
acestuia ?i num?rul de angaja?i.

--Solu?ia 1 (subcerere necorelat? în clauza FROM):

SELECT last_name, salary, e.department_id, department_name, sal_med, nr_sal
FROM employees e, departments d, (SELECT department_id, ROUND(AVG(salary)) sal_med, COUNT(*) nr_sal
                                  FROM employees
                                  GROUP BY department_id) ac
WHERE e.department_id = d.department_id AND d.department_id = ac.department_id 
                                        AND salary > (SELECT AVG(salary)
                                                      FROM employees
                                                      WHERE department_id = e.department_id);
                                                      
                                                      
--Solu?ia 2 (subcerere corelat? în clauza SELECT):

SELECT last_name, salary, e. department_id, department_name,(SELECT ROUND(AVG(salary))
                                                             FROM employees
                                                             WHERE department_id = e. department_id) "Salariu mediu",
                                                            (SELECT COUNT(*)
                                                             FROM employees
                                                             WHERE department_id = e. department_id) "Nr angajati"
FROM employees e join departments d on (e.department_id = d.department_id)
WHERE salary > (SELECT AVG(salary)
                FROM employees
                WHERE department_id = e.department_id);
  
                                                   
1. S? se afi?eze numele ?i salariul angaja?ilor al c?ror salariu este mai mare decât salariile
medii din toate departamentele. Se cer 2 variante de rezolvare: cu operatorul ALL sau cu
func?ia MAX.                                               
  
--ALL

select last_name, salary
from employees
where salary > ALL(SELECT round(avg(salary))
       FROM employees
       GROUP BY department_id);

--MAX

select last_name, salary
from employees
where salary > (SELECT max(avg(salary))
                FROM employees
                GROUP BY department_id);

2. Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament.

--Solu?ia 1 (cu sincronizare):

SELECT last_name, salary, department_id
FROM employees e
WHERE salary = (SELECT MIN(salary)
                FROM employees
                WHERE department_id = e.department_id);
 
--Solu?ia 2 (f?r? sincronizare):

SELECT last_name, salary, department_id
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, MIN(salary)
                                  FROM employees
                                  GROUP BY department_id);
 
--Solu?ia 3: Subcerere în clauza FROM 

SELECT last_name, salary, e.department_id
FROM employees e join (select min(salary) min_sal, department_id dep_id
                       from employees
                       group by department_id)
                    on (e.department_id = dep_id)
WHERE salary = min_sal;
                    

3. Sa se obtina numele salariatilor care lucreaza intr-un departament in care exista cel putin 1 
angajat cu salariul egal cu salariul maxim din departamentul 30.

--IN
select last_name, salary
from employees 
where salary in (select department_id
                 from employees
                 where salary = (select max(salary)
                                 from employees
                                 where department_id = 30
                                 )
                       and department_id != 30
                );

--EXISTS
select last_name, salary
from employees e
where exists (select 1
                    from employees
                    where e.department_id = department_id
                    AND
                    salary = (select max(salary)
                                    from employees
                                    where department_id = 30
                                    )
                        and department_id != 30
                    );

4. Sa se obtina numele primilor 3 angajati avand salariul maxim. Rezultatul se va afi?a în ordine
cresc?toare a salariilor. 

--sol 1: subcerere sincronizata
--numaram cate salarii sunt > decat salariul de pe linia la care suntem

select last_name, salary, rownum
from employees e 
where 3 > (SELECT count(salary)
            FROM employees
            WHERE e.salary < salary and rownum < 4
          );

--sol 2: vezi analiza top-n(mai jos)
--primii 3 angajati cu salariu maxim inseamna primii 3 ang care au primele 3 cele mai mari salarii din firma

select last_name, salary, rownum
from (select last_name, salary
      from employees
      order by salary desc)
where rownum <= 3
order by salary desc;


6. S? se determine loca?iile în care se afl? cel pu?in un departament

--IN

select location_id
from locations
where location_id in(SELECT location_id
                     FROM departments
                    );

--EXISTS

select location_id
from locations l
where exists(select 1
            from departments
            where l.location_id = location_id);


7. S? se determine departamentele în care nu exist? nici un angajat.

--NOT EXISTS

SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (SELECT 'x'
                  FROM employees
                  WHERE department_id = d.department_id);

--NOT IN

SELECT department_id, department_name
FROM departments 
WHERE department_id NOT IN (SELECT department_id
                            FROM employees
                            WHERE department_id is not null
                           );
    --sau                    
SELECT department_id, department_name
FROM departments 
WHERE department_id NOT IN (SELECT NVL(department_id,0)
                            FROM employees
                           );
--MINUS

SELECT department_id
FROM departments 

MINUS

SELECT department_id
FROM employees;


8. Utilizând clauza WITH, s? se scrie o cerere care afi?eaz? numele departamentelor ?i
valoarea total? a salariilor din cadrul acestora. Se vor considera departamentele a c?ror valoare
total? a salariilor este mai mare decât media valorilor totale ale salariilor tuturor angajatilor.

WITH val_dep AS (SELECT department_name, SUM(salary) AS total
                 FROM departments d join employees e ON (d.department_id = e.department_id)
                 GROUP BY department_name
                ),
    val_medie AS (SELECT SUM(total)/COUNT(*) AS medie
                  FROM val_dep)
                              
SELECT *
FROM val_dep
WHERE total > (SELECT medie
FROM val_medie)
ORDER BY department_name;

Tema: Lab 5: ex 5, 9, 10, 11, 12, 14







