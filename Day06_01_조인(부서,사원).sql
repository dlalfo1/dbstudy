/*
    드라이브(DRIVE) 테이블과 드리븐(DRIVEN) 테이블
    1. 드라이브(DRIVE) 테이블
        1) 조인 관계를 처리하는 메인 테이블
        2) 1:M 관계(일대다 관계)에서 1에 해당하는 테이블
        3) 행(ROW)의 개수가 일반적으로 적고, PK를 조인 조건으로 사용하기 때문에 인덱스(INDEX) 활용이 가능하다. : 인덱스란? 무슨데이터는 어디에 있다~ 하는 기록을 남겨놓는것.
    2. 드리븐(DRIVEN) 테이블
        1) 1:M 관계에서 M에 해당하는 테이블
        2) 행(ROW)의 개수가 일반적으로 많고, FK를 조인 조건으로 사용하기 때문에 인덱스(INDEX) 활용이 불가능하다. : 외래키는 인덱스를 타지 않음.
    3. 조인 성능 향상을 위해서 가급적 드라이브(DRIVE) 테이블을 먼저 작성한다. 드리븐(DRIVEN) 테이블은 나중에 작성한다.        
*/

--1, 내부 조인(두 테이블에 일치하는 정보를 조인한다.)
--1) 표준 문법 
SELECT E.EMP_NO, E.NAME, D.DEPT_NO, D.DEPT_NAME
  FROM DEPARTMENT_TBL D INNER JOIN EMPLOYEE_TBL E -- PK가진 테이블 먼저 명시(뒤에 단어 쓰면 별명 지어짐), 이게 성능이 더 좋다.
    ON D.DEPT_NO = E.DEPART; -- ON절에도 PK키 먼저 언급(근데 키가 여러개일때는 헷갈리니까 그냥 아무렇게 적어도 가능,, 성능차이기 때문,,)
                             -- 적은데이터를 가진걸로 운행을 해야 성능이 빠르다.

-- 표준문법 연습
SELECT E.EMP_NO, E.NAME, D.DEPT_NO, D.DEPT_NAME
  FROM DEPARTMENT_TBL D INNER JOIN EMPLOYEE_TBL E
    ON D.DEPT_NO = E.DEPART;


-- 2) 오라클 문법
SELECT E.EMP_NO, E.NAME, D.DEPT_NO, D.DEPT_NAME
  FROM DEPARTMENT_TBL D, EMPLOYEE_TBL E
 WHERE D.DEPT_NO = E. DEPART; 
 
-- 오라클 문법 연습
SELECT E.EMP_NO, E.NAME, D.DEPT_NO, D.DEPT_NAME
  FROM DEPARTMENT_TBL D, EMPLOYEE_TBL E
 WHERE D.DEPT_NO = E.DEPART;
 
 
--2. 왼쪽 외부 조인(왼쪽에 있는 테이블은 일치하는 정보가 없어도 무조건 조인한다.)
--   왼쪽 테이블에 있는 행들은 다 출력된다.

-- 1) 표준 문법
-- DEPT_NO가 일치하지 않는 총무부, 기획부의 값도 불러져온다. 대신 값은 null로 표기된다.
-- 이렇듯이 값이 없어도 불러와지기 때문에 주문내역 없는 회원리스트같은거 뽑아올 때 사용된다.
SELECT D.DEPT_NO, D.DEPT_NAME, E.EMP_NO, E.NAME
  FROM DEPARTMENT_TBL D LEFT OUTER JOIN EMPLOYEE_TBL E
    ON D.DEPT_NO = E.DEPART;

-- 표준문법 연습
SELECT D.DEPT_NAME, D.DEPT_NAME, E.EMP_NO, E.NAME
  FROM DEPARTMENT_TBL D LEFT OUTER JOIN EMPLOYEE_TBL E
    ON D.DEPT_NO = E.DEPART;
      
-- 2) 오라클 문법
-- FROM절에서 무슨쪽 조인인지 키워드를 사용하지 않는다.
-- 표준 문법이랑 다른점은 ON절 대신 WHERE절을 써준다는 점 (+) 붙여주는 점..
SELECT D.DEPT_NO, D.DEPT_NAME, E.EMP_NO, E.NAME
  FROM DEPARTMENT_TBL D, EMPLOYEE_TBL E
 WHERE D.DEPT_NO = E.DEPART(+); -- 왼쪽 조인을 한다면 오른쪽 조인 조건에(+) 붙여주기
 
-- 오라클 문법 연습
SELECT D.DEPT_NAME, D.DEPT_NAME, E.EMP_NO, E.NAME
  FROM DEPARTMENT_TBL D, EMPLOYEE_TBL E
 WHERE D.DEPT_NO = E.DEPART(+);

-- 외래키 제약 조건의 비활성화(일시 중지)
-- 제약조건이름 : FK_EMP_DEPT
ALTER TABLE EMPLOYEE_TBL
    DISABLE CONSTRAINT FK_EMP_DEPT; -- 비활성화 하는 키워드 : DISABLE
    
-- 외래키 제약조건이 없는 상태이므로, 제약조건을 위배하는 데이터를 입력할 수 있다.
-- 시퀀스 이름 EMPLOYEE_SEQ
INSERT INTO EMPLOYEE_TBL(EMP_NO, NAME, DEPART, POSITION, GENDER, HIRE_DATE, SALARY) -- 임플로이 테이블의 칼럼들 다 넣어줌
VALUES(EMPLOYEE_SEQ.NEXTVAL, '김성실', 5, '대리', 'F', '98/12/01', 3500000);
COMMIT; 

-- 외래키 제약조건의 활성화(다시 시작)
-- 제약조건이름 : FK_EMP_DEPT
ALTER TABLE EMPLOYEE_TBL
    ENABLE CONSTRAINT FK_EMP_DEPT;

--3. 오른쪽 외부 조인(오른쪽 있는 테이블은 일치하는 정보가 없어도 무조건 조인한다.) 

-- 1) 표준 문법
SELECT D.DEPT_NO, D.DEPT_NAME, E.EMP_NO, E.NAME
  FROM DEPARTMENT_TBL D RIGHT OUTER JOIN EMPLOYEE_TBL E
    ON D.DEPT_NO = E.DEPART;
 
-- 2) 오라클 문법
SELECT D.DEPT_NO, D.DEPT_NAME, E.EMP_NO, E.NAME
  FROM DEPARTMENT_TBL D, EMPLOYEE_TBL E 
 WHERE D.DEPT_NO(+) = E.DEPART;
 
-- 외래키 제약조건을 위반하는 데이터 삭제하기
DELETE FROM EMPLOYEE_TBL WHERE EMP_NO = 1005;   -- PK(EMP_NO)를 조건으로 사용하면 인덱스를 타기 때문에 빠르다.
DELETE FROM EMPLOYEE_TBL WHERE NAME = '김성실'; -- 인덱스를 타지 않는 일반 칼럼(NAME)은 풀스캔 해야하기 때문에 느리다.
                                                -- 이렇기 때문에 같은 상황이라면 PK를 이용해서 조건을 만드는게 좋다.
COMMIT;

 