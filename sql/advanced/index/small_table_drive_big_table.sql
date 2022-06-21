
for (int i = 5){
    for(int j=1000){

    }
}

==================
for (int i = 1000){
    for(int j=5){

    }
}


we would better choose upper one
database connect and release would costs lots of resource

============== 
-- optimise rule: small table to drive big table, means small data set to drive big data set
-- when result set in 'in' is small, use in, else use EXISTS 
-- 'in' and 'exists' will cause all table scan if indexes not exists

select * from A where id in (select id from B)

-- equals

for select id from B
    for select * from A where A.id = B.id
-- =========================================
-- when B table must be smaller than A table, use in is better than exists

select * from A where exists (select 1 from B where B.id = A.id)
-- exists () return true or false, SELECT 1 or x will ignore SELECT lists, there is no difference
-- equals

for select * from A
    for select * from B where B.id = A.id

EXISTS :
    SELECT ... FROM table WHERE EXISTS(subquery)
    -- verify if keep result or not in exists condition
    
-- ============ relavent
SELECT * FROM tbl_emp e where e.deptId in (SELECT id form tbl_dept d);
SELECT * FROM tbl_emp e where exists (SELECT 1 FROM tbl_dept d where d.id = e.deptId)
