-- dont turn on this feature on production enviroment

set global general_log = 1;
set global log_output='TABLE';

SELECT * FROM mysql.general_log;