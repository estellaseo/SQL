--Q. student ���̺��� ���������̸鼭 ���� ������ ģ���� ������� ���ϰ�, 
--   �� �л��� ��� �����̸��� �Բ� ��µǵ��� �Ͽ���.
--   ��, ��������(��ȭ��ȣ �÷� ���), ���� ����(�ֹι�ȣ ���)�� ������ ���Ե� �� ����.
 

--A.
--ORACLE STANDARD
select s.name �̸�, count(s2.studno) ģ����, p.name ������
  from student s, student s2,  professor p 
 where substr(s.tel, 1, instr(s.tel, ')')-1) = substr(s2.tel(+), 1, instr(s2.tel(+), ')')-1)
   and substr(s.jumin, 7, 1) = substr(s2.jumin(+), 7, 1)
   and s.studno != s2.studno (+)
   and s.profno = p.profno (+)
 group by s.name, p.name
 order by s.name;
 
 
--ANSI STANDARD
select s.name �̸�, count(s2.studno) ģ����, p.name ������
  from student s left outer join student s2
    on substr(s.tel, 1, instr(s.tel, ')')-1) = substr(s2.tel, 1, instr(s2.tel, ')')-1)
   and substr(s.jumin, 7, 1) = substr(s2.jumin, 7, 1)
   and s.studno != s2.studno
  left outer join professor p 
    on s.profno = p.profno
 group by s.name, p.name
 order by s.name;
 



 
--Q. emp, dept ���̺��� �̿��Ͽ� ���ΰ� ������������ ��տ������� ���� ������ �޴� ������
--   �̸�, �μ���, ����, ���������ڸ��� ����Ͽ���.


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
 




--Q. ������ �� �л����� ���� �г� �� ������ �� �� �� ģ���� ���� �л��̸�, ��1������, 
--   �г�, ���輺���� �Բ� ���(��, ���κ��� ������ �� �� ģ���� ��� ���)


--A.
--ORACLE STANDARD
select i1.name, d.dname, i1.grade, i1.total, count(i2.name) as ģ����
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
select i1.name, d.dname, i1.grade, i1.total, count(i2.name) as ģ����
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





--Q. emloyees ���̺��� ����Ͽ� �� ������ �Ի絿��(�Ի��� �ذ� ���� ���)�� ����
--   �� ������ �̸�, ����, ���������� �̸�(first_name) ������ �Բ� ���
--   ��, �Ի絿�⿡ ������ �������� �ʴ´�
--   (�Ի� ���Ⱑ ���� ���, ���������ڰ� ���� ��쵵 ���)


--A.
--ORACLE STANDARD
select e1.first_name, e1.hire_date, e1.salary, e3.first_name as ����������,
       count(e2.first_name) as ����� 
  from employees e1, 
       employees e2,
       employees e3
 where to_char(e1.hire_date, 'YYYY') = to_char(e2.hire_date(+), 'YYYY') 
   and e1.employee_id != e2.employee_id(+)
   and e1.manager_id = e3.employee_id(+)
 group by e1.first_name, e1.hire_date, e1.salary, e3.first_name;
 

--ANSI STANDARD
select e1.first_name, e1.hire_date, e1.salary, e3.first_name as ����������,
       count(e2.first_name) as ����� 
  from employees e1 left outer join employees e2 
    on to_char(e1.hire_date, 'YYYY') = to_char(e2.hire_date, 'YYYY')
   and e1.employee_id != e2.employee_id
  left outer join employees e3
    on e1.manager_id = e3.employee_id
 group by e1.first_name, e1.hire_date, e1.salary, e3.first_name;






