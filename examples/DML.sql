--[INSERT] 데이터 삽입

--1. student 테이블을 사용하여 지도교수가 없는 학생정보만을 갖는 student_t1 테이블 생성
create table student_t1 as select * from student where profno is null;
select * from student_t1;



--2. 위 테이블에 아래 정보를 갖는 학생 데이터 삽입
--학번 : 1000
--이름 : 김길동
--ID :  a1234
--grade : 4
--jumin : 9012122222222
--birthday : 1990-12-12

insert into student_t1(studno, name, id, grade, jumin, birthday) 
       values(1000,'김길동','a1234',4,'9012122222222',to_date('1990-12-12','YYYY-MM-DD'));
select * from student_t1;     
commit;



-- 3. 위 테이블에 추가 학생 데이터 임의 삽입(가능한 필수정보만 삽입)
desc student_t1;
insert into student_t1(NAME,ID,JUMIN) values('최길동','aa','9511111111111');
select * from student_t1;
commit;



-- 4. student 테이블에서 4학년 학생의 학번, 이름, ID, 학년, 주민번호, 생년월일 삽입
insert into student_t1(studno, name, id, grade, jumin, birthday)  
select studno,
       name,
       id,
       grade,
       jumin,
       birthday
  from student
 where grade = 4;

select * from student_t1;
commit;




--[UPDATE] 데이터 수정

--1. 이윤나와 같은 학년 학생의 학년을 2학년으로 수정
create table student_t1 as select * from student;

update student_t1
   set grade = 2
 where grade = (select grade  
                  from student_t1
                 where name = '이윤나');

select * from student_t1;
commit;



--2. king의 sal, comm을 smith의 sal, comm으로 수정
update emp_t1
   set (sal, comm) = (select sal, comm
                        from emp_t1
                       where ename = 'SMITH')
 where ename = 'KING';
select * from emp_t1;
commit;



--3. professor_t1을 만들고 101번 학과 교수의 pay를 전체 교수의 평균급여로 수정
create table professor_t1 as select * from professor;
select * from professor_t1;

update professor_t1
   set pay = (select avg(pay)
                from professor_t1)
 where deptno = 101;
 commit;
 
 

--[DELETE] 데이터 삭제

--1. professor_t1 테이블에서 양선희와 같은 학과 교수 정보 모두 삭제(양선희 포함)
delete professor_t1
 where deptno = (select deptno
                   from professor_t1
                  where name = '양선희');
commit; 



--2. student_t2를 생성, 성별로 평균키보다 작은 학생 삭제
delete student_t2 s1
 where height < (select avg(height)               
                   from student_t2 s2
                  where substr(s1.jumin,7,1) = substr(s2.jumin,7,1));
commit;




--[MERGE] 데이터 병합

--1. merge_old 테이블을 merge_new 테이블과 동일하게 merge문으로 변경
merge into merge_old m1
using merge_new m2
   on (m1.no = m2.no)
 when matched then 
      update 
         set m1.price = m2.price
 when not matched then
      insert values(m2.no, m2.name, m2.price);
      

--2. merge와 동일한 역할의 insert, update, delete

--2-1) emp_new에는 있고 emp_old는 없는 직원 정보를 emp_old 삽입
insert into emp_old
select *
  from emp_new e1
 where e1.empno not in (select e2.empno
                          from emp_old e2);
commit;


--2-2) emp_old를 emp_new 맞춰서 sal 수정(값이 다른 경우만)
update emp_old e1 
   set sal = (select sal
                from emp_new e2
               where e1.empno = e2.empno)
 where sal != (select sal
                 from emp_new e3
                where e1.empno = e3.empno); 
                
                
--2-3) update join view(when index exists)
alter table emp_old add constraint emp_old_pk primary key(empno);
alter table emp_new add constraint emp_new_pk primary key(empno);

update 
       (select e1.sal as old_sal, e2.sal as new_sal
          from emp_old e1, emp_new e2
         where 1=1
           and e1.empno = e2.empno
           and e1.sal != e2.sal) t1
   set t1.old_sal = t1.new_sal;
   
select * from emp_old;
commit;


