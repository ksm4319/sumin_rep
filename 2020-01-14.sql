--연관 배열(INDEX BY 테이블)
--스칼라:한 칼럼 짜리
--레코드:여러개의 칼럼

set serveroutput on;

declare
    --타입 선언
    --PLS_INTEGER이 BINARY_INTEGER나 NUMBER보다 연산을 빨리 수행
    type enameArr is table of
        employees.last_name%type 
        index by PLS_INTEGER;
    type enameArr2 is table of
        employees.last_name%type
        index by BINARY_INTEGER;
    type enameArr3 is table of
        employees.last_name%type
        index by varchar2(10);
    type dateArr is table of date index by pls_integer; --값이 date타입
    type cityArr is table of varchar2(50); --index는 1,2,3,4,5
    
    
    --변수 선언
    v_ename enameArr;
    v_ename2 enameArr2;
    v_ename3 enameArr3;
    v_hdate dateArr;
    v_city cityArr := cityArr('서울','부산','대전');
    
    
begin
    v_ename(10) := '홍길동';
    v_ename(11) := '박길동';
    dbms_output.put_line(v_ename(10));
    dbms_output.put_line(v_ename(11));
    
    v_ename2(12) := '홍길동2';
    v_ename2(13) := '박길동2';
    dbms_output.put_line(v_ename2(12));
    dbms_output.put_line(v_ename2(13));
    
    --인덱스가(키 값) 문자이다(varchar2)
    v_ename3('반장') := '홍길동3';
    v_ename3('부') := '박길동3';
    dbms_output.put_line(v_ename3('반장'));
    dbms_output.put_line(v_ename3('부'));   
    
    v_hdate(10):=sysdate;
    v_hdate(20):=sysdate+1; --내일
    v_hdate(30):=sysdate+2; --모레
    dbms_output.put_line(v_hdate(10));
    dbms_output.put_line(v_hdate(20));
    dbms_output.put_line('index개수: '|| v_hdate.count); --연관 배열에 포함된 요소의 수
    dbms_output.put_line('index첫: '|| v_hdate.first); --인덱스의 첫번호
    dbms_output.put_line('index끝: '|| v_hdate.last); --인덱스의 끝번호
    dbms_output.put_line('prior: '|| v_hdate.prior(20)); --1
    dbms_output.put_line('next: '|| v_hdate.next(20)); --2
    if v_hdate.exists(2) then
        dbms_output.put_line('2번째 요소가 존재한다.');
    else
        dbms_output.put_line('2번째 요소가 존재하지 않는다.');
    end if;
    --반복문
    for v_count in v_hdate.first..v_hdate.last loop
        dbms_output.put_line('index번호:'||v_count);
        continue when v_hdate.exists(v_count) = false;
            dbms_output.put_line('배열값:'||v_hdate(v_count));
    end loop;
    
    dbms_output.put_line(v_city.count);
    for idx in 1..v_city.count loop
    dbms_output.put_line(v_city(idx));
    end loop;
end;
/

declare
    --depttype은 부서테이블의 여러건
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
    --직원 100~110 -> table에 넣기
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
    --varray: 선언할 때 크기(요소 개수)를 지정하면 이보다 큰 수로 요소를 만들 수 없다
    --varray(최대 크기)
    type location_type is varray(5) of varchar2(20);
    v_location location_type;
begin
    --초기화
    v_location := location_type('서울','대구','부산',null,null);
    
    -- 요소 수정
    v_location(4) :='멀티캠퍼스';
    v_location(5) := '테헤란로';
    for idx in 1..v_location.count loop
        dbms_output.put_line(v_location(idx));
    end loop;
end;
/

--명시적 커서: 프로그래머가 선언하고 관리
--암시적 커서:모든 DML 및 PL/SQL select문에 대해 PL/SQL에서 선언하고 관리
declare
    cursor cur_emp is
    select employee_id,first_name
    from employees
    where department_id=60;
    
    cursor cur_emp2 is
    select *
    from employees
    where department_id=60;
    
    --스칼라
    v_empid employees.employee_id%type;
    v_fname employees.first_name%type;
    --레코드
    v_rec employees%rowtype;

begin
    --커서실행(열기)
    open cur_emp;
    
    loop
        fetch cur_emp into v_empid ,v_fname;
        --존재하지 않으면 나가기
        exit when cur_emp%notfound;
        dbms_output.put_line('직원번호:'||v_empid||' '||'직원이름:'||v_fname);    
    end loop;
    --커서 닫기(중요)
    close cur_emp;
    dbms_output.put_line('------------------------------');
    
    open cur_emp2;
    --레코드
    loop
        fetch cur_emp2 into v_rec;
        --(반환된 총 행수가 없을 때)존재하지 않으면 나가기
        exit when cur_emp2%notfound;
        dbms_output.put_line('직원번호:'||v_rec.employee_id||' '||'직원이름:'||v_rec.first_name);    
    end loop;
    --커서 닫기(중요)
    close cur_emp2;
    dbms_output.put_line('------------------------------');
    
    --for문은 cur_emp2 자동으로 open,fetch,close
    for v_rec2 in cur_emp2 loop
        dbms_output.put_line('직원급여:'||v_rec2.salary||' '||'직원이름:'||v_rec2.first_name);    
    end loop;
    dbms_output.put_line('------------------------------');
    --for문은 자동으로 커서처리(암시적 커서)
    for aa in (select * from employees where job_id='IT_PROG') loop
        dbms_output.put_line('직원:'||aa.last_name||' '||'직업:'||aa.job_id);    
    end loop;    
end;
/

--급여가 ?이상인 직원들 조회
execute sp_cursor_test(15000);
create or replace procedure sp_cursor_test(v_sal in number)
is
    --명시적 커서
    cursor cur_empsal is
        select * from employees
        where salary >= 10000;
        
    v_emp employees%rowtype; --record
begin
    --명시적커서열기(select문 실행)
    open cur_empsal;
    
    --커서fetch(한건 가져오기)
    fetch cur_empsal into v_emp;

    --while 들어갈지 결정
    while cur_empsal%found loop
        dbms_output.put_line(v_emp.last_name||'->'||v_emp.salary);
        fetch cur_empsal into v_emp;
    end loop;

    --명시적커서닫기
    close cur_empsal;
    dbms_output.put_line('------------------------------');
    
    --암시적커서(declare,open,fetch,close자동)
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
        --nowait: 다른 session이 lock걸었다면 커서 open시 오류
        --wait(default):다른 session이 lock을 걸었다면 대기
    v_empid number;
    v_lname varchar2(25);
begin
    open c_emp_cursor;
    loop
        fetch c_emp_cursor into v_empid,v_lname;
        exit when c_emp_cursor%notfound;
        dbms_output.put_line(v_empid ||' '|| v_lname);

    --fetch건에 해당하는 row
    --커서를 사용하여 현재 행을 갱신 또는 삭제
    --먼저 행을 잠그도록 커서query에 for update절을 포함
    update employees
    set salary= salary+1
    where current of c_emp_cursor;
    end loop;
    
    close c_emp_cursor;
end;
/

-------------------------------------------------
--예외:오류가 발생하더라도 중단되지 않고 계속 진행, 정상종료

create or replace procedure sp_exception
is
    v_su number :=10;
    v_su2 number :=0;
    v_lname varchar2(25);
    type location_type is varray(5) of varchar2(20);
    v_location location_type := location_type('ㅁ','ㄷ','ㄴ');
    --변수 변수타입
    v_rec employees%rowtype;
begin
    --v_su := v_su/v_su2; --중단
    select * into v_rec from employees where 1=0;
    
    dbms_output.put_line(v_location(1));
    v_location(4) := 'a';
    
    select last_name into v_lname
    from employees
    where first_name = 'John';
    dbms_output.put_line('success');  
    
exception 
    when ZERO_DIVIDE then
        dbms_output.put_line('0으로 나눌수 없음'); 
    when TOO_MANY_ROWS then
        dbms_output.put_line('건수가 1건 이상이다.'); 
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터가 없음.'); 
    when SUBSCRIPT_BEYOND_COUNT then
        dbms_output.put_line('컬렌션의 첨자 오류');
    when others then
        dbms_output.put_line('기타 예외 발생'); 
        dbms_output.put_line('코드번호:' || SQLCODE);
        dbms_output.put_line('error message:' ||SQLERRM);
end;
/
execute sp_exception;
--------------------------------------------------
create or replace procedure sp_exception(v_deptid number)
is
    v_emp employees%rowtype;
    v_test number;
    v_myexception EXCEPTION; --사용자 정의 exception
begin   
    --업무로직(business login)과 오류처리를 분리하는 목적
    if v_deptid < 10 or v_deptid > 200 then
        raise v_myexception; --강제 exception발생
    end if;
    
    v_test := 10/0;
    select *
    into v_emp
    from employees
    where department_id= v_deptid;
    dbms_output.put_line(v_emp.first_name||' '||v_emp.last_name);
exception 
    when TOO_MANY_ROWS then
        dbms_output.put_line('1개 이상의 rows 조회...커서 이용');
    when NO_DATA_FOUND then
        dbms_output.put_line('data가 존재하지 않음');
    when v_myexception then
         dbms_output.put_line('10<= 부서번호 <=200 아님');
    when others then
        dbms_output.put_line(SQLCODE); 
        dbms_output.put_line(SQLERRM);
        dbms_output.put_line(SQLERRM(SQLCODE));
end;
/

--부서id=10인 것은 행이 1개 인데, id=60인 것은 행이 여러개라 오류
execute sp_exception(60);

--만들어진 procedure를 다른 프로그램에서 사용
declare
begin
    sp_exception(5);
    --프로시저 오류가 날 경우 중단되어서 도달하지 못함
    dbms_output.put_line('성공');
end;
/

------부서번호를 이용해서 부서이름 출력

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
--이용
declare
    v_dept varchar2(40);
    v_fname varchar2(40);
begin
    --procedure 호출
    sp_deptname(60,v_dept);
    dbms_output.put_line(v_dept);
    --함수 호출1
    v_dept:=f_deptname(60);
    dbms_output.put_line(v_dept);
    --함수 호출2
    select first_name,f_deptname(department_id)
    into v_fname,v_dept
    from employees
    where employee_id=100;
    dbms_output.put_line(v_dept);
end;
/
--package: procedure +function 들의 묶음
--명세부+ 실행부
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
    --패키지
    select pkg_multicampus.f_deptname(department_id)
    into v_deptname
    from employees
    where employee_id=100;
    dbms_output.put_line(v_deptname);
end;
/

--trigger:select,update,delete이 실행되는 시점 전/후에 동반되어 하는 작업을 정의
--자동 실행되는 procedure

select * from emp;
--7900번은 수정 안됨,신규 안됨, 삭제 안됨

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
            v_message := '7900번은 수정불가입니다';
            raise_application_error(-20001,v_message);
        end if;
    end if;
    
    if deleting then
        if :old.empno=7900 then
            v_message := '7900번은 삭제불가입니다';
            raise_application_error(-20002,v_message);
        end if;
    end if;
    
      if inserting then
        if :new.empno=7900 then
            v_message := '7900번은 입력불가입니다';
            raise_application_error(-20003,v_message);
        end if;
    end if;
end;
/

--order_list에 insert하면
--sales_per_date에 없으면 insert하고, 있으면 update
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
  --이미 존재하는가?yes 수정, no 입력
    update sales_per_date
    set qty=qty+ :new.qty, amount=amount+:new.amount
    where sale_date =:new.order_date
    and product=:new.product;
    
    if sql%notfound then
        insert into sales_per_date values(:new.order_date, :new.product,:new.amount,:new.qty);
    end if;
    --commit;
    dbms_output.put_line('저장성공');
exception when others then
    --rollback;
    dbms_output.put_line('저장오류');
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




