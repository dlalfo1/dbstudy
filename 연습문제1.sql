-- 1. 다음 칼럼 정보를 이용하여 MEMBER_TBL 테이블을 생성하시오.
--    1) 회원번호: MEMBER_NO, NUMBER, 필수
--    2) 회원아이디: ID, VARCHAR2(30 BYTE), 필수, 중복 불가
--    3) 회원패스워드: PW, VARCHAR2(30 BYTE), 필수
--    4) 회원포인트: POINT, NUMBER
--    5) 회원등급: GRADE, VARCHAR2(10 BYTE), 'VIP', 'GOLD', 'SILVER', 'BRONZE' 값 중 하나를 가짐
--    6) 회원이메일: EMAIL, VARCHAR2(100 BYTE), 중복 불가

DROP TABLE MEMBER_TBL;
CREATE TABLE MEMBER_TBL(
       MEMBER_NO NUMBER NOT NULL,
       ID VARCHAR2(30 BYTE)  NOT NULL UNIQUE,
       PW VARCHAR2(30 BYTE)  NOT NULL,
    POINT NUMBER NULL,
    GRADE VARCHAR2(10 BYTE)  NULL CHECK(GRADE IN('VIP', 'GOLD', 'SILVER', 'BRONZE')),  -- CHECK IN 제약 조건 INSERT 키워드로 행에 넣을 문자열을 제한한다.
    EMAIL VARCHAR2(100 BYTE) NULL UNIQUE                                               -- GAEDE열엔 'VIP', 'GOLD', 'SILVER', 'BRONZE' 문자열만 올 수 있다.
);                                                                                     -- 그 외의 문자열을 넣으면 체크 제약조건이 위배되었다는 에러가 뜬다


INSERT INTO MEMBER_TBL(MEMBER_NO) VALUES(3);
INSERT INTO MEMBER_TBL(ID) VALUES('이미래');
INSERT INTO MEMBER_TBL(PW) VALUES('1111');
INSERT INTO MEMBER_TBL(POINT) VALUES(777);
INSERT INTO MEMBER_TBL(GRADE) VALUES('VVV');
INSERT INTO MEMBER_TBL(EMAIL) VALUES('AAA@AAA.CO.KR'); -- INSERT 키워드 사용해서 행 삽입할 때 이따위로 하나씩 나눠서 삽입하면 당연히 안 됨.

INSERT INTO MEMBER_TBL(MEMBER_NO, ID, PW, POINT, GRADE, EMAIL) VALUES(3, '이미래', '1111', 777, 'VIP', 'AAA@AAA.CO.KR'); -- 이렇게 한 행은 한번에 생성해야한다.
COMMIT;

-- 2. MEMBER_TBL 테이블에 다음 새로운 칼럼을 추가하시오. 
--    1) 회원주소: ADDRESS VARCHAR2(200 BYTE)
--    2) 회원가입일: REGIST_DATE DATE

ALTER TABLE MEMBER_TBL 
        ADD ADDRESS     VARCHAR2(200 BYTE) NULL
        ADD REGIST_DATE DATE               NULL;

-- 3. 추가된 회원주소 칼럼을 다시 삭제하시오.
ALTER TABLE MEMBER_TBL
     DROP COLUMN ADDRESS;

-- 4. 회원등급 칼럼의 타입을 VARCHAR2(20 BYTE)으로 수정하시오.
ALTER TABLE MEMBER_TBL
      MODIFY GRADE VARCHAR2(20 BYTE); -- CHECK IN 제약조건은 그대로 유지된다.
      
-- 5. 회원패스워드 칼럼의 이름을 PWD로 수정하시오.
ALTER TABLE MEMBER_TBL
     RENAME COLUMN PW TO PWD;

-- 6. 회원번호 칼럼에 기본키(PK_MEMBER)를 설정하시오.
ALTER TABLE MEMBER_TBL
      ADD CONSTRAINT PK_MEMBER PRIMARY KEY(MEMBER_NO);


-- 7. 다음 칼럼 정보를 이용하여 BOARD_TBL 테이블을 생성하시오.
--    1) 글번호: BOARD_NO, NUMBER, 필수
--    2) 글제목: TITLE, VARCHAR2(1000 BYTE), 필수
--    3) 글내용: CONTENT, VARCHAR2(4000 BYTE), 필수
--    4) 조회수: HIT, VARCHAR2(1 BYTE)
--    5) 작성자: WRITER, VARCHAR2(30 BYTE), 필수
--    6) 작성일자: CREATE_DATE, DATE

DROP TABLE BOARD_TBL;
CREATE TABLE BOARD_TBL(
    BOARD_NO NUMBER NOT NULL,
       TITLE VARCHAR2(1000 BYTE) NOT NULL,
     CONTENT VARCHAR2(4000 BYTE) NOT NULL,
         HIT VARCHAR2(1 BYTE)    NULL,
      WRITER VARCHAR2(30 BYTE)   NOT NULL,
 CREATE_DATE DATE NULL
); 

-- 8. 조회수 칼럼의 타입을 NUMBER로 수정하시오.

ALTER TABLE BOARD_TBL
     MODIFY HIT NUMBER;

-- 9. 글내용 칼럼의 필수 제약조건을 제거하시오.

ALTER TABLE BOARD_TBL
     MODIFY CONTENT VARCHAR2(4000 BYTE) NULL;


-- 10. 글번호 칼럼에 기본키(PK_BOARD)를 설정하시오.

ALTER TABLE BOARD_TBL
        ADD CONSTRAINT PK_BOARD PRIMARY KEY(BOARD_NO);

-- 11. 작성자 칼럼에 MEMBER_TBL 테이블의 회원아이디를 참조하는 FK_BOARD_MEMBER 외래키를 설정하시오.
-- 게시글을 작성한 회원 정보가 삭제되면 해당 회원이 작성한 게시글도 모두 함께 지워지도록 처리하시오.

ALTER TABLE BOARD_TBL
        ADD CONSTRAINT FK_BOARD_MEMBER FOREIGN KEY(WRITER)
        REFERENCES MEMBER_TBL(ID)
        ON DELETE CASCADE;
        

-- 12. MEMBER_TBL 테이블과 BOARD_TBL 테이블을 모두 삭제하시오.

DROP TABLE BOARD_TBL;
DROP TABLE MEMBER_TBL;
