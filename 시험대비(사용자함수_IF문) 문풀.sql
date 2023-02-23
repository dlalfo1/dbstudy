CREATE OR REPLACE FUNCTION GET_PR(BNO BOOK_TBL.BOOK_ID%TYPE)

RETURN VARCHAR2 -- 함수 실행시 리턴 받을 타입
IS
    MESSAGE VARCHAR2(12 BYTE); -- IF문의 결과값 리턴시 받을 타입 완벽!
    PR BOOK_TBL.PRICE%TYPE;
BEGIN
    SELECT PRICE -- 실제 테이블의 칼럼명이여야 함.
      INTO PR
      FROM BOOK_TBL
     WHERE BNO = BOOK_ID; 
   
    IF PR >= 30000 THEN
       MESSAGE := '비싸다'; -- 그 연봉이 15000 이상이면 고액연봉
    ELSIF
       PR >= 20000 THEN
       MESSAGE := '중간'; -- 그 연봉이 15000 이하면 보통연봉 
    ELSE
        MESSAGE := '싸다';
    END IF;
    RETURN MESSAGE;
END; 

SELECT GET_PR(4) AS 기준
  FROM BOOK_TBL
WHERE BOOK_ID = 4;

     