--<행병합>
desc employees;
select * from employees;

create table emp_copy
as
select employee_id,first_name,last_name,email
from employees
where employee_id>=200;

select * from emp_copy;

--emp_copy 테이블에 merge
--employees(employee_id,first_name,last_name,email)
create or replace procedure sp_merge
is
begin
    merge into emp_copy using employees
        on(emp_copy.employee_id=employees.employee_id)
    when matched then
    --email만 수정
        update set emp_copy.email = employees.email || '수정'
    when not matched then
        insert values(employees.employee_id,
            employees.first_name,employees.last_name,employees.email);
    commit;
end;
/

execute sp_merge;
select * from emp_copy;

--<SQL 커서>: 건수와 상관없이
--암시적:oracle서버에서 sql문을 처리하기 위해 내부적으로 생성하고 관리(내부적)
--명시적:프로그래머가 명시적으로 선언

create or replace procedure sp_emp
is 
    v_fname varchar2(20);
begin
    select first_name
    into v_fname
    from employees
    where employee_id=100;
    dbms_output.put_line(v_fname);
    --dbms_output.put_line(sql%found);
    --dbms_output.put_line(sql%notfound);
    --dbms_output.put_line(sql%rowcount);
    
    update emp set sal=20000;--12건
    dbms_output.put_line(sql%rowcount); 
     
    delete from emp
    where job='SALESMAN';
    dbms_output.put_line(sql%rowcount); --4건
end;
/
set serveroutput on; --output이 출력되도록 보여주는
execute sp_emp;

--프로시저는 이러한 절차를 미리 컴파일(절차적 프로그램)

select * from emp;
rollback;

--<제어 구조>
--score
--90~100 A학점
--80~89 B
--70~79 C
--60~69 D
--나머지는 F

create or replace procedure sp_getGrade(v_score in number)
is
    v_grade char(1);
    v_result varchar2(20) :=null;
begin
    if v_score >=90 then
        v_grade:='A';
    elsif  v_score >=80 then
        v_grade:='B';
    elsif  v_score >=70 then
        v_grade:='C';
    elsif  v_score >=60 then
        v_grade:='D';
    else
      v_grade:='F';
    end if;
    dbms_output.put_line('당신의 학점은 '||v_grade||'입니다.');
    
    if v_result ='success' then
        dbms_output.put_line('success');
    else
        dbms_output.put_line('fail');
    end if;
    --floor:내림함수
    v_grade:=
        case floor(v_score/10) when 10 then  'A'
                                when 9 then  'A'
                                when 8 then  'B'
                                when 7 then  'C'
                                when 6 then  'D'
                                else 'F' end;
     dbms_output.put_line('case문 이용:'||v_grade);
     
      v_grade:=
        case when v_score>=90 then  'A'
            when v_score>=80 and v_score<90 then  'B'
            when v_score>=70 and v_score<80 then  'C'
            when v_score>=60 and v_score<70 then  'D'
            else 'F' end;
     dbms_output.put_line('case문2 이용:'||v_grade);
     
     --중간에 다른 문장이 끼면 안됨
     v_result:= case when v_grade in ('A','B','C') then '합격'
        when v_grade in ('D','F') then '불합격'
        else '입력오류' end;
     dbms_output.put_line('case문3 이용:'||v_result);
end;
/
execute sp_getGrade(100);

select * from locations;
select max(location_id) from locations
where country_id='CA';

select * from locations
where country_id='CA';

desc locations;
--city='seoul'
--location_id:1901,1902,1903

--반복문(기본루프)1
Declare
    v_count number(2):=0;
    v_countryid char(2) :='CA';
    v_loc_id locations.location_id%TYPE;
    v_new_city varchar2(20) := 'Seoul';
begin
    select max(location_id)
    into v_loc_id
    from locations
    where country_id=v_countryid;
    
    
    loop
        v_count := v_count +1;
        exit when v_count=4;
        insert into locations(location_id,city,country_id)
        values((v_loc_id+v_count),v_new_city,v_countryid);
        
    end loop;
end;
/
rollback;

select * from locations;



--반복문 2(while루프)
Declare
    v_count number(2):=0;
    v_countryid char(2) :='CA';
    v_loc_id locations.location_id%TYPE;
    v_new_city varchar2(20) := 'Seoul';
begin
    select max(location_id)
    into v_loc_id
    from locations
    where country_id=v_countryid;
    
    --조건에 맞는 동안 looping
    while v_count<3
    loop v_count:=v_count+1;
        insert into locations(location_id,city,country_id)
        values((v_loc_id+v_count),v_new_city,v_countryid);
    end loop;
end;
/

--반복문(for루프):반복 횟수에 대한 테스트를 단축하려면
create or replace precedure sp_looptest(
    v_countryid in char,


Declare

   --v_count에 대한 초기 선언 필요 없음
    v_countryid char(2) :='CA';
    v_loc_id locations.location_id%TYPE;
    v_new_city varchar2(20) := 'Seoul';
begin
    select max(location_id)
    into v_loc_id
    from locations
    where country_id=v_countryid;
    
    --1부터 3까지 loop돌겠다
   for v_count in 1..3 loop
    dbms_output.put_line(v_count);
        insert into locations(location_id,city,country_id)
        values((v_loc_id+v_count),v_new_city,v_countryid);
    end loop;
end;
/

select * from locations;


--procedure로 수정
execute sp_looptest('US','pusan',5);

create or replace procedure sp_looptest(
    v_countryid in locations.country_id%type,
    v_new_city in locations.city%type,
    v_cnt in number)
is
    v_loc_id number;
begin
    select max(location_id)
    into v_loc_id
    from locations
    where country_id=v_countryid;
    
    --1부터 3까지 loop돌겠다
   for v_count in 1..v_cnt loop
    dbms_output.put_line(v_count);
        insert into locations(location_id,city,country_id)
        values((v_loc_id+v_count),v_new_city,v_countryid);
    end loop;
end;
/

--------------------------------------------
--1)loop-end loop
--2)while loop-end loop
--3)for loop ~end loop

--1부터 10까지 출력

create or replace procedure sp_loop2(v_count in number)
is
    v_su number:=1;
begin
    --방법1
    loop
        dbms_output.put_line(v_su);
        v_su := v_su +1;
        exit when  v_su > v_count;
    end loop;
    dbms_output.put_line('------------------------');
    
    --방법2
    v_su:=1;
    while v_su <= v_count loop
        dbms_output.put_line(v_su);
        v_su:=v_su+1;
    end loop;
    dbms_output.put_line('------------------------');
    
    --방법3
    for v_su in 1..v_count loop
        --exit when v_su =4;
        continue when v_su =4;
        dbms_output.put_line(v_su);
    end loop;
    
end;
/

set serveroutput on;
execute sp_loop2(10); 


--중첩 루프 및 레이블
declare
begin
    for v_su in 1..10 loop
       continue when mod(v_su,2)=0;
            dbms_output.put_line(v_su);
    end loop;
end;
/

declare
begin
    <<outter_for>>
    for v_dan in 2..9 loop
     dbms_output.put_line(v_dan || '단');
        <<inner_for>>
        for v_gop in 1..9 loop
            --4를 곱하는 부분만 없어진다.
            --continue when v_gop=4;
            --4부터 출력이 안됨(4부터 9까지 곱하는 부분 출력x)
            --exit when v_gop=4;
            --continue outter_for when v_gop=4; --exit랑 같은 역할
            exit outter_for when v_gop=4;
            dbms_output.put_line(v_dan || '*'||v_gop||'='||v_dan*v_gop);
        end loop;
    end loop;
end;
/
--exit:조건에 맞으면 반복 끝내기
--continue:조건에 맞으면 아래문장 무시하고 반복은 계속
--label이 있다면 중첩라벨인 경우도 exit,continue 가능

--1~10까지의 합계
declare
    v_total number:=0;
begin
    for v_su in 1..10 loop
    --짝수만 합한다.
    --홀수는 더하지 말기
        continue when mod(v_su,2)=1;
        v_total:=v_total+v_su;
    end loop;
    dbms_output.put_line(v_total);
end;
/

--반복문...
--무작위수(random) :dbms_random.value(1,100)
--loop,while loop,for loop
--loop: exit when v_su=5
--while v_su<=5 loop
--for loop: for v_su in 1..5 loop
--5번

--10~20사이의 수는 무효
declare
    v_num number;
    v_count number:=0;
begin
    for v_su in 1..5 loop
        v_num := trunc(dbms_random.value(1,100));
        continue when v_num>=10 and v_num<=20;
        v_count:=v_count+1;
        exit when v_count >5;
        dbms_output.put_line(v_num);
    end loop;
end;
/

--<조합 데이터>
--레코드: 서로 다른 여러 칼럼의 집합, 하나의 행
-->서로 다른 데이터 유형의 값을 저장하려는 경우 한번에 하나씩만 저장하려면 PL/SQL레코드를 사용
--컬렉션: 배열(데이터를 단일 단위로 처리하는 데 사용)


declare
    v_emp_rec employees%rowtype; --행참조타입
    v_salary employees.salary%type; --칼럼참조타입
    --mytype은 변수가 아니고 타입이다. (number,char,varchar2)
    --c의 structure(구조체),java
    type mytype is record (
        fname employees.first_name%type,
        sal employees.salary%type,
        hdate employees.hire_date%type
    );
    v_emp_rec2 mytype;
begin
    select *
    into v_emp_rec
    from employees
    where employee_id =100;
    dbms_output.put_line(v_emp_rec.first_name);
    dbms_output.put_line(v_emp_rec.salary);
    dbms_output.put_line(v_emp_rec.hire_date);
    
    select first_name,salary,hire_date
    into v_emp_rec2
    from employees
    where employee_id =100;
    dbms_output.put_line(v_emp_rec2.fname);
    dbms_output.put_line(v_emp_rec2.sal);
    dbms_output.put_line(v_emp_rec2.hdate);
end;
/

declare
    --2.row의 칼럼 전체를 가져오기(record)
    v_dept_rec departments%rowtype;
    
    --1.각각의 칼럼을 나열
    v_deptid departments.department_id%type;
    v_deptname departments.department_name%type;
    
    --3.사용자가 type정의..여러칼럼의 묶음(record)
    type deptrec is record(
        v_deptid departments.department_id%type,
        v_deptname departments.department_name%type
    );
    
    v_dept_rec2 deptrec;
begin
    select * 
    into v_dept_rec
    from departments
    where department_id =90;
    dbms_output.put_line(v_dept_rec.department_id);
    dbms_output.put_line(v_dept_rec.department_name);
    dbms_output.put_line(v_dept_rec.manager_id);
    dbms_output.put_line(v_dept_rec.location_id);
    
    select department_id,department_name
    into v_dept_rec2
    from departments
    where department_id =90;
    dbms_output.put_line(v_dept_rec2.v_deptid);
    dbms_output.put_line(v_dept_rec2.v_deptname);   
end;
/


declare
    type t_rec is record(
        v_sal number(8),
        v_minsal number(8) default 10000,
        v_hiredate employees.hire_date%type,
        v_emprec employees%rowtype);
        v_emp t_rec;
begin
    v_emp.v_sal := v_emp.v_minsal + 500;
    v_emp.v_hiredate := sysdate;
    dbms_output.put_line(v_emp.v_sal);
    dbms_output.put_line(v_emp.v_hiredate);
    
    select *
    into v_emp.v_emprec
    from employees
    where employee_id=110;
    dbms_output.put_line(v_emp.v_emprec.first_name);
end;
/

--rowtype 속성 사용시 이점: 기본 데이터베이스 열의 개수와 데이터 유형을 알 필요가 없다
--실제로 런타임에 변경될 수 있다.

desc retired_emps;

select * from retired_emps;
delete from retired_emps;
commit;

--124번 직원 퇴사

select * from employees where employee_id=124;
desc employees; --11개
desc retired_emps; --9개

----------------------------------------

create or replace procedure sp_retired(v_empid in number)
is
    v_emp_rec employees%rowtype;
    type mytype_emp is record(
        v_employee_id employees.employee_id%type,
        v_name varchar(45),
        v_job_id employees.job_id%type,
        v_manager_id employees.manager_id%type,
        v_hire_date employees.hire_date%type,
        v_leavedate employees.hire_date%type,
        v_salary employees.salary%type,
        v_commission_pct employees.commission_pct%type,
        v_department_id employees.department_id%type
    );
    
    v_emp_rec2 mytype_emp;
   
begin
    select *
    into v_emp_rec 
    from employees
    where employee_id=v_empid;
    
    insert into retired_emps values(
    v_emp_rec.employee_id,
    v_emp_rec.first_name ||v_emp_rec.last_name,
    v_emp_rec.job_id,
    v_emp_rec.manager_id,
    v_emp_rec.hire_date,sysdate,
    v_emp_rec.salary,v_emp_rec.commission_pct,
    v_emp_rec.department_id
    );
    
    select * 
    into v_emp_rec2
    from retired_emps
    where empno=v_empid;
    v_emp_rec2.v_name :='김수민';
    insert into retired_emps values v_emp_rec2;
    commit;
end;
/

execute sp_retired(124);
select * from retired_emps;

-------------------------------------

