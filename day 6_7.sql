--Q. STUDENT, EXAM_01, DEPARTMENT ���̺��� ����Ͽ� 
--�� �л��� �̸�, �г�, ��������, ��1������, ��2�������� ��� ���
--��, ��2������ ���� ��� ��1������ ���


--A.
SELECT s.name, e.total score,
       d1.dname first_major,
       nvl(d2.dname, d1.dname) second_major
  FROM student s, department d1, department d2, exam_01 e 
 WHERE s.deptno1 = d1.deptno 
   AND s.deptno2 = d2.deptno(+) 
   AND s.studno = e.studno;
   
   
   
--Q. STUDENT ���̺��� �а���, ���� ���輺���� ��� ���

--A. 
SELECT d.dname major, 
       decode(substr(s.jumin, 7, 1), '1', 'M', 'F') gender, 
       round(avg(e.total), 2 ) average
  FROM student s, exam_01 e, department d 
 WHERE s.studno = e.studno 
   AND s.deptno1 = d.deptno
 GROUP BY d.dname, substr(s.jumin, 7, 1)
 ORDER BY major;
 
 
 
--Q. PROFESSOR, DEPARTMENT ���̺��� ����Ͽ� �� ������ �Ҽ��а����� �Ҽӱ����� pay�� ����� ���ϰ�,
--�Ҽ��а���, �Ҽ��а���ȣ, �Ҽ��а� ��ġ�� �Բ� ���

--A.
SELECT d.dname subject, d.deptno, d.build,
       round(avg(p.pay), 2) avg_pay
  FROM professor p, department d 
 WHERE p.deptno = d.deptno
 GROUP BY d.dname, d.deptno, d.build;
 
 
 
--Q. EMP2, P_GRADE ���̺��� ����Ͽ� �� ������ ���̸� ��������
--������ �̸�, ���, �������, ����, ���� ����(POSITION), ��������(���̷� ����� ����), 
--���� ���޿� �´� ���������� �ְ��� ������ ��� ���


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
 
 
--Q. emp2, dept2 ���̺��� �� ������ ���̰� �����鼭 
--��̰� ���� ������ ���� ������ �̸�, �μ��̸�, ���, 
--pay�� �Բ� ����Ͽ���.(���� ����, ��̰� ���� ���ᰡ ���� ������ ���)

--[����]
--�̸�      ���          �޿�       �μ���  ģ����(�� ������ ���̿� ��̰� ���� �����)
--������	����	    20000000	����4��	    0
--�蹮ȣ	���	    35000000	S/W����	    0
--�輳��	����	    30000000	����2��	    0
--������	���ǰ���	100000000	�����	    0
--���Ѷ�	����	    20000000	S/W����	    1
--����ȣ	����	    68000000	������	    0


--A.
select e1.name �̸�, e1.hobby ���, e1.pay �޿�, d.dname �μ���, 
       count(e2.name) ģ����
  from emp2 e1, emp2 e2, dept2 d
 where to_char(sysdate, 'YYYY') - to_char(e1.birthday, 'YYYY') = 
       to_char(sysdate, 'YYYY') - to_char(e2.birthday(+), 'YYYY')
   and e1.hobby = e2.hobby(+) 
   and e1.empno != e2.empno(+)
   and e1.deptno = d.dcode
 group by e1.name, e1.hobby, e1.pay, d.dname
 order by �̸�;
 
 

--Q. student ���̺��� �� �л����� ���� ���� �� �����԰� ���� ������ �л��� ����
--�� �л��� �̸��� �г�, ������, ���� ���� ���(������ �����԰� ���� ���� ������ �л��� ���)

--�̸�   �г� ������ ���� �л���(���κ��� �����԰� ���� ������ ģ�� ��)
--������	3	  58	79	 0
--�蹮ȣ	2     51	82	 11
--��ſ�	3	  48	92	 5
--�����	4	  83	62	 0
--������	1	  81	83	 2
--...


--A.
select s1.name �̸�, s1.grade �г�, s1.weight ������, e.total ����, count(s2.name) �л���
  from student s1, student s2, exam_01 e
 where substr(s1.jumin, 7, 1) = substr(s2.jumin(+), 7, 1)
   and s1.weight < s2.weight(+)
   and s1.studno = e.studno 
 group by s1.name, s1.grade, s1.weight, e.total
 order by 1;