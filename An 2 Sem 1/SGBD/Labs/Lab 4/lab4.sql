--1. Care este rezultatul urm?torului bloc PL/SQL?
DECLARE 
    x NUMBER(1) := 5; 
    y x%TYPE := NULL; 
BEGIN 
    IF x <> y THEN 
        DBMS_OUTPUT.PUT_LINE ('valoare <> null este = true'); 
    ELSE 
        DBMS_OUTPUT.PUT_LINE ('valoare <> null este != true'); 
    END IF; 
    x := NULL; 
    IF x = y
        THEN 
            DBMS_OUTPUT.PUT_LINE ('null = null este = true');
        ELSE 
            DBMS_OUTPUT.PUT_LINE ('null = null este != true'); 
    END IF; 
END; 
/


--2. Defini?i tipul înregistrare emp_record care con?ine câmpurile employee_id, salary ?i job_id. 
--Apoi, defini?i o variabil? de acest tip.

--a. Ini?ializa?i variabila definit?. Afi?a?i variabila.

DECLARE 
    TYPE emp_record IS RECORD 
        (cod employees.employee_id%TYPE, 
        salariu employees.salary%TYPE, 
        job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN 
    v_ang.cod:=700; 
    v_ang.salariu:= 9000; 
    v_ang.job:='SA_MAN'; 
    DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu); 
END;
/

--b. Ini?ializa?i variabila cu valorile corespunz?toare angajatului având codul 101. Afi?a?i variabila.

DECLARE 
    TYPE emp_record IS RECORD 
        (cod employees.employee_id%TYPE, 
        salariu employees.salary%TYPE, 
        job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN 
    SELECT employee_id, salary, job_id 
    INTO v_ang 
    FROM employees 
    WHERE employee_id = 101; 
    DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu); 
END;
/

--c. ?terge?i angajatul având codul 100 din tabelul emp_*** ?i re?ine?i în variabila definit? anterior 
--informa?ii corespunz?toare acestui angajat. Anula?i modific?rile realizate.
DECLARE 
    TYPE emp_record IS RECORD 
        (cod employees.employee_id%TYPE, 
        salariu employees.salary%TYPE, 
        job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN 
    DELETE FROM emp_ttu 
    WHERE employee_id=100 
    RETURNING employee_id, salary, job_id INTO v_ang; 
    
    if sql%rowcount = 0
        then
            raise no_data_found;
    end if;
    DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu); 
EXCEPTION
    WHEN no_data_found THEN DBMS_OUTPUT.PUT_LINE ('Nu exista angajatul!');
    WHEN too_manu_rows THEN DBMS_OUTPUT.PUT_LINE ('Se incearca stergerea mai multor angajati!');
    WHEN others THEN DBMS_OUTPUT.PUT_LINE(SQLCode);
END; 
/ 
ROLLBACK;

--returning pentru update -> nu compileaza

DECLARE 
    TYPE emp_record IS RECORD 
        (v_rowid rowid,
        cod employees.employee_id%TYPE, 
        salariu employees.salary%TYPE, 
        job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    UPDATE emp_ttu
    SET salary = salary + 1000
    WHERE employee_id = 100
    RETURNING rowid, employee_id, salary, job_id INTO v_ang;
    if sql%rowcount = 0
        then
            raise no_data_found;
    end if;
    DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu || 'si rowid-ul ' || v_ang.v_rowid); 
EXCEPTION
    WHEN no_data_found THEN DBMS_OUTPUT.PUT_LINE ('Nu exista angajatul!');
    WHEN too_manu_rows THEN DBMS_OUTPUT.PUT_LINE ('Se incearca stergerea mai multor angajati!');
    WHEN others THEN DBMS_OUTPUT.PUT_LINE(SQLCode);
END; 
/ 
ROLLBACK;

--returning pentru insert -> nu compileaza

DECLARE 
    TYPE emp_record IS RECORD 
        (cod employees.employee_id%TYPE, 
        salariu employees.salary%TYPE, 
        job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    INSERT INTO emp_ttu
    values (500, 'Steven', 'King', 'SKING2', null, '17-AUG-2018', 'AD_PRES2', 24000, null, null, 90)
    returning employee_id, salary, job_id INTO v_ang;
    
    if sql%rowcount = 0
        then
            raise no_data_found;
    end if;
    DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu || 'si rowid-ul ' || v_ang.v_rowid); 
EXCEPTION
    WHEN no_data_found THEN DBMS_OUTPUT.PUT_LINE ('Nu exista angajatul!');
    WHEN too_manu_rows THEN DBMS_OUTPUT.PUT_LINE ('Se incearca stergerea mai multor angajati!');
    WHEN others THEN DBMS_OUTPUT.PUT_LINE(SQLCode);
END; 
/ 
ROLLBACK;

--3. Declara?i dou? variabile cu aceea?i structur? ca ?i tabelul emp_***. 
--?terge?i din tabelul emp_*** angaja?ii 100 ?i 101, 
--men?inând valorile ?terse în cele dou? variabile definite. 
--Folosind cele dou? variabile, introduce?i informa?iile ?terse în tabelul emp_***.

DECLARE 
    v_ang1 employees%ROWTYPE;
    v_ang2 employees%ROWTYPE;
BEGIN 
-- sterg angajat 100 si mentin in variabila linia stearsa 
    DELETE FROM emp_ttu
    WHERE employee_id = 100 
    RETURNING employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id 
    INTO v_ang1;
    
-- inserez in tabel linia stearsa 
    INSERT INTO emp_ttu 
    VALUES v_ang1;

-- sterg angajat 101 
    DELETE FROM emp_ttu 
    WHERE employee_id = 101;

-- obtin datele din tabelul employees 
    SELECT * 
    INTO v_ang2 
    FROM employees 
    WHERE employee_id = 101;

-- inserez o linie oarecare in emp_*** 
    INSERT INTO emp_ttu 
    VALUES(1000,'FN','LN','E',null,sysdate, 'AD_VP',1000, null,100,90);

-- modific linia adaugata anterior cu valorile variabilei v_ang2 
    UPDATE emp_ttu 
    SET ROW = v_ang2 
    WHERE employee_id = 1000;
END;
/

--4. Defini?i un tablou indexat de numere. Introduce?i în acest tablou primele 10 de numere naturale

--a. Afi?a?i num?rul de elemente al tabloului ?i elementele acestuia.
--b. Seta?i la valoarea null elementele de pe pozi?iile impare. 
--   Afi?a?i num?rul de elemente al tabloului ?i elementele acestuia.
--c. ?terge?i primul element, elementele de pe pozi?iile 5, 6 ?i 7, respectiv ultimul element. 
--   Afi?a?i valoarea ?i indicele primului, respectiv ultimului element. Afi?a?i elementele tabloului ?i num?rul acestora.
--d. ?terge?i toate elementele tabloului.

DECLARE 
    TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER; 
    t tablou_indexat;
BEGIN 
-- punctul a 
    FOR i IN 1..10 LOOP 
        t(i):=i; 
    END LOOP; 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
    FOR i IN t.FIRST..t.LAST LOOP 
        DBMS_OUTPUT.PUT(t(i) || ' '); 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;
    
-- punctul b 
    FOR i IN 1..10 LOOP 
        IF i mod 2 = 1 
            THEN t(i):=null; 
        END IF; 
    END LOOP; 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
    FOR i IN t.FIRST..t.LAST LOOP 
        DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;

-- punctul c 
    t.DELETE(t.first); 
    t.DELETE(5,7); 
    t.DELETE(t.last); 
    DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first),0)); 
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last),0)); 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
    FOR i IN t.FIRST..t.LAST LOOP 
        IF t.EXISTS(i) 
            THEN DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' '); 
        END IF; 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;
-- punctul d 
    t.delete;
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

--5. Defini?i un tablou indexat de înregistr?ri având tipul celor din tabelul emp_***. 
--?terge?i primele dou? linii din tabelul emp_***. Afi?a?i elementele tabloului. 
--Folosind tabelul indexat ad?uga?i înapoi cele dou? linii ?terse.

DECLARE 
    TYPE tablou_indexat IS TABLE OF emp_ttu%ROWTYPE 
                        INDEX BY BINARY_INTEGER; 
    t tablou_indexat;
BEGIN
-- stergere din tabel si salvare in tablou
    DELETE FROM emp_ttu
    WHERE ROWNUM<= 2 
    RETURNING employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id 
    BULK COLLECT INTO t;

--afisare elemente tablou
    DBMS_OUTPUT.PUT_LINE (t(1).employee_id ||' ' || t(1).last_name);
    DBMS_OUTPUT.PUT_LINE (t(2).employee_id ||' ' || t(2).last_name);
    
--inserare cele 2 linii in tabel 
    INSERT INTO emp_ttu VALUES t(1); 
    INSERT INTO emp_ttu VALUES t(2);
END;
/

--6. Rezolva?i exerci?iul 4 folosind tablouri imbricate.

DECLARE 
    TYPE tablou_imbricat IS TABLE OF NUMBER; 
    t tablou_imbricat := tablou_imbricat(); 
BEGIN
-- punctul a 
    FOR i IN 1..10 LOOP 
        t.extend; 
        t(i):=i; 
    END LOOP; 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
    FOR i IN t.FIRST..t.LAST LOOP 
        DBMS_OUTPUT.PUT(t(i) || ' '); 
    END LOOP; DBMS_OUTPUT.NEW_LINE;
-- punctul b 
    FOR i IN 1..10 LOOP 
        IF i mod 2 = 1 
            THEN t(i):=null; 
        END IF; 
    END LOOP; 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
    FOR i IN t.FIRST..t.LAST LOOP 
        DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;
-- punctul c 
    t.DELETE(t.first); 
    t.DELETE(5,7); 
    t.DELETE(t.last); 
    DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first),0)); 
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last),0)); 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
    FOR i IN t.FIRST..t.LAST LOOP 
        IF t.EXISTS(i) 
            THEN DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' '); 
        END IF; 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;
--punctul d 
    t.delete; 
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END; 
/
--7. Declara?i un tip tablou imbricat de caractere ?i o variabil? de acest tip. 
--Ini?ializa?i variabila cu urm?toarele valori: m, i, n, i, m. 
--Afi?a?i con?inutul tabloului, de la primul la ultimul element ?i invers. 
--?terge?i elementele 2 ?i 4 ?i apoi afi?a?i con?inutul tabloului

DECLARE 
    TYPE tablou_imbricat IS TABLE OF CHAR(1); 
    t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm'); 
    i INTEGER; 
BEGIN 
    i := t.FIRST; 
    WHILE i <= t.LAST LOOP 
        DBMS_OUTPUT.PUT(t(i)); 
        i := t.NEXT(i); 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE; 
    i := t.LAST; 
    WHILE i >= t.FIRST LOOP 
        DBMS_OUTPUT.PUT(t(i)); 
        i := t.PRIOR(i);
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;
    t.delete(2); 
    t.delete(4);
    i := t.FIRST; 
    WHILE i <= t.LAST LOOP 
        DBMS_OUTPUT.PUT(t(i)); 
        i := t.NEXT(i);
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE; 
    i := t.LAST; WHILE i >= t.FIRST LOOP 
        DBMS_OUTPUT.PUT(t(i)); 
        i := t.PRIOR(i); 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE; 
END; 
/

--8. Rezolva?i exerci?iul 4 folosind vectori.

DECLARE 
    TYPE vector IS VARRAY(20) OF NUMBER; 
    t vector:= vector();
BEGIN 
-- punctul a 
    FOR i IN 1..10 LOOP 
        t.extend;
        t(i):=i; 
    END LOOP; 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
    FOR i IN t.FIRST..t.LAST LOOP 
        DBMS_OUTPUT.PUT(t(i) || ' '); 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;
-- punctul b 
    FOR i IN 1..10 LOOP 
        IF i mod 2 = 1 
            THEN t(i):=null;
        END IF;
    END LOOP; 
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); 
    FOR i IN t.FIRST..t.LAST LOOP 
        DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
    END LOOP; 
    DBMS_OUTPUT.NEW_LINE;
-- punctul c 
-- metodele DELETE(n), DELETE(m,n) nu sunt valabile pentru vectori!!! 
-- din vectori nu se pot sterge elemente individuale!!!
t.trim(2); -- se sterg ultimele 2 elem
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente. ');
DBMS_OUTPUT.NEW_LINE;
-- punctul d 
    t.delete; 
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

--9. Defini?i tipul subordonati_*** (vector, dimensiune maxim? 10, men?ine numere). 
--Crea?i tabelul manageri_*** cu urm?toarele câmpuri: cod_mgr NUMBER(10), nume VARCHAR2(20), lista subordonati_***. 
--Introduce?i 3 linii în tabel. Afi?a?i informa?iile din tabel. ?terge?i tabelul creat, apoi tipul.

CREATE OR REPLACE TYPE subordonati_ttu AS VARRAY(10) OF NUMBER(4); 
/
CREATE TABLE manageri_ttu (cod_mgr NUMBER(10), nume VARCHAR2(20), lista subordonati_ttu); 
DECLARE 
    v_sub subordonati_ttu:= subordonati_ttu(100,200,300);
    v_lista manageri_ttu.lista%TYPE; 
BEGIN 
    INSERT INTO manageri_ttu 
    VALUES (1, 'Mgr 1', v_sub); 
    INSERT INTO manageri_ttu 
    VALUES (2, 'Mgr 2', null); 
    INSERT INTO manageri_ttu 
    VALUES (3, 'Mgr 3', subordonati_ttu(400,500));
    SELECT lista INTO v_lista 
    FROM manageri_ttu 
    WHERE cod_mgr=1; 
    FOR j IN v_lista.FIRST..v_lista.LAST loop 
        DBMS_OUTPUT.PUT_LINE (v_lista(j)); 
    END LOOP; 
END; 
/ 

SELECT * FROM manageri_ttu;

select a.cod_mgr, a.nume, b.*
from manageri_prof a, table(mp.lista)(+) b

union

select a.cod_mgr, a.nume, b.*
from manageri_prof a, table(mp.lista) b;

create or replace type subordonati_imb_ttu as table of number(4);

DROP TABLE manageri_ttu;
DROP TYPE subordonati_ttu;

select a.cod_mgr, a.nume, cast(a.lista as subordonati_imb_ttu)
from manageri_ttu a;

--10. Crea?i tabelul emp_test_*** cu coloanele employee_id ?i last_name din tabelul employees. 
--Ad?uga?i în acest tabel un nou câmp numit telefon de tip tablou imbricat. 
--Acest tablou va men?ine pentru fiecare salariat toate numerele de telefon la care poate fi contactat.
--Insera?i o linie nou? în tabel. Actualiza?i o linie din tabel. Afi?a?i informa?iile din tabel. ?terge?i tabelul ?i tipul.

CREATE TABLE emp_test_ttu 
    AS 
    SELECT employee_id, last_name 
    FROM employees 
    WHERE ROWNUM <= 2; 
    
CREATE OR REPLACE TYPE tip_telefon_ttu IS TABLE OF VARCHAR(12); 
/

ALTER TABLE emp_test_ttu 
ADD (telefon tip_telefon_ttu)
NESTED TABLE telefon STORE AS tabel_telefon_ttu; 

INSERT INTO emp_test_ttu 
VALUES (500, 'XYZ',tip_telefon_ttu('074XXX', '0213XXX', '037XXX')); 

UPDATE emp_test_ttu 
SET telefon = tip_telefon_ttu('073XXX', '0214XXX') 
WHERE employee_id=100; 

SELECT a.employee_id, b.* 
FROM emp_test_ttu a, TABLE (a.telefon) b;

DROP TABLE emp_test_ttu; 
DROP TYPE tip_telefon_ttu;

--11. ?terge?i din tabelul emp_*** salaria?ii având codurile men?inute într-un vector.

DECLARE 
    TYPE tip_cod IS VARRAY(5) OF NUMBER(3); 
    coduri tip_cod := tip_cod(205,206); 
BEGIN 
    FOR i IN coduri.FIRST..coduri.LAST LOOP 
        DELETE FROM emp_ttu 
        WHERE employee_id = coduri (i); 
    END LOOP; 
END; 
/ 

SELECT employee_id 
FROM emp_ttu; 

ROLLBACK;

--LEGAT DE TEMA:
--1. VEDETI CUM FACETI ROST DE TOP 5 SOMETHING
--ROWNUM? SAU ALTE ABORDARI + UPDATE CU FORALL

select employee_id
from (select *
      from employees
      where commission_pct is null
      order by salary asc)
where rownum <= 5
order by salary asc;

DECLARE 
    TYPE tablou_id IS TABLE OF employees.employee_id%type
                         INDEX BY BINARY_INTEGER;
    TYPE tablou_salariu IS TABLE OF employees.salary%type
                         INDEX BY BINARY_INTEGER;
    t tablou_id;
    s tablou_salariu;
BEGIN
    select employee_id bulk collect into t
    from (select *
          from employees
          where commission_pct is null
          order by salary asc)
    where rownum <= 5
    order by salary asc;
    
    select salary bulk collect into s
    from (select *
          from employees
          where commission_pct is null
          order by salary asc)
    where rownum <= 5
    order by salary asc;
    
    DBMS_OUTPUT.PUT_LINE('Valoare veche salarii:');
    DBMS_OUTPUT.NEW_LINE;
    FOR i IN t.first..t.last LOOP
        DBMS_OUTPUT.PUT_LINE('Angajatul cu id-ul ' || t(i) || ' are salariul ' || s(i));
    END LOOP;
    
    FOR i IN t.FIRST..t.LAST LOOP
        UPDATE emp_ttu
        set salary = salary * 1.05 
        WHERE employee_id = t(i);
    END LOOP;
    
    select salary bulk collect into s
    from (select *
          from emp_ttu
          where commission_pct is null
          order by salary asc)
    where rownum <= 5
    order by salary asc;
    
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Valoare noua salarii:');
    DBMS_OUTPUT.NEW_LINE;
    FOR i IN t.first..t.last LOOP
        DBMS_OUTPUT.PUT_LINE('Angajatul cu id-ul ' || t(i) || ' are salariul ' || s(i));
    END LOOP;
END;
/

rollback;

--2
--b) TREBUIE INSERAT IN FUNCTIE DE ORDINE, IN FUNCTIE DE CATE SUNT(COUNT)
--c) VARIABILA DE SUBSTITUTIE
--d) GROUP BY CU SQL !!SAU!! TREBUIE VAZUT CUM SE ITEREAZA CU PL SQL
--e) TABELE INDEXATE(MAPS) SAU VECTOR

CREATE OR REPLACE TYPE tip_orase_ttu AS VARRAY(10) OF VARCHAR(30); 
/

CREATE TABLE excursie_ttu
    (cod_excursie NUMBER(4),
     denumire VARCHAR2(20),
     orase tip_orase_ttu,
     status VARCHAR2(12)
    );

drop table excursie_ttu;
--a

DECLARE
    o tip_orase_ttu := tip_orase_ttu('Bucuresti', 'Buzau', 'Pitesti');
BEGIN
    INSERT INTO excursie_ttu
    VALUES(1, 'excursie 1', o,'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(2, 'excursie 2', tip_orase_ttu('Timisioara', 'Oradea'),'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(3, 'excursie 3', tip_orase_ttu('Iasi', 'Suceava', 'Piatra-Neamt', 'Focsani', 'Buzau'),'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(4, 'excursie 4', tip_orase_ttu('Cluj-Napoca', 'Bistrita-Nasaud'),'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(5, 'excursie 5', tip_orase_ttu('Bucuresti', 'Ploiesti', 'Brasov'),'disponibila');
END;
/

select * from excursie_ttu;

--b

DECLARE
    o tip_orase_ttu := tip_orase_ttu();
    o1 tip_orase_ttu := tip_orase_ttu();
    cod excursie_ttu.cod_excursie%type := &p_cod;
    oras_aux VARCHAR(30);
    oras1 VARCHAR(30) := 'Bucuresti';
    oras2 VARCHAR(30) := 'Buzau';
    oras3 VARCHAR(30) := 'Pitesti';
    io1 number(2);
    io2 number(2);
    io3 number(2);
    ind number(2);
BEGIN
    select orase into o
    from excursie_ttu
    where cod_excursie = cod;
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    o.extend;
    ind := o.count;
    o(ind) := 'Campulung';
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    o.extend;
    ind := o.count;
    
    loop
        o(ind) := o(ind - 1);
        ind := ind - 1;
        EXIT WHEN ind = 2;
    end loop;
    
    o(2) := 'Urziceni';
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    for i in 1..o.count loop
        if o(i) = oras1 then
            io1 := i;
        end if;
        if o(i) = oras2 then
            io2 := i;
        end if;
    end loop;
    
    oras_aux := o(io1);
    o(io1) := o(io2);
    o(io2) := oras_aux;
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    --creez un vector nou in care voi pune orasele din 'o', inafara de orasul care trebuie sters
    
    for i in 1..o.count loop
        if o(i) = oras3 then
            io3 := i;
        end if;
    end loop;
    
    ind := 1;
    
    for i in 1..o.count loop
        if i <> io3 then
            o1.extend;
            o1(ind) := o (i);
            ind := ind + 1;
        end if;
    end loop;
    
    UPDATE excursie_ttu
    SET orase = o1
    WHERE cod_excursie = cod;
END;
/

select * from excursie_ttu;

rollback;

--c
DECLARE
    o tip_orase_ttu := tip_orase_ttu();
    cod excursie_ttu.cod_excursie%type := &p_cod;
BEGIN
    select orase into o
    from excursie_ttu
    where cod_excursie = cod;
    
    DBMS_OUTPUT.PUT_LINE('Excursia viziteaza ' || o.count || ' orase: ');
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
END;
/

--d
DECLARE
    TYPE tablou_excursii IS TABLE OF excursie_ttu%ROWTYPE 
                         INDEX BY BINARY_INTEGER;
    t tablou_excursii;
    o tip_orase_ttu := tip_orase_ttu();
    nr number(2);
BEGIN
    select * bulk collect into t
    from excursie_ttu;
    
    for i in t.first..t.last loop
        DBMS_OUTPUT.PUT_LINE(t(i).denumire || ' viziteaza urmatoarele orasele: ');
        o := t(i).orase;
        for i in 1..o.count loop
            DBMS_OUTPUT.PUT_LINE(o(i));
        end loop;
        DBMS_OUTPUT.NEW_LINE;
    end loop;
END;
/

--e

DECLARE
    TYPE tablou_excursii IS TABLE OF excursie_ttu%ROWTYPE 
                         INDEX BY BINARY_INTEGER;
    t tablou_excursii;
    o tip_orase_ttu := tip_orase_ttu();
    nr number(2);
    mini number(2) := 99;
BEGIN
    select * bulk collect into t
    from excursie_ttu;
    
    for i in t.first..t.last loop
        o := t(i).orase;
        if o.count<mini then
            mini := o.count;
        end if;
    end loop;
    
    for i in t.first..t.last loop
        o := t(i).orase;
        if mini=o.count then
            UPDATE excursie_ttu
            SET status = 'anulata'
            WHERE cod_excursie = t(i).cod_excursie;
        end if;
    end loop;
    
    
END;
/

select *
from excursie_ttu;

drop table excursie_ttu;
DROP TYPE tip_orase_ttu;

--3

CREATE OR REPLACE TYPE tip_orase_ttu AS TABLE OF VARCHAR2(30);
/
CREATE TABLE excursie_ttu (
    cod_excursie number(4),
    denumire varchar2(20),
    orase tip_orase_ttu,
    status varchar2(12)
    )
    nested table orase store as orase_ttu;

select * from excursie_ttu;

DECLARE
    o tip_orase_ttu := tip_orase_ttu('Bucuresti', 'Buzau', 'Pitesti');
BEGIN
    INSERT INTO excursie_ttu
    VALUES(1, 'excursie 1', o,'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(2, 'excursie 2', tip_orase_ttu('Timisioara', 'Oradea'),'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(3, 'excursie 3', tip_orase_ttu('Iasi', 'Suceava', 'Piatra-Neamt', 'Focsani', 'Buzau'),'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(4, 'excursie 4', tip_orase_ttu('Cluj-Napoca', 'Bistrita-Nasaud'),'disponibila');
    
    INSERT INTO excursie_ttu
    VALUES(5, 'excursie 5', tip_orase_ttu('Bucuresti', 'Ploiesti', 'Brasov'),'disponibila');
END;
/

select * from excursie_ttu;

--b

DECLARE
    o tip_orase_ttu;
    o1 tip_orase_ttu;
    cod excursie_ttu.cod_excursie%type := &p_cod;
    oras_aux VARCHAR(30);
    oras1 VARCHAR(30) := 'Bucuresti';
    oras2 VARCHAR(30) := 'Buzau';
    oras3 VARCHAR(30) := 'Pitesti';
    io1 number(2);
    io2 number(2);
    io3 number(2);
    ind number(2);
BEGIN
    select orase into o
    from excursie_ttu
    where cod_excursie = cod;
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    o.extend;
    ind := o.count;
    o(ind) := 'Campulung';
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    o.extend;
    ind := o.count;
    
    loop
        o(ind) := o(ind - 1);
        ind := ind - 1;
        EXIT WHEN ind = 2;
    end loop;
    
    o(2) := 'Urziceni';
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    for i in 1..o.count loop
        if o(i) = oras1 then
            io1 := i;
        end if;
        if o(i) = oras2 then
            io2 := i;
        end if;
    end loop;
    
    oras_aux := o(io1);
    o(io1) := o(io2);
    o(io2) := oras_aux;
    
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
    
    DBMS_OUTPUT.NEW_LINE;
    
    for i in 1..o.count loop
        if o(i) = oras3 then
            io3 := i;
        end if;
    end loop;
    
    o.delete(io3);
    
    UPDATE excursie_ttu
    SET orase = o
    WHERE cod_excursie = cod;
END;
/

select * from excursie_ttu;

rollback;

--c
DECLARE
    o tip_orase_ttu := tip_orase_ttu();
    cod excursie_ttu.cod_excursie%type := &p_cod;
BEGIN
    select orase into o
    from excursie_ttu
    where cod_excursie = cod;
    
    DBMS_OUTPUT.PUT_LINE('Excursia viziteaza ' || o.count || ' orase: ');
    for i in 1..o.count loop
        DBMS_OUTPUT.PUT_LINE(o(i));
    end loop;
END;
/

--d
DECLARE
    TYPE tablou_excursii IS TABLE OF excursie_ttu%ROWTYPE 
                         INDEX BY BINARY_INTEGER;
    t tablou_excursii;
    o tip_orase_ttu := tip_orase_ttu();
    nr number(2);
BEGIN
    select * bulk collect into t
    from excursie_ttu;
    
    for i in t.first..t.last loop
        DBMS_OUTPUT.PUT_LINE(t(i).denumire || ' viziteaza urmatoarele orasele: ');
        o := t(i).orase;
        for i in 1..o.count loop
            DBMS_OUTPUT.PUT_LINE(o(i));
        end loop;
        DBMS_OUTPUT.NEW_LINE;
    end loop;
END;
/

--e

DECLARE
    TYPE tablou_excursii IS TABLE OF excursie_ttu%ROWTYPE 
                         INDEX BY BINARY_INTEGER;
    t tablou_excursii;
    o tip_orase_ttu := tip_orase_ttu();
    nr number(2);
    mini number(2) := 99;
BEGIN
    select * bulk collect into t
    from excursie_ttu;
    
    for i in t.first..t.last loop
        o := t(i).orase;
        if o.count<mini then
            mini := o.count;
        end if;
    end loop;
    
    for i in t.first..t.last loop
        o := t(i).orase;
        if mini=o.count then
            UPDATE excursie_ttu
            SET status = 'anulata'
            WHERE cod_excursie = t(i).cod_excursie;
        end if;
    end loop;
END;
/

select *
from excursie_ttu;






