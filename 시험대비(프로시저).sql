-- 전달된 부서번호의 부서를 삭제하는 프로시저를 작성하시오.
-- 전달된 부서에 근무하는 모든 사원을 함께 삭제하시오.
-- DB는 문제 풀어보는게 좋을것같음. 쿼리문제랑 프로시저, 사용자함수, 트리거 만들어보기
CREATE OR REPLACE PROCEDURE DELETE_PROC(DEPTNO IN DEPARTMENT_TBL.DEPT_NO%TYPE) -- 평가에 IN만 나온다.
IS -- 변수가 필요하면 IS에다가 선언해줘야함. 
    
BEGIN 
   DELETE -- 사원테이블이 참조테이블이므로 먼저 지워줘야한다! FK있는 테이블을 먼저 지워야함 자식먼저 지워주기~
     FROM EMPLOYEE_TBL
    WHERE DEPART = DEPTNO;
   DELETE
     FROM DEPARTMENT_TBL
    WHERE DEPT_NO = DEPTNO;
   COMMIT; -- INSERT, DELETE, UPDATE 하고나면 COMMIT 필수!
EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLCODE); -- 에러코드
      DBMS_OUTPUT.PUT_LINE(SQLERRM);  -- 에러메세지
      ROLLBACK; -- 예외가 발생하면 ROLLBACK 해줘야 한다.
END;

EXECUTE DELETE_PROC(1); -- 실행시 부서도 없어지고 사원도 없어졌다.