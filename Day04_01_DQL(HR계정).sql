-- 테이블의 구조 파악하기
DESC EMPLOYEES; -- DESCRIBE. 네글자로 줄여도 OK

-- 1. EMPLOYEES 테이블에서 FIRST_NAME, LAST_NAME 조회하기
SELECT FIRST_NAME, LAST_NAME 
  FROM EMPLOYEES; 
  
  -- SELECT절(칼럼 선택)
  -- 칼럼들은 EMPLOYEES 테이블 명시로 오너를 표시할 수 있다. 
  -- 칼럼명 뒤에 별명을 지어줄 수 있다. AS 별명 
  -- FROM절(테이블 선택)
  -- 테이블은 HR계정 명시로 오너를 표시할 수 있다. 
  -- 테이블명 뒤에 E라고 별명을 지어주면 SELECT절에서도 별명을 사용할 수 있다.
  
  
  -- 테이블의 별명을 지어줄 땐 AS 키워드를 사용할 수 없다.
  -- 순서 WHERE절 - FROM절 - SELECT절 (모든 것은 실행 순서로 이해하라.)
  -- ex) SELECT에서 지어준 별명을 WHERE절에서 못 쓰는 이유는 실행순서가 맞지 않기 때문이다.
  
-- 2. EMPLOYEES 테이블에서 DEPARTMENT_ID를 중복 제거하고 조회하기
SELECT DISTINCT DEPARTMENT_ID -- DISTINCT : 중복제거
  FROM EMPLOYEES;
  
-- 3. EMPLOYEES 테이블에서 EMPLOYEE_ID가 150인 사원 조회하기
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME 
  FROM EMPLOYEES
 WHERE EMPLOYEES_ID = 150; -- WHERE절(조건)의 등호(=)는 비교 연산자이다. 같다라는 뜻이다.

-- 4. EMPLOYEES 테이블에서 SALARY가 10000 ~ 20000 사이인 사원 조회하기
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
  FROM EMPLOYEES
 WHERE SALARY BETWEEN 10000 AND 20000;
  
-- 5. EMPLOYEES 테이블에서 DEPARTMENT_ID가 30,40,50인 사원 조회하기
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN(30, 40, 50); -- 배열 전달

-- 6. EMPLOYEES 테이블에서 DEPARTMENT_ID가 NULL인 사원 조회하기
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NULL; -- 널값인지 확인할 때는 = NULL; 이 아니다. IS NOT NULL : 널값이 아닌 애들 불러오기.
 
-- 7. EMPLOYEES 테이블에서 PHONE_NUMBER가 '515'로 시작하는 사원 조회하기
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER
  FROM EMPLOYEES
 WHERE PHONE_NUMBER LIKE '515%'; -- 515로 시작하고 그 뒤에는 모든 글자가 올 수 있다. (와일드카드) 
                                 -- 와일드카드 사용시 등호(=) 말고 LIKE 키워드를 사용해야 한다.
                                 -- NOT LIKE '515%' : 515로 시작하는 글자를 제외하고 모든 글자를 가져올 수 있다.
                                 
-- 8. EMPLOYEES 테이블에서 FIRST_NAME의 가나다순(오름차순:Ascending Sort)으로 정렬해서 조회하기     
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
  FROM EMPLOYEES
ORDER BY FIRST_NAME ASC; -- ASC는 생략 가능하다.
                         -- ORDER BY 키워드가 정렬해주는 키워드인데 키워드 생략시 오름차순으로 해준다.

-- 9. EMPLOYEES 테이블을 높은 SALARY(내림차순:Descending Sort)를 받는 사원을 먼저 조회하기
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
  FROM EMPLOYEES
ORDER BY SALARY DESC; -- DESC는 생략이 불가능하다.

-- 10. EMPLOYEES 테이블의 사원들을 DEPARTMENT_ID순으로 조회하고, 동일한 DEPARTMENT_ID를 가진 사원들은 SALARY순으로 조회하시오. 
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID, SALARY
  FROM EMPLOYEES
ORDER BY DEPARTMENT_ID, SALARY DESC; -- 둘다 내림차순은 아니다. 오름차순은 생략했을 뿐 DEPARTMENT_ID는 오름차순, SALARY는 내림차순이다.

