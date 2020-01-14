--���� �迭(INDEX BY ���̺�)
--��Į��:�� Į�� ¥��
--���ڵ�:�������� Į��

set serveroutput on;

declare
    --Ÿ�� ����
    --PLS_INTEGER�� BINARY_INTEGER�� NUMBER���� ������ ���� ����
    type enameArr is table of
        employees.last_name%type 
        index by PLS_INTEGER;
    type enameArr2 is table of
        employees.last_name%type
        index by BINARY_INTEGER;
    type enameArr3 is table of
        employees.last_name%type
        index by varchar2(10);
    type dateArr is table of date index by pls_integer; --���� dateŸ��
    type cityArr is table of varchar2(50); --index�� 1,2,3,4,5
    
    
    --���� ����
    v_ename enameArr;
    v_ename2 enameArr2;
    v_ename3 enameArr3;
    v_hdate dateArr;
    v_city cityArr := cityArr('����','�λ�','����');
    
    
begin
    v_ename(10) := 'ȫ�浿';
    v_ename(11) := '�ڱ浿';
    dbms_output.put_line(v_ename(10));
    dbms_output.put_line(v_ename(11));
    
    v_ename2(12) := 'ȫ�浿2';
    v_ename2(13) := '�ڱ浿2';
    dbms_output.put_line(v_ename2(12));
    dbms_output.put_line(v_ename2(13));
    
    --�ε�����(Ű ��) �����̴�(varchar2)
    v_ename3('����') := 'ȫ�浿3';
    v_ename3('��') := '�ڱ浿3';
    dbms_output.put_line(v_ename3('����'));
    dbms_output.put_line(v_ename3('��'));   
    
    v_hdate(10):=sysdate;
    v_hdate(20):=sysdate+1; --����
    v_hdate(30):=sysdate+2; --��
    dbms_output.put_line(v_hdate(10));
    dbms_output.put_line(v_hdate(20));
    dbms_output.put_line('index����: '|| v_hdate.count); --���� �迭�� ���Ե� ����� ��
    dbms_output.put_line('indexù: '|| v_hdate.first); --�ε����� ù��ȣ
    dbms_output.put_line('index��: '|| v_hdate.last); --�ε����� ����ȣ
    dbms_output.put_line('prior: '|| v_hdate.prior(20)); --1
    dbms_output.put_line('next: '|| v_hdate.next(20)); --2
    if v_hdate.exists(2) then
        dbms_output.put_line('2��° ��Ұ� �����Ѵ�.');
    else
        dbms_output.put_line('2��° ��Ұ� �������� �ʴ´�.');
    end if;
    --�ݺ���
    for v_count in v_hdate.first..v_hdate.last loop
        dbms_output.put_line('index��ȣ:'||v_count);
        continue when v_hdate.exists(v_count) = false;
            dbms_output.put_line('�迭��:'||v_hdate(v_count));
    end loop;
    
    dbms_output.put_line(v_city.count);
    for idx in 1..v_city.count loop
    dbms_output.put_line(v_city(idx));
    end loop;
end;
/

declare
    --depttype�� �μ����̺��� ������
    type depttype is table of 
        departments%rowtype index by binary_integer;
    type emptype is table of
        employees%rowtype index by pls_integer;
    v_dept depttype;
    v_emp emptype;
    
begin
    
    select * into v_dept(1) from departments
    where department_id=60;
    dbms_output.put_line(v_dept(1).department_id);
    dbms_output.put_line(v_dept(1).department_name);
    dbms_output.put_line(v_dept(1).location_id);
    dbms_output.put_line(v_dept(1).manager_id);
    dbms_output.put_line('-----------------------');
    --���� 100~110 -> table�� �ֱ�
    for idx in 100..110 loop
        select * into v_emp(idx) from employees
        where employee_id=idx;
    end loop;
    
     for idx in 100..110 loop
        dbms_output.put_line(v_emp(idx).first_name||' '||v_emp(idx).last_name);
    end loop;
end;
/

declare
    --varray: ������ �� ũ��(��� ����)�� �����ϸ� �̺��� ū ���� ��Ҹ� ���� �� ����
    --varray(�ִ� ũ��)
    type location_type is varray(5) of varchar2(20);
    v_location location_type;
begin
    --�ʱ�ȭ
    v_location := location_type('����','�뱸','�λ�',null,null);
    
    -- ��� ����
    v_location(4) :='��Ƽķ�۽�';
    v_location(5) := '�������';
    for idx in 1..v_location.count loop
        dbms_output.put_line(v_location(idx));
    end loop;
end;
/

--����� Ŀ��: ���α׷��Ӱ� �����ϰ� ����
--�Ͻ��� Ŀ��:��� DML �� PL/SQL select���� ���� PL/SQL���� �����ϰ� ����
declare
    cursor cur_emp is
    select employee_id,first_name
    from employees
    where department_id=60;
    
    cursor cur_emp2 is
    select *
    from employees
    where department_id=60;
    
    --��Į��
    v_empid employees.employee_id%type;
    v_fname employees.first_name%type;
    --���ڵ�
    v_rec employees%rowtype;

begin
    --Ŀ������(����)
    open cur_emp;
    
    loop
        fetch cur_emp into v_empid ,v_fname;
        --�������� ������ ������
        exit when cur_emp%notfound;
        dbms_output.put_line('������ȣ:'||v_empid||' '||'�����̸�:'||v_fname);    
    end loop;
    --Ŀ�� �ݱ�(�߿�)
    close cur_emp;
    dbms_output.put_line('------------------------------');
    
    open cur_emp2;
    --���ڵ�
    loop
        fetch cur_emp2 into v_rec;
        --(��ȯ�� �� ����� ���� ��)�������� ������ ������
        exit when cur_emp2%notfound;
        dbms_output.put_line('������ȣ:'||v_rec.employee_id||' '||'�����̸�:'||v_rec.first_name);    
    end loop;
    --Ŀ�� �ݱ�(�߿�)
    close cur_emp2;
    dbms_output.put_line('------------------------------');
    
    --for���� cur_emp2 �ڵ����� open,fetch,close
    for v_rec2 in cur_emp2 loop
        dbms_output.put_line('�����޿�:'||v_rec2.salary||' '||'�����̸�:'||v_rec2.first_name);    
    end loop;
    dbms_output.put_line('------------------------------');
    --for���� �ڵ����� Ŀ��ó��(�Ͻ��� Ŀ��)
    for aa in (select * from employees where job_id='IT_PROG') loop
        dbms_output.put_line('����:'||aa.last_name||' '||'����:'||aa.job_id);    
    end loop;    
end;
/

--�޿��� ?�̻��� ������ ��ȸ
execute sp_cursor_test(15000);
create or replace procedure sp_cursor_test(v_sal in number)
is
    --����� Ŀ��
    cursor cur_empsal is
        select * from employees
        where salary >= 10000;
        
    v_emp employees%rowtype; --record
begin
    --�����Ŀ������(select�� ����)
    open cur_empsal;
    
    --Ŀ��fetch(�Ѱ� ��������)
    fetch cur_empsal into v_emp;

    --while ���� ����
    while cur_empsal%found loop
        dbms_output.put_line(v_emp.last_name||'->'||v_emp.salary);
        fetch cur_empsal into v_emp;
    end loop;

    --�����Ŀ���ݱ�
    close cur_empsal;
    dbms_output.put_line('------------------------------');
    
    --�Ͻ���Ŀ��(declare,open,fetch,close�ڵ�)
    for aa in cur_empsal loop
        dbms_output.put_line(aa.last_name||'=>'||aa.salary);
    end loop;
    
    for aa in (select * from employees where salary >=v_sal) loop
        dbms_output.put_line(aa.last_name||'====>'||aa.salary);
    end loop;
end;
/

set serveroutput on;
--for update
Declare
    Cursor C_Emp_Cursor Is
        Select Employee_Id, Last_Name 
        From Employees
        Where Department_Id = 80 For Update Of Salary nowait;
        --nowait: �ٸ� session�� lock�ɾ��ٸ� Ŀ�� open�� ����
        --wait(default):�ٸ� session�� lock�� �ɾ��ٸ� ���
    v_empid number;
    v_lname varchar2(25);
begin
    open c_emp_cursor;
    loop
        fetch c_emp_cursor into v_empid,v_lname;
        exit when c_emp_cursor%notfound;
        dbms_output.put_line(v_empid ||' '|| v_lname);

    --fetch�ǿ� �ش��ϴ� row
    --Ŀ���� ����Ͽ� ���� ���� ���� �Ǵ� ����
    --���� ���� ��׵��� Ŀ��query�� for update���� ����
    update employees
    set salary= salary+1
    where current of c_emp_cursor;
    end loop;
    
    close c_emp_cursor;
end;
/

-------------------------------------------------
--����:������ �߻��ϴ��� �ߴܵ��� �ʰ� ��� ����, ��������

create or replace procedure sp_exception
is
    v_su number :=10;
    v_su2 number :=0;
    v_lname varchar2(25);
    type location_type is varray(5) of varchar2(20);
    v_location location_type := location_type('��','��','��');
    --���� ����Ÿ��
    v_rec employees%rowtype;
begin
    --v_su := v_su/v_su2; --�ߴ�
    select * into v_rec from employees where 1=0;
    
    dbms_output.put_line(v_location(1));
    v_location(4) := 'a';
    
    select last_name into v_lname
    from employees
    where first_name = 'John';
    dbms_output.put_line('success');  
    
exception 
    when ZERO_DIVIDE then
        dbms_output.put_line('0���� ������ ����'); 
    when TOO_MANY_ROWS then
        dbms_output.put_line('�Ǽ��� 1�� �̻��̴�.'); 
    when NO_DATA_FOUND then
        dbms_output.put_line('�����Ͱ� ����.'); 
    when SUBSCRIPT_BEYOND_COUNT then
        dbms_output.put_line('�÷����� ÷�� ����');
    when others then
        dbms_output.put_line('��Ÿ ���� �߻�'); 
        dbms_output.put_line('�ڵ��ȣ:' || SQLCODE);
        dbms_output.put_line('error message:' ||SQLERRM);
end;
/
execute sp_exception;
--------------------------------------------------
create or replace procedure sp_exception(v_deptid number)
is
    v_emp employees%rowtype;
    v_test number;
    v_myexception EXCEPTION; --����� ���� exception
begin   
    --��������(business login)�� ����ó���� �и��ϴ� ����
    if v_deptid < 10 or v_deptid > 200 then
        raise v_myexception; --���� exception�߻�
    end if;
    
    v_test := 10/0;
    select *
    into v_emp
    from employees
    where department_id= v_deptid;
    dbms_output.put_line(v_emp.first_name||' '||v_emp.last_name);
exception 
    when TOO_MANY_ROWS then
        dbms_output.put_line('1�� �̻��� rows ��ȸ...Ŀ�� �̿�');
    when NO_DATA_FOUND then
        dbms_output.put_line('data�� �������� ����');
    when v_myexception then
         dbms_output.put_line('10<= �μ���ȣ <=200 �ƴ�');
    when others then
        dbms_output.put_line(SQLCODE); 
        dbms_output.put_line(SQLERRM);
        dbms_output.put_line(SQLERRM(SQLCODE));
end;
/

--�μ�id=10�� ���� ���� 1�� �ε�, id=60�� ���� ���� �������� ����
execute sp_exception(60);

--������� procedure�� �ٸ� ���α׷����� ���
declare
begin
    sp_exception(5);
    --���ν��� ������ �� ��� �ߴܵǾ �������� ����
    dbms_output.put_line('����');
end;
/

------�μ���ȣ�� �̿��ؼ� �μ��̸� ���

--procedure
create or replace procedure sp_deptname(
 v_deptid in number,v_deptname out varchar2)
is
begin
    select department_name
    into v_deptname
    from departments
    where department_id = v_deptid;
end;
/
--function
create or replace function f_deptname(v_deptid in number)
return varchar2
is
    v_deptname varchar2(20);
begin
    select department_name
    into v_deptname
    from departments
    where department_id =  v_deptid;
    return v_deptname;
end;
/
--�̿�
declare
    v_dept varchar2(40);
    v_fname varchar2(40);
begin
    --procedure ȣ��
    sp_deptname(60,v_dept);
    dbms_output.put_line(v_dept);
    --�Լ� ȣ��1
    v_dept:=f_deptname(60);
    dbms_output.put_line(v_dept);
    --�Լ� ȣ��2
    select first_name,f_deptname(department_id)
    into v_fname,v_dept
    from employees
    where employee_id=100;
    dbms_output.put_line(v_dept);
end;
/
--package: procedure +function ���� ����
--����+ �����
create or replace package pkg_multicampus is
    procedure sp_deptname(v_deptid in number,v_deptname out varchar2);
 function f_deptname(v_deptid in number) return varchar2;
end pkg_multicampus;
/

create or replace package body pkg_multicampus is
 procedure sp_deptname(
     v_deptid in number,v_deptname out varchar2)
        is
        begin
            select department_name
            into v_deptname
            from departments
            where department_id = v_deptid;
        end sp_deptname;
        function f_deptname(v_deptid in number) return varchar2
            is
                v_deptname varchar2(20);
            begin
                select department_name
                into v_deptname
                from departments
                where department_id =  v_deptid;
                return v_deptname;
            end;
end pkg_multicampus;
/

declare 
    v_deptname varchar2(40);
begin
   pkg_multicampus.sp_deptname(60,v_deptname);
    dbms_output.put_line(v_deptname);
    
    v_deptname := pkg_multicampus.f_deptname(60);
    dbms_output.put_line(v_deptname);
    --��Ű��
    select pkg_multicampus.f_deptname(department_id)
    into v_deptname
    from employees
    where employee_id=100;
    dbms_output.put_line(v_deptname);
end;
/

--trigger:select,update,delete�� ����Ǵ� ���� ��/�Ŀ� ���ݵǾ� �ϴ� �۾��� ����
--�ڵ� ����Ǵ� procedure

select * from emp;
--7900���� ���� �ȵ�,�ű� �ȵ�, ���� �ȵ�

delete from emp where empno=7900;
insert into emp(empno,ename) values (7900,'aa');
update emp set ename='aa' where empno=7900;
rollback;

create or replace trigger trigger_emp
before update or delete or insert on emp for each row
declare
    v_message varchar2(100) := ' ';
begin
    if updating then
        if :old.empno=7900 then
            v_message := '7900���� �����Ұ��Դϴ�';
            raise_application_error(-20001,v_message);
        end if;
    end if;
    
    if deleting then
        if :old.empno=7900 then
            v_message := '7900���� �����Ұ��Դϴ�';
            raise_application_error(-20002,v_message);
        end if;
    end if;
    
      if inserting then
        if :new.empno=7900 then
            v_message := '7900���� �ԷºҰ��Դϴ�';
            raise_application_error(-20003,v_message);
        end if;
    end if;
end;
/

--order_list�� insert�ϸ�
--sales_per_date�� ������ insert�ϰ�, ������ update
select * from order_list;
select * from sales_per_date;

insert into order_list values('20200114','coffee',10,10000);
insert into order_list values('20200114','coffee',20,20000);
insert into order_list values('20200114','coffee',2,4000);
insert into order_list values('20200114','apple',20,14000);


create or replace trigger trigger_order
    after insert on ORDER_LIST for each row
declare 
begin
  --�̹� �����ϴ°�?yes ����, no �Է�
    update sales_per_date
    set qty=qty+ :new.qty, amount=amount+:new.amount
    where sale_date =:new.order_date
    and product=:new.product;
    
    if sql%notfound then
        insert into sales_per_date values(:new.order_date, :new.product,:new.amount,:new.qty);
    end if;
    --commit;
    dbms_output.put_line('���强��');
exception when others then
    --rollback;
    dbms_output.put_line('�������');
end;
/













CREATE TABLE ORDER_LIST (
ORDER_DATE CHAR(8) NOT NULL,
PRODUCT VARCHAR2(10) NOT NULL,
QTY NUMBER NOT NULL,
AMOUNT NUMBER NOT NULL);


CREATE TABLE SALES_PER_DATE (
SALE_DATE CHAR(8) NOT NULL,
PRODUCT VARCHAR2(10) NOT NULL,
QTY NUMBER NOT NULL,
 AMOUNT NUMBER NOT NULL);




