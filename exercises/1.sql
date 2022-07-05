--Q. STUDENT 테이블에서 각 학생의 전화번호를 아래 예시와 같이 변경하시오.

--예시) 
--051)426-1700  => 051)XXX-1700
--02)6255-9875  => 02)XXXX-9875

--A VER 1.
SELECT studno, name, id, grade, jumin, tel,
       substr(tel, 1, instr(tel, ')'))||
       lpad('X', instr(tel, '-') - instr(tel, ')') - 1, 'X') ||
       substr(tel, instr(tel, '-')) tel2
  FROM student;


--A VER 2.
SELECT studno, name, id, grade, jumin, tel,
       REPLACE(tel, 
               substr(tel, instr(tel, ')') +1, instr(tel,'-')-instr(tel, ')')-1), 
               lpad('X', instr(tel, '-') - instr(tel, ')') - 1, 'X')) AS tel2
  FROM student;
  
  
  
  
--Q. EMP 테이블을 이용하여 현재까지 근무일수를 YY년 MM개월 DD일 형태로 출력하시오.

--A.
SELECT ename, sysdate, hiredate,
       trunc(months_between(sysdate, hiredate)/12)||'년 '||
       trunc(mod(months_between(sysdate, hiredate), 12))||'개월 '||
       trunc(sysdate - add_months(hiredate, trunc(months_between(sysdate, hiredate))))||'일' workday       
  FROM emp; 
  



--Q. STUDENT 테이블을 사용하여 각 학생의 이름, 학년, 성별을 출력하시오.
SELECT *
  FROM student;

--A. with decode
SELECT name, grade, jumin,
       decode(substr(jumin, 7, 1), '1', 'M', 
                                   '2', 'F') gender
  FROM student;

--A. with case when
SELECT name, grade, jumin,
       CASE substr(jumin, 7, 1) WHEN '1' THEN 'M'
                                WHEN '2' THEN 'F'
                                END gender
  FROM student;
  
  

--Q. emp 테이블을 사용하여 연봉기준 등급을 아래의 기준에 맞게 표현하시오.
-- 2000미만 'C', 2000이상 3000이하 'B', 3000초과 'A'

--A. with decode
SELECT ename, job, hiredate, sal,
       decode(sign(sal - 2000) + sign(sal - 3000), '-2', 'C', '2', 'A', 'B') grade
  FROM emp;


--A. with case when
SELECT ename, job, hiredate, sal,
       CASE WHEN sal < 2000 THEN 'C'
            WHEN sal <= 3000 THEN 'B' -- filtering done for rows under 2000
                             ELSE 'A' END grade
  FROM emp;


  
