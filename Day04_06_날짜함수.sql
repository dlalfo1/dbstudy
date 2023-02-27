
/*

DUAL이란 'DUMMY 칼럼'에 'X'값을 하나 가지고 있는 테이블이다. 

오라클의 SELECT문은 FROM절이 필수이기 때문에, 테이블이 필요 없는 단순 조회도 FROM절을 작성해야 한다.

이때 테이블 자체는 아무 의미가 없는 DUAL테이블을 FROM절에 작성한다.

*/

-- 날짜 함수


-- 1. 현재 날짜와 시간
-- SYSDATE 함수는 특별히 사용자로부터 함수에 대한 인수를 요구하지 않는다.
-- 그 자체로서 오라클 내부적으로 현재날짜를 처리해서 출력해주는 기능을 제공한다.
SELECT
       SYSDATE -- 현재 날짜
     , SYSTIMESTAMP -- 현재 날짜 + 시간까지
  FROM
       DUAL;


-- 2. 날짜에 형식 지정하기
SELECT
       TO_CHAR(SYSDATE, 'YYYY-MM-DD') -- 숫자, 날짜 등의 값을 "문자열"로 변환하는 함수이다.
     , TO_CHAR(SYSDATE, 'YYYY')  -- 필요한 정보만 추출하는 용도로도 사용 가능하다.
  FROM
        DUAL;


-- 3. 날짜에서 필요한 정보만 추출하기
-- 예시 : SELECT EXTRACT('날짜요소' FROM 날짜함수) FROM 테이블; 
-- EXTRACT : 얻어내다, 뜯어내다
SELECT
       EXTRACT(YEAR FROM SYSDATE)
     , EXTRACT(MONTH FROM SYSDATE)
     , EXTRACT(DAY FROM SYSDATE)
     , EXTRACT(HOUR FROM SYSTIMESTAMP)  -- UTC 기준(세계 표준시), 우리나라 시간은 +9 해야 한다.
     , EXTRACT(MINUTE FROM SYSTIMESTAMP)
     , EXTRACT(SECOND FROM SYSTIMESTAMP)
     , FLOOR(EXTRACT(SECOND FROM SYSTIMESTAMP)) -- FLOOR : 소수점 버림
  FROM
       DUAL;


-- 4. N개월 전후 날짜 구하기
SELECT
       ADD_MONTHS(SYSDATE, 1)  -- 1개월 후 날짜
     , ADD_MONTHS(SYSDATE, -1) -- 1개월 전 날짜
     , ADD_MONTHS(SYSDATE, 12) -- 1년 후 날짜
  FROM
       DUAL;


-- 5. 경과한 개월 수 구하기
-- TO_DATE는 날짜 '형식'을 변경하는 함수가 아니라, 전달된 문자열을 지정된 날짜 형식으로 해석하는 형변환 함수이다.
-- CHARACTER 타입을 DATE 타입으로 변환하는 함수
-- 20210121 등 기본 날짜 형식이 아닌 문자열을 DATE 타입으로 인식시켜야 하는 경우 

SELECT
       MONTHS_BETWEEN(SYSDATE, TO_DATE('22/10/07', 'YY/MM/DD')) -- 문자열과 날짜 포맷의 형식이 같지 않으면 오류이다.
  FROM
       DUAL;


-- 6. 날짜 연산
--    1) 1일(하루)을 숫자 1로 처리한다.
--    2) 12시간은 숫자 0.5로 처리한다.
--    3) 날짜는 더하기/빼기가 가능하다. (며칠 전후, 경과한 일수 구하는 함수가 없다.) 
SELECT
       SYSDATE + 15  -- 15일 후 날짜
     , SYSDATE - 15  -- 15일 전 날짜
     , SYSDATE - TO_DATE('22/10/07', 'YY/MM/DD')  -- 경과한 일수
  FROM
       DUAL;
           
       
       