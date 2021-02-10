--1
CREATE OR REPLACE TRIGGER trig1_ttu BEFORE
    INSERT OR UPDATE OR DELETE ON emp_ttu
BEGIN
    IF ( to_char(sysdate, 'D') = 1 ) OR ( to_char(sysdate, 'HH24') NOT BETWEEN 8 AND 20 ) THEN
        raise_application_error(-20001, 'tabelul nu poate fi actualizat');
    END IF;
END;
/

DROP TRIGGER trig1_ttu;

--2

--var 1

CREATE OR REPLACE TRIGGER trig21_ttu BEFORE
    UPDATE OF salary ON emp_ttu
    FOR EACH ROW
BEGIN
    IF ( :new.salary < :old.salary ) THEN
        raise_application_error(-20002, 'salariul nu poate fi micsorat');
    END IF;
END;
/

UPDATE emp_ttu
SET salary = salary - 100;

DROP TRIGGER trig21_ttu;

--var 2

CREATE OR REPLACE TRIGGER trig22_ttu 
    BEFORE 
        UPDATE OF salary ON emp_ttu 
        FOR EACH ROW 
        WHEN (NEW.salary < OLD.salary) 
BEGIN 
    RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
END;
/ 

UPDATE emp_ttu 
SET salary = salary-100; 

DROP TRIGGER trig22_ttu;

--3

create table job_grades_ttu as select * from job_grades;

commit;

select * from job_grades_ttu;

CREATE OR REPLACE TRIGGER trig3_ttu 
    BEFORE 
        UPDATE OF lowest_sal, highest_sal ON job_grades_ttu 
        FOR EACH ROW 
DECLARE 
    v_min_sal emp_ttu.salary%TYPE; 
    v_max_sal emp_ttu.salary%TYPE; 
    exceptie EXCEPTION; 
BEGIN 
    SELECT MIN(salary), MAX(salary) INTO v_min_sal,v_max_sal 
    FROM emp_ttu; 
    IF (:OLD.grade_level=1) AND (v_min_sal< :NEW.lowest_sal) THEN 
        RAISE exceptie; 
    END IF; 
    IF (:OLD.grade_level=7) AND (v_max_sal> :NEW.highest_sal) THEN 
        RAISE exceptie; 
    END IF; 
EXCEPTION 
    WHEN exceptie THEN 
        RAISE_APPLICATION_ERROR (-20003, 'Exista salarii care se gasesc in afara intervalului'); 
END;
/

UPDATE job_grades_ttu 
SET lowest_sal =3000 
WHERE grade_level=1; 

UPDATE job_grades_ttu 
SET highest_sal =20000 
WHERE grade_level=7; 

DROP TRIGGER trig3_ttu;

--4

--a

CREATE TABLE info_dept_ttu
    (
     department_id NUMBER(3) PRIMARY KEY,
     nume_dept VARCHAR2(50),
     plati NUMBER
    );

--b

INSERT INTO info_dept_ttu
select d.department_id, department_name, nvl(sum(salary), 0) plati
from employees e join departments d on (e.department_id(+) = d.department_id)
group by d.department_id, d.department_name;

select * from info_dept_ttu;

--c

CREATE OR REPLACE PROCEDURE modific_plati_ttu 
    (v_codd info_dept_ttu.department_id%TYPE, 
     v_plati info_dept_ttu.plati%TYPE)
    AS 
BEGIN 
    UPDATE info_dept_ttu 
    SET plati = NVL (plati, 0) + v_plati 
    WHERE department_id = v_codd; 
END; 
/

CREATE OR REPLACE TRIGGER trig4_ttu 
    AFTER 
        DELETE OR UPDATE OR INSERT OF salary ON emp_ttu 
    FOR EACH ROW 
BEGIN 
    IF DELETING THEN -- se sterge un angajat 
        modific_plati_ttu (:OLD.department_id, -1*:OLD.salary); 
    ELSIF UPDATING THEN --se modifica salariul unui angajat 
        modific_plati_ttu (:OLD.department_id,:NEW.salary-:OLD.salary); 
    ELSE -- se introduce un nou angajat 
        modific_plati_ttu (:NEW.department_id, :NEW.salary); 
    END IF; 
END; 
/

SELECT *
FROM info_dept_ttu
WHERE department_id=90; 

INSERT INTO emp_ttu (employee_id, last_name, email, hire_date, job_id, salary, department_id ) 
    VALUES( 300, 'N1', 'n1@g.com', sysdate, 'SA_REP', 2000, 90 );

SELECT * 
FROM info_dept_ttu 
WHERE department_id=90; 

UPDATE emp_ttu 
SET salary = salary + 1000 
WHERE employee_id=300; 

SELECT * 
FROM info_dept_ttu 
WHERE department_id=90; 

DELETE FROM emp_ttu 
WHERE employee_id=300; 

SELECT * 
FROM info_dept_ttu 
WHERE department_id=90;

DROP TRIGGER trig4_ttu;

--5 -> data viitoare



--6

CREATE OR REPLACE TRIGGER trig6_ttu 
    BEFORE 
        DELETE ON emp_ttu 
BEGIN 
    IF USER = UPPER('grupa242') THEN 
        RAISE_APPLICATION_ERROR(-20900,'Nu ai voie sa stergi!'); 
    END IF; 
END; 
/ 

DELETE FROM emp_ttu 
WHERE employee_id=120;

DROP TRIGGER trig6_ttu;



















