--3. Creati un bloc anonim care sa afiseze propozitia "Invat PL/SQL" pe ecran.

--v1

VARIABLE g_mesaj VARCHAR2(50) 
BEGIN :g_mesaj := 'Invat PL/SQL'; 
END; 
/ 
PRINT g_mesaj;


--v2

BEGIN DBMS_OUTPUT.PUT_LINE('Invat PL/SQL'); 
END; 
/

--4. Defini?i un bloc anonim în care s? se afle numele departamentului cu cei mai mul?i angaja?i. 
--Comenta?i cazul în care exist? cel pu?in dou? departamente cu num?r maxim de angaja?i.

DECLARE 
v_dep departments.department_name%TYPE; 
BEGIN 
    SELECT department_name 
    INTO v_dep 
    FROM employees e, departments d 
    WHERE e.department_id=d.department_id 
    GROUP BY department_name 
    HAVING COUNT(*) <> (SELECT MAX(COUNT(*)) 
                        FROM employees 
                        GROUP BY department_id); 
    DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep); 
    EXCEPTION 
        when too_many_rows then DBMS_OUTPUT.PUT_LINE('Prea multe linii!');
        when no_data_found then DBMS_OUTPUT.PUT_LINE('Nimic');
END; 
/

--5. Rezolva?i problema anterioar? utilizând variabile de leg?tur?. Afi?a?i rezultatul atât din bloc, 
--cât ?i din exteriorul acestuia.

VARIABLE rezultat VARCHAR2(35) 
BEGIN 
    SELECT department_name 
    INTO :rezultat
    FROM employees e, departments d 
    WHERE e.department_id=d.department_id 
    GROUP BY department_name 
    HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                       FROM employees 
                       GROUP BY department_id); 
    DBMS_OUTPUT.PUT_LINE('Departamentul '|| :rezultat); 
END; 
/ 
PRINT rezultat

--6. Modifica?i exerci?iul anterior astfel încât s? ob?ine?i ?i num?rul de angaja?i din departamentul respectiv.
DECLARE
v_dep departments.department_name%TYPE;
v_nr number;
BEGIN 
    SELECT department_name, count(*)
    INTO v_dep, v_nr
    FROM employees e, departments d 
    WHERE e.department_id=d.department_id 
    GROUP BY department_name 
    HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                       FROM employees 
                       GROUP BY department_id); 
    DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep || ' are ' || v_nr || ' angajati.'); 
END; 
/ 
PRINT rezultat

--7. Determina?i salariul anual ?i bonusul pe care îl prime?te un 
--salariat al c?rui cod este dat de la tastatur?. Bonusul este 
--determinat astfel: dac? salariul anual este cel pu?in 200001, 
--atunci bonusul este 20000; dac? salariul anual este cel pu?in 100001 ?i cel mult 200000, 
--atunci bonusul este 10000, iar dac? salariul anual este cel mult 100000, 
--atunci bonusul este 5000. Afi?a?i bonusul ob?inut. 
--Comenta?i cazul în care nu exist? niciun angajat cu codul introdus.
--Obs. Se folose?te instruc?iunea IF.

SET VERIFY OFF 
DECLARE 
    v_cod employees.employee_id%TYPE:=&p_cod; 
    v_bonus NUMBER(8); 
    v_salariu_anual NUMBER(8); 
BEGIN 
    SELECT salary*12 
    INTO v_salariu_anual 
    FROM employees 
    WHERE employee_id = v_cod; 
    IF v_salariu_anual>=200001 
        THEN v_bonus:=20000; 
    ELSIF v_salariu_anual BETWEEN 100001 AND 200000 
        THEN v_bonus:=10000; 
    ELSE v_bonus:=5000; 
    END IF; 
DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus); 
END; 
/ 
SET VERIFY ON;

--8. Rezolva?i problema anterioar? folosind instruc?iunea CASE.

SET VERIFY OFF 
DECLARE 
    v_cod employees.employee_id%TYPE:=&p_cod; 
    v_bonus NUMBER(8); 
    v_salariu_anual NUMBER(8); 
BEGIN 
    SELECT salary*12 
    INTO v_salariu_anual 
    FROM employees 
    WHERE employee_id = v_cod; 
    CASE 
        WHEN v_salariu_anual>=200001 THEN v_bonus:=20000; 
        WHEN v_salariu_anual BETWEEN 100001 AND 200000 THEN v_bonus:=10000; 
        ELSE v_bonus:=5000; 
    END CASE; 
DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus); 
END; 
/ 
SET VERIFY ON;

--9. Scrie?i un bloc PL/SQL în care stoca?i prin variabile de substitu?ie un cod de angajat, un cod de departament ?i 
--procentul cu care se m?re?te salariul acestuia. S? se mute salariatul în noul departament ?i s? i se creasc? salariul în mod corespunz?tor. 
--Dac? modificarea s-a putut realiza (exist? în tabelul emp_*** un salariat având codul respectiv) s? se afi?eze mesajul “Actualizare realizata”, 
--iar în caz contrar mesajul “Nu exista un angajat cu acest cod”. Anula?i modific?rile realizate.

DEFINE p_cod_sal= 200 
DEFINE p_cod_dept = 80 
DEFINE p_procent =20 
DECLARE 
    v_cod_sal emp_ttu.employee_id%TYPE:= &p_cod_sal; 
    v_cod_dept emp_ttu.department_id%TYPE:= &p_cod_dept; 
    v_procent NUMBER(8):=&p_procent;

BEGIN 
    UPDATE emp_ttu
    SET department_id = v_cod_dept, 
        salary=salary + (salary* v_procent/100) 
    WHERE employee_id= v_cod_sal; 
    IF SQL%ROWCOUNT =0 
        THEN DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod'); 
    ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata'); 
    END IF; 
END; 
/
ROLLBACK;

select * from emp_ttu;
select * from employees;

--10. Crea?i tabelul zile_***(id, data, nume_zi). Introduce?i în tabelul zile_*** 
--informa?iile corespunz?toare tuturor zilelor care au r?mas din luna curent?.

create table zile_ttu (id number, data date, nume_zi varchar2(30));

select * from zile_ttu;

DECLARE 
    contor NUMBER(6) := 1; 
    v_data DATE; 
    maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN 
    LOOP 
        v_data := sysdate+contor; 
        INSERT INTO zile_ttu 
        VALUES (contor,v_data,to_char(v_data,'Day')); 
        contor := contor + 1; 
        EXIT WHEN contor > maxim; 
    END LOOP; 
END;
/

select * from zile_ttu;

rollback;

--11. Rezolva?i cerin?a anterioar? folosind instruc?iunea WHILE.

DECLARE 
    contor NUMBER(6) := 1; 
    v_data DATE; 
    maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN 
    WHILE contor <= maxim LOOP 
        v_data := sysdate+contor; 
        INSERT INTO zile_ttu 
        VALUES (contor,v_data,to_char(v_data,'Day'));
        contor := contor + 1; 
    END LOOP; 
END;
/

select * from zile_ttu;

rollback;

--12. Rezolva?i cerin?a anterioar? folosind instruc?iunea FOR.

DECLARE 
    v_data DATE; 
    maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN
    FOR contor IN 1..maxim LOOP 
        v_data := sysdate+contor; 
        INSERT INTO zile_ttu 
        VALUES (contor,v_data,to_char(v_data,'Day')); 
    END LOOP; 
END;
/

select * from zile_ttu;

--13. S? se declare ?i s? se ini?ializeze cu 1 variabila i de tip POZITIVE ?i cu 10 constanta max_loop de tip POZITIVE. 
--S? se implementeze un ciclu LOOP care incrementeaz? pe i pân? când acesta ajunge la o valoare > max_loop, 
--moment în care ciclul LOOP este p?r?sit ?i se sare la instruc?iunea i:=1.

--var 1

DECLARE 
    i POSITIVE:=1; 
    max_loop CONSTANT POSITIVE:=10; 
BEGIN 
    LOOP 
        i:=i+1; 
        IF i>max_loop 
            THEN DBMS_OUTPUT.PUT_LINE('in loop i=' || i); 
            GOTO urmator; 
        END IF; 
    END LOOP; 
<<urmator>> 
i:=1; 
DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i); 
END;
/

--var 2

DECLARE 
    i POSITIVE:=1; 
    max_loop CONSTANT POSITIVE:=10; 
BEGIN 
    i:=1; 
    LOOP 
        i:=i+1; 
        DBMS_OUTPUT.PUT_LINE('in loop i=' || i); 
        EXIT WHEN i>max_loop; 
    END LOOP; 
    i:=1; 
    DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i);
END;
/

--TEMA (Exercitii)

--1.
a) 2
b) text 2
c) text 3 adaugat in sub-bloc
d) 101
e) text 1 adaugat in blocul principal
f) text 2 adaugat in blocul principal

--2.
--a.

select to_char(z.ziua, 'dd/mm/yyyy') "Ziua" , count(r.book_date) "Nr imprumuturi"
from rental r right join (select trunc(sysdate, 'month') + level -1 ziua
                          from dual
                          connect by level <= extract (day from last_day(sysdate))
                          ) z 
                          on (to_char(r.book_date, 'dd/mm/yyyy') = to_char(z.ziua, 'dd/mm/yyyy'))
group by to_char(z.ziua, 'dd/mm/yyyy')
order by to_char(z.ziua, 'dd/mm/yyyy');

--b.

create table octombrie_ttu (id number, data date);

select * from octombrie_ttu;

declare
    n number := extract (day from last_day(sysdate));
    d date := trunc(sysdate, 'month');
begin
    for i in 1..n loop
        insert into octombrie_ttu 
        values (i, d);
        d := d + 1;
    end loop;
end;
/

--3

DECLARE 
    v_nume member.last_name%TYPE:=&v_nume;
    m_id member.member_id%TYPE;
    nr_filme NUMBER(8);
BEGIN
    select member_id into m_id from member where last_name = v_nume;
    EXCEPTION
        WHEN no_data_found then DBMS_OUTPUT.PUT_LINE('Nu exista un membru cu acest nume!');
        WHEN too_many_rows then DBMS_OUTPUT.PUT_LINE('Exista mai multi membri cu acest nume!');
    END;
    select count(unique(title_id)) into nr_filme
    from rental
    where m.last_name = vnume;
    DBMS_OUTPUT.PUT_LINE('Nr filme: ' || nr_filme);
END;
/

--4

DECLARE 
    v_nume member.last_name%TYPE:=&v_nume;
    m_id member.member_id%TYPE;
    nr_filme NUMBER(8);
BEGIN
    select member_id into m_id from member where last_name = v_nume;
    EXCEPTION
        WHEN no_data_found then DBMS_OUTPUT.PUT_LINE('Nu exista un membru cu acest nume!');
        WHEN too_many_rows then DBMS_OUTPUT.PUT_LINE('Exista mai multi membri cu acest nume!');
    END;
    select count(unique(title_id)) into nr_filme
    from rental
    where m.last_name = vnume;
    DBMS_OUTPUT.PUT_LINE('Nr filme: ' || nr_filme);
    
    select count(*) into nr_total_filme from title;
                
    CASE WHEN nr_filme >= 0.75 * nr_total_filme
            THEN DBMS_OUTPUT.PUT_LINE('A imprumutat peste 75% din filmele existente.');
         WHEN nr_filme >= 0.5 * nr_total_filme
            THEN DBMS_OUTPUT.PUT_LINE('A imprumutat peste 50% din filmele existente.');
         WHEN nr_filme >= 0.25 * nr_total_filme
            THEN DBMS_OUTPUT.PUT_LINE('A imprumutat peste 25% din filmele existente.');
         ELSE DBMS_OUTPUT.PUT_LINE('A imprumutat sub 25% din filmele existente.');
    END CASE;
END;
/

--5

create table member_ttu as (select * from member);

select * from member_ttu;

ALTER TABLE member_ttu
ADD Discount numeric(5,3);

DECLARE 
    m_id member.member_id%TYPE:=&m_id;
    nr_filme NUMBER(8);
    nr_total_filme NUMBER(8);
BEGIN
    select count(*) into nr_total_filme from title;
    
    select count(unique(title_id)) into nr_filme
    from rental
    where m.member_id = m_id;
    
    CASE WHEN nr_filme >= 0.75 * nr_total_filme
            THEN 
                update member_ttu
                set Discount = 0.1
                where member_id = m_id;
                DBMS_OUTPUT.PUT_LINE('Actualizare reusita.');
         WHEN nr_filme >= 0.5 * nr_total_filme
            THEN 
                update member_ttu
                set Discount = 0.05
                where member_id = m_id;
                DBMS_OUTPUT.PUT_LINE('Actualizare reusita.');
         WHEN nr_filme >= 0.25 * nr_total_filme
            THEN 
                update member_ttu
                set Discount = 0.03
                where member_id = m_id;
                DBMS_OUTPUT.PUT_LINE('Actualizare reusita.');
         ELSE DBMS_OUTPUT.PUT_LINE('Nu s-a actualizat nimic.');
    END CASE; 
END;
/
