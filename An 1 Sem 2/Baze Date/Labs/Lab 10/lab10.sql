-- lab 7

1. S? se creeze tabelele EMP_pnu, DEPT_pnu (în care ?irul de caractere “pnu”, p reprezint?
prima liter? a prenumelui, iar nu reprezint? primele dou? litere ale numelui), prin copierea
structurii ?i con?inutului tabelelor EMPLOYEES, respectiv DEPARTMENTS.


CREATE TABLE EMP_ttu AS SELECT * FROM employees;

CREATE TABLE DEPT_ttu AS SELECT * FROM departments;

SELECT * FROM employees;

SELECT * FROM departments;

SELECT * FROM emp_ttu;

SELECT * FROM dept_ttu;

2. Lista?i structura tabelelor surs? ?i a celor create anterior. Ce se observ??

desc employees;

desc emp_ttu;

-- observam faptul ca nu se copiaza constrangerile de integritate(chei primare, chei externe).

3. Lista?i con?inutul tabelelor create anterior.

SELECT * FROM employees;

SELECT * FROM departments;

SELECT * FROM emp_ttu;

SELECT * FROM dept_ttu;

--continutul se copiaza in totalitate.

4. Pentru introducerea constrângerilor de integritate, executa?i instruc?iunile LDD indicate în
continuare.

ALTER TABLE emp_ttu
ADD CONSTRAINT pk_emp_ttu PRIMARY KEY(employee_id);

ALTER TABLE dept_ttu
ADD CONSTRAINT pk_dept_ttu PRIMARY KEY(department_id);

ALTER TABLE emp_ttu
ADD CONSTRAINT fk_emp_dept_ttu
FOREIGN KEY(department_id) REFERENCES dept_ttu(department_id);

rollback; -- in acest caz rollback nu are efect pentru ca alter are commit implicit
          -- rollback se intoarce pana la ultimul commit (implicit/explicit)
          
Ce constrangeri nu am implementat?

alter table emp_ttu
add constraint fk_emp_sef_ttu foreign key(manager_id) references emp_ttu(employee_id);
          
alter table dept_ttu
add constraint fk_dept_sef_ttu foreign key(manager_id) references emp_ttu(employee_id);

rollback; --inutil

5. S? se insereze departamentul 300, cu numele Programare în DEPT_pnu.
Analiza?i cazurile, precizând care este solu?ia corect? ?i explicând erorile celorlalte variante.
Pentru a anula efectul instruc?iunii(ilor) corecte, utiliza?i comanda ROLLBACK.

--a) "not enough values"
--varianta implicita de inserare in care nu se precizeaza coloanele
INSERT INTO DEPT_ttu
VALUES (300, 'Programare');

--b) corecta
--varianta explicita de inserare
INSERT INTO DEPT_ttu (department_id, department_name)
VALUES (300, 'Programare');

rollback; -- ce se intampla daca facem rollback?
          -- dispare ce am inserat si se duce pana la alter

-- commit automat -> create, alter, drop

--c) "invalid number"
INSERT INTO DEPT_ttu (department_name, department_id)
VALUES (300, 'Programare');

--d) corect
INSERT INTO DEPT_ttu (department_id, department_name, location_id)
VALUES (301, 'Programare', null);

--e) --  cannot insert null in PRIMARY KEY
INSERT INTO DEPT_ttu (department_name, location_id)
VALUES ('Programare', null);

Executa?i varianta care a fost corect? de dou? ori. Ce se ob?ine ?i de ce?

6. S? se insereze un angajat corespunz?tor departamentului introdus anterior în tabelul EMP_pnu,
precizând valoarea NULL pentru coloanele a c?ror valoare nu este cunoscut? la inserare
(metoda implicit? de inserare). Determina?i ca efectele instruc?iunii s? devin? permanente.

insert into emp_ttu
values(257, NULL, 'nume257', 'email257', null, sysdate, 'it_prog', null, null, null, 300);

desc emp_ttu;

select *
from emp_ttu
where employee_id = 257;

7. S? se mai introduc? un angajat corespunz?tor departamentului 300, precizând dup? numele
tabelului lista coloanelor în care se introduc valori (metoda explicita de inserare). Se presupune
c? data angaj?rii acestuia este cea curent? (SYSDATE). Salva?i înregistrarea.

INSERT INTO emp_ttu (hire_date, job_id, employee_id, last_name, email, department_id)
VALUES (sysdate, 'sa_man', 278, 'nume_278', 'email_278', 300);
COMMIT ;

8. Este posibil? introducerea de înregistr?ri prin intermediul subcererilor (specificate în locul
tabelului). Ce reprezint?, de fapt, aceste subcereri? S? se analizeze urm?toarele comenzi INSERT:

INSERT INTO emp_pnu (employee_id, last_name, email, hire_date, job_id, salary,
 commission_pct)
VALUES (252, 'Nume252', 'nume252@emp.com',SYSDATE, 'SA_REP', 5000, NULL);


SELECT employee_id, last_name, email, hire_date, job_id, salary, commission_pct
FROM emp_pnu
WHERE employee_id=252;

ROLLBACK;

INSERT INTO(SELECT employee_id, last_name, email, hire_date, job_id, salary, commission_pct
            FROM emp_pnu)
VALUES (252, 'Nume252', 'nume252@emp.com',SYSDATE, 'SA_REP', 5000, NULL);


SELECT employee_id, last_name, email, hire_date, job_id, salary, commission_pct
FROM emp_pnu
WHERE employee_id=252;

ROLLBACK;

9. Crea?i un nou tabel, numit EMP1_PNU, care va avea aceea?i structur? ca ?i EMPLOYEES, dar
nici o înregistrare. Copia?i în tabelul EMP1_PNU salaria?ii (din tabelul EMPLOYEES) al c?ror
comision dep??e?te 25% din salariu.

create table emp1_ttu as select * from employees;

select * from emp1_ttu;

insert into emp1_ttu
    select * 
    from employees
    where commission_pct > 0.25;

select * from emp1_ttu;

rollback; -- sterge tot pana la create

12. Crea?i 2 tabele emp2_pnu ?i emp3_pnu cu aceea?i structur? ca tabelul EMPLOYEES, dar
f?r? înregistr?ri (accept?m omiterea constrângerilor de integritate). Prin intermediul unei singure
comenzi, copia?i din tabelul EMPLOYEES:

- în tabelul EMP1_PNU salaria?ii care au salariul mai mic decât 5000;
- în tabelul EMP2_PNU salaria?ii care au salariul cuprins între 5000 ?i 10000;
- în tabelul EMP3_PNU salaria?ii care au salariul mai mare decât 10000.
Verifica?i rezultatele, apoi ?terge?i toate înregistr?rile din aceste tabele.











