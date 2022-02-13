--EX. 1 -> am rezolvat a, b, e, f, g

CREATE SEQUENCE seq_ex1
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE PACKAGE pachet_ex1_ttu AS
    --f
    CURSOR lista_ang(id_job employees.job_id%TYPE)
    RETURN employees%ROWTYPE;
    --g
    CURSOR lista_joburi
    RETURN jobs%ROWTYPE;
    --a
    FUNCTION salariu(dept departments.department_id%TYPE)
        RETURN employees.salary%TYPE;
    FUNCTION sef (nume employees.last_name%TYPE, prenume employees.first_name%TYPE)
        RETURN employees.employee_id%TYPE;
    FUNCTION departament (nume departments.department_name%TYPE)
        RETURN departments.department_id%TYPE;
    FUNCTION jobul (nume jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE;
    PROCEDURE angajat (nume employees.last_name%TYPE, prenume employees.first_name%TYPE,
                       phone employees.phone_number%TYPE, mail employees.email%TYPE,
                       nume_job jobs.job_title%TYPE, dept departments.department_name%TYPE,
                       nume_sef employees.last_name%TYPE, prenume_sef employees.first_name%TYPE);
    --b
    PROCEDURE schimbare_dept(nume employees.last_name%TYPE, prenume employees.first_name%TYPE,
                             dept departments.department_name%TYPE,nume_job jobs.job_title%TYPE,
                             nume_sef employees.last_name%TYPE, prenume_sef employees.first_name%TYPE);
    --c
    PROCEDURE schimbare_sal(nume employees.last_name%TYPE, sal_nou employees.salary%TYPE);
END pachet_ex1_ttu;
/

CREATE OR REPLACE PACKAGE BODY pachet_ex1_ttu AS
    --f
    CURSOR lista_ang(id_job employees.job_id%TYPE)
    RETURN employees%ROWTYPE
    IS
        SELECT *
        FROM employees
        WHERE job_id = id_job;
    
    --g
    CURSOR lista_joburi
    RETURN jobs%ROWTYPE
    IS
        SELECT *
        FROM jobs;
    
    --a
    FUNCTION salariu(dept departments.department_id%TYPE)
        RETURN employees.salary%TYPE 
        IS
        sal employees.salary%TYPE;
    BEGIN
        select min(salary) into sal
        from departments d join employees e on (d.department_id = e.department_id)
        where d.department_id = dept
        group by d.department_id;
        
        return sal;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line('Nu exista departmentul dat ca parametru!');
            return -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('Alta eroare!');
            return -2;
    END salariu;
    
    FUNCTION sef (nume employees.last_name%TYPE, prenume employees.first_name%TYPE)
        RETURN employees.employee_id%TYPE
        IS
        cod_sef employees.employee_id%TYPE;
        BEGIN
            select employee_id into cod_sef
            from employees 
            where  first_name = prenume and last_name = nume;
            return cod_sef;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.put_line('Nu exista niciun angajat cu numele dat!');
                return -1;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.put_line('Exista mai multi angajati cu numele dat!');
                return -2;
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Alta eroare!');
                return -3;
    END sef;
    
    FUNCTION departament (nume departments.department_name%TYPE)
        RETURN departments.department_id%TYPE
        IS
        cod_dept departments.department_id%TYPE;
        BEGIN
            select department_id into cod_dept
            from departments
            where  department_name = nume;
            return cod_dept;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.put_line('Nu exista niciun departament cu numele dat!');
                return -1;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.put_line('Exista mai multe departamente cu numele dat!');
                return -2;
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Alta eroare!');
                return -3;
    END departament;
    
    FUNCTION jobul (nume jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE
    IS
        cod_job jobs.job_id%TYPE;
        BEGIN
            select job_id into cod_job
            from jobs
            where job_title = nume;
            return cod_job;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.put_line('Nu exista niciun job cu numele dat!');
                return -1;
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.put_line('Exista mai multe joburi cu numele dat!');
                return -2;
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Alta eroare!');
                return -3;
    END jobul;
    
    PROCEDURE angajat (nume employees.last_name%TYPE, prenume employees.first_name%TYPE,
                       phone employees.phone_number%TYPE, mail employees.email%TYPE,
                       nume_job jobs.job_title%TYPE, dept departments.department_name%TYPE,
                       nume_sef employees.last_name%TYPE, prenume_sef employees.first_name%TYPE)
    IS
    BEGIN
        INSERT INTO emp_ttu VALUES (seq_ex1.nextval, prenume, nume, mail, phone, 
            sysdate, pachet_ex1_ttu.jobul(nume_job), salariu(departament(dept)), 
            null, sef(nume_sef, prenume_sef),departament(dept));
    END angajat;
    
    --b
    PROCEDURE schimbare_dept(nume employees.last_name%TYPE, prenume employees.first_name%TYPE,
                             dept departments.department_name%TYPE, nume_job jobs.job_title%TYPE,
                             nume_sef employees.last_name%TYPE, prenume_sef employees.first_name%TYPE)
    IS
        sal_curent employees.salary%TYPE;
        data_ang employees.hire_date%TYPE;
        job_vechi employees.job_id%TYPE;
        dept_vechi employees.department_id%TYPE;
        sal_nou employees.salary%TYPE;
        comm employees.commission_pct%TYPE;
    BEGIN
        SELECT min(nvl(commission_pct, 0)) INTO comm
        FROM employees
        WHERE department_id = departament(dept)
        GROUP BY department_id;
        
        IF (comm = 0) THEN
            comm := null;
        END IF;
        
        SELECT salary, hire_date, job_id, department_id INTO sal_curent, data_ang, job_vechi, dept_vechi
        FROM employees
        WHERE employee_id = sef(nume, prenume);
        
        SELECT min(salary) INTO sal_nou
        FROM employees
        WHERE department_id = departament(dept) AND job_id = jobul(nume_job)
        GROUP BY department_id;
        
        IF(sal_nou < sal_curent) THEN
            sal_nou := sal_curent;
        END IF;
        
        UPDATE emp_ttu
        SET department_id = departament(dept), job_id = jobul(nume_job), manager_id = sef(nume_sef, prenume_sef),
                            salary = sal_nou, commission_pct = comm, hire_date = sysdate
        WHERE employee_id = sef(nume, prenume); --functia se numeste 'sef' dar se poate apela si pentru angajati oarecare
       
        INSERT INTO job_history_ttu
        VALUES(sef(nume,prenume), data_ang, sysdate, job_vechi, dept_vechi);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line('Nicio valoare!');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.put_line('Prea multe valori!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('Alta eroare!');
    END schimbare_dept;
    
    --e
    PROCEDURE schimbare_sal(nume employees.last_name%TYPE, sal_nou employees.salary%TYPE)
    IS
        id_ang employees.employee_id%TYPE;
        id_job employees.job_id%TYPE;
        min_sal jobs.min_salary%TYPE;
        max_sal jobs.max_salary%TYPE;
    BEGIN
        SELECT employee_id, job_id INTO id_ang, id_job
        FROM employees
        WHERE last_name = nume;
        
        SELECT min_salary, max_salary INTO min_sal, max_sal
        FROM jobs
        WHERE job_id = id_job;
        
        IF(sal_nou >= min_sal AND sal_nou <= max_sal) THEN
            UPDATE emp_ttu
            SET salary = sal_nou
            WHERE employee_id = id_ang;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line('Nu exista angajati cu numele dat!');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.put_line('Exista mai multi angajati cu numele dat!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('Alta eroare!');
    END schimbare_sal;
END pachet_ex1_ttu;
/

--APELARE 

--a

BEGIN
    --SALARIU
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.salariu(100));
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.salariu(700));
    DBMS_OUTPUT.new_line;
    --SEF
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.sef('King', 'Steven'));
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.sef('Mirel', 'Hampu'));
    DBMS_OUTPUT.new_line;
    --DEPARTAMENT
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.departament('Administration'));
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.departament('dep'));
    DBMS_OUTPUT.new_line;
    --JOBUL
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.jobul('President'));
    DBMS_OUTPUT.put_line(pachet_ex1_ttu.jobul('job'));
    DBMS_OUTPUT.new_line;
    --ANGAJAT
    pachet_ex1_ttu.angajat ('Geor', 'Gica', '590.423.4568', 'georgica@gmail.com',
             'Stock Clerk', 'Sales', 'King', 'Steven');
    pachet_ex1_ttu.angajat ('Doe', 'John', '590.423.4568', 'john_doe@gmail.com',
             'Stock Clerk', 'Sales', 'King', 'Steven');
END;
/

SELECT * FROM emp_ttu;

--b
CREATE TABLE job_history_ttu as(SELECT * FROM job_history);

BEGIN
    pachet_ex1_ttu.schimbare_dept('Baida', 'Shelli', 'Shipping', 'Stock Clerk', 'Weiss', 'Matthew');
END;
/

SELECT * FROM
job_history_ttu;

select *
from emp_ttu
where department_id = 50;

--e
BEGIN
    pachet_ex1_ttu.schimbare_sal('Gietz', 8999);
END;
/

select * from emp_ttu;

--f
DECLARE
    aux number :=1;
BEGIN
    FOR i IN pachet_ex1_ttu.lista_ang('SA_REP') LOOP
        DBMS_OUTPUT.PUT_LINE(aux || '. ' || i.first_name ||' '|| i.last_name);
        aux := aux + 1;
    END LOOP;
END;
/

select * 
from employees
where job_id = 'SA_REP';

--g
DECLARE
    aux number :=1;
BEGIN
    FOR i IN pachet_ex1_ttu.lista_joburi LOOP
        DBMS_OUTPUT.PUT_LINE(aux || '. ' || i.job_title);
        aux := aux + 1;
    END LOOP;
END;
/

select * from jobs;