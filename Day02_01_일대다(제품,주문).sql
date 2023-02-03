/*
    KEY 제약조건 
    1. 기본키(PK : Primary Key)
        1) 개체무결성
        2) NOT NULL + UNIQUE 해야 한다.
    2. 외래키(FK : Foreign Key)
        1) 참조무결성
        2) FK는 참조하는 값만 가질 수 있다.
*/

/*
    일대다(1:M) 관계
    1. PK와 FK를 가진 테이블 간의 관계이다.
        1) 부모 테이블 : 1, PK를 가진 테이블
        2) 자식 테이블 : M, FK를 가진 테이블
    2. 생성과 삭제 규칙
        1) 생성 규칙 : "반드시" 부모 테이블을 먼저 생성한다.
        2) 삭제 규칙 : "반드시" 자식 테이블을 먼저 삭제 한다.
        * 당연하게 생각해보면 부모가 먼저 생겨야 자식이 생기고 참조된 자식을 먼저 지워야 오류없이 부모도 지워질듯        
*/

-- 삭제를 모아서 하고, 생성도 모아서 한다, 삭제는 생성 순서와 거꾸로 한다.
-- 생성부터 먼저 하고 위에 삭제를 써주면 쉽다. 생성과 거꾸로 하면 되니까. 
-- 테이블 삭제 
DROP TABLE ORDER_TBL; -- 삭제는 자식 먼저
DROP TABLE PRODUCT_TBL; -- 부모는 다음에 삭제

-- 제품 테이블(부모테이블)
CREATE TABLE PRODUCT_TBL (
    PROD_NO    NUMBER NOT NULL,  
    PROD_NAME  VARCHAR2(10 BYTE),
    PROD_PRICE NUMBER,
    PROD_STOCK NUMBER,
    CONSTRAINT PK_PROD PRIMARY KEY(PROD_NO) -- CONSTRAINT 키워드 사용하여 PK 제약조건을 줄 때 이름도 같이 준다. 관리하기 편하게 (PK_PROD)
                                            -- PK 키워드 쓸 때 괄호 안에 칼럼 이름 써주기.        
);


-- 주문 테이블(자식테이블)
CREATE TABLE ORDER_TBL (
    ORDER_NO NUMBER NOT NULL,
    USER_ID VARCHAR2(10 BYTE),
    PROD_NO NUMBER ,
    ORDER_DATE DATE, -- / 슬래시 사용해서 입력한다 23/02/03
    CONSTRAINT PK_ORDER PRIMARY KEY(ORDER_NO),
    CONSTRAINT FK_ORDER_PROD FOREIGN KEY(PROD_NO) REFERENCES PRODUCT_TBL(PROD_NO) 
    -- CONSTRAINT 제약조건명 FOREIGN KEY(컬럼명) REFERENCES 부모테이블(참조컬럼명)
    -- PK 제약조건을 줄건데 제약조건의 이름도 같이 줌. 관리하기 편하게 (PK_PROD)
    -- PK 키워드 쓸 때 괄호 안에 칼럼 이름 써주기. 
    -- REFERENCES 키워드 사용해서 어떤 테이블을 참조하는지 명시하고 괄호안에 칼럼 이름 써주기.
        
);


/*
    제약조건 테이블
    1. SYS, SYSTEM 관리 계정으로 접속해서 확인한다.
    2. 종류 
        1) ALL_CONSTRAINTS
        2) USER_CONSTRAINTS
        3) DBA_CONSTRAINTS
        
        앞엔 ALL, USER, DBA 키워드가 올 수도 있고 _ 테이블 확인하고 싶으면 TABLES가 올 수도 있다.
        (DATA DICTIONARY, CATALOG 로 부른다)
*/

-- 테이블의 구조를 확인하는 쿼리문 (설명)
-- DESCRIBE ALL_CONSTRAINTS;
-- SELECT * FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME LIKE 'PK%';






