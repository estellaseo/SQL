--Q. STUDENT 테이블에서 각 학생의 전화번호를 아래 예시와 같이 변경하시오.

--예시) 
--051)426-1700  => 051)XXX-1700
--02)6255-9875  => 02)XXXX-9875

 
--A VER 1.
select studno, name, id, grade, jumin, tel,
       substr(tel, 1, instr(tel, ')'))||
       lpad('X', instr(tel, '-') - instr(tel, ')') - 1, 'X') ||
       substr(tel, instr(tel, '-')) tel2
  from student;


--A VER 2.
select studno, name, id, grade, jumin, tel,
       replace(tel, 
               substr(tel, instr(tel, ')') +1, instr(tel,'-')-instr(tel, ')')-1), 
               lpad('X', instr(tel, '-') - instr(tel, ')') - 1, 'X')) as tel2
  from student;
  
  
  
--Q. EMP 테이블을 이용하여 현재까지 근무일수를 YY년 MM개월 DD일 형태로 출력하시오.

select * 
  from emp;

--A.
select ename, sysdate, hiredate,
       trunc(months_between(sysdate, hiredate)/12)||'년 '||
       trunc(mod(months_between(sysdate, hiredate), 12))||'개월 '||
       trunc(sysdate - add_months(hiredate, trunc(months_between(sysdate, hiredate))))||'일' workday       
  from emp; 
  


--Q. STUDENT 테이블을 사용하여 각 학생의 이름, 학년, 성별을 출력하시오.
select *
  from student;

--A. with decode
select name, grade, jumin,
       decode(substr(jumin, 7, 1), '1', 'M', 
                                   '2', 'F') gender
  from student;

--A. with case when
select name, grade, jumin,
       case substr(jumin, 7, 1) when '1' then 'M'
                                when '2' then 'F'
                                end gender
  from student;
  
  

--Q. emp 테이블을 사용하여 연봉기준 등급을 아래의 기준에 맞게 표현하시오.
-- 2000미만 'C', 2000이상 3000이하 'B', 3000초과 'A'

--A. with decode
select ename, job, hiredate, sal,
       decode(sign(sal - 2000) + sign(sal - 3000), '-2', 'C', '2', 'A', 'B') grade
  from emp;


--A. with case when
select ename, job, hiredate, sal,
       case when sal < 2000 then 'C'
            when sal <= 3000 then 'B' -- filtering done for rows under 2000
                             else 'A' end grade
  from emp;

  