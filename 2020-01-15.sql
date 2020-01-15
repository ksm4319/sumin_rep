--Admin

SID(database instance)

select * from v$database;
select * from v$thread;
select * from v$process;

select * from v$session
where username='HR';

show sga; --파라미터로 보는 것
select * from v$sgainfo; --뷰로 보는 것

show parameter db_block_buffers; --sk(i/o 단위는 block)
--고정영역:sga를 관리하는 구조체계정보 및 오라클 파라메터정보
--동적영역:라이브러리 캐쉬,데이터 딕셔너리 캐쉬

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

--잔여공간
select * from dba_free_space;

select v$datafile.name,v$tablespace.name
from v$tablespace join v$datafile using(ts#);

--테이블스페이스 online/offline
ALTER TABLESPACE info_data offline;
ALTER TABLESPACE info_data online;

--생성된 테이블스페이스 크기 변경하기
ALTER DATABASE DATAFILE 'c:/jj/info_data.dbf'
RESIZE 300M;

--테이블스페이스 생성
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


--다른 테이블 스페이스에서 현재 tablespace의 segment 참조
DROP TABLESPACE info_data
INCLUDING CONTENTS
CASCADE CONSTRAINTS;

GRANT RESOURCE, CONNECT TO zzilre2;
GRANT DBA TO zzilre2;


