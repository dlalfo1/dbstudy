-- 샘플 데이터

-- DDL
DROP TABLE SAMPLE_TBL; 
CREATE TABLE SAMPLE_TBL(
    NAME VARCHAR2(10 BYTE),
    KOR NUMBER(3),
    ENG NUMBER(3),
    MAT NUMBER(3)
);

-- DML
INSERT INTO SAMPLE_TBL(NAME, KOR, ENG, MAT) VALUES(NULL, 100, 100, 100);
INSERT INTO SAMPLE_TBL(NAME, KOR, ENG, MAT) VALUES('정숙', NULL, 90, 90);
INSERT INTO SAMPLE_TBL(NAME, KOR, ENG, MAT) VALUES('미희', 80, NULL, 80);
INSERT INTO SAMPLE_TBL(NAME, KOR, ENG, MAT) VALUES('철순', 70, 70, NULL);
COMMIT;

/*
    집계함수(그룹별 통계)
    1. 통계(합계, 평균, 개수, 최대, 최소 등)
    2. GROUP BY절에서 주로 사용한다.
    3. 종류 
        1) 합계 : SUM(칼럼)
        2) 평균 : AVG(칼럼)
        3) 개수 : COUNT(칼럼)
        4) 최대 : MAX(칼럼)
        5) 최소 : MIN(칼럼)
    4. NULL값은 연산에서 제외한다.
       즉, 덧셈을 할 때는 정상작동 되지만 평균시엔 NVL함수를 사용하여 값을 0으로 바꿔줘야 정확히 계산된다.
*/

/*
    이름     국어   영어    수학    합계
    NULL,    100,   100,    100,    300
    '정숙',  NULL,   90,     90,    180
    '미희',  80,   NULL,     80,    160
    '철순',  70,     70,   NULL,    140
   ------------------------------------
     합계   250     260     270 
     (SUM으로 구할 수 있는 합계이다.)
*/

-- 합계
SELECT SUM(KOR) 
     , SUM(ENG)
     , SUM(MAT)
--   , SUM(KOR, ENG, MAT) -- SUM 함수의 인수는 1개만 가능하다.
    FROM SAMPLE_TBL;

-- 평균
SELECT
       AVG(NVL(KOR,0)) -- NVL 함수 사용하지 않으면 평균을 NULL값이 있는 정숙을 빼고 나누기 3으로 계산한다.
     , AVG(NVL(ENG,0))
     , AVG(NVL(MAT,0))
  FROM SAMPLE_TBL;   
  
-- 개수
SELECT 
       COUNT(KOR) -- 국어 시험에 응시한 인원 수
     , COUNT(ENG) -- 영어 시험에 응시한 인원 수
     , COUNT(MAT) -- 수학 시험에 응시한 인원 수
     , COUNT(*)   -- 모든 칼럼을 참조해서 어느 한 칼럼이라도 값을 가지고 있으면 개수에 포함
                  -- 특별한 경우가 아닌 이상 개수 구하는 함수는 COUNT(*)를 사용한다.
                  -- NULL 값이 없는 칼럼(대표적으로 PK)만 COUNT(칼럼)을 활용한다.
  FROM SAMPLE_TBL;
  
-- 개수 정리!
-- 테이블에 포함된 데이터(행, ROW)의 개수는 COUNT(*)로 구한다.

  










