-- 데이터베이스 생성
create database if not exists mydb;

-- database 사용 선택
use mydb;

-- 테이블 생성
-- primaryv key : 기본키로 지정(unique, not null 기본 설정)
-- auto_increment : 자동증가 +1
create table member(
	member_no int(10) primary key auto_increment,
	member_id varchar(50), -- 로그인 아이디
	member_pw varchar(50), -- 로그인 패스워드
	member_nickname varchar(50) -- 닉네임
);

-- 테이블 구조 확인
desc member;

-- 행/레코드 추가
insert into `member`(member_no, member_id, member_pw, member_nickname)
values (1, 'hong','1234','홍길동');
--  모든 컬럼의 데이터를 기입하면, 필드이름 생략 가능
insert into `member` values (2, 'lee','1234','이순신');
-- auto_increment 속성 칼럼 0이면, 자동증가함
insert into `member` values (0, 'su','1234','수선화');

-- 레코드 수정하기
 update `member` set member_id='hong2', member_pw='2222' where member_no=1;

-- 레코드 삭제하기
delete from `member` where member_no =1;

-- 데이터 조회
select * from `member`;
-- 백틱` : 예약어일 수도 있는 사용자 정의어를 사용할 때

-- mysql : auto commit - 파일에 적용이 바로된다.

commit;


