-- ch08.sql

-- DDL : 데이터 정의어
-- create / alter / drop

-- 예제 8-1
create database 세계학사;
use 세계학사;

-- 예제 8-2
create table 학과
( 	학과번호 char(2),
	학과명 varchar(20),
	학과장명 varchar(20)
);

desc 학과;

insert into 학과
values('AA','컴퓨터공학과','배경민'),
('BB','소프트웨어학과','김남준'),
('CC','디자인융합학과','박선영');

select * from 학과;

-- 예제 8-3
create table 학생
(
	학번 char(5),
	이름 varchar(20),
	생일 date,
	연락처 varchar(20),
	학과번호 char(2) -- 외래키
);

insert into 학생
values ('S0001','이윤주','2020-01-30','01033334444','AA'),
('S0002','이승은','2021-02-23',null,'AA'),
('S0003','백재용','2018-03-31','01077778888','DD');

select * from 학생;

-- 테이블의 구조와 데이터를 복사하기
create table 휴학생 as
select * from 학생;

select * from 휴학생;

-- 예제 8-4
-- 구조만 복사하기
create table 휴학생 as
select * from 학생
where 1=2; -- 항상 false이다.

-- 계산된 결과를 저장하기
create table 회원(
	아이디 varchar(20) primary key,
	회원명 varchar(20),
	키 int,
	몸무게 int,
	체질량지수 decimal(4,1) as (몸무게/power(키/100,2)) stored
	-- decimal(4,1)소수점 1자리까지, 4자리 수
	-- power(밑,지수) 밑을 지수만큼 거듭제곱
	-- stored 테이블에 실제 저장
);

desc 회원;

insert into 회원(아이디, 회원명, 키, 몸무게)
values ('ARANG','김아랑',170,55);

select * from 회원;

-- 테이블, 뷰, 인덱스 속성 변경
-- alter
-- 예제 8-6
alter table 학생 add 성별 char(1);
desc 학생;

-- 예제 8-8
alter table 학생 change column 연락처 휴대폰번호 varchar(20);
-- 예제 8-9
alter table 학생 drop column 성별;
-- 예제 8-10
alter table 학생 rename 졸업생;
desc 졸업생;

-- 테이블, 뷰, 인덱스 삭제
-- drop
-- 예제 8-11
drop table 학과;
drop table 졸업생;

-- 제약조건
-- 예제 8-12
-- 1
create table 학과(
	학과번호 char(2) primary key, -- not null, unique
	학과명 varchar(20) not null,
	학과장명 varchar(20)
);
drop table 학과;
-- 2
create table 학과(
	학과번호 char(2),
	학과명 varchar(20),
	학과장명 varchar(20),
	primary key(학과번호)
);
-- 3
create table 학과(
	학과번호 char(2),
	학과명 varchar(20),
	학과장명 varchar(20)
);
alter table 학과
add constraint pk_학과 primary key(학과번호);
desc 학과;

insert into 학과
values('01','국어국문과','홍교수');
insert into 학과
values('01','영어국문과','데이비드교수'); -- primary key -> unique 속성으로 안 됨
insert into 학과
values(null,'영어국문과','데이비드교수'); -- primary key -> not null 속성으로 안 됨

-- 예제 8-13
create table 학생(
	학번 char(5) primary key,
	이름 varchar(20) not null,
	생일 date not null,
	연락처 varchar(20) unique,
	학과번호 char(2) references 학과(학과번호),
	성별 char(1) check(성별 in ('남','여')),
	등록일 date default(curdate()),
	foreign key(학과번호) references 학과(학과번호) -- 외래키 제약조건
);
drop table 학생;

desc 학생;

insert into 학과
values('01','국어국문과','홍교수');
select * from 학과;

insert into 학생
values('S0001','강감찬','2000-02-03','01022223333','01','남',null);
insert into 학생
values('S0002','사임당','2000-02-03','01044445555','01','여',null);
insert into 학생(학번, 이름, 생일, 연락처, 학과번호, 성별)
values('S0003','이순신','2000-02-03','01066667777','01','남'); -- 등록일 default

select * from 학생;

-- 예제 8-14
create table 과목( 
	과목번호 char(5) primary key,
	과목명 varchar(20) not null,
	학점 int not null check( 학점 between 2 and 4),
	구분 varchar(20) check(구분 in ('전공','교양','일반'))
);

-- 예제 8-15
create table 수강( 
	수강번호 int primary key auto_increment,
	수강년도 char(4) not null,
	수강학기 varchar(20) not null check( 수강학기 in ('1학기','2학기','여름학기','겨울학기')),
	학번 char(5) not null,
	과목번호 char(5) not null,
	성적 numeric(3,1) check(성적 between 0 and 4.5),
	foreign key(학번) references 학생(학번),
	foreign key(과목번호) references 과목(과목번호)
);
desc 수강;
-- 예제 8-17
INSERT INTO 학과
VALUES ('AA','컴퓨터공학과','배경민');

INSERT INTO 학과
VALUES ('BB','소프트웨어학과','김남준');

INSERT INTO 학과
VALUES ('CC','디자인융합학과','박선영');

desc 제품;
drop table 수강;
-- ON DELETE/UPDATE CASCADE
-- 참조하는 부모 테이블에서 삭제/수정이 일어날 때 자식 테이블도 자동으로 반영
DROP TABLE 학생; -- 외래키가 있는 테이블부터 먼저 삭제해야 됨.
DROP TABLE 학과;

CREATE TABLE 학과 (
  학과번호 CHAR(2) PRIMARY KEY,
  학과명 VARCHAR(20)
);
CREATE TABLE 학생 (
  학번 CHAR(5) PRIMARY KEY,
  이름 VARCHAR(20),
  학과번호 CHAR(2),
  FOREIGN KEY (학과번호) 
    REFERENCES 학과(학과번호)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 학과 데이터
INSERT INTO 학과 VALUES ('01', '국어국문과');
INSERT INTO 학과 VALUES ('02', '컴퓨터공학과');

-- 학생 데이터
INSERT INTO 학생 VALUES ('S0001', '홍길동', '01');
INSERT INTO 학생 VALUES ('S0002', '이몽룡', '02');

SELECT * FROM 학생;
SELECT * FROM 학과;

-- 학생 테이블에서 '02'를 참조하던 '이몽룡'의 학과번호도 자동으로 '03'으로 바뀜
UPDATE 학과 SET 학과번호 = '03' WHERE 학과번호 = '02';

-- 학생 테이블에서 '01'을 참조하던 '홍길동' 학생도 자동 삭제됨
DELETE FROM 학과 WHERE 학과번호 = '01';

use 세계무역;
desc 제품;
-- 연습문제
-- 1. 제품 테이블의 재고 컬럼에 CHECK 제약조건을 추가하시오.
-- * ALTER TABLE 명령을 사용합니다.
-- 제약조건: 재고는 0보다 크거나 같아야 합니다.
alter table 제품
add check ( 재고 >=0 );

-- 2. 제품 테이블에 재고금액 컬럼을 추가하시오. 이때 재고금액은 ‘단가 * 재고’가 자동 계산되어 저장되도록 합니다.
--     * ALTER TABLE 명령을 사용합니다.
--     * STORED 옵션을 사용하면 됩니다.
alter table 제품
add 재고금액 int as (단가*재고) stored;

-- 3. 제품 테이블에서 제품 레코드를 삭제하면 주문세부 테이블에 있는 관련 레코드도 함께 삭제되도록
-- 주문세부 테이블의 제품번호 컬럼에 외래키 제약조건과 옵션을 설정하시오.
--     * ALTER TABLE 명령을 사용합니다.
-- 	   * 외래키 제약조건을 설정할 때  ON DELETE CASCADE 옵션을 설명하면, 
--     부모 레코드 삭제시 자식 레코드도 연쇄적으로 삭제되어 데이터의 일관성을 유지할 수 있습니다.
alter table 주문세부
add foreign key(제품번호) references 제품(제품번호) ON DELETE cascade;

desc 주문세부;

-- 실전문제
-- 1.영화 테이블과 평점관리 테이블을 만들고자 합니다. 다음 테이블 명세서를 참고하여 테이블을 생성하시오.
create table 영화(
	영화번호 char(5) primary key,
	타이틀 varchar(100) not null,
	장르 varchar(20) check(장르 in ('코미디','드라마','다큐','SF','액션','기타')),
	배우 varchar(100) not null,
	감독 varchar(50) not null,
	제작사 varchar(150) not null,
	개봉일 date,
	등록일 date default(curdate())
);

desc 영화;

-- 2.다음 테이블 명세서를 참고하여 평점관리 테이블을 생성하시오.
create table 평점관리(
	번호 int primary key auto_increment,
	평가자닉네임 varchar(50) not null,
	영화번호 char(20) not null,
	평점 int check( 평점 between 1 and 5) not null ,
	평가 varchar(2000) not null,
	등록일 date default(curdate()),
	foreign key(영화번호) references 영화(영화번호)
);

desc 평점관리;

-- 3.영화  테이블에 다음과 같이 데이터를 추가하시오.
insert into 영화(영화번호, 타이틀, 장르, 배우, 감독, 제작사, 개봉일)
values('00001','파묘','드라마','최민식, 김고은','장재현','쇼박스','2024-02-22'),
('00002','듄:파트2','액션','티미시 샬라메, 젠데이아','드니 뵐뇌브','레전더리 픽처스','2024-02-28');

select * from 영화;

-- 4.평점관리 테이블에 다음과 같이 데이터를 추가하시오.
insert into 평점관리(평가자닉네임, 영화번호, 평점, 평가)
values('영화광','00001',5,'미치도록 스릴이 넘쳐요'),
('무비러브','00002',4,'장엄한 스케일이 좋다');

select * from 평점관리;

-- 5.영화번호를 00003으로도 새로운 레코드를 넣어서 오류 발생 여부를 확인하시오.
insert into 평점관리(평가자닉네임, 영화번호, 평점, 평가)
values('영화광','00003',5,'미치도록 스릴이 넘쳐요');

-- 6. 영화테이블에서 레코드를 지우면 외래키 제약조건에 의해 오류가 발생하는지 확인하시오.
delete from 영화 where 영화번호='00001';

-- 7. ON CASCADE 옵션을 통해 6번 문제를 해결하시오.
alter table 평점관리
drop FOREIGN KEY 평점관리_ibfk_1; -- 기존 외래키 제거

alter table 평점관리
add foreign key(영화번호) references 영화(영화번호) on delete cascade;

delete from 영화 where 영화번호='00001';

select * from 평점관리;

desc 평점관리;


