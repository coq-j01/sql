-- mysql blog

-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS blog;

-- 데이터베이스 선택
USE blog;
create table posts( 
	id int primary key auto_increment,
	title varchar(50) not null,
	content varchar(200) not null
);
create table comments(
	comment_id int primary key auto_increment,
	post_id int,
	comment_content varchar(200) not null,
	foreign key(post_id) references posts(id) on delete cascade
);

select * from comments;