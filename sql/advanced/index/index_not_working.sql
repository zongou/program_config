1, all value match is my favorite
2, best left front policy

3, dont do any operation on indexes( calculation, function,(auto or manually) type convertion), will causing indexes not working and forward to all table scan
4, the storage engine cannot use the right column of the range conditon
5, use CoveringIndex as much as you can(query that only visiting index(columns of index are the same with the query conditon)), try not to use 'SELECT *'
6, mysql cannot use index when using not equal(!=,>,<) and will scan through all rows
7, is null, is not null cannot use index
8, like statement start with wildcard('%abc...'), mysql indexes not working and table scan all
9, charater not using single quote will cause indexes not working
10, using 'or' to link will cause index not working


-- prepaing table
CREATE TABLE staffs(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(24)NOT NULL DEFAULT'' COMMENT'姓名',
`age` INT NOT NULL DEFAULT 0 COMMENT'年龄',
`pos` VARCHAR(20) NOT NULL DEFAULT'' COMMENT'职位',
`add_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT'入职时间'
)CHARSET utf8 COMMENT'员工记录表';
INSERT INTO staffs(`name`,`age`,`pos`,`add_time`) VALUES('z3',22,'manager',NOW());
INSERT INTO staffs(`name`,`age`,`pos`,`add_time`) VALUES('July',23,'dev',NOW());
INSERT INTO staffs(`name`,`age`,`pos`,`add_time`) VALUES('2000',23,'dev',NOW());

ALTER TABLE staffs ADD INDEX index_staffs_nameAgePos(`name`,`age`,`pos`);

-- ==============================================

-- 1, all value match is my favorite
    EXPLAIN SELECT * FROM staffs WHERE name = 'July';
    -- index partly used, working
    EXPLAIN SELECT * FROM staffs WHERE name = 'July' AND age = 25;
    EXPLAIN SELECT * FROM staffs WHERE name = 'July' AND  age = 25 AND pos = 'dev';

-- 2, best left front policy
    EXPLAIN 
    SELECT * FROM staffs WHERE age = 23 AND pos = 'dev';
    -- index not used
    EXPLAIN 
    SELECT * FROM staffs WHERE pos = 'dev';
    -- index not used

    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July';
    -- using index condition

    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July' AND pos = 'dev';
    -- ref: const,  only part of the index is used, best left front policy
    -- head must remains, body must continues

-- 3, dont do any operation on indexes( calculation, function,(auto or manually) type convertion), will causing indexes not working and forward to all table scan
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July';
    -- index used

    EXPLAIN 
    SELECT * FROM staffs WHERE left(name,4) = 'July';
    -- wrapped function outer of indexed column, INDEX not used

-- 4, the storage engine cannot use the right column of the range conditon
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July';
    -- key_len: 74
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July' AND age = 25;
    -- index working
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July' AND age = 25 AND pos = 'manager';
    -- key_len: 140
    -- index working

    EXPLAIN
    SELECT * FROM staffs WHERE name = 'July' AND age > 25 AND pos = "manager";
    -- key_len: 78, age index is used
    -- type becomes range, query according to age sorted, and pos index not working
    -- index after range is not working


-- 5, use CoveringIndex as much as you can(query that only visiting index(columns of index are the same with the query conditon)), try not to use 'SELECT *'
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July';

    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July' AND age = 25;

    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July' AND age = 25 AND pos = 'dev';
    -- Extra: Using where,      search in table

    EXPLAIN 
    SELECT name, age, pos FROM staffs WHERE name = 'July' AND age = 25 AND pos = 'dev';
    -- Extra: Using where; Using index,     get from index directly

    EXPLAIN 
    SELECT name, age, pos FROM staffs WHERE name = 'July' AND age > 25 AND pos = 'dev';
    -- Extra: Using where; Using index      not range, get data from index

    EXPLAIN 
    SELECT name, age, pos FROM staffs WHERE name = 'July' AND age = 25;
    -- Extra: Using where; Using index       get data from index

-- 6, mysql cannot use index when using not equal(!=,>,<) and will scan through all rows
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July';
    -- type: ref
    -- key: index_staffs_nameAgePos         index used

    EXPLAIN 
    SELECT * FROM staffs WHERE name != 'July';
    -- type: ALL
    -- key: (NULL)
    -- even through it will make index not working, but according to transaction we will use it

-- 7, is null, is not null cannot use index
    EXPLAIN 
    SELECT * FROM staffs WHERE name is NULL;
    -- key: (NULL)
    -- type: (NULL)
    -- Extra: Impossible WHERE

    EXPLAIN
    SELECT * FROM staffs WHERE name IS NOT NULL;
    -- key: (NULL)
    -- type: ALL
    -- Extra: Using where

-- 8, like statement start with wildcard('%abc...'), mysql indexes not working and table scan all, the following index not working
    EXPLAIN 
    SELECT * FROM staffs WHERE name LIKE '%July%';
    -- type: ALL
    -- key: (NULL)

    EXPLAIN 
    SELECT * FROM staffs WHERE name LIKE '%July';
    -- type: ALL
    -- key: (NULL)

    EXPLAIN 
    SELECT * FROM staffs WHERE name LIKE 'July%';
    -- type: range
    -- key: index_staffs_nameAgePos
    -- so '%' better be added to the right when using 'like'

    --  solve problems using CoveringIndex
    -- preparing table



    CREATE TABLE `tbl_user`(
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) DEFAULT NULL,
    `age`INT(11) DEFAULT NULL,
    `email` VARCHAR(20) DEFAULT NULL,
    PRIMARY KEY(`id`)
    )ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

    INSERT INTO tbl_user(`name`,`age`,`email`)VALUES('1aa1',21,'a@163.com');
    INSERT INTO tbl_user(`name`,`age`,`email`)VALUES('2bb2',23,'b@163.com');
    INSERT INTO tbl_user(`name`,`age`,`email`)VALUES('3cc3',24,'c@163.com');
    INSERT INTO tbl_user(`name`,`age`,`email`)VALUES('4dd4',26,'d@163.com');

    -- work to do
    SELECT * FROM tbl_user WHERE name LIKE '%aa%'; 

    SELECT * FROM tbl_user WHERE name LIKE 'aa%';
    -- no result

    -- before index
    EXPLAIN SELECT name, age FROM tbl_user WHERE name LIKE '%aa%'; 

    EXPLAIN SELECT id FROM tbl_user WHERE name LIKE '%aa%';
    EXPLAIN SELECT name FROM tbl_user WHERE name LIKE '%aa%';
    EXPLAIN SELECT age FROM tbl_user WHERE name LIKE '%aa%';

    EXPLAIN SELECT id, name FROM tbl_user WHERE name LIKE '%aa%';
    EXPLAIN SELECT id, name, age FROM tbl_user WHERE name LIKE '%aa%';
    EXPLAIN SELECT name, age FROM tbl_user WHERE name LIKE '%aa%';


    EXPLAIN SELECT * FROM tbl_user WHERE name LIKE '%aa%';
    EXPLAIN SELECT id, name, age, email FROM tbl_user WHERE name LIKE '%aa%';

    -- create index
    CREATE INDEX idx_user_nameAge ON tbl_user(name, age);



    
    -- DROP TABLE tbl_user;
-- 9, charater not using single quote will cause indexes not working
    EXPLAIN 
    SELECT * FROM staffs WHERE name = '2000';

    -- not using quote
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 2000;
    -- hidden type convertion from num to string by mysql, index not working

-- 10, using 'or' to link will cause index not working, use it as less as possible
    EXPLAIN 
    SELECT * FROM staffs WHERE name = 'July' OR name = 'z3';

    -- https://www.bilibili.com/video/BV1KW411u7vy?p=41 for conslusion memorics

-- ======================= Test ==========================
presumption: index(a,b,c)

where a = 3                                             | Y, a
where a = 3 and b = 5                                   | Y, a,b
where a = 3 and b = 5 and c = 4                         | Y, a,b
where b = 3 | where b = 3 and c = 4 | where c = 4       | N
where a = 3 and c = 5                                   | Y, a
where a = 3 and b > 4 and c = 5                         | Y, a,b
where a = 3 and b  like 'kk%' and c = 4                 | Y, a,b,c
where a = 3 and b  like '%kk' and c = 4                 | Y, a
where a = 3 and b  like '%kk%' and c = 4                | Y, a
where a = 3 and b  like 'k%kk%' and c = 4               | Y, a,b,c


