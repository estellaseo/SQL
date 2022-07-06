--[SINGLE-ROW SUBQUERY] ������ ��������

--SMITH�� ���� �μ� ������ �̸� �μ���ȣ ���(SMITH�� ����)
select ename, deptno
  from emp
 where deptno = (select deptno
                   from emp
                  where ename = 'SMITH');
                  




--[MULTIPLE-ROW SUBQUERY] ������ ��������

--1. �̸��� A�� �����ϴ� ������ ���� �μ��� �ִ� ������ �̸�, �μ���ȣ ���
select *
  from emp
 where deptno in (select deptno            
                    from emp
                   where ename like 'A%');
 
 
 
--2. EMP ���̺��� �̸��� A�� �����ϴ� ������ sal���� ū ���� ���

--A 1) �����ڿ� ������ ����(�� ���� ���ϵǵ���)   
select *
  from emp
 where sal > (select max(sal)
                from emp
               where ename like 'A%'); 
               
--A 2) �����ڸ� ������ �°� ����(���� �࿡ �񱳵ǵ���)
select *
  from emp
 where sal > all (select sal                
                    from emp
                   where ename like 'A%'); 




--[MULTI-COLUMN SUBQUERY] �����÷� ��������

--1. emp ���̺��� �� �μ��� �ִ뿬���� ���
select *
  from emp
 where (deptno, sal) in (select deptno, max(sal)
                          from emp
                         group by deptno);




--2. professor ���̺��� position�� �Ի����� ���� ���� ������ �̸�, position, �Ի���, �а��� ���
select position, min(hiredate)
  from professor
 group by position;

select name, position, hiredate, d.dname
  from professor p, department d
 where (position, hiredate) in (select position, min(hiredate)
                                  from professor
                                 group by position)
   and p.deptno = d.deptno;
   
   
   
--3. professor ���̺��� �� position�� �ִ� �޿��� �޴� ������ �̸�, position, �Ҽ��а���, �����л� ���� ���Ͽ���
select p.name, p.position, d.dname, count(s.name) as �����л���
  from professor p, department d, student s
 where (p.position, p.pay) in (select position, max(pay) as max_pay
                                 from professor
                                group by position)
   and p.deptno = d.deptno
   and p.profno = s.profno(+)
 group by p.name, p.position, d.dname;
   



--[INLINE VIEW] �ζ��κ�

--1. �μ��� ��տ������� ���� ������ �޴� ���� ���
select * 
  from emp e, (select deptno, avg(sal) as avg_sal
                 from emp
                group by deptno) i 
 where e.deptno = i.deptno
   and e.sal > i.avg_sal
 order by e.deptno;  



--2. STUDENT ���̺��� �� �г⺰ �������� ��պ��� ���� �л��� �̸�, �а���, �г�, ������ ���
select s.name, d.dname, s.grade, s.weight
  from student s, department d,
       (select grade, avg(weight) as avg_weight
          from student
         group by grade) i
 where s.deptno1 = d.deptno
   and s.grade = i.grade
   and s.weight < i.avg_weight;
   
   
   
 --3. professor ���̺��� �� position�� �ִ� �޿��� �޴� ������ �̸�, position, �Ҽ��а���, �����л� ���� ���Ͽ���
select p.name, d.dname, p.position, p.pay, i.max_pay,
       count(s.name) as �����л���
  from professor p, (select position, max(pay) as max_pay
                       from professor
                      group by position) i,
       department d, student s
 where p.position = i.position
   and p.pay = i.max_pay
   and p.deptno = d.deptno
   and p.profno = s.profno(+)
 group by p.name, d.dname, p.position, p.pay, i.max_pay;
 
 
 
--4. emp2 ���̺��� �¾ ������ ��տ������� ���� ������ �޴� ������ �̸�, �ҼӺμ���, ���������ڸ�(PEMPNO ���)�� �Բ� ���
select e.name, d.dname, e.pay, i.avg_pay, e2.name as ���������ڸ�
  from emp2 e, 
       (select to_char(e.birthday, 'yyyy') as birth_year, avg(pay) as avg_pay
          from emp2 e
         group by to_char(e.birthday, 'yyyy')) i, 
       dept2 d, emp2 e2
 where to_char(e.birthday, 'yyyy') = i.birth_year
   and e.pay < avg_pay
   and e.deptno = d.dcode
   and e.PEMPNO = e2.empno;
   
   
   
   
--[CORRELATED SUBQUERY] ��ȣ���� ��������   

--1. student ���̺��� ����Ͽ� �� ���� Ű�� ���� ū �л��� �̸�, ����, Ű�� ���
select name, substr(jumin,7,1) as ����, height
  from student s1
 where height = (select max(height)
                   from student s2
                  where substr(s1.jumin,7,1) = substr(s2.jumin,7,1));
 
 

--2. emp ���̺��� �� �μ����� �Ի����� ���� ���� ����� �̸�, �μ���ȣ, �޿� ���
select deptno, min(hiredate)
  from emp
 group by deptno;
 
select e1.ename, e1.deptno, e1.sal
  from emp e1
 where e1.hiredate = (select min(hiredate)
                        from emp e2
                       where e1.deptno = e2.deptno);
                       
                       
                       
                       
 --[SCALAR SUBQUERY] ��Į�� ��������
 
 --student, exam_01, hakjum ���̺��� ����Ͽ� �� �л��� �̸�, ����, ���� ���. ��, ��Į�� �������� �� �� ���
select (select s.name
          from student s
         where s.STUDNO = e.STUDNO) as �̸�,
       e.TOTAL,
       (select h.GRADE
          from hakjum h
         where e.TOTAL between h.MIN_POINT and h.MAX_POINT) as ����
 from exam_01 e;
  
  
  
  
  