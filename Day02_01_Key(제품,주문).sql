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

-- 제품 테이블
DROP TABLE PRODUCT_TBL; -- 맨 처음 실행시킬 때 삭제 먼저 하고 생성하기 때문에 오류메세지 먼저 출력후 생성된다.
CREATE TABLE PRODUCT_TBL (
    PROD_NO NUMBER NOT NULL PRIMARY KEY, -- PK 선언. NOT NULL 명시는 함께한다. 하지만 UNIQUE는 생략한다.
    PROD_NAME VARCHAR2(10 BYTE),
    PROD_PRICE NUMBER,
    PROD_STOCK NUMBER
);