--Q. 다음 뷰를 사용하여 desc emp 결과와 동일하게 출력
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
  
  

--Q. 아래 테이블 생성 및 작업 후 시간대별 가장 인기있는 업종
create table delivery(
일자          varchar2(10),
시간대        varchar2(10),
업종          varchar2(40),
시도          varchar2(20),
시군구        varchar2(20),
읍면동        varchar2(20),
통화건수      number);


select count(*) from delivery;
select * from delivery;


-- view 생성
create view view_order_some as select 시간대, 업종, sum(통화건수) 주문
  from delivery
 group by 시간대, 업종
 order by 시간대, 주문 desc;
 

 
-- 시간대별 업종, 주문수 
select * from view_order_some;


-- 시간대별 가장 인기있는 업종
select v1.시간대, v1.업종, i.order_count 주문수
  from view_order_some v1, (select 시간대, max(주문) order_count
                   from view_order_some
                  group by 시간대
                  order by 시간대) i 
 where v1.주문 = i.order_count;
 
 
 