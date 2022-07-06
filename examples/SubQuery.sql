--[SINGLE-ROW SUBQUERY] 단일행 서브쿼리

--SMITH와 같은 부서 직원의 이름 부서번호 출력(SMITH도 포함)
select ename, deptno
  from emp
 where deptno = (select deptno
                   from emp
                  where ename = 'SMITH');
                  




--[MULTIPLE-ROW SUBQUERY] 다중행 서브쿼리

--1. 이름이 A로 시작하는 직원과 같은 부서에 있는 직원의 이름, 부서번호 출력
select *
  from emp
 where deptno in (select deptno            
                    from emp
                   where ename like 'A%');
 
 
 
--2. EMP 테이블에서 이름이 A로 시작하는 직원의 sal보다 큰 직원 출력

--A 1) 연산자에 쿼리를 맞춤(한 행이 리턴되도록)   
select *
  from emp
 where sal > (select max(sal)
                from emp
               where ename like 'A%'); 
               
--A 2) 연산자를 쿼리를 맞게 수정(다중 행에 비교되도록)
select *
  from emp
 where sal > all (select sal                
                    from emp
                   where ename like 'A%'); 




--[MULTI-COLUMN SUBQUERY] 다중컬럼 서브쿼리

--1. emp 테이블에서 각 부서별 최대연봉자 출력
select *
  from emp
 where (deptno, sal) in (select deptno, max(sal)
                          from emp
                         group by deptno);




--2. professor 테이블에서 position별 입사일이 가장 빠른 교수의 이름, position, 입사일, 학과명 출력
select position, min(hiredate)
  from professor
 group by position;

select name, position, hiredate, d.dname
  from professor p, department d
 where (position, hiredate) in (select position, min(hiredate)
                                  from professor
                                 group by position)
   and p.deptno = d.deptno;
   
   
   
--3. professor 테이블에서 각 position별 최대 급여를 받는 교수의 이름, position, 소속학과명, 지도학생 수를 구하여라
select p.name, p.position, d.dname, count(s.name) as 지도학생수
  from professor p, department d, student s
 where (p.position, p.pay) in (select position, max(pay) as max_pay
                                 from professor
                                group by position)
   and p.deptno = d.deptno
   and p.profno = s.profno(+)
 group by p.name, p.position, d.dname;
   



--[INLINE VIEW] 인라인뷰

--1. 부서별 평균연봉보다 높은 연봉을 받는 직원 출력
select * 
  from emp e, (select deptno, avg(sal) as avg_sal
                 from emp
                group by deptno) i 
 where e.deptno = i.deptno
   and e.sal > i.avg_sal
 order by e.deptno;  



--2. STUDENT 테이블에서 각 학년별 몸무게의 평균보다 낮은 학생의 이름, 학과명, 학년, 몸무게 출력
select s.name, d.dname, s.grade, s.weight
  from student s, department d,
       (select grade, avg(weight) as avg_weight
          from student
         group by grade) i
 where s.deptno1 = d.deptno
   and s.grade = i.grade
   and s.weight < i.avg_weight;
   
   
   
 --3. professor 테이블에서 각 position별 최대 급여를 받는 교수의 이름, position, 소속학과명, 지도학생 수를 구하여라
select p.name, d.dname, p.position, p.pay, i.max_pay,
       count(s.name) as 지도학생수
  from professor p, (select position, max(pay) as max_pay
                       from professor
                      group by position) i,
       department d, student s
 where p.position = i.position
   and p.pay = i.max_pay
   and p.deptno = d.deptno
   and p.profno = s.profno(+)
 group by p.name, d.dname, p.position, p.pay, i.max_pay;
 
 
 
--4. emp2 테이블에서 태어난 연도별 평균연봉보다 낮은 연봉을 받는 직원의 이름, 소속부서명, 상위관리자명(PEMPNO 사용)을 함께 출력
select e.name, d.dname, e.pay, i.avg_pay, e2.name as 상위관리자명
  from emp2 e, 
       (select to_char(e.birthday, 'yyyy') as birth_year, avg(pay) as avg_pay
          from emp2 e
         group by to_char(e.birthday, 'yyyy')) i, 
       dept2 d, emp2 e2
 where to_char(e.birthday, 'yyyy') = i.birth_year
   and e.pay < avg_pay
   and e.deptno = d.dcode
   and e.PEMPNO = e2.empno;
   
   
   
   
--[CORRELATED SUBQUERY] 상호연관 서브쿼리   

--1. student 테이블을 사용하여 각 성별 키가 가장 큰 학생의 이름, 성별, 키를 출력
select name, substr(jumin,7,1) as 성별, height
  from student s1
 where height = (select max(height)
                   from student s2
                  where substr(s1.jumin,7,1) = substr(s2.jumin,7,1));
 
 

--2. emp 테이블에서 각 부서별로 입사일이 가장 빠른 사람의 이름, 부서번호, 급여 출력
select deptno, min(hiredate)
  from emp
 group by deptno;
 
select e1.ename, e1.deptno, e1.sal
  from emp e1
 where e1.hiredate = (select min(hiredate)
                        from emp e2
                       where e1.deptno = e2.deptno);
                       
                       
                       
                       
 --[SCALAR SUBQUERY] 스칼라 서브쿼리
 
 --student, exam_01, hakjum 테이블을 사용하여 각 학생의 이름, 점수, 학점 출력. 단, 스칼라 서브쿼리 두 개 사용
select (select s.name
          from student s
         where s.STUDNO = e.STUDNO) as 이름,
       e.TOTAL,
       (select h.GRADE
          from hakjum h
         where e.TOTAL between h.MIN_POINT and h.MAX_POINT) as 학점
 from exam_01 e;
  
  
  
  
  