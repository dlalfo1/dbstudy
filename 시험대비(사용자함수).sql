-- 사원번호를 전달하면 해당 사원의 이름을 반환하는 함수 만들기

CREATE OR REPLACE FUNCTION GET_NAME(EMPNO EMPLOYEE_TBL.EMP_NO%TYPE) -- 실제 칼럼명과 출돌하는 이름은 사용하면 안된다.
                                 -- 1001 들어옴
RETURN VARCHAR2 -- RETURN 타입 작성할 때 사이즈는 적지 않는다. ex) 20 BYTE 이런거
IS 
    EMPNAME EMPLOYEE_TBL.NAME%TYPE; -- 여기까지 반환받고 싶은거
BEGIN
    SELECT NAME
      INTO EMPNAME -- 구창민이 들어있음.
      FROM EMPLOYEE_TBL
     WHERE EMP_NO = EMPNO; -- 여기서 1001번이랑 매칭시킴
     RETURN EMPNAME;
END;

-- 사원명
-- 구창민

SELECT GET_NAME(1001) AS 사원명 
  FROM EMPLOYEE_TBL
 WHERE EMP_NO = 1001; -- 특정 사원의 이름을 알고 싶을 때
 
SELECT DISTINCT GET_NAME(1001) AS 사원명 
 FROM EMPLOYEE_TBL
WHERE EMP_NO = 1001; -- 특정 사원의 이름을 알고 싶을 때
 
SELECT GET_NAME(1001) AS 사원명 
  FROM EMPLOYEE_TBL; -- 전체 사원의 이름을 알고 싶을 때