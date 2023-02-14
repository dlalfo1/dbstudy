/*
    프로시저(PROCEDURE)
    1. 하나의 프로시저에 여러 개의 쿼리문을 작성해서 처리할 수 있다.
    2. 여러 개의 쿼리문이 필요한 서비스를 프로시저로 작성해 두면 사용이 편리하다.
        (예시 : 은행 이체(UPDATE 쿼리가 2개로 구성)
    3. 형식
        CREATE [OR REPLACE] PROCEDURE 프로시저[(매개변수)] => 매개변수가 없을 때는 () 괄호 자체가 생략될 수 있다.
        IS -- AS도 가능
           변수선언 - 프로시저에선 DECLARE 대신에 IS나 AS를 사용한다.
        BEGIN
           본문
        [EXCEPTION
           예외처리]
        END;
    4. 작성된 프로시저는 EXECUTE 프로시저(); 형식으로 실행한다. => 매개변수가 없어서 CREATE문에서 괄호를 쓰지 않았어도 실행할 땐 써줘야 함..
*/

-- 프로시저1 정의(만들기)
CREATE OR REPLACE PROCEDURE PROC1
AS -- 변수 선언을 안해도 IS나 AS는 넣어야 한다.
BEGIN 
   DBMS_OUTPUT.PUT_LINE('Hello World');
END;                                                                     

-- 프로시저1 호출(실행하기)
EXECUTE PROC1();

-- 프로시저2 정의(만들기) : 사원번호가 100인 사원의 FIRST_NAME , LAST_NAME, SALARY를 조회하는 프로시저
CREATE OR REPLACE PROCEDURE PROC2
IS
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME, SALARY
      INTO FNAME, LNAME, SAL
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE(FNAME || ',' || LNAME || ',' || SAL);
END;

-- 프로시저2 호출(실행하기)
EXECUTE PROC2();

-- 프로시저3 정의(만들기) : 사원번호를 전달하면 해당 사원의 FIRST_NAME, LAST_NAME, SALARY를 조회하는 프로시저
-- 입력 파라미터
-- 1. 프로시저로 값을 전달할 때 사용한다.
-- 2.형식 : 변수명 IN 타입

CREATE OR REPLACE PROCEDURE PROC3(EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE)

IS
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME, SALARY
      INTO FNAME, LNAME, SAL
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
     DBMS_OUTPUT.PUT_LINE(FNAME || ',' || LNAME || ',' || SAL);
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('예외가 발생했습니다.');
END;

-- 프로시저3 호출(실행하기)
EXECUTE PROC3(100); -- 100을 호출하면 EMP_ID에 100이 들어간다.

-- 프로시저4 정의(만들기)
-- 사원번호가 100인 사원의 FIRST_NAME, LAST_NAME을 출력 파라미터로 반환하는 프로시저

-- 출력 파라미터 
-- 1. 프로시저의 실행 결과를 저장하는 변수이다.
-- 2. 형식 : 변수명 OUT 타입

CREATE OR REPLACE PROCEDURE PROC4(FNAME OUT EMPLOYEES.FIRST_NAME%TYPE, LNAME OUT EMPLOYEES.LAST_NAME%TYPE)
IS 
BEGIN
    SELECT FIRST_NAME, LAST_NAME
      INTO FNAME, LNAME           -- 이 곳에서 출력 파라미터에 값이 저장된다.
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
END;
      
-- 프로시저4 호출(실행하기)
-- FNAME과 LNAME값을 저장할 변수를 선언한 뒤, 프로시저에 전달해야 한다.
DECLARE
   FNAME EMPLOYEES.FIRST_NAME%TYPE;
   LNAME EMPLOYEES.LAST_NAME%TYPE;
BEGIN  
   PROC4(FNAME, LNAME); -- PLSQL 내부에서 프로시저를 호출할 때는 EXECUTE를 생략해야 한다.
   DBMS_OUTPUT.PUT_LINE(FNAME || ',' || LNAME);
END;

-- 프로시저5. 사원번호를 전달하면, 해당 사원의 FIRST_NAME이 출력 파마리터 FNAME에 저장되도록 작성.
-- 없는 사원번호가 전달되면 출력 파라미터 FNAME에 'Noname'이 저장되도록 작성.
-- 실행 예시)
-- PROC5(100, FNAME) : 사원번호 100은 Steven입니다.
-- PROC5(0, FNAME)   : 사원번호 0은 Noname입니다.

CREATE OR REPLACE PROCEDURE PROC5
(
    EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE, 
    FNAME OUT EMPLOYEES.FIRST_NAME%TYPE
)

IS
BEGIN
    SELECT FIRST_NAME
      INTO FNAME -- FIRST_NAME을 INTO의 FNAME에 전달
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         FNAME := 'Noname';
END;

DECLARE -- 변수가 있어야 호출 가능하기 때문에 프로시저문 나와서 DECLARE로 변수를 만들어준다.
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
BEGIN  
    PROC5(100, FNAME);
    DBMS_OUTPUT.PUT_LINE(FNAME);
END;


/*
  프로시저 연습
  1. BUT_PROIC 프로시저 구현하기 (아래 기능이 한번에 일어날 수 있도록 프로시저 만들기)
  2. 처리할 일
     1) 구매내역 테이블에 구매 내역을 추가(INSERT)
     2) 제품 테이블의 재고 내역을 수정(UPDATE)한다.
     3) 고객 테이블의 포인트를 수정(UPDATE)한다
*/


-- 테이블 삭제하기
DROP TABLE BUY_TBL;
DROP TABLE CUST_TBL;
DROP TABLE PROD_TBL;

-- 시퀀스 삭제하기
DROP SEQUENCE BUY_SQE;

-- 제품 테이블 구성하기
CREATE TABLE PROD_TBL (
   /* 제품코드 */P_CODE NUMBER NOT NULL, 
   /* 제품이름 */P_NAME VARCHAR2(20 BYTE),
   /* 제품가격 */P_PRICE NUMBER,
   /* 제품재고 */P_STOCK NUMBER 
);
ALTER TABLE PROD_TBL
 ADD CONSTRAINT PK_PROD PRIMARY KEY(P_CODE);
INSERT INTO PROD_TBL(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1000, '홈런볼', 1000, 100);
INSERT INTO PROD_TBL(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1001, '맛동산', 2000, 100);
COMMIT;

-- 고객 테이블 구성하기
CREATE TABLE CUST_TBL (
   /* 고객코드 */C_NO NUMBER NOT NULL,
   /* 고객이름 */C_NAME VARCHAR2(20 BYTE),
   /* 고객포인트 */C_POINT NUMBER
);

ALTER TABLE CUST_TBL
    ADD CONSTRAINT PK_CUST PRIMARY KEY(C_NO);
INSERT INTO CUST_TBL(C_NO, C_NAME, C_POINT) VALUES(1, '정숙', 0);
INSERT INTO CUST_TBL(C_NO, C_NAME, C_POINT) VALUES(2, '재홍', 0);
COMMIT;

-- 구매 테이블 구성하기
CREATE TABLE BUY_TBL (
    /*구매번호*/B_NO NUMBER NOT NULL, -- 기본키
    /*구매한사람*/C_NO NUMBER NOT NULL, -- 외래키
    /*제품종류*/P_CODE NUMBER, -- 외래키
    /*구매수량*/B_AMOUNT NUMBER
);

ALTER TABLE BUY_TBL
    ADD CONSTRAINT PK_BUY PRIMARY KEY(B_NO);
ALTER TABLE BUY_TBL
    ADD CONSTRAINT FK_BUY_CUST FOREIGN KEY(C_NO)
        REFERENCES CUST_TBL(C_NO) 
            ON DELETE CASCADE; -- BUY_TBL의 C_NO 칼럼옵션이 NOT NULL이므로
ALTER TABLE BUY_TBL
    ADD CONSTRAINT FK_BUY_PROD FOREIGN KEY(P_CODE)
        REFERENCES PROD_TBL(P_CODE)
            ON DELETE SET NULL; -- BUY_TBL의 P_CODE 칼럼옵션이 NULL이므로
                      
CREATE SEQUENCE BUY_SEQ
    NOCACHE;
    
-- BUY_PROC 프로시저 정의(프로시저 만들기)
-- 누가(C_NO) 무슨 제품(P_CODE) 을 몇개(B_AMOUNT) 샀나
-- C_NO IN CUST_TBL.C_NO%TYPE => CUST_TBL의 C_NO와 같은타입이다. 이런식으로 해석한한다.
CREATE OR REPLACE PROCEDURE BUY_PROC
(
    /*고객번호*/CNO IN CUST_TBL.C_NO%TYPE, 
    /*제품코드*/PCODE IN PROD_TBL.P_CODE%TYPE, 
    /*구매수량*/BUY_AMOUNT IN BUY_TBL.B_AMOUNT%TYPE
)
    IS -- 추가변수가 없어도 IS든 AS든  적어야 한다.
    BEGIN
    -- 1) 구매내역 테이블에 구매 내역을 추가(INSERT)
    INSERT INTO BUY_TBL(B_NO, C_NO, P_CODE, B_AMOUNT) VALUES(BUY_SEQ.NEXTVAL, CNO, PCODE, BUY_AMOUNT); -- 테이블의 칼럼값에 변수를 대입하는 개념

    -- 2) 제품 테이블의 재고 내역을 수정(UPDATE)한다. 
    --    구매수량만큼 재고가 준다.
    UPDATE PROD_TBL SET P_STOCK = P_STOCK - BUY_AMOUNT WHERE P_CODE = PCODE; 
    -- 모든 제품의 재고를 다 빼면 안 되니까 WHERE절에 P_CODE = PCODE 를 써주는것
    -- 매개변수로 입력받은 PCODE가 PROD_TBL의 P_CODE의 있는 번호와 같을때만
    
    -- 3) 고객 테이블의 포인트를 수정(UPDATE)한다.
    --    총 구매액의 10%를 정수로 올림처리해서 포인트로 준다.
    --    CEIL(가격 * 구매수량 * 0.1) => 제품테이블에서 가격을 SELECT해서 가져와야 한다.
    UPDATE CUST_TBL SET C_POINT = C_POINT + CEIL((SELECT P_PRICE FROM PROD_TBL WHERE P_CODE = PCODE) * BUY_AMOUNT * 0.1) WHERE C_NO = CNO;

    -- 4) 커밋
    COMMIT;
     
EXCEPTION

    WHEN OTHERS THEN  -- 모든 예외를 처리
    
        -- 예외 사유 확인
        DBMS_OUTPUT.PUT_LINE(SQLCODE || '(' || SQLERRM || ')');
        
        -- 롤백
        ROLLBACK;
    
END;

-- BUY PROC 프로시저 호출 (2가지 방법)

EXECUTE BUY_PROC(1, 1000, 10); -- 고객번호1, 제품코드 1000, 구매수량 10

BEGIN
    BUY_PROC(2, 1001, 5);-- 고객번호2, 제품코드 1001, 구매수량 5
END;
