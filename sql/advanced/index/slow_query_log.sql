-- check:
SHOW variables LIKE '%slow_query_log%';

-- enable: 
set global slow_query_log = 1;
-- if not for optimisation, it is not recommanded to turn it on, it influences the performance
-- this works only on current database, restart server will fail it
-- to make it work always, change th my.cnf
[mysqld]
    show_query_log=1
    slow_query_log_file=/var/lib/mysql/atguigu-slow.log

      -- default log name is host_name-slow.log
      -- if using docker, log file is at where docker is mounted

-- long_query_time
  -- check
show variables like '%long_query_time%';
-- default time: 10s, we can change it in cli or config
-- verify if query time > long_query_time, not >=

-- set
set global long_query_time = 3;
-- this works for next connect, restart to check it, or check global variable

-- test
SELECT sleep(4);

-- show slow queries count (repeat counts)
SHOW global status like '%Slow_queries';
-- this can test system health status

-- log analyse tool: mysqldumpslow
-- https://www.bilibili.com/video/BV1KW411u7vy?p=49

mysqldumpslow --
help
    -- examples:
    -- 10 sql returns the max resultset:
    mysqldumpslow -s t -t 10 /var/lib/mysql/xxx- slow.log

    -- 10 sql most visits:
    mysqldumpslow -s c -t 10 /var/lib/mysql/xxx- slow.log

    -- 10 sql contains left join statement queries
    mysqldumpslow -s t -t 10 -g "left join" /var/lib/mysql/xxx- slow.log

    -- use with | more
    mysqldumpslow -s r -t 10 /var/lib/mysql/xxx- slow.log | more
