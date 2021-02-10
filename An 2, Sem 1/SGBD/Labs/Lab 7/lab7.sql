--I. Pachete definite de utilizator
--1
CREATE OR REPLACE PACKAGE pachet1_ttu AS
    FUNCTION f_numar(v_dept departments.department_id%TYPE)
        RETURN NUMBER;
    FUNCTION f_suma(v_dept departments.department_id%TYPE)
        RETURN NUMBER;
END pachet1_ttu;
/
CREATE OR REPLACE PACKAGE BODY pachet1_ttu AS
    FUNCTION f_numar(v_dept departments.department_id%TYPE)
        RETURN NUMBER IS numar NUMBER;
    BEGIN
        SELECT COUNT(*) INTO numar
        FROM employees
        WHERE department_id = v_dept;
    RETURN numar;
    END f_numar;
    FUNCTION f_suma (v_dept departments.department_id%TYPE)
        RETURN NUMBER IS
        suma NUMBER;
    BEGIN
        SELECT SUM(salary + salary * NVL(commission_pct, 0)) INTO suma
        FROM employees
        WHERE department_id = v_dept;
    RETURN suma;
    END f_suma;
END pachet1_ttu;
/
--apelare:
--sql
SELECT pachet1_ttu.f_numar(80)
FROM DUAL;
SELECT pachet1_ttu.f_suma(80)
FROM DUAL;

--pl/sql
BEGIN
    DBMS_OUTPUT.PUT_LINE('numarul de salariati este '|| pachet1_ttu.f_numar(80));
    DBMS_OUTPUT.PUT_LINE('suma alocata este '|| pachet1_ttu.f_suma(80));
END;
/



--2 -> nu ruleaza!!!:(
create table dept_ttu as (select * from departments);

select * from dept_ttu;

select * from emp_ttu;

create sequence sec_ttu;

commit;

CREATE OR REPLACE PACKAGE pachet2_ttu AS
    PROCEDURE p_dept (v_codd dept_ttu.department_id%TYPE,
                      v_nume dept_ttu.department_name%TYPE,
                      v_manager dept_ttu.manager_id%TYPE,
                      v_loc dept_ttu.location_id%TYPE);
    PROCEDURE p_emp (v_first_name emp_ttu.first_name%TYPE,
                     v_last_name emp_ttu.last_name%TYPE,
                     v_email emp_ttu.email%TYPE,
                     v_phone_number emp_ttu.phone_number%TYPE:=NULL,
                     v_hire_date emp_ttu.hire_date%TYPE :=SYSDATE,
                     v_job_id emp_ttu.job_id%TYPE,
                     v_salary emp_ttu.salary%TYPE :=0,
                     v_commission_pct emp_ttu.commission_pct%TYPE:=0,
                     v_manager_id emp_ttu.manager_id%TYPE,
                     v_department_id emp_ttu.department_id%TYPE);
    FUNCTION exista (cod_loc dept_ttu.location_id%TYPE,
                     manager dept_ttu.manager_id%TYPE)
    RETURN NUMBER;
END pachet2_ttu;
/
CREATE OR REPLACE PACKAGE BODY pachet2_ttu AS

    FUNCTION exista(cod_loc dept_ttu.location_id%TYPE,
                    manager dept_ttu.manager_id%TYPE)
    RETURN NUMBER IS
        rezultat NUMBER:=1;
        rez_cod_loc NUMBER;
        rez_manager NUMBER;
    BEGIN
        SELECT count(*) INTO rez_cod_loc
        FROM locations
        WHERE location_id = cod_loc;
        
        SELECT count(*) INTO rez_manager
        FROM emp_ttu
        WHERE employee_id = manager;
        IF rez_cod_loc=0 OR rez_manager=0 THEN
            rezultat:=0;
        END IF;
    RETURN rezultat;
    END;
    PROCEDURE p_dept(v_codd dept_ttu.department_id%TYPE,
                     v_nume dept_ttu.department_name%TYPE,
                     v_manager dept_ttu.manager_id%TYPE,
                     v_loc dept_ttu. location_id%TYPE) IS
    BEGIN
        IF exista(v_loc, v_manager)=0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu s-au introdus date coerente pentru tabelul dept_ttu');
        ELSE
            INSERT INTO dept_ttu (department_id,department_name,manager_id,location_id)
            VALUES (v_codd, v_nume, v_manager, v_loc);
        END IF;
END p_dept;
    PROCEDURE p_emp
        (v_first_name emp_ttu.first_name%TYPE,
         v_last_name emp_ttu.last_name%TYPE,
         v_email emp_ttu.email%TYPE,
         v_phone_number emp_ttu.phone_number%TYPE:=null,
         v_hire_date emp_ttu.hire_date%TYPE :=SYSDATE,
         v_job_id emp_ttu.job_id%TYPE,
         v_salary emp_ttu.salary %TYPE :=0,
         v_commission_pct emp_ttu.commission_pct%TYPE:=0,
         v_manager_id emp_ttu.manager_id%TYPE,
         v_department_id emp_ttu.department_id%TYPE)
AS
    BEGIN
        INSERT INTO emp_ttu
            VALUES (sec_ttu.NEXTVAL, v_first_name, v_last_name, v_email,
                    v_phone_number,v_hire_date, v_job_id, v_salary,
                    v_commission_pct, v_manager_id,v_department_id);
    END p_emp;
END pachet2_ttu;
/

--apelare
--sql

EXECUTE pachet2_ttu.p_dept(50,'Economic',200,2000);

SELECT * FROM dept_ttu WHERE department_id=50;

EXECUTE pachet2_ttu.p_emp('f','l','e',v_job_id=>'j', v_manager_id=>200,v_department_id=>50);

SELECT * FROM emp_ttu WHERE job_id='j';

ROLLBACK;

--pl/sql
BEGIN
    pachet2_ttu.p_dept(50,'Economic',99,2000);
    pachet2_ttu.p_emp('f','l','e',v_job_id=>'j',v_manager_id=>200,
                       v_department_id=>50);
END;
/

SELECT * FROM emp_ttu WHERE job_id='j';
ROLLBACK;

select * from user_dependencies where referenced_name = 'EMP_TTU';

select * from user_objects
where object_type in ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE')
      and object_name like '%TTU';

select * 
from user_dependencies ud, user_objects uo
where referenced_name = 'EMP_TTU'
      and ud.name = uo.object_name;

--3
CREATE OR REPLACE PACKAGE pachet3_ttu AS
    CURSOR c_emp(nr NUMBER) RETURN employees%ROWTYPE;
    FUNCTION f_max (v_oras locations.city%TYPE) RETURN NUMBER;
END pachet3_ttu;
/
CREATE OR REPLACE PACKAGE BODY pachet3_ttu AS
    CURSOR c_emp(nr NUMBER) RETURN employees%ROWTYPE
    IS
        SELECT *
        FROM employees
        WHERE salary >= nr;

    FUNCTION f_max (v_oras locations.city%TYPE) RETURN NUMBER IS
    maxim NUMBER;
    BEGIN
        SELECT MAX(salary) INTO maxim
        FROM employees e, departments d, locations l
        WHERE e.department_id=d.department_id
              AND d.location_id=l.location_id
              AND UPPER(city)=UPPER(v_oras);
    RETURN maxim;
    END f_max;
END pachet3_ttu;
/

DECLARE
    oras locations.city%TYPE:= 'Toronto';
    val_max NUMBER;
    lista employees%ROWTYPE;
BEGIN
    val_max:= pachet3_ttu.f_max(oras);
    FOR v_cursor IN pachet3_ttu.c_emp(val_max) LOOP
        DBMS_OUTPUT.PUT_LINE(v_cursor.last_name||' '|| v_cursor.salary);
    END LOOP;
END;
/

--4
CREATE OR REPLACE PACKAGE pachet4_ttu IS
    PROCEDURE p_verific
        (v_cod employees.employee_id%TYPE,
         v_job employees.job_id%TYPE);
    CURSOR c_emp RETURN employees%ROWTYPE;
END pachet4_ttu;
/

CREATE OR REPLACE PACKAGE BODY pachet4_ttu IS
    CURSOR c_emp RETURN employees%rowtype IS
    SELECT*
    FROM employees;
    PROCEDURE p_verific 
        (v_cod  employees.employee_id%TYPE,
         v_job  employees.job_id%TYPE) IS
        gasit  BOOLEAN := false;
        lista  employees%rowtype;
    BEGIN
        OPEN c_emp;
        LOOP
            FETCH c_emp INTO lista;
            EXIT WHEN c_emp%notfound;
            IF lista.employee_id = v_cod AND lista.job_id = v_job THEN
                gasit := true;
            END IF;
        END LOOP;
        CLOSE c_emp;
        IF gasit = true THEN
            dbms_output.put_line('combinatia data exista');
        ELSE
            dbms_output.put_line('combinatia data nu exista');
        END IF;
    END p_verific;
END pachet4_ttu;
/
EXECUTE pachet4_ttu.p_verific(200, 'AD_ASST');

--II. Pachete predefinite
--1
DECLARE
-- paramentrii de tip OUT pt procedura GET_LINE
    linie1  VARCHAR2(255);
    stare1  INTEGER;
    linie2  VARCHAR2(255);
    stare2  INTEGER;
    linie3  VARCHAR2(255);
    stare3  INTEGER;
    v_emp   employees.employee_id%TYPE;
    v_job   employees.job_id%TYPE;
    v_dept  employees.department_id%TYPE;
BEGIN
    SELECT employee_id, job_id, department_id
    INTO v_emp, v_job, v_dept
    FROM employees
    WHERE last_name = 'Lorentz';
-- se introduce o linie in buffer fara caracter
-- de terminare linie
    dbms_output.put(' 1 ' || v_emp || ' ');
-- se incearca extragerea liniei introdusa
-- in buffer si starea acesteia
    dbms_output.get_line(linie1, stare1);
-- se depunde informatie pe aceeasi linie in buffer
    dbms_output.put(' 2 ' || v_job || ' ');
-- se inchide linia depusa in buffer si se extrage
-- linia din buffer
    dbms_output.new_line;
    dbms_output.get_line(linie2, stare2);
-- se introduc informatii pe aceeasi linie
-- si se afiseaza informatia
    dbms_output.put_line(' 3 ' || v_emp || ' ' || v_job);
    dbms_output.get_line(linie3, stare3);
-- se afiseaza ceea ce s-a extras
    dbms_output.put_line('linie1 = ' || linie1 || '; stare1 = ' || stare1);
    dbms_output.put_line('linie2 = ' || linie2 || '; stare2 = ' || stare2);
    dbms_output.put_line('linie3 = ' || linie3 || '; stare3 = ' || stare3);
END;
/
--exp. 2
DECLARE
-- parametru de tip OUT pentru NEW_LINES
-- tablou de siruri de caractere
    linii     dbms_output.chararr;
-- paramentru de tip IN OUT pentru NEW_LINES
    nr_linii  INTEGER;
    v_emp     employees.employee_id%TYPE;
    v_job     employees.job_id%TYPE;
    v_dept    employees.department_id%TYPE;
BEGIN
    SELECT employee_id, job_id, department_id
    INTO v_emp, v_job, v_dept
    FROM employees
    WHERE last_name = 'Lorentz';
-- se mareste dimensiunea bufferului
    dbms_output.enable(1000000);
    dbms_output.put(' 1 ' || v_emp || ' ');
    dbms_output.put(' 2 ' || v_job || ' ');
    dbms_output.new_line;
    dbms_output.put_line(' 3 '  || v_emp || ' ' || v_job);
    dbms_output.put_line(' 4 ' || v_emp || ' ' || v_job || ' ' || v_dept);
-- se afiseaza ceea ce s-a extras
    nr_linii := 4;
    dbms_output.get_lines(linii, nr_linii);
    dbms_output.put_line('In buffer sunt ' || nr_linii || ' linii');
    FOR i IN 1..nr_linii LOOP
        dbms_output.put_line(linii(i));
    END LOOP;
-- nr_linii := 4;
-- DBMS_OUTPUT.GET_LINES(linii,nr_linii);
-- DBMS_OUTPUT.put_line('Acum in buffer sunt '|| nr_linii ||' linii');
-- FOR i IN 1..nr_linii LOOP
-- DBMS_OUTPUT.put_line(linii(i));
-- END LOOP;
--
---- DBMS_OUTPUT.disable;
---- DBMS_OUTPUT.enable;
----
---- nr_linii := 4;
---- DBMS_OUTPUT.GET_LINES(linii,nr_linii);
---- DBMS_OUTPUT.put_line('Acum in buffer sunt '|| nr_linii || ' linii' );
END;
/

--2
CREATE OR REPLACE PROCEDURE marire_salariu_ttu
    (id_angajat emp_ttu.employee_id%type, valoare number)
IS
BEGIN
    UPDATE emp_ttu
    SET salary = salary + valoare
    WHERE employee_id = id_angajat; 
END;
/

--var 1
VARIABLE nr_job NUMBER

BEGIN
    dbms_job.submit(
-- întoarce num?rul jobului, printr-o variabil? de leg?tur?
    job => :nr_job,
-- codul PL/SQL care trebuie executat
    what => 'marire_salariu_***(100, 1000);',
-- data de start a execu?iei (dupa 30 secunde)
    next_date => sysdate + 30 / 86400,
-- intervalul de timp la care se repet? execu?ia
    INTERVAL => 'SYSDATE+1');
    COMMIT;
END;
/

SELECT salary 
FROM emp_ttu 
WHERE employee_id = 100;
-- asteptati 30 de secunde
SELECT salary 
FROM emp_ttu 
WHERE employee_id = 100;

-- numarul jobului
PRINT nr_job;

-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM USER_JOBS;

-- lansarea jobului la momentul dorit
SELECT salary FROM emp_ttu WHERE employee_id = 100;
BEGIN
    -- presupunand ca jobul are codul 1 atunci:
    DBMS_JOB.RUN(job => 1);
END;
/
SELECT salary 
FROM emp_ttu 
WHERE employee_id = 100;

-- stergerea unui job
BEGIN
    DBMS_JOB.REMOVE(job=>1);
END;
/
SELECT JOB, NEXT_DATE, WHAT
FROM USER_JOBS;

UPDATE emp_ttu
SET salary = 24000
WHERE employee_id = 100;

COMMIT;

--var 2 -> in pdf lab 5 pl/sql

--3
CREATE OR REPLACE PROCEDURE scriu_fisier_ttu
    (director VARCHAR2, fisier VARCHAR2)
IS
    v_file utl_file.file_type;
    CURSOR cursor_rez IS
        SELECT department_id departament,  SUM(salary) suma
    FROM employees
    GROUP BY department_id
    ORDER BY SUM(salary);
    v_rez cursor_rez%rowtype;
BEGIN
    v_file := utl_file.fopen(director, fisier, 'w');
    utl_file.putf(v_file, 'Suma salariilor pe departamente \n Raport generat pe data ');
    utl_file.put(v_file, sysdate);
    utl_file.new_line(v_file);
    OPEN cursor_rez;
    LOOP
        FETCH cursor_rez INTO v_rez;
        EXIT WHEN cursor_rez%notfound;
        utl_file.new_line(v_file);
        utl_file.put(v_file, v_rez.departament);
        utl_file.put(v_file, ' ');
        utl_file.put(v_file, v_rez.suma);
    END LOOP;
    CLOSE cursor_rez;
    utl_file.fclose(v_file);
END;
/

SQL> EXECUTE scriu_fisier('F:\','test.txt');

--TEMA

--EX. 1

CREATE OR REPLACE PACKAGE pachet_ex1_ttu AS
    FUNCTION salariu(dept departments.department_id%TYPE)
        RETURN employees.salary%TYPE;
END pachet_ex1_ttu;
/

select employee_id
from departments;

CREATE OR REPLACE PACKAGE BODY pachet_ex1_ttu AS
    FUNCTION salariu(dept departments.department_id%TYPE)
        RETURN employees.salary%TYPE;
        IS
    BEGIN
        
END pachet_ex1_ttu;
/



