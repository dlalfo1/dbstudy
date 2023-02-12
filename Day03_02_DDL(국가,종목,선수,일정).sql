/*
    KEY 제약조건 변경하기
    1. 기본키
        1) 추가
            ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY(칼럼);
        2) 삭제
            ALTER TABLE 테이블명 DROP PRIMARY KEY;
            ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
    2. 외래키
        1) 추가
            ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 FOREIGN KEY(칼럼) REFERENCES 부모테이블(참조칼럼) [옵션]
        2) 삭제
            ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
*/ 

-- 테이블 삭제
DROP TABLE SCHEDULE_TBL;
DROP TABLE PLAYER_TBL;
DROP TABLE EVENT_TBL;
DROP TABLE NATION_TBL;

-- NATION_TBL 테이블 생성
CREATE TABLE NATION_TBL (
    N_CODE          NUMBER(3)         NOT NULL,
    N_NAME          VARCHAR2(30 BYTE) NOT NULL,
    N_PARTI_PERSON  NUMBER            NULL,
    N_PARTI_EVENT   NUMBER            NULL,
    N_PREV_RANK     NUMBER            NULL,
    N_CURR_RANK     NUMBER            NULL
);

-- EVENT_TBL 테이블 생성
CREATE TABLE EVENT_TBL (
    E_CODE        NUMBER             NOT NULL,
    E_NAME        VARCHAR2(30 BYTE)  NOT NULL,
    E_FIRST_YEAR  NUMBER(4)          NULL,
    E_INFO        VARCHAR2(100 BYTE) NULL
);

-- PLAYER_TBL 테이블 생성
CREATE TABLE PLAYER_TBL (
    P_CODE  NUMBER(3)         NOT NULL,
    P_NAME  VARCHAR2(30 BYTE) NOT NULL,
    N_CODE  NUMBER(3)         NOT NULL,
    E_CODE  NUMBER            NOT NULL,
    P_RANK  NUMBER            NULL,
    P_AGE   NUMBER(3)         NULL
);

-- SCHEDULE_TBL 테이블 생성
CREATE TABLE SCHEDULE_TBL (
    S_NO          NUMBER(3)          NOT NULL,
    N_CODE        NUMBER(3)          NULL,
    E_CODE        NUMBER             NULL,
    S_START_DATE  DATE               NULL,
    S_END_DATE    DATE               NULL,
    S_INFO        VARCHAR2(100 BYTE) NULL
);

-- 기본키 제거하기(문법 소개일 뿐, 실제로 작성할 필요는 없습니다. DROP TABLE을 수행하면 제약조건도 모두 제거됩니다.)
ALTER TABLE NATION_TBL
    DROP PRIMARY KEY;  -- 테이블의 기본키는 오직 1개이므로 제약조건의 이름을 몰라도 삭제할 수 있다.
ALTER TABLE EVENT_TBL
    DROP PRIMARY KEY;
ALTER TABLE PLAYER_TBL
    DROP PRIMARY KEY;
ALTER TABLE SCHEDULE_TBL
    DROP PRIMARY KEY;

-- 기본키 추가하기
ALTER TABLE NATION_TBL
    ADD CONSTRAINT PK_NATION PRIMARY KEY(N_CODE);
ALTER TABLE EVENT_TBL
    ADD CONSTRAINT PK_EVENT PRIMARY KEY(E_CODE);
ALTER TABLE PLAYER_TBL
    ADD CONSTRAINT PK_PLAYER PRIMARY KEY(P_CODE);
ALTER TABLE SCHEDULE_TBL
    ADD CONSTRAINT PK_SCHEDULE PRIMARY KEY(S_NO);

-- 외래키 제거하기(문법 소개일 뿐, 실제로 작성할 필요는 없습니다. DROP TABLE을 수행하면 제약조건도 모두 제거됩니다.)
ALTER TABLE PLAYER_TBL
    DROP CONSTRAINT FK_PLAYER_NATION;
ALTER TABLE PLAYER_TBL
    DROP CONSTRAINT FK_PLAYER_EVENT;
ALTER TABLE SCHEDULE_TBL
    DROP CONSTRAINT FK_SCHEDULE_NATION;
ALTER TABLE SCHEDULE_TBL
    DROP CONSTRAINT FK_SCHEDULE_EVENT;

-- 외래키 추가하기
ALTER TABLE PLAYER_TBL
    ADD CONSTRAINT FK_PLAYER_NATION FOREIGN KEY(N_CODE)
        REFERENCES NATION_TBL(N_CODE)
            ON DELETE CASCADE;
ALTER TABLE PLAYER_TBL
    ADD CONSTRAINT FK_PLAYER_EVENT FOREIGN KEY(E_CODE)
        REFERENCES EVENT_TBL(E_CODE)
            ON DELETE CASCADE;
ALTER TABLE SCHEDULE_TBL
    ADD CONSTRAINT FK_SCHEDULE_NATION FOREIGN KEY(N_CODE)
        REFERENCES NATION_TBL(N_CODE)
            ON DELETE SET NULL;  -- ON DELETE CASCADE도 가능하다.
ALTER TABLE SCHEDULE_TBL
    ADD CONSTRAINT FK_SCHEDULE_EVENT FOREIGN KEY(E_CODE)
        REFERENCES EVENT_TBL(E_CODE)
            ON DELETE SET NULL;  -- ON DELETE CASCADE도 가능하다.

-- 연습. NATION_TBL의 기본키 제거하기
-- 외래키(FK)에 의해서 참조 중인 기본키(PK)는 "반드시" 외래키를 먼저 삭제해야 한다.
ALTER TABLE PLAYER_TBL
    DROP CONSTRAINT FK_PLAYER_NATION;
    
ALTER TABLE SCHEDULE_TBL
    DROP CONSTRAINT FK_SCHEDULE_NATION;    
    
ALTER TABLE NATION_TBL
    DROP PRIMARY KEY;    

-- 외래키 제약 조건 일시중지(비활성화)
ALTER TABLE PLAYER_TBL 
    DISABLE CONSTRAINT FK_PLAYER_EVENT;
    
    
    
-- 외래키 제약 조건 다시 시작(활성화)
ALTER TABLE PLAYER_TBL
    ENABLE CONSTRAINT FK_PLAYER_EVENT;







