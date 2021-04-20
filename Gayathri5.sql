CREATE TABLE PROJECT1_BOOK_AUTHORS 
(
AUTHOR_ID NUMBER(38,0) NOT NULL,
ISBN10 CHAR(10 BYTE),
ISBN13 NUMBER(38,0),
CONSTRAINT BOOK_AUTHORS_PK PRIMARY KEY(AUTHOR_ID, ISBN10, ISBN13),
CONSTRAINT BOOK_AUTHORS_FK1 FOREIGN KEY(AUTHOR_ID)
REFERENCES PROJECT1_AUTHORS,
CONSTRAINT BOOK_AUTHORS_FK2 FOREIGN KEY(ISBN10,ISBN13)
REFERENCES PROJECT1_BOOKS
);

DROP TABLE PROJECT1_BOOK_AUTHORS;

CREATE TABLE PROJECT1_AUTHORS(
AUTHOR_ID NUMBER(38,0) NOT NULL,
NAME VARCHAR2(128 BYTE) NOT NULL,
CONSTRAINT AUTHORS_PK PRIMARY KEY(AUTHOR_ID)
);
DROP TABLE PROJECT1_AUTHORS;

CREATE TABLE PROJECT1_BOOK_LOANS(
LOAN_ID NUMBER(38,0) NOT NULL,
BOOK_ID CHAR(12 BYTE) NOT NULL,
CARD_NO VARCHAR2(26 BYTE) NOT NULL,
DATE_OUT DATE,
DATE_IN DATE,
DUE_DATE DATE,
CONSTRAINT BOOK_LOAN_PK PRIMARY KEY(LOAN_ID),
CONSTRAINT BOOK_LOANS_FK1 FOREIGN KEY(LOAN_ID)
REFERENCES PROJECT1_FINES,
CONSTRAINT BOOK_LOANS_FK2 FOREIGN KEY(BOOK_ID)
REFERENCES PROJECT1_BOOK_COPIES,
CONSTRAINT BOOK_LOANS_FK3 FOREIGN KEY(CARD_NO)
REFERENCES PROJECT1_BORROWERS
);

DROP TABLE PROJECT1_BOOK_LOANS;

CREATE TABLE PROJECT1_FINES(
LOAN_ID NUMBER(38,0) not null,
FINE_AMT NUMBER(38,0),
PAID VARCHAR2(28 BYTE),
CONSTRAINT FINES_PK PRIMARY KEY(LOAN_ID),
constraint fines_fk foreign key(loan_id) references project1_book_loans
);

DROP TABLE PROJECT1_FINES ;

CREATE TABLE PROJECT1_BOOKS(
ISBN10 CHAR(10 BYTE) NOT NULL,
ISBN13 NUMBER(38,0) NOT NULL,
TITLE VARCHAR2(256 BYTE) NOT NULL,
AUTHRO VARCHAR2(128 BYTE) NOT NULL,
COVER VARCHAR2(128 BYTE) NOT NULL,
PUBLISHER VARCHAR2(128 BYTE) NOT NULL,
PAGES NUMBER(38,0) NOT NULL,
CONSTRAINT ISBN PRIMARY KEY(ISBN10, ISBN13) 
);

DROP TABLE PROJECT1_BOOKS;

CREATE TABLE PROJECT1_BOOK_COPIES(
BOOK_ID CHAR(12 BYTE) NOT NULL,
BRANCH_ID NUMBER(38,0),
NO_OF_COPIES NUMBER(38,0),
ISBN10 CHAR(10 BYTE),
ISBN13 NUMBER(38,0),
CONSTRAINT BOOK_COPIES_PK PRIMARY KEY(BOOK_ID),
CONSTRAINT BOOK_COPIES_FK1 FOREIGN KEY(BRANCH_ID)
REFERENCES PROJECT1_LIBRARY_BRANCH,
CONSTRAINT BOOK_COPIES_FK2 FOREIGN KEY(ISBN10, ISBN13)
REFERENCES PROJECT1_BOOKS
);

CREATE TABLE PROJECT1_LIBRARY_BRANCH(
BRANCH_ID NUMBER(38,0) NOT NULL,
BRANCH_NAME VARCHAR2(26 BYTE) NOT NULL,
ADDRESS VARCHAR2(128 BYTE) NOT NULL,
CONSTRAINT BRANCH_ID PRIMARY KEY(BRANCH_ID)
);

CREATE TABLE PROJECT1_BORROWERS(
CARD_NO VARCHAR2(26 BYTE) NOT NULL,
SSN VARCHAR2(26 BYTE),
FIRST_NAME VARCHAR2(26 BYTE) NOT NULL,
LAST_NAME VARCHAR2(26 BYTE) NOT NULL,
EMAIL VARCHAR2(128 BYTE) NOT NULL,
ADDRESS VARCHAR2(128 BYTE) NOT NULL,
CITY VARCHAR2(26 BYTE) NOT NULL,
STATE VARCHAR2(26 BYTE) NOT NULL,
PHONE VARCHAR2(26 BYTE),
CONSTRAINT BORROWERS_PK PRIMARY KEY(CARD_NO)
);

DEFINE SEARCH_STRING = 'bill';

SELECT DISTINCT(B.ISBN10), B.TITLE,  LISTAGG(A.NAME, ';') WITHIN GROUP
(ORDER BY B.ISBN10 ) OVER (PARTITION BY B.ISBN10) AS NAME_OF_AUTHOR
FROM PROJECT1_BOOKS B,
PROJECT1_AUTHORS A,
PROJECT1_BOOK_AUTHORS BA
WHERE BA.ISBN10 = B.ISBN10
AND BA.AUTHOR_ID = A.AUTHOR_ID
AND (
LOWER(b.TITLE) LIKE LOWER('%&search_string%')
OR
LOWER(A.NAME) LIKE LOWER('%&search_string%')
)
ORDER BY B.ISBN10;

INSERT INTO PROJECT1_BOOKS_TEMPTABLE
(SELECT floor(dbms_random.value(1, 5)), BOOK_ID from
(select MAX(book_id) as BOOK_ID, ISBN10 from PROJECT1_BOOK_COPIES
GROUP BY ISBN10
order by DBMS_RANDOM.value
FETCH FIRST 100 ROWS ONLY));

INSERT INTO PROJECT1_BORROWER_TEMP
(select floor(dbms_random.value(1, 5)), CARD_NO from
PROJECT1_BORROWERs
order by DBMS_RANDOM.value
FETCH NEXT 200 ROWS ONLY
);

commit;

INSERT into project1_book_loans(book_id, card_no, date_out, due_date)
(
select T1.book_id, T2.card_no, T3.date_out, T4.due_date
from project1_BOOKs_TEMPtable T1, project1_BORROWER_TEMP T2,
(select trunc(sysdate) - numtodsinterval(floor(dbms_random.value(30,
45)), 'day') as date_out
from dual) T3,
(select trunc(sysdate) as due_date
from dual) T4
where T1.TEMP_NO >= T2.TEMP_NO
);

UPDATE project1_book_loans BL
SET BL.due_date = BL.date_out + numtodsinterval(15, 'day'),
BL.date_in = BL.date_out + numtodsinterval(floor(dbms_random.value(1,
10)), 'day');

UPDATE project1_book_loans BL
SET date_in = null
where BL.card_no in
(select card_no from project1_book_loans
GROUP BY card_no
having count(loan_id) > 3
order by DBMS_RANDOM.value
FETCH FIRST 20 ROWS ONLY);

UPDATE project1_book_loans BL
SET BL.date_in = BL.date_out +
numtodsinterval(floor(dbms_random.value(16, 30)), 'day')
where BL.loan_id in
(select loan_id from project1_book_loans
where date_in is null
order by DBMS_RANDOM.value
FETCH FIRST 100 ROWS ONLY
);

insert into project1_fines(loan_id,fine_amt)
(select loan_id, floor(trunc(date_in) - trunc(due_date)) * 100
from project1_book_loans
where floor(trunc(due_date) - trunc(date_in)) < 0);
commit;

/*AUTHOR with highest number of books*/

SELECT A.NAME, BC.ISBN10,COUNT(BC.ISBN10) NO_OF_COPIES
FROM PROJECT1_AUTHORS A, PROJECT1_BOOK_AUTHORS BA, PROJECT1_BOOK_COPIES BC
WHERE A.AUTHOR_ID = BA.AUTHOR_ID
and BA.ISBN10 = BC.ISBN10
GROUP BY BA.ISBN10, A.NAME, BC.ISBN10
FETCH NEXT 10 ROWS ONLY;


/*Books that were checked in late*/

select D.ISBN10, D.Title, count(D.ISBN10) from PROJECT1_BOOKS D,
(
select B.ISBN10
from PROJECT1_BOOKS B, PROJECT1_BOOK_LOANS BL, PROJECT1_BOOK_COPIES C
where B.ISBN10 = C.ISBN10
and C.BOOK_ID = BL.BOOK_ID
and BL.DATE_IN - BL.DATE_OUT > 0
order by (BL.DATE_IN - BL.DATE_OUT) DESC
) E
WHERE E.ISBN10 = D.ISBN10
group by D.ISBN10, D.Title
order by count(D.ISBN10) desc
FETCH NEXT 10 ROWS ONLY;