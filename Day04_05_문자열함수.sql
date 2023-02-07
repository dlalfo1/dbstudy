-- 문자열 함수

-- 1. 대소문자 변환 함수 
SELECT
        UPPER(EMAIL)   -- 대문자
      , LOWER(EMAIL)   -- 소문자
      , INITCAP(EMAIL) -- 첫글자만 대문자 나머지 소문자
   FROM 
        EMPLOYEES;

-- 2. 글자 수(바이트 수) 반환 함수
SELECT 
       LENGTH('HELLO')  -- 글자 수 : 5
     , LENGTH('안녕')   -- 글자 수 : 2
     , LENGTHB('HELLO') -- 바이트 수 : 5
     , LENGTHB('안녕')  -- 바이트 수 : 6 -- 편집기 세팅할 때 UTF-8 세팅을 미리 해뒀음
FROM
       DUAL;

-- 3. 문자열 연결 함수/연산자
--     1) 함수   : CONCAT(A,B)  주의! 인수가 2개만 전달 가능하다.(CONCAT(A, B, C) 같은 형태는 불가능하다.) 
--     2) 연산자 : ||  주의! OR 연산 아닙니다! 오라클 전용입니다! 
SELECT
       CONCAT(CONCAT(FIRST_NAME, ' '), LAST_NAME) -- 문자열 붙일 때 공백주는 법 CONCAT 두번 쓰기
     , FIRST_NAME || ' ' || LAST_NAME -- 이거 쓰면 되는 거 아닌가요..?
FROM 
      EMPLOYEES;
       
-- ex) 이름에 A가 들어간 사람을 전부 출력하는 기능을 만들시 %A% 작업을 자바에서 할지 DB에서 할지 고민해야 함.     
--     둘 다 할 수 있으면 DB에서 하라 그게 맞다!
       
       
       
       
       
       
       
       