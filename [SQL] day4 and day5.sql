--Q. STUDENT ���̺��� �� �л��� ��ȭ��ȣ�� �Ʒ� ���ÿ� ���� �����Ͻÿ�.

--����) 
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
  
  
  
  
--Q. EMP ���̺��� �̿��Ͽ� ������� �ٹ��ϼ��� YY�� MM���� DD�� ���·� ����Ͻÿ�.

--A.
SELECT ename, sysdate, hiredate,
       trunc(months_between(sysdate, hiredate)/12)||'�� '||
       trunc(mod(months_between(sysdate, hiredate), 12))||'���� '||
       trunc(sysdate - add_months(hiredate, trunc(months_between(sysdate, hiredate))))||'��' workday       
  FROM emp; 
  



--Q. STUDENT ���̺��� ����Ͽ� �� �л��� �̸�, �г�, ������ ����Ͻÿ�.
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
  
  

--Q. emp ���̺��� ����Ͽ� �������� ����� �Ʒ��� ���ؿ� �°� ǥ���Ͻÿ�.
-- 2000�̸� 'C', 2000�̻� 3000���� 'B', 3000�ʰ� 'A'

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

  