--Q. student 테이블에서 같은지역이면서 같은 성별의 친구가 몇명인지 구하고, 
--   그 학생의 담당 교수이름도 함께 출력되도록 하여라.
--   단, 같은지역(전화번호 컬럼 사용), 같은 성별(주민번호 사용)에 본인은 포함될 수 없다.
 

--A.
--ORACLE STANDARD
select s.name 이름, count(s2.studno) 친구수, p.name 교수명
  from student s, student s2,  professor p 
 where substr(s.tel, 1, instr(s.tel, ')')-1) = substr(s2.tel(+), 1, instr(s2.tel(+), ')')-1)
   and substr(s.jumin, 7, 1) = substr(s2.jumin(+), 7, 1)
   and s.studno != s2.studno (+)
   and s.profno = p.profno (+)
 group by s.name, p.name
 order by s.name;
 
 
--ANSI STANDARD
select s.name 이름, count(s2.studno) 친구수, p.name 교수명
  from student s left outer join student s2
    on substr(s.tel, 1, instr(s.tel, ')')-1) = substr(s2.tel, 1, instr(s2.tel, ')')-1)
   and substr(s.jumin, 7, 1) = substr(s2.jumin, 7, 1)
   and s.studno != s2.studno
  left outer join professor p 
    on s.profno = p.profno
 group by s.name, p.name
 order by s.name;
 



 
--Q. emp, dept 테이블을 이용하여 본인과 상위관리자의 평균연봉보다 많은 연봉을 받는 직원의
--   이름, 부서명, 연봉, 상위관리자명을 출력하여라.


--A. 
--ORACLE STANDARD
select e1.ename, d.dname, e1.sal, e2.ename 
  from emp e1, emp e2, dept d
 where e1.mgr = e2.empno(+) 
   and e1.sal > (e1.sal + nvl(e2.sal, e1.sal))/2 
   and e1.deptno = d.deptno;
 
 
--ANSI STANDARD
select e1.ename, d.dname, e1.sal, e2.ename 
  from emp e1 left outer join emp e2
    on e1.mgr = e2.empno
  join dept d
   on e1.deptno = d.deptno
  and e1.sal > (e1.sal + nvl(e2.sal, e1.sal))/2 ;
 




--Q. 위에서 각 학생별로 같은 학년 내 시험을 더 잘 본 친구의 수를 학생이름, 제1전공명, 
--   학년, 시험성적과 함께 출력(단, 본인보다 시험을 잘 본 친구가 없어도 출력)


--A.
--ORACLE STANDARD
select i1.name, d.dname, i1.grade, i1.total, count(i2.name) as 친구수
  from (select s1.name, s1.deptno1, s1.grade, e1.total
          from student s1, exam_01 e1 
         where s1.studno = e1.studno) i1,
       (select s2.name, s2.grade, e2.total
          from student s2, exam_01 e2 
         where s2.studno = e2.studno) i2,
       department d
 where i1.grade = i2.grade (+)
   and i1.total < i2.total (+)
   and i1.deptno1 = d.deptno
 group by i1.name, d.dname, i1.grade, i1.total
 order by i1.name;


--ANSI STANDARD
select i1.name, d.dname, i1.grade, i1.total, count(i2.name) as 친구수
  from (select s1.name, s1.deptno1, s1.grade, e1.total
          from student s1, exam_01 e1 
         where s1.studno = e1.studno) i1 left outer join
       (select s2.name, s2.grade, e2.total
          from student s2, exam_01 e2 
         where s2.studno = e2.studno) i2
    on i1.grade = i2.grade
   and i1.total < i2.total
  join department d
    on i1.deptno1 = d.deptno
 group by i1.name, d.dname, i1.grade, i1.total
 order by i1.name;





--Q. emloyees 테이블을 사용하여 각 직원의 입사동기(입사한 해가 같은 경우)의 수를
--   각 직원의 이름, 연봉, 상위관리자 이름(first_name) 정보와 함께 출력
--   단, 입사동기에 본인은 포함하지 않는다
--   (입사 동기가 없는 경우, 상위관리자가 없는 경우도 출력)


--A.
--ORACLE STANDARD
select e1.first_name, e1.hire_date, e1.salary, e3.first_name as 상위관리자,
       count(e2.first_name) as 동기수 
  from employees e1, 
       employees e2,
       employees e3
 where to_char(e1.hire_date, 'YYYY') = to_char(e2.hire_date(+), 'YYYY') 
   and e1.employee_id != e2.employee_id(+)
   and e1.manager_id = e3.employee_id(+)
 group by e1.first_name, e1.hire_date, e1.salary, e3.first_name;
 

--ANSI STANDARD
select e1.first_name, e1.hire_date, e1.salary, e3.first_name as 상위관리자,
       count(e2.first_name) as 동기수 
  from employees e1 left outer join employees e2 
    on to_char(e1.hire_date, 'YYYY') = to_char(e2.hire_date, 'YYYY')
   and e1.employee_id != e2.employee_id
  left outer join employees e3
    on e1.manager_id = e3.employee_id
 group by e1.first_name, e1.hire_date, e1.salary, e3.first_name;






