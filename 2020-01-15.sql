--Admin

SID(database instance)

select * from v$database;
select * from v$thread;
select * from v$process;

select * from v$session
where username='HR';

show sga; --�Ķ���ͷ� ���� ��
select * from v$sgainfo; --��� ���� ��

show parameter db_block_buffers; --sk(i/o ������ block)
--��������:sga�� �����ϴ� ����ü������ �� ����Ŭ �Ķ��������
--��������:���̺귯�� ĳ��,������ ��ųʸ� ĳ��

select * from dba_tables
where owner='HR'
and table_name='EMPLOYEES';

select * from employees
where department_id =60;

alter system flush shared_pool;

select * from v$sql where sql_text like '%employees%';

select * from v$bgprocess;

select * from dba_tablespaces;
select * from v$tablespace;
select * from v$datafile;

--�ܿ�����
select * from dba_free_space;

select v$datafile.name,v$tablespace.name
from v$tablespace join v$datafile using(ts#);

--���̺����̽� online/offline
ALTER TABLESPACE info_data offline;
ALTER TABLESPACE info_data online;

--������ ���̺����̽� ũ�� �����ϱ�
ALTER DATABASE DATAFILE 'c:/jj/info_data.dbf'
RESIZE 300M;

--���̺����̽� ����
create tablespace info_data
datafile 'c:/jj/multi_test.dbf'
size 200m
default storage(
           initial               80k
           next                80k
           minextents        1
           maxextents        121
           pctincrease        80
           )online;
           
           
create user zzilre2 identified by 1234
default tablespace info_data;
select * from dba_users;


--�ٸ� ���̺� �����̽����� ���� tablespace�� segment ����
DROP TABLESPACE info_data
INCLUDING CONTENTS
CASCADE CONSTRAINTS;

GRANT RESOURCE, CONNECT TO zzilre2;
GRANT DBA TO zzilre2;


