-- ==================== single table ====================
-- preparing table

use webpage;
drop table article;

CREATE TABLE IF NOT EXISTS article
(
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    author_id   INT(10) UNSIGNED NOT NULL,
    category_id INT(10) UNSIGNED NOT NULL,
    views       INT(10) UNSIGNED NOT NULL,
    comments    INT(10) UNSIGNED NOT NULL,
    title       VARBINARY(255)   NOT NULL,
    content     TEXT             NOT NULL
);
INSERT INTO article(author_id, category_id, views, comments, title, content)
VALUES (1, 1, 1, 1, 1, 1),
       (2, 2, 2, 2, 2, 2),
       (1, 1, 3, 3, 3, 3);

-- test table
SELECT * FROM  article;

-- query the article_id which has category_id = 1 and comments > 1
EXPLAIN 
select *
from article
where category_id = 1
  and comments > 1
order by views desc
limit 1;       
--  type 'all' means searched all, 'using filesort' means it sorted when runing

-- show INDEX 
show INDEX FROM article;

-- create INDEX 
-- ALTER TABLE article ADD INDEX idx_article_ccv (category_id, comments, views);
-- SHOW INDEX FROM article;
-- DROP INDEX idx_article_ccv ON article;
-- SHOW INDEX FROM article;

CREATE INDEX idx_article_ccv ON article(category_id, comments, views);
SHOW INDEX FROM article;
-- goto line 25 and test
-- if using range, the following indexes will not work
EXPLAIN 
select *
from article
where category_id = 1
  and comments = 1
order by views desc
limit 1; 

DROP INDEX idx_article_ccv ON article;
CREATE INDEX idx_article_cv    ON article(category_id, views);
show INDEX FROM article;
-- goto line 47 to test cv INDEX, result is Using where, it is working

-- ==================== double table ====================
 /* preparing table */
CREATE TABLE IF NOT EXISTS `class`(
`id` INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
`card` INT (10) UNSIGNED NOT NULL
);
CREATE TABLE IF NOT EXISTS `book`(
`bookid` INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
`card` INT (10) UNSIGNED NOT NULL
);

-- TRUNCATE TABLE class;
INSERT INTO class(`card`) VALUES
(FLOOR(1 + (RAND() * 20))),
(FLOOR(1 + (RAND() * 20))),
(FLOOR(1 + (RAND() * 20))),
(FLOOR(1 + (RAND() * 20))),
(FLOOR(1 + (RAND() * 20))),
(FLOOR(1 + (RAND() * 20))),
(FLOOR(1 + (RAND() * 20))),
(FLOOR(1 + (RAND() * 20)))
;

INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO class(card)VALUES(FLOOR(1+(RAND()*20)));
 
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO book(card)VALUES(FLOOR(1+(RAND()*20)));


SELECT * FROM class;
SELECT * FROM book;

SELECT * FROM book INNER JOIN class ON book.card = class.card;
EXPLAIN 
SELECT * FROM class LEFT JOIN book ON class.card =  book.card;

SHOW INDEX FROM book;
-- test INDEX on left table
ALTER TABLE book ADD INDEX Y (card);
EXPLAIN SELECT * FROM book LEFT JOIN class ON book.card =  class.card;
-- when index is added to left table, it is using index on book, book table type:index, both table rows:20
-- test index on right TABLE
DROP INDEX Y ON book;
CREATE INDEX ON class(card);
EXPLAIN SELECT * FROM book LEFT JOIN class ON book.card =  class.card;

-- when index is added to right table, ts using index on right table, right tab type: ref, rows:1, left table rows:20
;
-- conclusion: when index in on left table, using right join, when index is on right table, using left join

-- 
-- for inner join, when where is only one index on a table, is will be used, type: ref
-- if both have a index, the index on right table will be used

-- ==================== tripple table ====================

-- preparing TABLE 
CREATE TABLE IF NOT EXISTS `phone`(
    `phoneid` INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `card` INT (10) UNSIGNED NOT NULL
);

INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card)VALUES(FLOOR(1+(RAND()*20)));

SELECT * FROM phone;

-- tripple table links
EXPLAIN 
SELECT
  *
FROM
  book
  LEFT JOIN class ON book.card = class.card
  LEFT JOIN phone ON book.card = phone.card; 

-- create index on the following table
  CREATE INDEX Y on class(card);
  CREATE INDEX Z on phone(card);

-- class and phone used index, both type: ref
-- type both are ref mean optimised well, so index show be created on table frequently queried

-- ==================== conclusion ====================

-- reduce total count times of NestedLoop in 'join' statement: always be using the small result set to drive big result set
  -- for exaple, using book categories to drive book names, obviously there is a lot more book names than book categories

-- make sure the column of JOIN condition on table drived is indexed

-- when it is not able to make sure it is indexed and the computer resource is sufficient, dont be stingy of the JoinBuffer config of setting