/*
    사용자 함수(FUNCTION) -- JAVA에서 메소드 개념이다.
    1. 어떤 값을 반환할 때 사용하는 데이터베이스 객체이다.
    2. 실제로 함수를 만들어서 사용하는 개념이다.
    3. RETURN 개념이 존재한다.
    4. 함수의 결과 값을 확인할 수 있도록 SELECT문에서 많이 사용한다.
    5. 형식
        CREATE [OR REPLACE] FUNCTION 함수명[(매개변수)] -- 프로시저처럼 매개변수가 없을 때는 괄호가 생략될 수 있다.
        RETURN 반환타입 
        IS -- AS도 가능
           변수 선언
        BEGIN
           함수 본문
        [EXCEPTION
            예외 처리]
        END;    
*/

-- 사용자 함수 FUNC1 정의
CREATE OR REPLACE FUNCTION FUNC1
RETURN VARCHAR2 -- 반환타입에서는 크기를 명시하지 않는다.
IS
BEGIN
    RETURN 'Hello World';
END; 


-- 사용자 함수 FUNC1 호출
SELECT FUNC1() FROM DUAL;

-- 사용자 함수 FUNC2 정의
-- 사원번호를 전달하면 해당 사원의 FULL_NAME(Steven King)을 반환하는 함수

-- 사용자 함수의 파라미터는 IN/OUT 표기가 없다.
-- 입력 파라미터 형식으로 사용된다.

CREATE OR REPLACE FUNCTION FUNC2(EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE) -- EMP_ID 변수 선언
RETURN VARCHAR2 -- VARCHAR2 타입의 데이터를 반환한다.
IS
    FNAME EMPLOYEES.FIRST_NAME%TYPE; -- FNAME 변수 선언
    LNAME EMPLOYEES.LAST_NAME%TYPE; -- LNAME 변수 선언
BEGIN 
    SELECT FIRST_NAME, LAST_NAME
      INTO FNAME, LNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
    RETURN FNAME || ' ' || LNAME; -- 변수에 저장된 값을 반환해야하니까 FANME을 반환한다.
END;

-- CREATE OR REPLACE FUNCTION FUNC2(EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE)
-- 테이블의 EMPLOYEE_ID 타입과 같은 EMP_ID 변수선언 => 함수에 매개변수로 EMP_ID를 넣어주겠다.
-- RETURN VARCHAR2
-- VARCHAR2 타입의 데이터를 반환한다.
-- IS FNAME EMPLOYEES.FIRST_NAME%TYPE;

-- 사용자 함수 FUN2 호출
SELECT FUNC2(100) -- 사원번호 100을 넣으면 Steven King을 호출한다.
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 100;

SELECT EMPLOYEE_ID, FUNC2(EMPLOYEE_ID) -- 전체사원의 풀네임 확인하는 방법.
FROM EMPLOYEES;

-- 사용자 함수 FUNC3 정의
-- 사원번호를 전달하면 해당 사원의 연봉이 15000 이상이면 '고액연봉', 아니면 '보통연봉'을 반환하는 함수

CREATE OR REPLACE FUNCTION FUNC3(EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE)
RETURN VARCHAR2
IS
    SAL EMPLOYEES.SALARY%TYPE;  
    MESSAGE VARCHAR2(12 BYTE);   
BEGIN

    SELECT SALARY -- 가져온 SALARY의 값을
    INTO SAL -- 변수 SAL에 저장한다.
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = EMP_ID;
    
    -- 번호를 전달하면 전달된 번호의 연봉을 변수에 저장시키고
    IF SAL >= 15000 THEN
       MESSAGE := '고액연봉'; -- 그 연봉이 15000 이상이면 고액연봉
    ELSE
       MESSAGE := '보통연봉'; -- 그 연봉이 15000 이하면 보통연봉            
    END IF;
    RETURN MESSAGE;
END; 

-- 사용자 함수 FUNC3 호출
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, FUNC3(EMPLOYEE_ID) -- 모든사원의 번호가 FUNC3로 전달된다.
  FROM EMPLOYEES;
 
-- 함수 MY_CEIL 정의
CREATE OR REPLACE FUNCTION MY_CEIL(N NUMBER, DIGIT NUMBER)
RETURN NUMBER 
IS
BEGIN
    RETURN CEIL(N * POWER(10, DIGIT)) / POWER(10, DIGIT); -- CEIL 안에 10의 제곱을 곱한 후 10의 제곱으로 나눈 값을 넣어준다.
END;

-- 함수 MY_CEIL 호출
SELECT
        MY_CEIL(1.111, 2)  -- 소수2자리 올림 (1.12)
     ,  MY_CEIL(1.111, 1)  -- 소수1자리 올림 (1.2)
     ,  MY_CEIL(1.111, 0)  -- 정수로 올림 (2)
     ,  MY_CEIL(1.111, -1) -- 일의자리 올림 (10)
     ,  MY_CEIL(1.111, -2) -- 십의자리 올림 (100)
FROM 
        DUAL;

-- 원래 CEIL의 기능 
-- CEIL(A) : 실수 A를 A보다 큰 정수로 올린 값을 반환
SELECT 
       CEIL(1.1) -- 2
     , CEIL(-1.1) -- -1
  FROM 
       DUAL;

-- 함수 MY_FLOOR 정의
CREATE OR REPLACE FUNCTION MY_FLOOR(N NUMBER, DIGIT NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN FLOOR(N * POWER(10, DIGIT)) / POWER(10, DIGIT);
END;

-- 함수 MY_FLOOR 호출
SELECT
       MY_FLOOR(9999.999, 2)   -- 소수2자리 내림
     , MY_FLOOR(9999.999, 1)   -- 소수1자리 내림
     , MY_FLOOR(9999.999, 0)   -- 정수로 내림
     , MY_FLOOR(9999.999, -1)  -- 일의자리 내림
     , MY_FLOOR(9999.999, -2)  -- 십의자리 내림
  FROM DUAL;




