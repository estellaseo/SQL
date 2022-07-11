-- JOIN(ORACLE STANDARD)

--1. student, exam_01 테이블을 사용하여 각 학생의 이름, 학년, 시험성적을 출력
select s.name, s.grade, e.total, d.dname as first_major
  from student s, exam_01 e, department d
 where s.studno = e.studno
   and s.deptno1 = d.deptno;



-- Inner Join
--2. 위 데이터에서 학년별 시험성적의 최고점수 출력
select s.grade, max(e.total) as highest_score
  from student s, exam_01 e
 where s.studno = e.studno
 group by s.grade;



-- Outer Join
--3. student, professor 테이블을 사용하여 각 학생의 이름, 학년, 지도교수명, 입사일 출력
select s.name, s.grade, p.name, p.hiredate
  from student s, professor p
 where s.profno = p.profno(+); 
 
 
 
--4. emp2, p_grade 테이블을 사용하여 각 직원의 이름, 현급여(pay), 직급, 직급에 맞는 최소급여기준(S_PAY), 최대급여기준(E_PAY) 함께 출력
--단, 모든 사원에 대해 출력

--ORACLE STANDARD
select e.name, e.position, e.pay, p.S_PAY, p.E_PAY
  from emp2 e, p_grade p
 where e.position = p.position(+);

--ANSI STANDARD
select e.name, e.pay, e.position, p.S_PAY, p.E_PAY
  from emp2 e left outer join p_grade p
    on e.position = p.position;
 
 
 
-- Self Join
--5. gogak, gift 테이블을 사용하여 현재 포인트로 가져갈 수 있는 모든상품을 조회
select g1.gname as 고객명, g1.point,
       g2.gname as 사은품,
       g2.g_start, g2.g_end
  from gogak g1, gift g2
 where g1.point >= g2.g_start 
 order by 1,4; 
 

--6. 각 직원별 같은 부서 선배수. 단, 각 직원의 이름, 급여, 부서번호, 입사일과 함께 출력
select e1.ename, e1.sal, e1.deptno, e1.hiredate,
       count(e2.ename) as 선배수
  from emp e1, emp e2
 where e1.deptno = e2.deptno(+)
   and e1.hiredate > e2.hiredate(+)                          
 group by e1.empno, e1.ename, e1.sal, e1.deptno, e1.hiredate  
 order by 1;

 
 
 -- Non equi join
--6. student, exam_01, hakjum, deparment 테이블을 사용하여 각 학생의 이름, 제1전공명, 성적, 학점 출력
 
 --ORACLE STANDARD
 select s.name, d.dname, e.total, h.grade
  from student s, department d, exam_01 e, hakjum h
 where s.deptno1 = d.deptno
   and s.studno = e.studno
   and e.total between h.min_point and h.max_point;
 
 --ANSI STANDARD
 select s.name, d.dname, e.total, h.grade
  from student s join department d
    on s.deptno1 = d.deptno
  join exam_01 e
    on s.studno = e.studno
  join hakjum h 
    on e.total between h.min_point and h.max_point;
    
    
    
 
