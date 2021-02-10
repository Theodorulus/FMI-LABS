--1

DECLARE
    v_nume employees.last_name%TYPE := Initcap('&p_nume');
    FUNCTION f1 RETURN NUMBER IS
        salariu employees.salary%type;
    BEGIN
        SELECT salary INTO salariu
        FROM employees
        WHERE last_name = v_nume;
        RETURN salariu;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
            return -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '|| 'cu numele dat');
            return -2;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare!');
            return -3;
    END f1;
BEGIN 
    if f1 > 0 then 
        DBMS_OUTPUT.PUT_LINE('Salariul este '|| f1); 
    end if;
EXCEPTION 
 WHEN OTHERS THEN 
  DBMS_OUTPUT.PUT_LINE('Eroarea are codul = '||SQLCODE || ' si mesajul = ' || SQLERRM); 
END; 
/

--2

CREATE OR REPLACE FUNCTION f2_ttu
    (v_nume employees.last_name%TYPE DEFAULT 'Bell') 
RETURN NUMBER IS 
    salariu employees.salary%type; 
    BEGIN 
        SELECT salary INTO salariu 
        FROM employees 
        WHERE last_name = v_nume; 
        RETURN salariu; 
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat'); 
        WHEN TOO_MANY_ROWS THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat'); 
        WHEN OTHERS THEN 
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_ttu;
/

-- metode de apelare 
-- metoda 1. bloc plsql 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_ttu); -- functioneaza si fara paramentru pentru ca exista valoare default('Bell')
END; 
/ 

BEGIN 
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_ttu('King')); 
END;
/

-- metoda 2. SQL 

SELECT f2_ttu 
FROM DUAL; 

SELECT f2_ttu('King')
FROM DUAL;

-- metoda 3. SQL*PLUS CU VARIABILA HOST 

VARIABLE nr NUMBER 
EXECUTE :nr := f2_ttu('Bell'); 
PRINT nr

--3

-- varianta 1 
DECLARE 
    v_nume employees.last_name%TYPE := Initcap('&p_nume');
    PROCEDURE p3 
    IS 
        salariu employees.salary%TYPE; 
    BEGIN 
        SELECT salary INTO salariu 
        FROM employees 
        WHERE last_name = v_nume; 
        DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat'); 
        WHEN TOO_MANY_ROWS THEN 
            DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '|| 'cu numele dat'); 
        WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Alta eroare!'); 
    END p3; 
    
BEGIN 
    p3; 
END;
/

-- varianta 2 
DECLARE 
    v_nume employees.last_name%TYPE := Initcap('&p_nume'); 
    v_salariu employees.salary%type; 
    PROCEDURE p3(salariu OUT employees.salary%type) 
    IS 
    BEGIN 
        SELECT salary INTO salariu 
        FROM employees 
        WHERE last_name = v_nume;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat'); 
        WHEN TOO_MANY_ROWS THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
        WHEN OTHERS THEN 
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!'); 
        END p3; 
BEGIN
    p3(v_salariu); 
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/

--4

-- varianta 1 
CREATE OR REPLACE PROCEDURE p4_ttu
    (v_nume employees.last_name%TYPE) 
    IS 
        salariu employees.salary%TYPE; 
    BEGIN 
        SELECT salary INTO salariu 
        FROM employees 
        WHERE last_name = v_nume; 
        DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu); 
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat'); 
        WHEN TOO_MANY_ROWS THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat'); 
        WHEN OTHERS THEN 
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!'); 
    END p4_ttu; 
/

-- metode apelare 
-- metoda 1. Bloc PLSQL 

BEGIN p4_ttu('King'); 
END; 
/

-- metoda 2.SQL*PLUS 

EXECUTE p4_ttu('Bell'); 
EXECUTE p4_ttu('King'); 
EXECUTE p4_ttu('Kimball');

-- varianta 2 
CREATE OR REPLACE PROCEDURE 
    p4_ttu(v_nume IN employees.last_name%TYPE, salariu OUT employees.salary%type) 
    IS 
    BEGIN 
        SELECT salary INTO salariu 
        FROM employees 
        WHERE last_name = v_nume; 
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat'); 
        WHEN TOO_MANY_ROWS THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat'); 
        WHEN OTHERS THEN 
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!'); 
    END p4_ttu;
/

-- metode apelare 
-- metoda 1. Bloc PLSQL 

DECLARE 
    v_salariu employees.salary%type; 
BEGIN 
    p4_ttu('Bell',v_salariu);
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu); 
END; 
/ 

-- 2. SQL*PLUS 

VARIABLE v_sal NUMBER 
EXECUTE p4_ttu ('Bell',:v_sal) 
PRINT v_sal

--5

VARIABLE ang_man NUMBER 
BEGIN 
    :ang_man:=200;
END; 
/

CREATE OR REPLACE PROCEDURE 
    p5_ttu (nr IN OUT NUMBER) 
    IS 
    BEGIN 
        SELECT manager_id INTO nr 
        FROM employees 
        WHERE employee_id=nr; 
    END p5_ttu;
/

EXECUTE p5_ttu (:ang_man) 
PRINT ang_man

--6

DECLARE 
    nume employees.last_name%TYPE; 
PROCEDURE 
    p6 (rezultat OUT employees.last_name%TYPE, 
        comision IN employees.commission_pct%TYPE:=NULL, 
        cod IN employees.employee_id%TYPE:=NULL) 
    IS 
    BEGIN 
        IF (comision IS NOT NULL) THEN 
            SELECT last_name INTO rezultat 
            FROM employees 
            WHERE commission_pct= comision; 
            DBMS_OUTPUT.PUT_LINE('numele salariatului care are comisionul '||comision||' este '||rezultat); 
        ELSE 
            SELECT last_name INTO rezultat
            FROM employees 
            WHERE employee_id =cod; 
            DBMS_OUTPUT.PUT_LINE('numele salariatului avand codul '|| cod ||' este '||rezultat); 
        END IF; 
    END p6;

BEGIN 
    p6(nume,0.4);
    p6(nume,cod=>200);
END; 
/

--7

DECLARE 
    medie1 NUMBER(10,2); 
    medie2 NUMBER(10,2); 
    FUNCTION medie (v_dept employees.department_id%TYPE) 
        RETURN NUMBER IS 
        rezultat NUMBER(10,2); 
    BEGIN 
        SELECT AVG(salary) INTO rezultat 
        FROM employees 
        WHERE department_id = v_dept; 
        RETURN rezultat; 
    END; 
    
    FUNCTION medie (v_dept employees.department_id%TYPE, 
                    v_job employees.job_id %TYPE) 
        RETURN NUMBER IS 
        rezultat NUMBER(10,2);
    BEGIN 
        SELECT AVG(salary) INTO rezultat
        FROM employees
        WHERE department_id = v_dept AND job_id = v_job;
        RETURN rezultat; 
    END; 
    
BEGIN 
    medie1:=medie(80); 
    DBMS_OUTPUT.PUT_LINE('Media salariilor din departamentul 80' || ' este ' || medie1);
    medie2 := medie(80,'SA_MAN'); 
    DBMS_OUTPUT.PUT_LINE('Media salariilor managerilor din' || ' departamentul 80 este ' || medie2); 
END; 
/

--8

CREATE OR REPLACE FUNCTION 
    factorial_ttu(n NUMBER) 
    RETURN INTEGER IS 
    BEGIN 
        IF (n=0) THEN 
            RETURN 1; 
        ELSE 
            RETURN n*factorial_ttu(n-1); 
        END IF; 
END factorial_ttu; 
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Factorial ' || factorial_ttu(6));
END;
/

--9

CREATE OR REPLACE FUNCTION 
    medie_ttu 
RETURN NUMBER 
IS
rezultat NUMBER; 
BEGIN 
    SELECT AVG(salary) INTO rezultat 
    FROM employees; 
    RETURN rezultat; 
END; 
/ 

SELECT last_name,salary 
FROM employees 
WHERE salary >= medie_ttu;

--EXERCITII TEMA:

--1

CREATE TABLE INFO_TTU
(
id number(3) primary key,
utilizator varchar2(50),
data date,
comanda varchar2(50),
nr_linii number(3),
eroare varchar2(200)
);

CREATE SEQUENCE s_info_ttu
start with 1;

--2
--FUNCTIE

CREATE OR REPLACE FUNCTION f2_ttu2
    (v_nume employees.last_name%TYPE DEFAULT 'Bell') 
RETURN NUMBER IS 
    salariu employees.salary%type; 
    BEGIN 
        SELECT salary INTO salariu 
        FROM employees 
        WHERE last_name = v_nume;
        
        insert into info_ttu
        values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 1, null);
        RETURN salariu; 
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            --RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat'); 
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 0, 'Nu exista angajati cu numele dat');
            return -1;
        WHEN TOO_MANY_ROWS THEN 
            --RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat'); 
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 3, 'Exista mai multi angajati cu numele dat');
            return -2;
        WHEN OTHERS THEN 
            --RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 0, 'Alta eroare!');
            return -3;
END f2_ttu2;
/

--apelare

BEGIN 
    DBMS_OUTPUT.PUT_LINE(f2_ttu2); -- functioneaza si fara paramentru pentru ca exista valoare default('Bell')
    DBMS_OUTPUT.PUT_LINE(f2_ttu('King')); 
    DBMS_OUTPUT.PUT_LINE(f2_ttu('K')); 
END; 
/ 

SELECT * FROM INFO_TTU;

--PROCEDURA

CREATE OR REPLACE PROCEDURE p2_ttu2
    (v_nume employees.last_name%TYPE) 
    IS 
        salariu employees.salary%TYPE; 
    BEGIN 
        SELECT salary INTO salariu 
        FROM employees 
        WHERE last_name = v_nume; 
        
        insert into info_ttu
        values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 1, null);
        
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            --RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat'); 
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 0, 'Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN 
            --RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat'); 
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 3, 'Exista mai multi angajati cu numele dat');
        WHEN OTHERS THEN 
            --RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 0, 'Alta eroare!');
END p2_ttu2; 
/

--apelare 

BEGIN 
p2_ttu2('King');
p2_ttu2('Bell'); 
p2_ttu2('Kal'); 
END; 
/

SELECT * FROM INFO_TTU;

--3

select * from locations;

-- nr de angajati care lucreaza in prezent in orasul x
select count(*)
from locations l, employees e, departments d
where l.location_id = d.location_id
and d.department_id = e.department_id
and upper(city) = 'LONDON';

select city from locations
where city = 'London';




CREATE OR REPLACE FUNCTION ex3_ttu
    (v_oras locations.city%type)
RETURN NUMBER IS
    nr NUMBER;
    oras locations.city%type;
BEGIN
    SELECT city into oras
    FROM locations
    WHERE upper(city) = upper(v_oras);
    
    IF SQL%ROWCOUNT = 0 THEN
        insert into info_ttu
        values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 0, 'Nu exista orasul dat.');
        return -2;
    END IF;

    SELECT COUNT(*) INTO nr
    FROM locations l, employees e, departments d
    WHERE l.location_id = d.location_id
          AND d.department_id = e.department_id
          AND upper(city) = upper(v_oras);

    if nr =0 then
        insert into info_ttu
        values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 0, 'In orasul dat nu exista niciun angajat.');
        return -1;
    end if;

    select count(*) into nr
    from
    (select employee_id
     from job_history jh
     where exists  (select employee_id
                    from locations l, employees e, departments d
                    where l.location_id = d.location_id
                    and d.department_id = e.department_id
                    and jh.employee_id = e.employee_id
                    and city = v_oras)
    group by employee_id
    having count(distinct(job_id)) >=2);
    
    insert into info_ttu
    values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 1, NULL);
    
    return nr;
    EXCEPTION
        WHEN No_data_found THEN
        insert into info_ttu
        values(s_info_ttu.nextval,USER,SYSTIMESTAMP,'SELECT',0,'Nu exista orasul dat');
        return -2;
end ex3_ttu;
/

--apelare

BEGIN 
    DBMS_OUTPUT.PUT_LINE(ex3_ttu('London'));
    DBMS_OUTPUT.PUT_LINE(ex3_ttu('Venice'));
    DBMS_OUTPUT.PUT_LINE(ex3_ttu('Oradea'));
END; 
/

SELECT * FROM INFO_TTU;

--4

create table employee_ttu as (select * from employees);

select * from employee_ttu;

CREATE OR REPLACE PROCEDURE tema4_ttu
    (emp_id employees.employee_id%TYPE) 
    IS 
         TYPE tablou_ids IS TABLE OF employees.employee_id%TYPE;
         v_ids tablou_ids;
         salariu employees.salary%TYPE;
         linii_schimbate NUMBER(5);
         CURSOR c is 
                     select e.employee_id
                     from employees e join employees m on (e.manager_id = m.employee_id)
                     where m.employee_id = emp_id or m.employee_id in (select e1.employee_id 
                                                                    from employees e1 join employees m1 on (e1.manager_id = m1.employee_id)
                                                                    where m1.employee_id = emp_id or m1.employee_id in 
                                                                    (select e2.employee_id 
                                                                     from employees e2 join employees m2 on (e2.manager_id = m2.employee_id)
                                                                     where m2.employee_id = emp_id));
    BEGIN 
        linii_schimbate := 0;
        FOR i in c LOOP
            SELECT salary INTO salariu 
            FROM employee_ttu
            WHERE employee_id = i.employee_id;
            
            salariu := salariu * 1.1;
            
            UPDATE employee_ttu
            SET salary = salariu
            WHERE employee_id = i.employee_id;
            
            linii_schimbate := linii_schimbate + 1;
        END LOOP;
        
        IF linii_schimbate <> 0 THEN
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'INSERT', linii_schimbate, null);
        ELSE
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'INSERT', linii_schimbate, 'Nu exista manageri cu id-ul dat');
        END IF;
        
    EXCEPTION 
        WHEN OTHERS THEN 
            --RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
            insert into info_ttu
            values(s_info_ttu.nextval, USER, SYSTIMESTAMP, 'SELECT', 0, 'Alta eroare!');
END tema4_ttu; 
/

--apelare

BEGIN 
    tema4_ttu(100);
    tema4_ttu(0);
END; 
/

select * from info_ttu;

--5


DECLARE
    TYPE tab_dep IS TABLE OF departments.department_name%TYPE;
    TYPE tab_zi IS TABLE OF VARCHAR2(15);
    TYPE tab_nr IS TABLE OF NUMBER(3);
    t_dep tab_dep;
    t_zi tab_zi;
    t_nr tab_nr;
    CURSOR c (paramentru NUMBER) IS
        select to_char(hire_date, 'day') ziua_ang, count(employee_id) nr_ang
        from employees e, departments d 
        where d.department_id = e.department_id(+) and d.department_id = parametru
        GROUP BY to_char(hire_date, 'day')
        order by nr_ang desc;
    CURSOR c1 IS
        select department_name
        from departments;
BEGIN
    OPEN c1; 
    FETCH c1 BULK COLLECT INTO t_dep; 
    CLOSE c1;
    OPEN c(50); 
    FETCH c BULK COLLECT INTO t_zi, t_nr; 
    CLOSE c;
END; 
/

select d.department_name, to_char(hire_date, 'day') ziua_ang, count(employee_id) nr_ang
from employees e join departments d on (d.department_id = e.department_id(+))
GROUP BY to_char(hire_date, 'day'), d.department_name 
ORDER BY d.department_name;

select max(nr_ang)
from   (select to_char(hire_date, 'day') ziua_ang, count(employee_id) nr_ang
        from employees e join departments d on (d.department_id = e.department_id(+))
        where d.department_name = 'Sales'
        GROUP BY to_char(hire_date, 'day')
        order by nr_ang desc);

select *
from employees
where department_id = 10 and upper(to_char(hire_date, 'day')) = 'THURSDAY ';

SELECT to_char(hire_date, 'day'), count(employee_id)
FROM  EMPLOYEES
HAVING count(employee_id) = (SELECT max(count(employee_id))
                             FROM  EMPLOYEES
                             GROUP BY to_char(hire_date, 'day') )
GROUP BY to_char(hire_date, 'day') ;

SELECT to_char(hire_date, 'day'), count(employee_id)
FROM  EMPLOYEES
GROUP BY to_char(hire_date, 'day') ;

select department_name from departments;

select CAST(sysdate-hire_date AS int)
from employees;

select DATEDIFF ( year , hire_date , sysdate ) 
from employees;


--6















