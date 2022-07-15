--Q. ���� �並 ����Ͽ� desc emp ����� �����ϰ� ���
create view emp_test as select * 
  from user_tab_columns
 where table_name = 'EMP';

select * from emp_test;

select column_name "Column", 
       case nullable when 'N' then 'NOT NULL'
                     when 'Y' then null end "Nullable",
       data_type||case when data_type = 'VARCHAR2' then '('||CHAR_COL_DECL_LENGTH||')'
                       when data_type = 'DATE' then null 
                       when data_type = 'NUMBER' and data_scale > 0 then '('||DATA_PRECISION||','||DATA_SCALE||')'  
                       when data_type = 'NUMBER' then '('||DATA_PRECISION||')' 
       end "Type", 
       DATA_TYPE_OWNER "Comment"
  from emp_test;
  
  

--Q. �Ʒ� ���̺� ���� �� �۾� �� �ð��뺰 ���� �α��ִ� ����
create table delivery(
����          varchar2(10),
�ð���        varchar2(10),
����          varchar2(40),
�õ�          varchar2(20),
�ñ���        varchar2(20),
���鵿        varchar2(20),
��ȭ�Ǽ�      number);


select count(*) from delivery;
select * from delivery;


-- view ����
create view view_order_some as select �ð���, ����, sum(��ȭ�Ǽ�) �ֹ�
  from delivery
 group by �ð���, ����
 order by �ð���, �ֹ� desc;
 

 
-- �ð��뺰 ����, �ֹ��� 
select * from view_order_some;


-- �ð��뺰 ���� �α��ִ� ����
select v1.�ð���, v1.����, i.order_count �ֹ���
  from view_order_some v1, (select �ð���, max(�ֹ�) order_count
                   from view_order_some
                  group by �ð���
                  order by �ð���) i 
 where v1.�ֹ� = i.order_count;
 
 
 