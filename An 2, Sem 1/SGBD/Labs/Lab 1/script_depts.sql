SET FEEDBACK OFF;
SET PAGESIZE 0;
spool 'D:\Theo\Info\Laboratoare fac 2.1\SGBD\Lab 1\inserare_depts.sql';

select 'INSERT INTO departments VALUES (' || department_id || ', ' || department_name || ', ' || manager_id || ', ' || location_id  || ');'
from departments;

spool off;