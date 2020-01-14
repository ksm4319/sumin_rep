--<�ິ��>
desc employees;
select * from employees;

create table emp_copy
as
select employee_id,first_name,last_name,email
from employees
where employee_id>=200;

select * from emp_copy;

--emp_copy ���̺� merge
--employees(employee_id,first_name,last_name,email)
create or replace procedure sp_merge
is
begin
    merge into emp_copy using employees
        on(emp_copy.employee_id=employees.employee_id)
    when matched then
    --email�� ����
        update set emp_copy.email = employees.email || '����'
    when not matched then
        insert values(employees.employee_id,
            employees.first_name,employees.last_name,employees.email);
    commit;
end;
/

execute sp_merge;
select * from emp_copy;

--<SQL Ŀ��>: �Ǽ��� �������
--�Ͻ���:oracle�������� sql���� ó���ϱ� ���� ���������� �����ϰ� ����(������)
--�����:���α׷��Ӱ� ��������� ����

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
    
    update emp set sal=20000;--12��
    dbms_output.put_line(sql%rowcount); 
     
    delete from emp
    where job='SALESMAN';
    dbms_output.put_line(sql%rowcount); --4��
end;
/
set serveroutput on; --output�� ��µǵ��� �����ִ�
execute sp_emp;

--���ν����� �̷��� ������ �̸� ������(������ ���α׷�)

select * from emp;
rollback;

--<���� ����>
--score
--90~100 A����
--80~89 B
--70~79 C
--60~69 D
--�������� F

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
    dbms_output.put_line('����� ������ '||v_grade||'�Դϴ�.');
    
    if v_result ='success' then
        dbms_output.put_line('success');
    else
        dbms_output.put_line('fail');
    end if;
    --floor:�����Լ�
    v_grade:=
        case floor(v_score/10) when 10 then  'A'
                                when 9 then  'A'
                                when 8 then  'B'
                                when 7 then  'C'
                                when 6 then  'D'
                                else 'F' end;
     dbms_output.put_line('case�� �̿�:'||v_grade);
     
      v_grade:=
        case when v_score>=90 then  'A'
            when v_score>=80 and v_score<90 then  'B'
            when v_score>=70 and v_score<80 then  'C'
            when v_score>=60 and v_score<70 then  'D'
            else 'F' end;
     dbms_output.put_line('case��2 �̿�:'||v_grade);
     
     --�߰��� �ٸ� ������ ���� �ȵ�
     v_result:= case when v_grade in ('A','B','C') then '�հ�'
        when v_grade in ('D','F') then '���հ�'
        else '�Է¿���' end;
     dbms_output.put_line('case��3 �̿�:'||v_result);
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

--�ݺ���(�⺻����)1
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



--�ݺ��� 2(while����)
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
    
    --���ǿ� �´� ���� looping
    while v_count<3
    loop v_count:=v_count+1;
        insert into locations(location_id,city,country_id)
        values((v_loc_id+v_count),v_new_city,v_countryid);
    end loop;
end;
/

--�ݺ���(for����):�ݺ� Ƚ���� ���� �׽�Ʈ�� �����Ϸ���
create or replace precedure sp_looptest(
    v_countryid in char,


Declare

   --v_count�� ���� �ʱ� ���� �ʿ� ����
    v_countryid char(2) :='CA';
    v_loc_id locations.location_id%TYPE;
    v_new_city varchar2(20) := 'Seoul';
begin
    select max(location_id)
    into v_loc_id
    from locations
    where country_id=v_countryid;
    
    --1���� 3���� loop���ڴ�
   for v_count in 1..3 loop
    dbms_output.put_line(v_count);
        insert into locations(location_id,city,country_id)
        values((v_loc_id+v_count),v_new_city,v_countryid);
    end loop;
end;
/

select * from locations;


--procedure�� ����
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
    
    --1���� 3���� loop���ڴ�
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

--1���� 10���� ���

create or replace procedure sp_loop2(v_count in number)
is
    v_su number:=1;
begin
    --���1
    loop
        dbms_output.put_line(v_su);
        v_su := v_su +1;
        exit when  v_su > v_count;
    end loop;
    dbms_output.put_line('------------------------');
    
    --���2
    v_su:=1;
    while v_su <= v_count loop
        dbms_output.put_line(v_su);
        v_su:=v_su+1;
    end loop;
    dbms_output.put_line('------------------------');
    
    --���3
    for v_su in 1..v_count loop
        --exit when v_su =4;
        continue when v_su =4;
        dbms_output.put_line(v_su);
    end loop;
    
end;
/

set serveroutput on;
execute sp_loop2(10); 


--��ø ���� �� ���̺�
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
     dbms_output.put_line(v_dan || '��');
        <<inner_for>>
        for v_gop in 1..9 loop
            --4�� ���ϴ� �κи� ��������.
            --continue when v_gop=4;
            --4���� ����� �ȵ�(4���� 9���� ���ϴ� �κ� ���x)
            --exit when v_gop=4;
            --continue outter_for when v_gop=4; --exit�� ���� ����
            exit outter_for when v_gop=4;
            dbms_output.put_line(v_dan || '*'||v_gop||'='||v_dan*v_gop);
        end loop;
    end loop;
end;
/
--exit:���ǿ� ������ �ݺ� ������
--continue:���ǿ� ������ �Ʒ����� �����ϰ� �ݺ��� ���
--label�� �ִٸ� ��ø���� ��쵵 exit,continue ����

--1~10������ �հ�
declare
    v_total number:=0;
begin
    for v_su in 1..10 loop
    --¦���� ���Ѵ�.
    --Ȧ���� ������ ����
        continue when mod(v_su,2)=1;
        v_total:=v_total+v_su;
    end loop;
    dbms_output.put_line(v_total);
end;
/

--�ݺ���...
--��������(random) :dbms_random.value(1,100)
--loop,while loop,for loop
--loop: exit when v_su=5
--while v_su<=5 loop
--for loop: for v_su in 1..5 loop
--5��

--10~20������ ���� ��ȿ
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

--<���� ������>
--���ڵ�: ���� �ٸ� ���� Į���� ����, �ϳ��� ��
-->���� �ٸ� ������ ������ ���� �����Ϸ��� ��� �ѹ��� �ϳ����� �����Ϸ��� PL/SQL���ڵ带 ���
--�÷���: �迭(�����͸� ���� ������ ó���ϴ� �� ���)


declare
    v_emp_rec employees%rowtype; --������Ÿ��
    v_salary employees.salary%type; --Į������Ÿ��
    --mytype�� ������ �ƴϰ� Ÿ���̴�. (number,char,varchar2)
    --c�� structure(����ü),java
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
    --2.row�� Į�� ��ü�� ��������(record)
    v_dept_rec departments%rowtype;
    
    --1.������ Į���� ����
    v_deptid departments.department_id%type;
    v_deptname departments.department_name%type;
    
    --3.����ڰ� type����..����Į���� ����(record)
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

--rowtype �Ӽ� ���� ����: �⺻ �����ͺ��̽� ���� ������ ������ ������ �� �ʿ䰡 ����
--������ ��Ÿ�ӿ� ����� �� �ִ�.

desc retired_emps;

select * from retired_emps;
delete from retired_emps;
commit;

--124�� ���� ���

select * from employees where employee_id=124;
desc employees; --11��
desc retired_emps; --9��

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
    v_emp_rec2.v_name :='�����';
    insert into retired_emps values v_emp_rec2;
    commit;
end;
/

execute sp_retired(124);
select * from retired_emps;

-------------------------------------

