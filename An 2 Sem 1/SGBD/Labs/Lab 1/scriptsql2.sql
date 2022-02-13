SET FEEDBACK OFF;
SET PAGESIZE 0;
spool 'D:\Theo\Info\Laboratoare fac 2.1\SGBD\Lab 1\sterg_tabele.sql';

select 'drop table' || table_name || ';'
from user_tables
where table_name like upper('emp_%');

spool off;