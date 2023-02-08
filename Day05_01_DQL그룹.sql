/*
    GROUP BY절
    1. GROUP BY절에서 지정한 칼럼의 데이터는 동일한 데이터끼리 하나로 모여서 조회된다.
    2. SELECT절에서 조회하려는 칼럼은 "반드시" GROUP BY절에 있어야 한다.(필수 규칙)
       -- 만약 SELECT절에서 조회하려는 칼럼이 DEPARTMENT_ID, FIRST_NAME으로 2개인데
           GROUP BY절에 DEPARTMENT_ID만 적는다면 이 칼럼만 중복값 제거되고 모이게 됨. 
           그럼 FIRST_NAME 칼럼은 찌부될 수도 없고 어쩔..? 그러니까 다 명시해줘야 하는 것.
*/

-- 1. 동일한 DEPARTMENT_ID를 그룹화하여 조회하시오.
SELECT DEPARTMENT_ID
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID; -- 같은 DEPARTMENT_ID는 모여라~ 중복제거해줌. 중복값이 몇갠지 알려준다
 
-- 2. 동일한 DEPARTMENT_ID로 그룹화하여 FIRST_NAME과 DEPARTMENT_ID를 조회하시오. (실패하는 쿼리문)
SELECT FIRST_NAME, DEPARTMENT_ID -- FIRST_NAME 칼럼이 GROUP BY절에 없기 때문에 실패
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID;
 
-- 3. GROUP BY절이 없는 집계함수는 전체 데이터를 대상으로 한다.
SELECT
       COUNT(*) AS 전체사원수
     , SUM(SALARY) AS 전체사원연봉합
     , AVG(SALARY) AS 전체사원연봉평균
     , MAX(SALARY) AS 전체사원연봉킹
     , MIN(SALARY) AS 전체사원연봉꽝
  FROM 
       EMPLOYEES; 

-- 4. GROUP BY절을 지정하면 같은 그룹끼리 집계함수가 적용된다.
SELECT 
       DEPARTMENT_ID -- SELECT절에서 조회하려는 칼럼은 반드시  GROUP BY절에 있어야 한다.
     , COUNT(*) AS 부서별사원수
     , SUM(SALARY) AS 전체사원연봉합
     , AVG(SALARY) AS 전체사원연봉평균
     , MAX(SALARY) AS 전체사원연봉킹
     , MIN(SALARY) AS 전체사원연봉꽝    
  FROM 
       EMPLOYEES
 WHERE
       DEPARTMENT_ID IS NOT NULL -- WHERE절에서 조건걸어서 NULL값 빼고 보고싶다고 선택하는거랑
                                 -- HAVING절 써서 GROUP BY절에 옵션걸어주는거랑 결과출력물은 같다.
                                 -- 하지만 WHERE절을 쓰는게 성능상 훨씬 좋다.
                                 -- WHERE절을 써서 그룹화할 덩어리를 줄여주는게 좋다. 근데 이것도 때에 따라 다른데,
                                 -- 그룹화를 해야만 사용할 수 있는 조건은 HAVING절을 써야하기 때문.
                                 -- ex) 부서별 인원수가 5명 이하인 부서를 조회시
                                 --     부서별 인원수를 먼저 GROUP BY 해야만 5명 이하인 부서를 조회할 수 있기 때문에 HAVING절을 쓴다.
 GROUP BY
       DEPARTMENT_ID; 

-- 참고. GROUP BY 없이 집계함수 사용하기
SELECT 
       DISTINCT DEPARTMENT_ID
     , COUNT(*) OVER(PARTITION BY DEPARTMENT_ID) AS 부서별사원수 -- DEPARTMENT_ID별로 모아서 COUNT할 것. 그게 부서별사원수가 된다.
     , SUM(SALARY) OVER(PARTITION BY DEPARTMENT_ID) AS부서별연봉합
     , AVG(SALARY) OVER(PARTITION BY DEPARTMENT_ID) AS부서별연봉평균
     , MAX(SALARY) OVER(PARTITION BY DEPARTMENT_ID) AS부서별연봉킹
     , MIN(SALARY) OVER(PARTITION BY DEPARTMENT_ID) AS부서별연봉꽝
 FROM   
       EMPLOYEES;
       
-- 위 순서 정리
-- FROM절 후 GROUP BY절이 먼저 실행돼서 DEPARTMENT_ID를 중복제거 해서 가져와주고 SELECT절이 실행된다.



/*
    조건 지정하기
    1. GROUP BY절로 그룹화 할 대상(모수)이 적을수록 성능에 유리하다.
    2. GROUP BY 이전에 처리할 수 있는 조건은 WHERE절로 처리하는 것이 유리하다.
    3. GROUP BY 이후에만 처리할 수 있는 조건은 HAVING절이 처리한다. (나머지 일반적인 것들을 보통 WHERE절에 때려넣어서 처리함.)    
*/

-- 5. DEPARTMENT_ID가 NULL인 부서를 제외하고, 모든 부서의 부서별 사원 수를 조회하시오.
--     해설) DEPARTMENT_ID가 NULL인 부서의 제외는 GROUP BY이전에 처리할 수 있으므로 WHERE절로 처리한다.
SELECT 
       DEPARTMENT_ID 
     , COUNT(*) AS 부서별사원수  
  FROM 
       EMPLOYEES
 WHERE
       DEPARTMENT_ID IS NOT NULL
 GROUP BY
       DEPARTMENT_ID;

-- 6. 부서별 인원수가 5명 이하인 부서를 조회하시오.
--    해설) 부서별 인원 수는 GROUP BY 이후에 확인할 수 있으므로, HAVING절에서 조건을 처리한다.
SELECT
        DEPARTMENT_ID 
      , COUNT(*) AS 부서별사원수 
  FROM
        EMPLOYEES
  GROUP BY
        DEPARTMENT_ID
 HAVING 
        COUNT(*) <= 5;

 