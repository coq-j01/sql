-- 확인용
-- db 생성
DROP DATABASE IF EXISTS dashboard;
CREATE DATABASE dashboard;

-- db 사용 설정
USE dashboard;

-- 회원정보 테이블
DROP TABLE IF EXISTS dashboard.welding;
CREATE TABLE dashboard.welding(
   w_no INT PRIMARY KEY AUTO_INCREMENT NOT NULL, -- 기본키
   w_method VARCHAR(255) NOT NULL, -- 용접방법( "FCAW", "EGW", "FCSA", "FAB", "SAW" )
   w_defect_rate INT, -- 용접 불량율( 10 : 10% )
   w_date date DEFAULT (CURRENT_DATE) -- 가입일
);

-- json 출력 형식
-- { "w_no": 1, "w_method": "FCAW", "w_defect_rate": 10, "w_date": "2023-10-10" }
-- { "w_no": 2, "w_method": "EGW", "w_defect_rate": 5, "w_date": "2023-10-11" }

-- 테이블 구조 확인
DESCRIBE dashboard.welding;

-- 데이터 추가하기
INSERT INTO welding VALUES
	(0, 'FCAW', 10, '2024-01-01');
INSERT INTO welding VALUES
	(0, 'EGW', 5, CURRENT_DATE); -- 현재 날짜로 날짜 입력
INSERT INTO welding VALUES
	(0, 'FCSA', 15, CURRENT_DATE);
INSERT INTO welding VALUES
	(0, 'FAB', 25, CURRENT_DATE);
INSERT INTO welding VALUES
	(0, 'SAW', 12, CURRENT_DATE);    

SELECT * FROM welding;

-- Node.js에서 접속시 에러내용 : 
-- Error: ER_NOT_SUPPORTED_AUTH_MODE: Client does not support authentication protocol requested by server; consider upgrading MySQL client

-- MySQL 서버의 사용자 인증 방식을 변경
-- 기존 사용자에 대해 MySQL 8.0의 caching_sha2_password 방식 대신 
-- mysql_native_password 방식을 사용할 수 있도록 사용자 계정을 수정합니다.
-- ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '0000';
-- 변경 사항을 적용합니다.
-- FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql123';
FLUSH PRIVILEGES;