--Q. STUDENT, EXAM_01, DEPARTMENT 테이블을 사용하여 각 학생의 이름, 학년, 시험점수, 제1전공명, 제2전공명을 모두 출력
--단, 제2전공이 없는 경우 제1전공명 출력


--A.
SELECT s.name, e.total score,
       d1.dname first_major,
       nvl(d2.dname, d1.dname) second_major
  FROM student s, department d1, department d2, exam_01 e 
 WHERE s.deptno1 = d1.deptno 
   AND s.deptno2 = d2.deptno(+) 
   AND s.studno = e.studno;
   
   
   
--Q. STUDENT 테이블에서 학과별, 성별 시험성적의 평균 출력

--A. 
SELECT d.dname major, 
       decode(substr(s.jumin, 7, 1), '1', 'M', 'F') gender, 
       round(avg(e.total), 2 ) average
  FROM student s, exam_01 e, department d 
 WHERE s.studno = e.studno 
   AND s.deptno1 = d.deptno
 GROUP BY d.dname, substr(s.jumin, 7, 1)
 ORDER BY major;
 
 
 
--Q. PROFESSOR, DEPARTMENT 테이블을 사용하여 각 교수의 소속학과별로 소속교수의 pay의 평균을 구하고,
--소속학과명, 소속학과번호, 소속학과 위치와 함께 출력

--A.
SELECT d.dname subject, d.deptno, d.build,
       round(avg(p.pay), 2) avg_pay
  FROM professor p, department d 
 WHERE p.deptno = d.deptno
 GROUP BY d.dname, d.deptno, d.build;
 
 
 
--Q. EMP2, P_GRADE 테이블을 사용하여 각 직원의 나이를 기준으로
--직원의 이름, 사번, 생년월일, 나이, 현재 직급(POSITION), 예상직급(나이로 계산한 직급), 
--예상 직급에 맞는 최저연봉과 최고연봉 기준을 모두 출력


--A. 
--ORACLE STANDARD
SELECT e.name, e.empno, e.birthday, 
       to_char(sysdate, 'YYYY') - to_char(birthday, 'YYYY') age, 
       e.position, p.position expected_position, p.s_pay, p.e_pay 
  FROM emp2 e, p_grade p 
 WHERE to_char(sysdate, 'YYYY') - to_char(birthday, 'YYYY') between s_age(+) and e_age(+)
 ORDER BY age;
 
--ANSI STANDARD
SELECT e.name, e.empno, e.birthday, 
       to_char(sysdate, 'YYYY') - to_char(e.birthday, 'YYYY') age, 
       e.position, p.position expected_position, p.s_pay, p.e_pay 
  FROM emp2 e left outer join p_grade p 
    ON to_char(sysdate, 'YYYY') - to_char(e.birthday, 'YYYY') between p.s_age and p.e_age
 ORDER BY age desc;
 
 
--Q. emp2, dept2 테이블에서 각 직원과 나이가 같으면서 취미가 같은 직원의 수를 직원의 이름, 부서이름, 취미, 
--pay와 함께 출력하여라.(본인 제외, 취미가 같은 동료가 없는 직원도 출력)

--[예시]
--이름      취미          급여       부서명  친구수(각 직원과 나이와 취미가 같은 동료수)
--강월악	골프	    20000000	영업4팀	    0
--김문호	등산	    35000000	S/W지원	    0
--김설악	낚시	    30000000	영업2팀	    0
--나사장	음악감상	100000000	사장실	    0
--나한라	독서	    20000000	S/W지원	    1
--노정호	수영	    68000000	영업부	    0


--A.
select e1.name 이름, e1.hobby 취미, e1.pay 급여, d.dname 부서명, 
       count(e2.name) 친구수
  from emp2 e1, emp2 e2, dept2 d
 where to_char(sysdate, 'YYYY') - to_char(e1.birthday, 'YYYY') = 
       to_char(sysdate, 'YYYY') - to_char(e2.birthday(+), 'YYYY')
   and e1.hobby = e2.hobby(+) 
   and e1.empno != e2.empno(+)
   and e1.deptno = d.dcode
 group by e1.name, e1.hobby, e1.pay, d.dname
 order by 이름;
 
 

--Q. student 테이블에서 각 학생마다 같은 성별 내 몸무게가 많이 나가는 학생의 수를
--각 학생의 이름과 학년, 몸무게, 시험 성적 출력(성별로 몸무게가 가장 많이 나가는 학생도 출력)

--이름   학년 몸무게 점수 학생수(본인보다 몸무게가 많이 나가는 친구 수)
--구유미	3	  58	79	 0
--김문호	2     51	82	 11
--김신영	3	  48	92	 5
--김재수	4	  83	62	 0
--김주현	1	  81	83	 2
--...


--A.
select s1.name 이름, s1.grade 학년, s1.weight 몸무게, e.total 점수, count(s2.name) 학생수
  from student s1, student s2, exam_01 e
 where substr(s1.jumin, 7, 1) = substr(s2.jumin(+), 7, 1)
   and s1.weight < s2.weight(+)
   and s1.studno = e.studno 
 group by s1.name, s1.grade, s1.weight, e.total
 order by 1;



