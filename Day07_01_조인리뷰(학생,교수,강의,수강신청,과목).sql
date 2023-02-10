-- 학생 이름, 담당 교수 이름 조회하기
-- 표준 문법
SELECT S.S_NAME, P.P_NAME
  FROM PROFESSOR_TBL P INNER JOIN STUDENT_TBL S
    ON P.P_NO = S.P_NO;
    
-- 오라클 문법
SELECT S.S_NAME, P.P_NAME
  FROM PROFESSOR_TBL P, STUDENT_TBL S
 WHERE P.P_NO = S.P_NO;
 
-- 교수번호, 교수이름, 교수전공, 강의이름, 강의실을 조회하시오.
-- P_NO         P_NAME  P_MAJOR,  L_LOCATION

-- 표준 문법
SELECT P.P_NO, P.P_NAME, P.P_MAJOR, L.L_NAME, L.L_LOCATION
  FROM PROFESSOR_TBL P INNER JOIN LECTURE_TBL L
    ON P.P_NO = L.P_NO;
    
-- 오라클 문법
SELECT P.P_NO, P.P_NAME, P.P_MAJOR, L.L_NAME, L.L_LOCATION
  FROM PROFESSOR_TBL P, LECTURE_TBL L
 WHERE P.P_NO = L.P_NO;

-- 학번, 학생이름, 수강 신청한 과목이름을 조회하시오
-- S_NO   S_NAME        C_NAME

-- 표준 문법
SELECT S.S_NO, S.S_NAME, C.C_NAME
  FROM STUDENT_TBL S INNER JOIN ENROLL_TBL E 
    ON S.S_NO = E.S_NO INNER JOIN COURSE_TBL C -- 드라이브, 드라이븐 테이블 개념으로 보면 맞지 않지만 이게 지켜지지 않았다고 해서 문제되는 건 아니다.
    ON C.C_NO = E.C_NO;

-- 오라클 문법
SELECT S.S_NO, S.S_NAME, C.C_NAME
  FROM STUDENT_TBL S, ENROLL_TBL E, COURSE_TBL C
 WHERE  S.S_NO = E.S_NO
   AND C.C_NO = E.C_NO;

-- 모든 교수들의 교수이름, 교수전공, 강의이름을 조회하시오. (교수는 총 3명이다.)
--                 P_NAME    P_MAJOR   L_NAME

-- 표준 문법
SELECT P.P_NAME, P.P_MAJOR, L.L_NAME
  FROM PROFESSOR_TBL P LEFT OUTER JOIN LECTURE_TBL L -- 강좌열린건 1번교수뿐이라 교수전체가 나오지 않고 1번교수만 나오기 때문에 
                                                     -- 교수를 다 보기 위해선 왼쪽 조인을 해준다.
    ON P.P_NO = L.P_NO;

-- 오라클 문법
SELECT P.P_NAME, P.P_MAJOR, NVL(L.L_NAME, '강좌없음')
  FROM PROFESSOR_TBL P, LECTURE_TBL L
 WHERE P.P_NO = L.P_NO(+);









