--  ORDER BY subquery, try to use 'Index' to sort, not 'FileSort' 


create table tblA(
#id int primary key not null auto_increment,
age int,
birth timestamp not null
);

insert into tblA(age, birth) values(22, now());
insert into tblA(age, birth) values(23, now());
insert into tblA(age, birth) values(24, now());

create index idx_A_ageBirth on tblA(age, birth);

select * from tblA;

-- ======================

EXPLAIN SELECT * FROM tblA WHERE age > 20 ORDER BY age;
EXPLAIN SELECT * FROM tblA WHERE age > 20 ORDER BY age, birth;
EXPLAIN SELECT * FROM tblA WHERE age > 20 ORDER BY birth;

-- when 'order by' column order is the same as indexes, indexes will be used

EXPLAIN SELECT * FROM tblA WHERE age > 20 ORDER BY birth, age;
-- 'where' condition can be optimised, but ORDER BY must follow the ORDER strictly 
EXPLAIN SELECT * FROM tblA ORDER BY birth;
EXPLAIN SELECT * FROM tblA WHERE birth > '2016-01-28 00:00:00' ORDER BY birth;
EXPLAIN SELECT * FROM tblA WHERE birth > '2016-01-28 00:00:00' ORDER BY age;
EXPLAIN SELECT * FROM tblA ORDER BY age ASC , birth DESC;
-- when sorting direction is different will use FileSort, by default index is sorted ASC
-- mysql supports two kinds of sorting, Index and FileSort, Index is finished, more efficient

-- 'ORDER BY' will use Index if the two condition are sufficiant:
    -- 'ORDER By' use index top LEFT column
    -- Using 'Where' substatement with 'Order' substatement suffice Top Left


-- ================= sort_buffer ==================
when sort_buffer size is small, it could cause single way sort to load multiple times,
if this happens, we need to contact DBA to adujust the size

-- increase sort_buffer_size
-- increase max_length_for_sort_data


-- ======================== conclution ========================
1, when Using 'ORDER BY', try not to use 'select *':
    1, when the total length to query is lesser than max_length_for_sort_data, and column is not TEXT|BLOB,
        single way sorting will be used, else use classic method: multiple way sorting
    2, the two algrithm could both surpass the capacity of sort_buffer, causing creating temparary table to store data and multiple IO
        , but using single way sorting risk more, so we need to adjust the sort_buffer size

2, increase sort_buffer_size
3, increase max_length_for_sort_data


======================= sorting optimisation ==================

    mysql has two soring methods: Index and FileSort
    mysql can use the index to query or sort with the same columns

        KEY a_b_c(a,b,c)

        order by can use the most left prefix
        - ORDER BY a
        - ORDER BY a,b
        - ORDER BY a,b,c
        - ORDER BY a DESC ,b DESC ,c DESC 
        - ORDER BY a ASC ,b ASC, c ASC  

        if the most left prefix is constant, 'order by' can use INDEX (not using FileSort)
        - WHERE a = const ORDER BY b,c
        - WHERE a = const AND b = const ORDER BY b,c
        - WHERE a = const ORDER BY b,c
        - WHERE a = const ORDER BY b > const ORDER BY b,c

        cannot use index to sort(using FileSort)
        -- ORDER BY a ASC, b DESC, c DESC       # sorting direction is not the same
        -- WHERE g = const ORDER BY b,c         # lost 'a' index
        -- WHERE a = const ORDER BY C           # lost 'b' index
        -- WHERE a = const ORDER BY a,d         # d is not part of index
        -- WHERE a in(...) ORDER BY b,c         # for sorting, multiple euqal conditon is rang query, please use const