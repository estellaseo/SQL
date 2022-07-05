--Q. dept2 ���̺��� �̿��Ͽ� �����μ����� ������ ���� ��� -> "�濵�������� �����μ��� ����� �Դϴ�."
--   ��, �����μ��� ���� ���� ���κμ��� ���.


--A. 
--JOIN
select d1.dname||
       '�� �����μ��� '|| 
       nvl(d2.dname, d1.dname)
       ||' �Դϴ�.' �μ�����
  from dept2 d1, dept2 d2 
 where d1.pdept = d2.dcode(+);


--SCALAR SUBQUERIES
select d1.dname||
       '�� �����μ��� '||
       nvl((select d2.dname
              from dept2 d2 
             where d1.pdept = d2.dcode), d1.dname)
       ||' �Դϴ�.' �μ�����
  from dept2 d1;





--Q. professor ���̺��� �Ի�⵵(1980,1990,2000���...)�� ��տ������� ���� ������ �޴� ������ 
--   �̸�, �а���, ����, �����л� �� ���. (���� �л��� ���� ��� 0�� ���)


--A. 
--INLINE VIEW
select p.name, d.dname, p.pay, count(s.studno) as �л���
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
select p1.name, d.dname, p1.pay, count(s.studno) as �л���
  from professor p1, department d, student s 
 where p1.pay > (select avg(pay)
                   from professor p2 
                  where trunc(to_char(p1.hiredate, 'YYYY'), -1) = 
                        trunc(to_char(p2.hiredate, 'YYYY'), -1))
   and p1.deptno = d.deptno 
   and p1.profno = s.profno(+) 
 group by p1.name, d.dname, p1.pay;
 
 
 
 
 
--Q. emp ���̺��� �̿��Ͽ� �μ����� ���κ��� �Ի�⵵�� ���� ����� ���� �� ������ �̸�, �μ���� �Բ� ���.
--   ��, ������� ���� ��� ������ �����϶�.


--A. 
--JOIN
select e1.ename, d.dname, count(e2.ename) as �����
  from emp e1, emp e2, dept d 
 where e1.deptno = e2.deptno(+) 
   and e1.hiredate > e2.hiredate(+) 
   and e1.deptno = d.deptno 
 group by e1.ename, d.dname
 order by ����� desc;
 

--SCALAR SUBQUERIES
select e1.ename,
      (select d.dname 
         from dept d 
        where e1.deptno = d.deptno) as �μ���,
      (select count(e2.ename) 
         from emp e2 
        where e1.deptno = e2.deptno 
          and e1.hiredate > e2.hiredate) as ����� 
  from emp e1
 order by ����� desc;
 
 
 
 
 
 --Q. ���� ���·� ���(professor, student, exam_01, hakjum, department)
--    �������� �� ������ �����л����� ���輺���� ��հ�
--    �����л����� ���� ������ A,B,C,D�� �����ؼ� ����ϰ� ������ �Ҽ� �а��� �Բ� ���

--������         �����а���  �л��������   A�����ڼ�   B�����ڼ�   C�����ڼ�   D�����ڼ�
--�赵��	����Ʈ������а�	0	        0	        0	        0	        0
--�迵��	��Ƽ�̵����а�	87	        0	        1	        0	        0
--������	����Ʈ������а�	0	        0	        0	        0	        0
--���ѿ�	����Ʈ������а�	83	        0	        1	        0	        0
--�ٺ�	    ȭ�а��а�	        0	        0	        0	        0	        0
 
 
--A.
select p.name as ������, 
       d.dname as �����а���,
       round(nvl(avg(e.total), 0)) as �л��������, 
       count(decode(substr(h.grade, 1, 1), 'A', 1)) A�����ڼ�,
       count(decode(substr(h.grade, 1, 1), 'B', 1)) B�����ڼ�,
       count(decode(substr(h.grade, 1, 1), 'C', 1)) C�����ڼ�,
       count(decode(substr(h.grade, 1, 1), 'D', 1)) D�����ڼ�
  from professor p, department d, student s, exam_01 e, hakjum h 
 where p.deptno = d.deptno 
   and p.profno = s.profno(+) 
   and s.studno = e.studno(+) 
   and e.total between h.min_point(+) and h.max_point(+) 
 group by p.name, d.dname;

 
 
 
 
 