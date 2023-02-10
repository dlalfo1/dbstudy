/*
    서브쿼리(Sub Query)
    1. 메인쿼리에 포함하는 하위쿼리를 의미한다.(메인 SELECT에 포함된 하위 SELECT)
    2. 일반적으로 하위쿼리는 괄호()로 묶어서 메인쿼리에 포함한다.
    3. 하위쿼리가 항상 메인쿼리보다 먼저 실행된다.
*/

/*
    서브쿼리가 포함되는 위치
    1. SELECT절 : 스칼라 서브쿼리
    2. FROM절   : 인라인 뷰
    3. WHERE절  : 서브쿼리
*/

/*
    서브쿼리의 실행 결과에 의한 구분
    1. 단일 행 서브쿼리(Single Row Sub Query) -- 당장은 결과가 1개이더라도 나중에 결과가 바뀐다면 단일행 서브쿼리가 아님.
                                              -- 즉, 값이 중복이 될 수 있는 경우 
        1) 결과 행이 1개이다. 
        2) 단일 행 서브쿼리인 대표적인 경우
            (1) WHERE절에서 사용한 동등비교(=) 칼럼이 PK, UNIQUE 칼럼인 경우 (결과가 1개 나온다. 당연함. PK니까)
            (2) 집계함수처럼 결과가 1개의 값을 반환하는 경우
        3) 단일 행 서브커리에서 사용하는 연산자
            단일 행 연산자를 사용(=, !=, >, >=, <, <=)
    2. 다중 행 서브쿼리
        1) 결과 행이 1개 이상이다. (1개여도 다중행이 될 수 있다)
        2) FROM절, WHERE절에서 많이 사용된다.
        3) 다중 행 서브쿼리에서 사용하는 연산자
            다중 행 연산자를 사용(IN, ANY, ALL 등) -- 그냥 IN 사용하자! (IN을 사용하면 결과가 두개나와도 문제없음)
                                                   -- ANY나 ALL은 다른 연산자로도 대체될 수 있다.
*/

/* WHERE절의 서브쿼리 */
-- WHERE절의 서브쿼리는 JOIN으로 대부분 풀린다.

-- 1. 사원번호가 1001인 사원과 동일한 직급(POSITION)을 가진 사원을 조회하시오.
 SELECT 사원정보
   FROM 사원테이블
  WHERE 직급 = (사원번호가 1001인 사원의 직급)

-- 괄호안의 서브 쿼리가 먼저 돌아서 '과장' 데이터가 나오고 나머지 메인 쿼리가 돈다

SELECT EMP_NO, NAME, DEPART, GENDER, POSITION, HIRE_DATE, SALARY -- SELECT절
  FROM EMPLOYEE_TBL
 WHERE POSITION = (SELECT POSITION -- (SELECT절 ~); : 서브쿼리
                     FROM EMPLOYEE_TBL
                    WHERE EMP_NO = 1001); -- PK의 동등비교를 진행하는 서브쿼리이기 때문에 단일 행 서브쿼리이다.


-- 2. 부서번호가 2인 부서와 동일한 지역에 있는 부서를 조회하시오.
SELECT 부서정보
  FROM 부서
 WHERE 지역 = (부서번호가 2인 부서의 지역)

SELECT DEPT_NO, DEPT_NAME, LOCATION
  FROM DEPARTMENT_TBL
 WHERE LOCATION = (SELECT LOCATION -- 메인쿼리가 LOCATION을 준비했으니 서브쿼리도 LOCATION을 반환해줘야함
                     FROM DEPARTMENT_TBL
                    WHERE DEPT_NO = 2);
                    
--3. 가장 높은 급여를 받은 사원을 조회하시오.
SELECT 사원정보
  FROM 사원
 WHERE 급여 = (가장 높은 급여)

SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
  FROM EMPLOYEE_TBL
 WHERE SALARY = (SELECT MAX(SALARY) -- MAX함수는 SELECT절에서 칼럼에 미리 선택해줘야함 (WHERE절에서 하는거 아님 주의)
                   FROM EMPLOYEE_TBL);
       
-- 4. 평균 급여 이상을 받는 사원을 조회하시오.
SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
  FROM EMPLOYEE_TBL
 WHERE SALARY > (SELECT AVG(SALARY)
                   FROM EMPLOYEE_TBL);

-- 5. 평균 근속 개월 수 이상을 근무한 사원을 조회하시오
SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
  FROM EMPLOYEE_TBL
 WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= (SELECT AVG(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))
                                              FROM EMPLOYEE_TBL);
                  
-- 6. 부서번호가 2인 부서에 근무하는 사원들의 직급과 일치하는 사원을 조회하시오
SELECT 사원정보
  FROM  사원
 WHERE 직급 = (부서번호가 2인 부서에 근무하는 사원들의 직급);
 
SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
  FROM EMPLOYEE_TBL
 WHERE POSITION IN (SELECT POSITION -- 서브쿼리가 실행되면 '부장', '과장'값이 온다. 부장, 과장의 직급과 일치하는 사람을 데려오는거
                     FROM EMPLOYEE_TBL 
                    WHERE DEPART = 2); -- 서브쿼리의 WHERE절에서 사용한 칼럼(DEPART 칼럼)이 PK, UNIQUE가 아니기 때문에 단일행이 아니다.
                                       -- 따라서 단일 행 연산자인 등호(=) 대신 다중 행 연산자 IN을 사용해야 한다.                                       

 
 
-- 7. 부서명이 '영업부'인 부서에 근무하는 사원을 조회하시오.
SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
  FROM EMPLOYEE_TBL
 WHERE DEPART IN (SELECT DEPT_NO -- 둘이 PK,FK관계므로 참조할 수 있으니 비교 가능하다.
                    FROM DEPARTMENT_TBL
                   WHERE DEPT_NAME = '영업부'); -- 서브쿼리의 WHERE절에서 사용한 DEPART_NAME 칼럼은 PK/UNIQUE가 아니므로 다중 행 서브쿼리이다.
-- 참고. 조인으로 풀기
SELECT E.EMP_NO, E.NAME, E.DEPART, E.POSITION, E.GENDER, E.HIRE_DATE, E.SALARY -- SELECT절에서 테이블의 별명은 안 붙여도 실행가능하다. 가능한 붙여주자
  FROM DEPARTMENT_TBL D INNER JOIN EMPLOYEE_TBL E
    ON D.DEPT_NO = E.DEPART
 WHERE D.DEPT_NAME IN '영업부';

-- 8. 직급이 '과장'인 사원들이 근무하는 부서 정보를 조회하시오.

SELECT DEPT_NO, DEPT_NAME, LOCATION
  FROM DEPARTMENT_TBL
 WHERE DEPT_NO IN (SELECT DEPART -- WHERE절에는 관련이 있는 키를 넣어줘야하는 것 같다..
                     FROM EMPLOYEE_TBL
                    WHERE POSITION = '과장'); -- 서브쿼리의 WHERE절에서 사용한 POSITION 칼럼은 PK/UNIQUE가 아니므로 다중 행 서브쿼리이다.
  
-- 참고. 조인으로 풀기                    
SELECT D.DEPT_NO, D.DEPT_NAME, D.LOCATION
  FROM DEPARTMENT_TBL D INNER JOIN EMPLOYEE_TBL E
    ON D.DEPT_NO = E.DEPART
 WHERE E.POSITION = '과장';


-- 9. '영업부'에서 가장 높은 급여보다 더 높은 급여를 받는 사원을 조회하시오.
SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
  FROM EMPLOYEE_TBL
 WHERE SALARY > (SELECT MAX(SALARY)
                  FROM EMPLOYEE_TBL
                 WHERE DEPART IN (SELECT DEPT_NO
                                  FROM DEPARTMENT_TBL
                                 WHERE DEPT_NAME = '영업부'));
                    
-- 참고. 서브쿼리를 조인으로 풀기 (서브쿼리 + 조인)                           
SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
  FROM EMPLOYEE_TBL
 WHERE SALARY > (SELECT MAX(E.SALARY)
                   FROM DEPARTMENT_TBL D INNER JOIN EMPLOYEE_TBL E
                     ON D.DEPT_NO = E.DEPART
                  WHERE D.DEPT_NAME = '영업부');
                  
                  
                  
                  

/* SELECT절의 서브쿼리 */ 




/* FROM절의 서브쿼리 */ -- 중요.............,..,.,.,.,,.,.,
-- FROM 절의 서브쿼리는 별명을 꼭 줘라
-- 별명 준후 메인쿼리에서 별명 사용

/*
    인라인 뷰(Inline View) -- FROM절의 서브쿼리는 테이블을 반환하기 때문에 인라인뷰라고 부른다.
    1. 쿼리문에 포함된 뷰(가상 테이블)이다.
    2. FROM절에 포함되는 서브쿼리를 의미한다.
    3. 단일 행/다중 행 개념이 필요 없다.
    4. 인라인 뷰에 포함된 칼럼만 메인쿼리에서 사용할 수 있다.
    5. 인라인 뷰를 이용해서 SELECT문의 실행 순서를 조정할 수 있다.
*/    
/*
    가상 칼럼
    1. PSEDO COLOUMN (P는 묵음, 수도칼럼)
    2. 존재하지만 저장되어 있지 않은 칼럼을 의미한다.
    3. 사용할 수 있지만 일부 사용에 제약이 있다.
    4. 종류
        1) ROWID    : 행(ROW) 아이디, 어떤 행이 어디에 저장되어 있는지 알고 있는 칼럼(물리적 저장 위치)
        2) ROWNUM   : 행(ROW) 번호, 어떤 행의 순번 
*/


-- ROWID
SELECT ROWID, EMP_NO, NAME -- ROWID : 실제로 데이터가 어디에 저장되어 있는지 알려주는 주소같은 개념이다.
  FROM EMPLOYEE_TBL;
-- 오라클의 가장 빠른 검색은 ROWID를 이용한 검색이다
-- SELECT절의 서브쿼리는 JOIN으로 대부분 풀린다. 
SELECT EMP_NO, NAME
  FROM EMPLOYEE_TBL
 WHERE ROWID = 'AAAFH1AABAAALDBAAA';

/*
    ROWNUM의 제약 사항 - 중요
    1. ROWNUM이 1을 포함하는 범위를 조건으로 사용할 수 있다.
    2. ROWNUM이 1을 포함하지 않는 범위는 조건으로 사용할 수 없다.
    3. 모든 ROWNUM을 사용하려면 ROWNUM에 별명을 지정하고 그 별명을 사용하면 된다.(특이하네.. 별명 지어주면 모든 행 다 볼 수 있음)    
       칼럼의 별명은 SELECT절에서 준다(AS 절 이용)
*/

SELECT EMP_NO, NAME 
  FROM EMPLOYEE_TBL 
 WHERE ROWNUM = 1; -- ROWNUM이 1을 포함한 범위가 사용되므로 가능
 
SELECT EMP_NO, NAME 
  FROM EMPLOYEE_TBL 
 WHERE ROWNUM <= 2; -- ROWNUM이 1을 포함한 범위가 사용되므로 가능
 
SELECT EMP_NO, NAME 
  FROM EMPLOYEE_TBL 
 WHERE ROWNUM = 2; -- ROWNUM이 1을 포함한 범위가 아니므로 불가능!
 
SELECT ROWNUM AS RN, EMP_NO, NAME
  FROM EMPLOYEE_TBL
 WHERE RN = 2;  -- 실행 순서가 맞지 않기 때문에 실행이 불가능하다.(별명을 사용할 수 없다.)
                -- WHERE절의 순서가 먼전데 이미 별명으로 불렀으니 오류가 난다.
                -- 별명 지정을 WHERE절보다 먼저 처리하면 해결된다.
                -- 별명을 지정하는 인라인 뷰를 사용하면 가장 먼저 별명이 지정되므로 해결된다.
              
                         
SELECT E.EMP_NO, E.NAME 
  FROM (SELECT ROWNUM AS RN, EMP_NO, NAME
          FROM EMPLOYEE_TBL) E -- FROM 절의 서브쿼리도 ROWNUM의 이름을 지어줬기 때문에 메인 쿼리의 WHERE절에서 별명을 사용하여 ROWNUM을 부를 수 있다.
                               -- 그렇게 되면 행이 어떤 번호든 상관없이 불러와진다.
  WHERE E.RN = 4;              

-- FROM절 서브쿼리 연습

-- 1. 연봉이 2번째로 높은 사원을 조회하시오

-- 1) ROWNUM 칼럼 사용하기
SELECT E.EMP_NO, E.NAME, E.DEPART, E.POSITION, E.GENDER, E.HIRE_DATE, E.SALARY 
  FROM (SELECT ROWNUM AS RN, A.EMP_NO, A.NAME, A.DEPART, A.POSITION, A.GENDER, A.HIRE_DATE, A.SALARY -- 정렬하고 행번호 정리한 테이블의 이름은 E
          FROM (SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY                     --  ROWNUM AS RN : 연봉순으로 정렬한 테이블에 행번호 부여해라
                   FROM EMPLOYEE_TBL 
                 ORDER BY SALARY DESC) A) E    -- 정렬한 테이블의 이름은 A   
 WHERE E.RN = 3; -- 서브쿼리에서 정렬하고 행번호 붙이고 거기에 별명도 줬으니 메인쿼리에서 행번호 아무거나 조회 가능하다.

-- 2) ROW_NUMBER() 함수 이용하기
SELECT E.EMP_NO, E.NAME, E.DEPART, E.POSITION, E.GENDER, E.HIRE_DATE, E.SALARY 
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY SALARY DESC) AS RN, EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
          FROM EMPLOYEE_TBL) E -- ROW_NUMBER() : 함수기능을 사용한 ROWNUM  가져다 쓰기 
 WHERE E.RN = 3;

-- 2. 3 ~ 4번째로 입사한 사원을 조회하시오
--      1) 입사일자 순으로 정렬한다.
--      2) 정렬 결과에 행번호(ROWNUM)을 붙인다.
--      3) 원하는 행 번호를 조회한다.


-- 1) ROWNUM 칼럼 사용하기
SELECT E.EMP_NO, E.NAME, E.DEPART, E.POSITION, E.GENDER, E.HIRE_DATE, E.SALARY 
  FROM (SELECT ROWNUM AS RN, A.EMP_NO, A.NAME, A.DEPART, A.POSITION, A.GENDER, A.HIRE_DATE, A.SALARY
          FROM (SELECT EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY                
                  FROM EMPLOYEE_TBL 
                ORDER BY HIRE_DATE ASC) A) E
 WHERE E.RN = 3 OR E.RN = 4;
 
-- 2) ROW_NUMBER() 함수 이용하기

SELECT E.EMP_NO, E.NAME, E.DEPART, E.POSITION, E.GENDER, E.HIRE_DATE, E.SALARY 
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY HIRE_DATE ASC) AS RN, EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY
          FROM EMPLOYEE_TBL) E 
 WHERE E.RN = 3 OR E.RN = 4;

/*
    ROWNUM 정리하기
    ROWNUM이라는 시스템 함수를 사용하면 데이터의 행번호를 가져올 수 있다.
    하지만 아무런 정렬이 되지 않은 데이터에 순번을 매긴다면 그 순번을 쓸모가 없게 되버린다.
    그렇다면 정렬을 먼저 진행해야 하는데 SELECT절에 ROWNUM을 사용하고 ORDER BY를 사용해서 정렬한다면
    SELECT절이 먼저 실행되므로 행번호를 붙인후 정렬을하게 된다. 쓸모없는 과정이 바로 이것!
    이 문제를 정렬 ->순번 매기기로 진행한다며 문제가 해결된다.
    위와 같이 서브쿼리에서 먼저 정렬을 하고 순번을 매기는 방법으로 정렬된 데이터에 순번을 매길 수 있다.
    ORDER BY절에 의해 정렬된 순서에 행번호를 붙여 가져올 수 있다.
*/


























