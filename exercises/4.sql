--Q. dept2 테이블을 이용하여 상위부서명을 다음고 같이 출력 -> "경영지원부의 상위부서는 사장실 입니다."
--   단, 상위부서가 없는 경우는 본인부서명 출력.


--A. 
--JOIN
select d1.dname||
       '의 상위부서는 '|| 
       nvl(d2.dname, d1.dname)
       ||' 입니다.' 부서정보
  from dept2 d1, dept2 d2 
 where d1.pdept = d2.dcode(+);


--SCALAR SUBQUERIES
select d1.dname||
       '의 상위부서는 '||
       nvl((select d2.dname
              from dept2 d2 
             where d1.pdept = d2.dcode), d1.dname)
       ||' 입니다.' 부서정보
  from dept2 d1;





--Q. professor 테이블에서 입사년도(1980,1990,2000년대...)별 평균연봉보다 높은 연봉을 받는 교수의 
--   이름, 학과명, 연봉, 지도학생 수 출력. (지도 학생이 없는 경우 0명 출력)


--A. 
--INLINE VIEW
select p.name, d.dname, p.pay, count(s.studno) as 학생수
  from professor p, department d, student s,
      (select trunc(to_char(hiredate, 'YYYY'), -1) as hyear,
              avg(pay) as avg_pay 
         from professor 
        group by trunc(to_char(hiredate, 'YYYY'), -1)) i 
 where trunc(to_char(p.hiredate, 'YYYY'), -1) = i.hyear 
   and p.pay > i.avg_pay
   and p.deptno = d.deptno
   and p.profno = s.profno (+)
 group by p.name, d.dname, p.pay;


--CORRELATED SUBQUERY
select p1.name, d.dname, p1.pay, count(s.studno) as 학생수
  from professor p1, department d, student s 
 where p1.pay > (select avg(pay)
                   from professor p2 
                  where trunc(to_char(p1.hiredate, 'YYYY'), -1) = 
                        trunc(to_char(p2.hiredate, 'YYYY'), -1))
   and p1.deptno = d.deptno 
   and p1.profno = s.profno(+) 
 group by p1.name, d.dname, p1.pay;
 
 
 
 
 
--Q. emp 테이블을 이용하여 부서에서 본인보다 입사년도가 빠른 사람의 수를 각 직원의 이름, 부서명과 함께 출력.
--   단, 선배수가 많은 사람 순으로 정렬하라.


--A. 
--JOIN
select e1.ename, d.dname, count(e2.ename) as 선배수
  from emp e1, emp e2, dept d 
 where e1.deptno = e2.deptno(+) 
   and e1.hiredate > e2.hiredate(+) 
   and e1.deptno = d.deptno 
 group by e1.ename, d.dname
 order by 선배수 desc;
 

--SCALAR SUBQUERIES
select e1.ename,
      (select d.dname 
         from dept d 
        where e1.deptno = d.deptno) as 부서명,
      (select count(e2.ename) 
         from emp e2 
        where e1.deptno = e2.deptno 
          and e1.hiredate > e2.hiredate) as 선배수 
  from emp e1
 order by 선배수 desc;
 
 
 
 
 
--Q. 다음 형태로 출력(professor, student, exam_01, hakjum, department)
--   교수별로 각 교수의 지도학생들의 시험성적의 평균과
--   지도학생들의 학점 분포를 A,B,C,D로 구분해서 출력하고 교수의 소속 학과명도 함께 출력

--교수명         교수학과명  학생성적평균   A학점자수   B학점자수   C학점자수   D학점자수
--김도형	소프트웨어공학과	0	        0	        0	        0	        0
--김영조	멀티미디어공학과	87	        0	        1	        0	        0
--김현정	소프트웨어공학과	0	        0	        0	        0	        0
--나한열	소프트웨어공학과	83	        0	        1	        0	        0
--바비	    화학공학과	        0	        0	        0	        0	        0
 
 
--A.
select p.name as 교수명, 
       d.dname as 교수학과명,
       round(nvl(avg(e.total), 0)) as 학생성적평균, 
       count(decode(substr(h.grade, 1, 1), 'A', 1)) A학점자수,
       count(decode(substr(h.grade, 1, 1), 'B', 1)) B학점자수,
       count(decode(substr(h.grade, 1, 1), 'C', 1)) C학점자수,
       count(decode(substr(h.grade, 1, 1), 'D', 1)) D학점자수
  from professor p, department d, student s, exam_01 e, hakjum h 
 where p.deptno = d.deptno 
   and p.profno = s.profno(+) 
   and s.studno = e.studno(+) 
   and e.total between h.min_point(+) and h.max_point(+) 
 group by p.name, d.dname;

 
 
 
 
  
