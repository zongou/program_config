-- analyse resource usage, can be used to optimism sql

-- check
    show variables like 'profiling';

-- set
    set profiling=on;

SELECT * FROM tbl_emp e INNER JOIN tbl_dept d ON e.deptId = d.id;

SHOW profiles;
SHOW profile cpu,block io for query 2;
-- options: 
    ALL
    BLOCK IO
    CONTEXT SWITCHES
    CPU
    IPC
    MEMORY
    PAGE FAULTS
    SOURCE SWAPS

-- problem hints:
    converting HEAP to MyISAM result is big
    Creating tmp table
    Copying to tmp table on disk, this costs a lot performance
    locked


-- ====================== batch scripts ======================
-- create big_data TABLE 
create TABLE dept
(
    id     int UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    deptno MEDIUMINT UNIQUE NOT NULL DEFAULT 0,
    dname  VARCHAR(20)      NOT NULL DEFAULT "",
    loc    VARCHAR(13)      NOT NULL DEFAULT ""
);

CREATE TABLE emp
(
    id       INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    empno    MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    ename    VARCHAR(20)        NOT NULL DEFAULT "",
    job      VARCHAR(9)         NOT NULL DEFAULT "",
    mgr      MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    hiredate DATE               NOT NULL,
    sal      DECIMAL(7, 2)      NOT NULL,
    comm     DECIMAL(7, 2)      NOT NULL,
    deptno   MEDIUMINT UNSIGNED NOT NULL DEFAULT 0
);

-- if reports error creating function: This function has none of DETERMINISTIC...
-- because we enabled slow_query, we enabled bin-log, we must define a parameter for function
SHOW variables LIKE '%log_bin_trust_function_creators';
SET global log_bin_trust_function_creators = 1;

-- this does not work the next start, to persist always:
-- edit my.ini or my.cnf
	[mysqld]
    log_bin_trust_function_creators=1

-- FUNCTION to CREATE random str
DELIMITER $$
CREATE FUNCTION rand_string(n INT) RETURNS VARCHAR(255)
BEGIN
    Declare CHAR_str VARCHAR(100) default 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE return_str varchar(255) default '';
    declare i int default 0;
    while i < n
        DO
            set return_str = concat(return_str, substring(CHAR_str, floor(1 + rand() * 52), 1));
            set i = i + 1;
        end while;
    return return_str;
END $$

-- FUNCTION to return random num
DELIMITER $$
CREATE FUNCTION rand_num() RETURNS INT (5)
BEGIN 
	declare i INT default 0;
	SET i = floor(100 + rand()*10);
	RETURN i;
END $$


# 1、函数：向dept表批量插入
DELIMITER $$
CREATE PROCEDURE insert_dept(IN START INT(10),IN max_num INT(10))
BEGIN
DECLARE i INT DEFAULT 0;
    SET autocommit = 0;
    REPEAT
    SET i = i + 1;
    INSERT INTO dept(deptno,dname,loc) VALUES((START + i),rand_string(10),rand_string(8));
    UNTIL i = max_num
    END REPEAT;
    COMMIT;
END $$

# 2、函数：向emp表批量插入
DELIMITER $$
CREATE PROCEDURE insert_emp(IN start INT(10), IN max_num INT(10))
BEGIN 
	declare i INT default 0;
	set autocommit = 0;
	repeat
		SET i = i + 1;
		INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) 
		values((start+i), rand_string(6),
				'SALEMAN', 0001, curdate(), 2000, 400, rand_num()
		);
		until i = max_num
		end repeat;
		commit;
END $$

-- process
DELIMITER ;
CALL insert_dept(100,10);

SELECT * FROM dept;

CALL insert_emp(100001,500000);