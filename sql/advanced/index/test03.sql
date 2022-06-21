-- preparing table
create table test03(
id int primary key not null auto_increment,
c1 char(10),
c2 char(10),
c3 char(10),
c4 char(10),
c5 char(10));

insert into test03(c1,c2,c3,c4,c5) values ('a1','a2','a3','a4','a5');
insert into test03(c1,c2,c3,c4,c5) values ('b1','b2','b3','b4','b5');
insert into test03(c1,c2,c3,c4,c5) values ('c1','c2','c3','c4','c5');
insert into test03(c1,c2,c3,c4,c5) values ('d1','d2','d3','d4','d5');
insert into test03(c1,c2,c3,c4,c5) values ('e1','e2','e3','e4','e5');

create index idx_test03_c1234 on test03(c1,c2,c3,c4);
SHOW INDEX FROM test03;

-- ================= Analyse use of index =================

                    -- simple --

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1';
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2';
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c3 = 'a3';
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c3 = 'a3' AND c4 = 'a4';


                    -- change order --

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c4 = 'a4' AND c3 = 'a3';
EXPLAIN SELECT * FROM test03 WHERE c4 = 'a4' AND c3 = 'a3' AND c2 = 'a2' AND c1 = 'a1';
-- change order will work too, just like 1 + 2 + 3 = 3 + 2 + 1, mysql will optimised it
-- we would better used the origin order could prevent that optimisation


                    -- not equal --

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c3 > 'a3' AND c4 = 'a4';
-- part of c3 index is used to sorted, cannot be used to search, and c4 not working
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c4 > 'a4' AND c3 = 'a3';
-- same as c1 = 'a1' and c2 = 'a2 and c3 = 'a3' and c4 > 'a4', so 4 index a,b,c,d used

                    -- order by --

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' and c4 = 'a4' ORDER BY c3;
-- two use of index, ordering and searching, c3 index is used to sort but search, not documented
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' ORDER BY c3;
-- index use is the same as above, it means c4 = 'a4' has no impact
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' ORDER BY c4;
-- using filesort, 9413

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c5 = 'a5' ORDER BY c2, c3;
-- only c1 column index is used, but c2, c3 used to sort, no filesort
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c5 = 'a5' ORDER BY c3, c2;
-- same as above but using file sort

EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' ORDER BY c2, c3;
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c5 = 'a5' ORDER BY c2, c3;
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 = 'a2' AND c5 = 'a5' ORDER BY c3, c2;

                        -- extra --
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 LIKE 'kk%' AND c3 = 'a3';
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 LIKE '%kk' AND c3 = 'a3';
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 LIKE '%kk%' AND c3 = 'a3';
EXPLAIN SELECT * FROM test03 WHERE c1 = 'a1' AND c2 LIKE 'K%kk%' AND c3 = 'a3';
-- working if like condition beginning with constant
