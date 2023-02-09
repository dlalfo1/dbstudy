/*
    셀프 조인
    1. 하나의 테이블에 PK와 FK가 모두 있는 경우에 사용되는 조인이다.
    2. 동일한 테이블을 조인하기 때문에 별명을 다르게 지정해서 조인한다.
    3. 문법은 기본적으로 내부 조인/외부조인과 동일하다.
*/

-- 모든 사원들의 EMPLOYEE_ID, FIRST_NAME, LAST_NAME, MANAGER의 FIRST_NAME을 조회하시오.
-- 1:M 관계 파악
-- PK               FK
-- EMPLOYEE_ID      MANAGER_ID


-- 조인 조건 파악
-- 셀프 조인 할 때는 두 테이블이라 생각하고 조건을 생각해야 한다. (사원테이블과 매니저테이블이 있다고 생각해)
-- 사원테이블 E          -    매니저 테이블 M
-- 사원들의 매니저번호   -    매니저의 사원번호



-- 사원의 매니저가 누군지 알아보자.
SELECT 
       E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME    -- 각 사원들의 정보
     , M.FIRST_NAME                                -- 매니저 정보
     
  FROM
       EMPLOYEES E LEFT OUTER JOIN EMPLOYEES M -- 스티븐킹의 매니저번호는 null이기 때문에 스티븐킹 까지 조회하려면 왼쪽 외부 조인을 사용해야 한다.
                                               -- 보통 셀프조인은 내부조인으로 처리하나 이 예제는 외부조인으로 처리해야 한다.
    ON 
       E.MANAGER_ID = M.EMPLOYEE_ID(+) -- 이해안감.
 ORDER BY
       E.EMPLOYEE_ID;
    
-- 셀프 조인 연습.
-- 각 사원 중에서 매니저보다 먼저 입사한 사원을 조회하시오.

SELECT 
       E.EMPLOYEE_ID, E.FIRST_NAME, E.HIRE_DATE AS 입사일자
     , M.EMPLOYEE_ID, M.FIRST_NAME, M.HIRE_DATE AS 매니저입사일자
  FROM
       EMPLOYEES E INNER JOIN EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID
 WHERE 
       TO_DATE(E.HIRE_DATE, 'YY/MM/DD') < TO_DATE(M.HIRE_DATE, 'YY/MM/DD')
 ORDER BY
       E.EMPLOYEE_ID;
    
-- PK,FK가 아닌 일반 칼럼을 이요한 셀프 조인

-- 동일한 부서에서 근무하는 사원들을 조인하기 위해 DEPARTMENT_ID로 조인조건을 생성

-- 사원 (나)       사원 (너)
-- EMPLOYEES ME    EMPLOYEES YOU

-- 문제. 같은 부서에 근무하는 사원 중에서 나보다 SALARY가 높은 사원 정보를 조회하시오.

SELECT 
       ME.EMPLOYEE_ID, ME.FIRST_NAME, ME.SALARY AS 내급여
     , YOU.FIRST_NAME, YOU.SALARY AS 너급여
     , ME.DEPARTMENT_ID, YOU.DEPARTMENT_ID
  FROM EMPLOYEES ME INNER JOIN EMPLOYEES YOU
    ON ME.DEPARTMENT_ID = YOU.DEPARTMENT_ID
 WHERE 
       ME.SALARY < YOU.SALARY
 ORDER BY
       ME.EMPLOYEE_ID;
    

-- 조인 연습.
-- 1. LOCATION_ID가 1700인 부서에 근무하는 사원들의 EMPLOYEE_ID, FIRST_NAME, DEPARTMENT_NAME을 조회하시오

-- 1) 표준 문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME
  FROM DEPARTMENTS D INNER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID -- 결합조건(PK,FK 조건 적으면 되는듯..?)
 WHERE D.LOCATION_ID = 1700; -- LOCATION_ID는 INT값임에도 불구하고
                             -- '1700' 이렇게 문자열로 적어도 되는 이유가 SQL에서 자동으로 INT값으로 변환해주기 때문이다.
  
-- 2) 오라클 문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME
  FROM DEPARTMENTS D, EMPLOYEES E
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
   AND D.LOCATION_ID = 1700; -- 추가 조건은 WHERE절에서 AND 키워드로 연결한다.
   

-- 2. DEPARTMENT_NAME이 'Executive'인 부서에 근무하는 사원들의 EMPLOYEE_ID, FIRST_NAME을 조회하시오

-- 1) 표준 문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME
  FROM DEPARTMENTS D INNER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
 WHERE D.DEPARTMENT_NAME = 'Executive';


--2 ) 오라클 문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME
  FROM DEPARTMENTS D, EMPLOYEES E
 WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
   AND D.DEPARTMENT_NAME = 'Executive';


-- 3. 모든 사원들의 EMPLOYEE_ID, FIRST_NAME, DEPARTMENT_NAME, CITY를 조회하시오.
-- EMPLOYEE_ID      FIRST_NAME      DEPARTMENT_NAME     CITY
-- EMPLOYEES        EMPLOYEES       DEPARTMNETS         LOCATDION

-- 1) 표준문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME, L.CITY
  FROM LOCATIONS L INNER JOIN DEPARTMENTS D -- 일단 LOCATIONS 테이블과 DEPARTMENTS을 먼저 조인해주고 
    ON L.LOCATION_ID = D.LOCATION_ID -- ON으로 조인조건 넣어주고(조인의 완성은 조건까지 해주는거임. 이너 조인을 또 쓸 수는 없다)
    INNER JOIN EMPLOYEES E -- EMPLOYEES 테이블이랑 또 조인해주기.
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;
    
-- 2) 오라클 문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME, L.CITY
  FROM LOCATIONS L, DEPARTMENTS D, EMPLOYEES E -- 오라클 문법을 일단 FROM에 관련된 테이블을 다 넣어준다.
 WHERE L.LOCATION_ID = D.LOCATION_ID                                  -- 여기에 또 ,EMPLOYEES E 하는거 아님 주의!
   AND D.DEPARTMENT_ID = E.DEPARTMENT_ID;    
  
-- 4. 부서별 DEPARTMENT_NAME과 사원 수와 평균 연봉을 조회하시오.
--    GROUP BY와 JOIN 함께 사용해보기

SELECT D.DEPARTMENT_NAME, COUNT(*), AVG(SALARY) -- 조회할 칼럼에 아예 함수를 넣어서 조회하는거임.
  FROM DEPARTMENTS D INNER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
 GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME; -- 집계함수 쓸 때 그룹바이 사용
 
 -- GROUP BY절에는 SELECT절(조회할 칼럼)에 오는 칼럼이 무조건 와야한다. (너가 보고 싶은 칼럼이 있니? 그럼 그룹바이에 넣어!)
 -- 하지만! GROUP BY절에는 SELECT절에 없는 칼럼을 넣어도 상관없다.
 -- 예를 들어 회원별 구매총액을 구할 경우 이름만 그룹화 한다면 
 -- 이름만 같고 다른회원인 경우일시에 같은 이름으로 그룹화 되는 일이 발생한다.
 -- 그래서 보통 이름으로 그룹화하지 않지만 할 거면 회원번호도 넣어서 한다.
                             

-- 부서별 DEPARTMENT_ID과 사원 수와 평균 연봉을 조회하시오.
SELECT DEPARTMENT_ID, COUNT(*), AVG(SALARY)
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID;
    
-- 5. 모든 사원들의 EMPLOYEE_ID, FIRST_NAME, DEPARTMENT_NAME을 조회하시오
-- 1)표준 문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME
  FROM DEPARTMENTS D RIGHT OUTER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID  
  ORDER BY E.EMPLOYEE_ID;  

-- 2)오라클 문법
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME
  FROM DEPARTMENTS D, EMPLOYEES E
 WHERE D.DEPARTMENT_ID(+) = E.DEPARTMENT_ID  -- DEPARTMENT_ID 값이 null인 사원도 불러오기 위해서(+) 표시를 해준다.아
  ORDER BY E.EMPLOYEE_ID;
  
-- 6. 모든 부서의 DEPARTMENT_NAME과 근무 중인 사원 수를 조회하시오. 근무하는 사원이 없으면 0으로 조회하시오.
-- DEPARTMENTS의 DEPARTMENT_ID가 EMPLOYEES의 DEPARTMENT_ID엔 없는 경우가 있음

SELECT D.DEPARTMENT_NAME, COUNT(E.EMPLOYEE_ID) -- COUNT(*)을 쓸 경우 칼럼 전체를 검색하기 때문에 부서에 근무중인 사람이 없어도 1로 출력된다
                                               -- 그래서 DEPARTMENT_ID가 있는EMPLOYEE_ID만 조회한다.
  FROM DEPARTMENTS D LEFT OUTER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID 
 GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME;

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    