-- mysql blog
use mydb;

create table posts( 
	id int primary key auto_increment,
	title varchar(50) not null,
	content varchar(100) not null
);
create table comments(
	id int primary key auto_increment,
	post_id int,
	content varchar(100) not null,
	foreign key(post_id) references posts(id) on delete cascade
);