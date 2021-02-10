--1
DECLARE 
    v_nr number(4); 
    v_nume departments.department_name%TYPE; 
    CURSOR c IS 
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) 
        GROUP BY department_name; 
BEGIN 
    OPEN c; 
    LOOP 
        FETCH c INTO v_nume, v_nr; 
        EXIT WHEN c%NOTFOUND; 
        IF v_nr=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' nu lucreaza angajati'); 
        ELSIF v_nr=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza un angajat'); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza '|| v_nr||' angajati'); 
        END IF; 
    END LOOP; 
    CLOSE c; 
END;

--2 cu limit-> nu ruleaza

DECLARE 
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE; 
    TYPE tab_nr IS TABLE OF NUMBER(4); 
    t_nr tab_nr; 
    t_nume tab_nume; 
    CURSOR c IS 
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) 
        GROUP BY department_name; 
BEGIN 
    OPEN c; 
    FETCH c BULK COLLECT INTO t_nume, t_nr limit 5; 
    
    if t_nume.count = 0 then
        DBMS_OUTPUT.PUT_LINE('Nicio linie incarcata');
    else
        DBMS_OUTPUT.PUT_LINE('Primele 5 linii');
    
    FOR i IN t_nume.FIRST..t_nume.LAST LOOP 
        IF t_nr(i)=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' nu lucreaza angajati'); 
        ELSIF t_nr(i)=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume(i)|| ' lucreaza un angajat'); 
        ELSE DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' lucreaza '|| t_nr(i)||' angajati'); 
        END IF; 
    END LOOP;
    
    DBMS_OUTPUT.new_line;
    DBMS_OUTPUT.PUT_LINE('Urmatoarele linii');
    FETCH c BULK COLLECT INTO t_nume, t_nr;
    FOR i IN t_nume.FIRST..t_nume.LAST LOOP 
        IF t_nr(i)=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' nu lucreaza angajati'); 
        ELSIF t_nr(i)=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume(i)|| ' lucreaza un angajat'); 
        ELSE DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' lucreaza '|| t_nr(i)||' angajati'); 
        END IF; 
    END LOOP;
    
    CLOSE c;
END;
/

--3

DECLARE 
    CURSOR c IS 
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) 
        GROUP BY department_name; 
BEGIN 
    FOR i in c LOOP 
        IF i.nr=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' nu lucreaza angajati'); 
        ELSIF i.nr=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume || ' lucreaza un angajat'); 
        ELSE DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' lucreaza '|| i.nr||' angajati'); 
        END IF; 
    END LOOP;
END;
/

--4

BEGIN 
    FOR i in (SELECT department_name nume, COUNT(employee_id) nr 
              FROM departments d, employees e 
              WHERE d.department_id=e.department_id(+) 
              GROUP BY department_name) LOOP 
        IF i.nr=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' nu lucreaza angajati'); 
        ELSIF i.nr=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume || ' lucreaza un angajat'); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' lucreaza '|| i.nr||' angajati'); 
        END IF; 
    END LOOP; 
END; 
/

DECLARE
    contor pls_integer :=0; 
BEGIN 
    FOR i in (SELECT department_name nume, COUNT(employee_id) nr 
              FROM departments d, employees e 
              WHERE d.department_id=e.department_id(+) 
              GROUP BY department_name) LOOP 
        contor := contor + 1;
        DBMS_OUTPUT.PUT_LINE('Nr linii incarcate ' || contor);
        IF i.nr=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' nu lucreaza angajati'); 
        ELSIF i.nr=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume || ' lucreaza un angajat'); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' lucreaza '|| i.nr||' angajati'); 
        END IF; 
    END LOOP; 
END; 
/

--5

DECLARE 
    v_cod employees.employee_id%TYPE; 
    v_nume employees.last_name%TYPE; 
    v_nr NUMBER(4); 
    CURSOR c IS 
        SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
        FROM employees sef, employees ang 
        WHERE ang.manager_id = sef.employee_id 
        GROUP BY sef.employee_id 
        ORDER BY nr DESC; 
BEGIN 
    OPEN c; 
    LOOP 
        FETCH c INTO v_cod,v_nume,v_nr; 
        EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE('Managerul '|| v_cod || ' avand numele ' || v_nume || ' conduce ' || v_nr||' angajati'); 
    END LOOP; 
    CLOSE c; 
END; 
/

--top 3 in pl sql

DECLARE 
    v_cod employees.employee_id%TYPE; 
    v_nume employees.last_name%TYPE; 
    v_nr NUMBER(4); 
    CURSOR c IS 
        SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
        FROM employees sef, employees ang 
        WHERE ang.manager_id = sef.employee_id 
        GROUP BY sef.employee_id 
        ORDER BY nr DESC; 
    top binary_integer := 0;
    v_nr_anterior binary_integer;
BEGIN 
    OPEN c; 
    top := 1;
    FETCH c INTO v_cod,v_nume,v_nr; 
    DBMS_OUTPUT.PUT_LINE('Pozitia ' || top || ' Managerul '|| v_cod || ' avand numele ' || v_nume || ' conduce ' || v_nr||' angajati');  
    v_nr_anterior := v_nr;
    LOOP
        FETCH c INTO v_cod,v_nume,v_nr;
        IF v_nr <> v_nr_anterior then
            top := top + 1;
        END IF;
        v_nr_anterior := v_nr;
        EXIT WHEN top > 3 or c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Pozitia ' || top || ' Managerul '|| v_cod || ' avand numele ' || v_nume || ' conduce ' || v_nr||' angajati');  
    END LOOP;
    CLOSE c; 
END; 
/

WITH tabel as(
    SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
    FROM employees sef, employees ang 
    WHERE ang.manager_id = sef.employee_id 
    GROUP BY sef.employee_id 
    ORDER BY nr DESC; 
)
select *
from tabel t
where 3 > (select count(distinct nr)
           from tabel
           where nr > t.nr);


declare
    cursor c is 
    (
        WITH tabel as(
        SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
        FROM employees sef, employees ang 
        WHERE ang.manager_id = sef.employee_id 
        GROUP BY sef.employee_id 
        ORDER BY nr DESC; 
        )
        select *
        from tabel t
        where 3 > (select count(distinct nr)
                   from tabel
                   where nr > t.nr);
    )
begin
    for i in c loop
        DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || ' avand numele ' || i.nume || ' conduce ' || i.nr||' angajati'); 
        
    end loop;
end;
/
--6

DECLARE 
    CURSOR c IS 
        SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
        FROM employees sef, employees ang 
        WHERE ang.manager_id = sef.employee_id 
        GROUP BY sef.employee_id 
        ORDER BY nr DESC; 
BEGIN 
    FOR i IN c LOOP 
        EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || ' avand numele ' || i.nume || ' conduce '|| i.nr||' angajati'); 
    END LOOP; 
END;
/

--7

DECLARE 
    top number(1):= 0; 
BEGIN 
    FOR i IN (SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
              FROM employees sef, employees ang 
              WHERE ang.manager_id = sef.employee_id 
              GROUP BY sef.employee_id ORDER BY nr DESC) LOOP 
        DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || ' avand numele ' || i.nume || ' conduce '|| i.nr||' angajati'); 
        Top := top+1; 
        EXIT WHEN top=3; 
    END LOOP; 
END; 
/

--8

DECLARE 
    v_x number(4) := &p_x; 
    v_nr number(4); 
    v_nume departments.department_name%TYPE;
    CURSOR c (paramentru NUMBER) IS 
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id 
        GROUP BY department_name 
        HAVING COUNT(employee_id)> paramentru; 
BEGIN 
    OPEN c(v_x); 
    LOOP 
        FETCH c INTO v_nume,v_nr; 
        EXIT WHEN c%NOTFOUND;
        IF v_nr >= v_x THEN
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza '|| v_nr||' angajati'); 
        END IF;
    END LOOP; 
    CLOSE c;
END; 
/


DECLARE 
    v_x number(4) := &p_x; 
    v_nr number(4); 
    v_nume departments.department_name%TYPE;
    CURSOR c (paramentru NUMBER) IS 
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id 
        GROUP BY department_name 
        HAVING COUNT(employee_id)> paramentru; 
BEGIN 
    OPEN c(v_x); 
    LOOP 
        FETCH c INTO v_nume,v_nr; 
        EXIT WHEN c%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza '|| v_nr||' angajati'); 
    END LOOP; 
    CLOSE c; 
END; 
/


DECLARE 
    v_x number(4) := &p_x; 
    CURSOR c (paramentru NUMBER) IS
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id 
        GROUP BY department_name 
        HAVING COUNT(employee_id)> paramentru; 
BEGIN 
    FOR i in c(v_x) LOOP 
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' lucreaza '|| i.nr||' angajati'); 
    END LOOP; 
END;
/


DECLARE 
    v_x number(4) := &p_x; 
BEGIN 
    FOR i in 
    (SELECT department_name nume, COUNT(employee_id) nr 
     FROM departments d, employees e 
     WHERE d.department_id=e.department_id 
     GROUP BY department_name 
     HAVING COUNT(employee_id)> v_x) LOOP 
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' lucreaza '|| i.nr||' angajati'); 
    END LOOP; 
END;
/


--9

SELECT last_name, hire_date, salary 
FROM emp_ttu 
WHERE TO_CHAR(hire_date, 'yyyy') = 2000;

DECLARE 
    CURSOR c IS 
        SELECT * 
        FROM emp_ttu 
        WHERE TO_CHAR(hire_date, 'YYYY') = 2000 
        FOR UPDATE OF salary NOWAIT; 
BEGIN 
    FOR i IN c LOOP 
        UPDATE emp_ttu 
        SET salary = salary + 1000 
        WHERE CURRENT OF c; 
    END LOOP; 
END;
/

SELECT last_name, hire_date, salary 
FROM emp_ttu 
WHERE TO_CHAR(hire_date, 'yyyy') = 2000; 

ROLLBACK;

--10

--a

BEGIN 
    FOR v_dept IN (SELECT department_id, department_name 
                   FROM departments 
                   WHERE department_id IN (10,20,30,40)) LOOP 
        DBMS_OUTPUT.PUT_LINE('-------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_dept.department_name); 
        DBMS_OUTPUT.PUT_LINE('-------------------------------------'); 
        FOR v_emp IN (SELECT last_name 
                      FROM employees 
                      WHERE department_id = v_dept.department_id) LOOP 
                DBMS_OUTPUT.PUT_LINE (v_emp.last_name); 
        END LOOP; 
    END LOOP; 
END; 
/

--b

DECLARE
    TYPE refcursor IS REF CURSOR;
    CURSOR c_dept IS
        SELECT department_name,
            CURSOR (SELECT last_name
                    FROM employees e
                    WHERE e.department_id = d.department_id)
        FROM departments d
        WHERE department_id IN (10,20,30,40);
    v_nume_dept departments.department_name%TYPE;
    v_cursor refcursor;
    v_nume_emp employees.last_name%TYPE;
BEGIN
    OPEN c_dept;
    LOOP
        FETCH c_dept INTO v_nume_dept, v_cursor;
        EXIT WHEN c_dept%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_nume_dept);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        LOOP
            FETCH v_cursor INTO v_nume_emp;
            EXIT WHEN v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE (v_nume_emp);
        END LOOP;
    END LOOP;
    CLOSE c_dept;
END;
/

--11

DECLARE
    TYPE emp_tip IS REF CURSOR RETURN employees%ROWTYPE;
    -- sau
    -- TYPE emp_tip IS REF CURSOR;
    
    v_emp emp_tip;
    v_optiune NUMBER := &p_optiune;
    v_ang employees%ROWTYPE;
BEGIN
    IF v_optiune = 1 THEN
        OPEN v_emp FOR SELECT *
                       FROM employees;
    ELSIF v_optiune = 2 THEN
        OPEN v_emp FOR SELECT *
                       FROM employees
                       WHERE salary BETWEEN 10000 AND 20000;
    ELSIF v_optiune = 3 THEN
        OPEN v_emp FOR SELECT *
                       FROM employees
                       WHERE TO_CHAR(hire_date, 'YYYY') = 2000;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Optiune incorecta');
    END IF;
    IF v_emp%isopen then
        LOOP
            FETCH v_emp into v_ang;
            EXIT WHEN v_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_ang.last_name);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Au fost procesate '||v_emp%ROWCOUNT || ' linii');
        CLOSE v_emp;
    END IF;
END;
/

--12

DECLARE 
    TYPE empref IS REF CURSOR; 
    v_emp empref; 
    v_nr INTEGER := &n; 
    v_id number;
    v_sal number;
    v_comm number;
BEGIN 
    OPEN v_emp FOR 
        'SELECT employee_id, salary, commission_pct ' || 
        'FROM employees 
         WHERE salary > :bind_var' 
            USING v_nr; 
    -- introduceti liniile corespunzatoare rezolvarii problemei 
    LOOP
        FETCH v_emp INTO v_id, v_sal, v_comm;
        EXIT WHEN v_emp%notfound;
        if v_comm is not null then
            DBMS_OUTPUT.PUT_LINE('Id: ' || v_id || ', salariu: ' || v_sal || ', comision: ' || v_comm);
        else
            DBMS_OUTPUT.PUT_LINE('Id: ' || v_id || ', salariu: ' || v_sal);
        end if;
    END LOOP;
    close v_emp;
END;
/

--Tema
--1 (in SQL)

SELECT
CASE
    WHEN COUNT(employee_id) = 0 THEN 'În departamentul ' || department_name || ' nu lucreza angajati' 
    WHEN COUNT(employee_id) = 1 THEN 'În departamentul ' || department_name || ' lucreza un angajat'
    ELSE 'În departamentul ' || department_name || ' lucreza ' || COUNT(employee_id) || ' angajati'
END AS NumarAngajati
FROM departments d, employees e 
WHERE d.department_id=e.department_id(+) 
GROUP BY department_name;

--pentru verificare:
SELECT department_name nume, COUNT(employee_id) nr,
CASE
    WHEN COUNT(employee_id) = 0 THEN 'În departamentul ' || department_name || ' nu lucreza angajati' 
    WHEN COUNT(employee_id) = 1 THEN 'În departamentul ' || department_name || ' lucreza un angajat'
    ELSE 'În departamentul ' || department_name || ' lucreza ' || COUNT(employee_id) || ' angajati'
END AS NumarAngajati
FROM departments d, employees e 
WHERE d.department_id=e.department_id(+) 
GROUP BY department_name;

--2

--a. Rezolva?i problema folosind cursorul ?i o singur? colec?ie.
DECLARE 
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    nr_ang NUMBER(4);
    t_nume tab_nume; 
    CURSOR c IS 
        SELECT department_name nume
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) 
        GROUP BY department_name; 
BEGIN 
    OPEN c; 
    FETCH c BULK COLLECT INTO t_nume; 
    CLOSE c; 
    FOR i IN t_nume.FIRST..t_nume.LAST LOOP
    
        SELECT COUNT(employee_id) INTO nr_ang
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) and department_name = t_nume(i)
        GROUP BY department_name;
        
        IF nr_ang=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' nu lucreaza angajati'); 
        ELSIF nr_ang=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume(i)|| ' lucreaza un angajat'); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' lucreaza '|| nr_ang ||' angajati'); 
        END IF; 
    END LOOP; 
END;
/

--b. Rezolva?i problema folosind doar colec?ii.

DECLARE 
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE; 
    TYPE tab_nr IS TABLE OF NUMBER(4); 
    t_nr tab_nr; 
    t_nume tab_nume;  
BEGIN 
    SELECT department_name nume bulk collect into t_nume
    FROM departments d, employees e 
    WHERE d.department_id=e.department_id(+) 
    GROUP BY department_name;
    
    SELECT COUNT(employee_id) nr bulk collect into t_nr
    FROM departments d, employees e 
    WHERE d.department_id=e.department_id(+) 
    GROUP BY department_name;
    
    FOR i IN t_nume.FIRST..t_nume.LAST LOOP 
        IF t_nr(i)=0 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' nu lucreaza angajati'); 
        ELSIF t_nr(i)=1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume(i)|| ' lucreaza un angajat'); 
        ELSE 
            DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)|| ' lucreaza '|| t_nr(i)||' angajati'); 
        END IF; 
    END LOOP; 
END; 
/

--5 in SQL
--a
select * 
from (SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
      FROM employees sef, employees ang 
      WHERE ang.manager_id = sef.employee_id 
      GROUP BY sef.employee_id 
      ORDER BY nr DESC)
where rownum <= 3
order by nr desc;

--b
select * 
from (SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr 
      FROM employees sef, employees ang 
      WHERE ang.manager_id = sef.employee_id 
      GROUP BY sef.employee_id 
      ORDER BY nr DESC)
where rownum <= 4
order by nr desc;

--10
--1.1
DECLARE 
    TYPE tab_dep IS TABLE OF departments.department_name%TYPE;
    TYPE tab_ang IS TABLE OF employees.last_name%TYPE;
    t_ang tab_ang;
    t_dep tab_dep; 
    CURSOR c IS 
        SELECT department_name 
        FROM departments 
        WHERE department_id IN (10,20,30,40);
    CURSOR c_ang (nume_dep VARCHAR2) IS 
        SELECT last_name BULK COLLECT INTO t_ang
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) and department_name = nume_dep;
BEGIN 
    OPEN c; 
    FETCH c BULK COLLECT INTO t_dep; 
    CLOSE c;
    FOR i IN t_dep.FIRST..t_dep.LAST LOOP
        OPEN c_ang(t_dep(i)); 
        FETCH c_ang BULK COLLECT INTO t_ang; 
        CLOSE c_ang;
        
        DBMS_OUTPUT.PUT_LINE('-------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '|| t_dep(i)); 
        DBMS_OUTPUT.PUT_LINE('-------------------------------------'); 
        FOR j IN t_ang.FIRST..t_ang.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(t_ang(j));
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP; 
END;
/

--1.2
DECLARE
    TYPE tab_ang IS TABLE OF employees.last_name%TYPE;
    t_ang tab_ang;
    CURSOR c IS 
        SELECT department_name 
        FROM departments 
        WHERE department_id IN (10,20,30,40);
    CURSOR c_ang (nume_dep VARCHAR2) IS 
        SELECT last_name BULK COLLECT INTO t_ang
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) and department_name = nume_dep;
BEGIN 
    FOR i IN c LOOP
        SELECT last_name BULK COLLECT INTO t_ang
        FROM departments d, employees e 
        WHERE d.department_id=e.department_id(+) and department_name = i.department_name;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '|| i.department_name); 
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        FOR j IN c_ang(i.department_name) LOOP
            DBMS_OUTPUT.PUT_LINE(j.last_name);
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP; 
END;
/


--Exercitii
--1

--a. cursoare clasice
DECLARE
    CURSOR j IS 
        SELECT job_id, job_title 
        FROM jobs;
    CURSOR e(parametru VARCHAR2) IS
        SELECT last_name, salary 
        FROM employees 
        WHERE job_id = parametru;
    job jobs.job_id%TYPE;
    job_t jobs.job_title%TYPE;
    sal employees.salary%TYPE;
    nume employees.last_name%TYPE;
BEGIN
    OPEN j;
    LOOP
        FETCH j INTO job, job_t;
        EXIT WHEN j%notfound;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Job title ' || job_t);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        OPEN e(job);
        LOOP
            FETCH e INTO nume, sal;
            EXIT WHEN e%notfound;
            DBMS_OUTPUT.PUT_LINE('   ' || nume || ' ' || sal);
        END LOOP;
        IF e%rowcount = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   fara angajati.');
        END IF;
        CLOSE e;
    END LOOP;
    CLOSE j;
END;
/

--b. ciclu cursoare
DECLARE
    CURSOR c_job IS 
        SELECT job_id, job_title 
        FROM jobs;
    CURSOR e(parametru VARCHAR2) IS
        SELECT last_name, salary 
        FROM employees 
        WHERE job_id = parametru;
BEGIN
    FOR i IN c_job LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Job title ' || i.job_title);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        FOR j in e(i.job_id) LOOP
            DBMS_OUTPUT.PUT_LINE('   ' || j.last_name || ' ' || j.salary);
        END LOOP;
        IF c_job%rowcount = 0 THEN
                DBMS_OUTPUT.PUT_LINE('   fara angajati.');
        END IF;
    END LOOP;
END;
/

--c. ciclu cursoare cu subcereri
BEGIN
    FOR i IN (SELECT job_id, job_title 
              FROM jobs) LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Job title ' || i.job_title);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        FOR j in (SELECT last_name, salary 
                  FROM employees 
                  WHERE job_id = i.job_id) LOOP
            DBMS_OUTPUT.PUT_LINE('   ' || j.last_name || ' ' || j.salary);
        END LOOP;
        IF SQL%rowcount = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   fara angajati.');
        END IF;
    END LOOP;
END;
/

--d. expresii cursor
DECLARE
    TYPE refcursor IS REF CURSOR;
    CURSOR c_job IS 
        SELECT job_title,
               CURSOR (SELECT last_name, salary 
                       FROM employees e
                       WHERE e.job_id = jb.job_id )
        FROM jobs jb;
    v_cursor refcursor;
    job_t jobs.job_title%TYPE;
    sal employees.salary%TYPE;
    nume employees.last_name%TYPE;
BEGIN
    OPEN c_job;
    LOOP
        FETCH c_job INTO job_t, v_cursor;
        EXIT WHEN c_job%notfound;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Job title ' || job_t);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        LOOP
            FETCH v_cursor INTO nume, sal;
            EXIT WHEN v_cursor%notfound;
            DBMS_OUTPUT.PUT_LINE('   ' || nume || ' ' || sal);
        END LOOP;
        IF v_cursor%rowcount = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   fara angajati.');
        END IF;
    END LOOP;
    CLOSE c_job;
END;
/

--2

DECLARE
    nr NUMBER;
    t_nr NUMBER := 0;
    t_suma NUMBER := 0;
    t_media NUMBER(20, 2);
    j_suma NUMBER := 0;
    j_media NUMBER(20, 2);
BEGIN
    FOR j IN (SELECT job_id, job_title FROM jobs) LOOP
        nr := 0;
        j_suma := 0;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Job title ' || j.job_title);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        FOR e IN (SELECT last_name, salary FROM employees WHERE job_id = j.job_id )LOOP
            nr := nr + 1;
            DBMS_OUTPUT.PUT_LINE(nr || '. ' || e.last_name || ' ' || e.salary);
            j_suma := j_suma + e.salary;
        END LOOP;
        j_media := j_suma / nr;
        t_nr := t_nr + nr;
        t_suma := t_suma + j_suma;
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT_LINE('-------- Numar angajati: ' || nr);
        DBMS_OUTPUT.PUT_LINE('-------- Suma salarii: ' || j_suma);
        DBMS_OUTPUT.PUT_LINE('-------- Medie salarii: ' || j_media);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
    t_media := t_suma / t_nr;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('~~~~~~~~ Numar total angajati: ' || t_nr);
    DBMS_OUTPUT.PUT_LINE('~~~~~~~~ Suma totala salarii: ' || t_suma);
    DBMS_OUTPUT.PUT_LINE('~~~~~~~~ Media totala salarii: ' || t_media);
END;
/

--3
DECLARE
    nr NUMBER;
    t_nr NUMBER := 0;
    t_suma NUMBER := 0;
    t_media NUMBER(20, 2);
    j_suma NUMBER := 0;
    j_media NUMBER(20, 2);
    sal NUMBER;
    proc NUMBER(20, 5);
BEGIN
    FOR j IN (SELECT job_id, job_title FROM jobs) LOOP
        nr := 0;
        j_suma := 0;
        FOR e IN (SELECT last_name, salary, NVL(commission_pct, 0) comision FROM employees WHERE job_id = j.job_id )LOOP
            nr := nr + 1;
            j_suma := j_suma + e.salary + e.salary * e.comision;
        END LOOP;
        j_media := j_suma / nr;
        t_nr := t_nr + nr;
        t_suma := t_suma + j_suma;
    END LOOP;
    t_media := t_suma / t_nr;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Suma totala salarii + comisioane: ' || t_suma);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    FOR e IN (SELECT last_name, salary, NVL(commission_pct, 0) comision FROM employees )LOOP
        sal := e.salary + e.salary * e.comision;
        proc := sal / t_suma * 100;
        --acest if e pentru a afisa frumos cand procentul e mai mic decat 1%. Daca nu era if-ul se afisa .15 in loc de 0.15
        IF proc >= 1 THEN
            DBMS_OUTPUT.PUT_LINE('Angajatul ' || e.last_name || ' castiga ' || e.salary || ', adica  ' || proc || '% din suma totala.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Angajatul ' || e.last_name || ' castiga ' || e.salary || ', adica  0' || proc || '% din suma totala.');
        END IF;
    END LOOP;
END;
/



