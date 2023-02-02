/*
    DQL
    1. Data Query Language
    2. 데이터 질의(조회) 언어
    3. 테이블의 데이터를 조회하는 언어이다.
    4. 테이블 내용의 변경이 생기지 않는다. - 트랜잭션의 대상이 아니고, COMMIT이 필요하지 않다.
    5. 형식 ([]는 생략 가능) 
        SELECT 조회할칼럼, 조회할칼럼, 조회할칼럼, ... 
        FROM 테이블이름 (SELECT절, FROM절) - 각 절별로 한줄씩 쓰는 것을 권장한다.
        [WHERE 조건식] 
        [GROUP BY 그룹화할칼럼 [HAVING 그룹조건식] - HAVING은 GROUP BY가 나와야 사용 가능하다.
        [ORDER BY 정렬할칼럼 정렬방식]   
    6. 순서 (FROM -> WHERE -> SELECT-> ORDER) - 실제 쿼리를 짤 때 쓰는 순서가 아니라 처리되는 순서이다.
        ④ SELECT 조회할칼럼, 조회할칼럼, 조회할칼럼, ... 
        ① FROM 테이블이름   
        ② [WHERE 조건식] 
        ③ [GROUP BY 그룹화할칼럼 [HAVING 그룹조건식]
        ⑤ [ORDER BY 정렬할칼럼 정렬방식]   
/*

/*
    트랜잭션
    1. Transaction
    2. 데이터베이스의 상태를 변화시키기 위해 수행하는 작업 단위
    3. 여러 개의 세부 작업으로 구성된 하나의 작업을 의미한다. 
    4. 모든 세부 작업이 성공하면 COMMIT, 하나라도 실패하면 모든 세부 작업의 취소를 진행한다.
        (All of Nothing) 
        - ex) 휴먼고객처리시 정상테이블에서 지우고 휴먼테이블에 넣어야하는 작업을 둘 다 해야하는데 
              둘 중 하나만 하게 된다면 데이터의 훼손이 발생하므로
              그런 상황을 막기 위해서 두 작업 모두 하고 COMMIT을 해야한다. 하나만 한다면 모든 작업을 취소한다.
*/

-- 조회 실습.
-- 1. 사원 테이블에서 사원명 조회하기
-- 1) 기본 방식
SELECT ENAME -- SELECT의 결과는 테이블이다.
  FROM EMP;

-- 2) 오너 명시하기(테이블을 가지고 있는 계정)
SELECT ENAME
  FROM SCOTT.EMP;  

-- 3) 테이블 명시하기(칼럼을 가지고 있는 테이블)
SELECT EMP.ENAME
  FROM EMP; -- SELECT에서 테이블을 명시해줬더라도 FROM은 생략할 수 없다.

-- 4) 테이블 별명 지정하기
SELECT E.ENAME -- 그럼 칼럼에서 별명으로 부를 수 있다. AS(ALIAS)를 사용할 수 없다.
  FROM EMP E; -- EMP 테이블의 별명을 E로 부여한다.

--5) 칼럼 별명 지정하기
SELECT E.ENAME AS 사원명 -- E.ENAME 칼럼의 별명을 '사원명'으로 부여한다. AS(ALIAS)를 사용할 수 있다.
  FROM EMP E;

-- 2. 사원테이블의 모든 칼럼 조회하기
-- 1) * 활용하기(SELECT절에서 *는 모든 칼럼을 의미한다.)
SELECT *       -- 불려 가기 싫으면 사용 금지!   
  FROM EMP;

SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO 
  FROM EMP;

-- 3. 동일한 데이터는 한 번만 조회하기
SELECT DISTINCT JOB -- DISTINCT 중복값 제거하기 (JOB 칼럼 가져올 때 중복된 값을 제거해준다.) DISTINCT : 확실한
 FROM EMP;

-- 4. JOB이 MANAGER인 사원 목록 조회하기
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE JOB = 'MANAGER'; -- 오라클에서 같다는 = 한개.
 
 SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE JOB in('MANAGER'); -- in은 가져올 값이 여러개일 때 주로 사용한다. (1개도 사용가능하다.) 
 
-- 5. SAL이 1500 초과인 사원 목록 조회하기
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE SAL > 1500;
 
-- 6. SAL이 2000 ~ 2999인 사원 목록 조회하기
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE SAL BETWEEN 2000 AND 2999; 
 
-- 7. COMM을 받는 사원 목록 조회하기
--    1) NULL 이다 : IS NULL
--    2_ NULL 아니다 : IS NOT NULL
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE COMM IS NOT NULL -- NULL 체크의 방법은 별도의 방법이 있다.
   AND COMM != 0;       -- 0은 != 기호로 체크할 수 있다.   
-- COMM 값이 NULL이 아니고 0이 아닐 때 데이터를 불러 와라.

-- 8. ENAME이 A로 시작하는 사원 목록 조회하기
--    1) WILD CARD (보통 % 쓴다.)
--       (1) % : 모든 문자, 글자 수 제한 없은 모든 문자
--       (2) _ : 1글자로 제한된 모든 문자      
--    2) 연산자
--        (1) LIKE     : WID CARD를 포함한다.
--        (2) NOT LIKE : WILD CARD를 포함하지 않는다.  
/*
    A% (A로 시작하는 모든 문자)     A_ (A로 시작하는 1글자)
    AI                              AI
    APP                             AP
    APPLE                           AM    
    
    %A% (A가 포함된 모든 문자)     %A (A로 끝나는 모든문자)
    AI                             HA
    HAIVE                          AREA
    GIANT                             
    
    보통 %A% 이렇게 특정 단어가 포함된 키워드를 많이 쓴다.
*/

SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
  FROM EMP
 WHERE ENAME LIKE 'A%'; -- 와일드 카드 사용시 LIKE 또는 NOT LIKE 연산자를 사용해야 한다. 
















