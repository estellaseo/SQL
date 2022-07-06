-- UNION / UNION ALL
select ename, lpad(deptno, 4, 0) deptno, hiredate, sal, nvl(comm, 0) comm
  from emp
 union all
select name, deptno, sysdate, pay/10000, 0
  from emp2;
  
  
-- INTERSECT
select ename, deptno, sal 
  from emp_1020
intersect
select ename, deptno, sal 
  from emp_10;
  

-- MINUS
select ename, deptno, sal 
  from emp_1020
 minus
select ename, deptno, sal 
  from emp_10;