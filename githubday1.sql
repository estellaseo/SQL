--Q. STUDENT ���̺��� �� �л��� ��ȭ��ȣ�� �Ʒ� ���ÿ� ���� �����Ͻÿ�.

--����) 
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
  
  
  
--Q. EMP ���̺��� �̿��Ͽ� ������� �ٹ��ϼ��� YY�� MM���� DD�� ���·� ����Ͻÿ�.

select * 
  from emp;

--A.
select ename, sysdate, hiredate,
       trunc(months_between(sysdate, hiredate)/12)||'�� '||
       trunc(mod(months_between(sysdate, hiredate), 12))||'���� '||
       trunc(sysdate - add_months(hiredate, trunc(months_between(sysdate, hiredate))))||'��' workday       
  from emp; 
  


--Q. STUDENT ���̺��� ����Ͽ� �� �л��� �̸�, �г�, ������ ����Ͻÿ�.
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
  
  

--Q. emp ���̺��� ����Ͽ� �������� ����� �Ʒ��� ���ؿ� �°� ǥ���Ͻÿ�.
-- 2000�̸� 'C', 2000�̻� 3000���� 'B', 3000�ʰ� 'A'

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

  