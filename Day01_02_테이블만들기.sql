/*
    테이블
    1. 데이터베이스의 가장 대표적인 객체이다.
    2. 데이터를 보관하는 객체이다.
    3. 표 형식으로 데이터를 보관한다.
    4. 테이블 기본 용어
        1) 열 : colum, 속성(attribute), 필드(field) 
        2) 행 : row,   개체(entity),    레코드(record) - 데이터를 의미한다.
*/

/* 
    오라클의 데이터 타입
    1. CHAR(size)    : 고정 길이 문자 타입(size : 1 ~ 2000바이트)
        - 오라클에선 한글자든 여러글자든 키워드를 나눠서 저장하지 않는다. (CHAR 키워드에 문자든 문자열이든 전부 담긴다.)
        - 길이가 고정적일 때 사용한다(ex. CHAR(13) - 주민등록번호)
    2. VARCHAR2(size) : 가변길이 문자 타입(size : 1~ 4000바이트)    
        - 길이가 다 다를 때 사용한다 (ex. 집 주소)
    3. DATE          : 날짜/시간 타입(JAVA DATE 클래스와 매칭하기 위한 타입)
    4. TIMESTAMP     : 날짜/시간 타입(좀 더 정밀) - (JAVA TIMESTAMP 클래스와 매칭하기 위한 타입)
    5. NUMBER(p,s)   : 정밀도(p), 스케일(s)로 표현하는 숫자 타입
        1) 정밀도 : 정수부와 소수부를 모두 포함하는 전체 유효 숫자가 몇 개인가?
        3) 스케일 : 소수부의 전체 유효 숫자가 몇 개인가?
        예시)
            (1) NUMBER      : 최대 38자리 숫자(22바이트) 
            (2) NUMBER(3)   : 정수부가 최대 3자리인 숫자(최대 999)
            (3) NUMBER(5,2) : 최대 전체 5자리, 소수부 2자리인 숫자 ex)231.45
            (4) NUMBER(2,2) : 1 미만의 소수부 2자리인 실수 ex)0.15 - 정수부의 0은 유효 자리수가 아니다. 0이 소수부 뒤에 붙어도 그러하다.
       -> JAVA에서는 int, double 등등으로 정수 실수를 구분했지만 Oracle SQL에선 NUMBER로 구분한다.  
*/

/*
    제약조건(Constraint) - 
    1. 널
        1) NULL 또는 생략
        2) NOT NULL
    2. 중복 데이터 방지 - 데이터가 중복 되면 안 될 때 사용한다. ex) 주민등록번호
        UNIQUE 
    3. 값의 제한 - 특정한 값이 들어가면 안될 때 사용한다. 값의 범위를 지정해준다고 생각하면 될 것 같다.
        CHECK
    4. 개체 무결성 - 테이블 데이터를 식별할 수 있는 단 하나의 칼럼 PK(PRIMARY KEY) - 기본키라고 부른다.
       PRIMARY KEY   테이블에는 테이블을 관리하는 ex)회원번호, 블로그번호 같은 칼럼이 꼭 들어가 있다
                     여기서 회원번호, 블로그 번호가 PK이다.
                     PK 값은 NOT NULL 이고 UNIQUE 여야 하지만 명시할 땐 NOT NULL 키워드만 적어준다.
                     칼럼에 밑줄이 쳐져 있다.
    5. 참조 무결성  - 참조하는 값만 가질 수 있다. (메모장에 설명)
       FOREIGIN KEY   관계를 맺은 칼럼이 존재하지 않다면 참조 무결성에 위배된것이다.
  
        
        
    
*/

-- 예시 테이블
-- SQL에선 변수이름을 앞에 두고 타입을 뒤에 둔다.
-- 키워드 DROP, CREATE - 뭔가를 지우고 만들 때 쓴다.(DBL)  
-- 쿼리문을 쓸 때 대문자든 소문자든 상관이 없다. 다만 한가지로 통일해야 한다. (무엇으로 쓰든 DB로 넘어갈 때 대문자로 바뀐다.)
-- 키워드 입력할 때 순서는 상관이 없다. 띄어쓰기만 해서 써주면 된다.
-- = 키워드는 같다이다.
-- 글자수에 상관없이 '' 작은따옴표로 묶는다.
-- 그리고 AND , 또는 OR
DROP TABLE PRODUCT;
CREATE TABLE PRODUCT(
    CODE         VARCHAR2(2 BYTE)  NOT NULL UNIQUE, -- CODE의 값은 NULL일 수 없다. NULLABLE에 NO가 표시된다. 제약조건은 UNIQUE이다.
    MODEL        VARCHAR2(10 BYTE) NULL, 
    CATEGORY     VARCHAR2(5 BYTE)   CHECK(CATEGORY IN('MAIN', 'SUB')) : CATEGORY가 MAIN과 SUB중 하나다
    PRICE        NUMBER            CHECK(PRICE >= 0), 
    AMOUNT       NUMBER(2)         CHECK(AMOUNT >= 0 AND AMOUNT <= 100),        -- CHECK(AMOUNT BETWEEN 0 AND 100) : AMOUNT가 0과 100사이이다.(0과 100 포함)
    MANUFACTURED DATE 
);

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    