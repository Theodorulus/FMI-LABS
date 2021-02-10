--EX. 4
CREATE OR REPLACE FUNCTION nr_ang_in_dept(dept departments.department_id%TYPE)
    RETURN NUMBER
    IS
        nr_ang NUMBER;
    BEGIN
        select count(employee_id) INTO nr_ang
        from emp_ttu
        where department_id = dept
        group by department_id;
    
        return nr_ang;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line('Nu exista departamentul cu codul dat!');
            return -1;
END nr_ang_in_dept;

BEGIN
    DBMS_OUTPUT.put_line(nr_ang_in_dept(1));
END;
/

CREATE OR REPLACE TRIGGER trig_tema_ex4_ttu BEFORE
    UPDATE OR INSERT ON emp_ttu
    FOR EACH ROW
BEGIN
    IF (nr_ang_in_dept(:new.department_id) = 45) THEN
        raise_application_error(-20001, 'Departamentul are numarul maxim (45) de anagajati!');
    END IF;
END;
/

INSERT INTO emp_ttu
VALUES(207, 'William1', 'Gietz1', 'WGIETZ1', '515.123.8181', sysdate, 'AC_ACCOUNT', 8999, null, 205, 50);

--EX. 5

--a
create table emp_test_ttu as 
                (select employee_id, last_name, first_name, department_id
                 from employees);
                 
ALTER TABLE emp_test_ttu
ADD PRIMARY KEY (employee_id);

create table dept_test_ttu as 
                (select department_id, department_name
                 from departments);
                 
ALTER TABLE dept_test_ttu
ADD PRIMARY KEY (department_id);

select *
from emp_test_ttu;

select *
from dept_test_ttu;

--b

CREATE OR REPLACE PROCEDURE sterge_ang(dept departments.department_id%TYPE)
    IS
    BEGIN
    DELETE FROM emp_test_ttu
    WHERE department_id = dept;
END sterge_ang;
/

CREATE OR REPLACE PROCEDURE modifica_dept(dept_vechi departments.department_id%TYPE, dept_nou departments.department_id%TYPE)
    IS
    BEGIN
    UPDATE emp_test_ttu
    SET department_id = dept_nou
    WHERE department_id = dept_vechi;
END modifica_dept;
/

CREATE OR REPLACE TRIGGER trig_tema_ex5_ttu 
    AFTER
        DELETE OR UPDATE ON dept_test_ttu
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        sterge_ang (:OLD.department_id); 
    ELSE
        modifica_dept (:OLD.department_id, :NEW.department_id); 
    END IF;
END;
/

delete from dept_test_ttu
where department_id = 20;

select * from emp_test_ttu;

rollback;

update dept_test_ttu
set department_id = 21
where department_id = 20;

select * from emp_test_ttu;

rollback;

--EX. 6

CREATE TABLE erori( user_id VARCHAR2(30),
                    nume_bd VARCHAR2(50),
                    erori VARCHAR2(255),
                    data_eroare DATE);


CREATE OR REPLACE TRIGGER trig_tema_ex6_ttu
    AFTER DDL ON DATABASE
BEGIN
    INSERT INTO erori
    VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, DBMS_UTILITY.FORMAT_ERROR_STACK, sysdate);
END;
/