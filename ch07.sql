-- ch07.sql

-- dml : 데이터 조작어

-- insert into 테이블 values 값
SELECT *
FROM 부서;
-- 예제 7-1
INSERT INTO 부서
VALUES ('A5', '마케팅부');

-- 예제 7-2
INSERT INTO 제품
VALUES(91, '연어피클소스', NULL, 5000, 40);

-- 예제 7-3
INSERT INTO 제품(제품번호, 제품명, 단가, 재고)
VALUES(90, '연어핫소스', 4000, 50);



DESC 사원;

-- 예제 7-4
INSERT INTO 사원(사원번호, 이름, 직위, 성별, 입사일)
VALUES('E20', '김사과','수습사원', '남', CURDATE())
	 ,('E21', '박바나나','수습사원', '여', CURDATE())
     ,('E22', '정오렌지','수습사원', '여', CURDATE());
     
SELECT *
FROM 사원;   

-- update 테이블 set 수정
-- 예제 7-5
update 사원
set 이름='김레몬'
where 사원번호 = 'E20';

-- 예제 7-6
update 제품
set 포장단위 = '200 ml bottles'
where 제품번호=91;

-- 예제 7-7
update 제품
set 단가 = 단가*1.1, 재고 = 재고-10
where 제품번호=91;

-- delete from 테이블
-- 예제 7-8
delete from 제품
where 제품번호=91;

-- 예제 7-9
delete from 사원
order by 입사일 desc
limit 3;

-- insert on duplicate key update : 레코드가 없다면 새롭게 추가하고, 있다면 데이터 변경
-- 예제 7-10
insert into 제품(제품번호, 제품명, 단가, 재고)
values(91, '연어피클핫소스',6000,50)
on duplicate key update
제품명 = '연어피클핫소스', 단가=7000, 재고=60;

SELECT *
FROM 제품;


-- 연습문제

-- 1. 제품 테이블에 레코드를 추가하시오.
-- 제품번호: 95, 제품명: 망고베리 아이스크림, 포장단위 : 400g, 단가: 800, 재고: 30
insert into 제품
values(95,'망고베리 아이스크림','400g',800,30);
-- 2. 제품 테이블에 레코드를 추가하시오.
-- 제품번호: 96, 제품명: 눈꽃빙수맛 아이스크림, 단가: 2000
insert into 제품(제품번호, 제품명, 단가)
values(96,'눈꽃빙수맛 아이스크림',2000);
-- 3. 문제2에서 추가한 96번 제품의 재고를 30으로 변경하시오.
update 제품
set 재고=30
where 제품번호=96;
-- 4. 사원이 한 명도 존재하지 않는 부서를 부서 테이블에서 삭제하시오.
delete from 부서
where not exists (select 사원번호 from 사원 where 사원.부서번호=부서.부서번호);

select * from 부서;


-- 실전문제
-- 1. 고객 테이블에서 새로운 레코드를 삽입하시오.
-- 고객번호: ZZZAA, 담당자명: 한동욱, 고객회사명: 자유트레이딩, 도시: 서울특별시
select * from 고객;

insert into 고객(고객번호,담당자명,고객회사명,도시)
values('ZZZAA','한동욱','자유트레이닝','서울특별시');
-- 2. 1번에서 삽입한 'ZZZAA' 고객의 레코드에 대해 컬럼 값을 다음과 같이 변경하시오.
-- 도시: 부산광역시, 마일리지: 100, 담당자직위: 대표 이사
update 고객
set 도시='부산광역시', 마일리지=100, 담당자직위='대표 이사'
where 고객번호='ZZZAA';

-- 3. 1번에서 삽입한 'ZZZAA' 고객의 레코드에 대해 마일리지를 
-- '대표 이사' 직위의 평균 마일리지 값으로 변경하시오.
-- 서브쿼리를 사용해서
-- CTE을 사용해서'
with 이사마일리지 as
(select avg(마일리지) as '평균마일리지'
from 고객
group by 담당자직위
having 담당자직위='대표 이사')
update 고객
set 마일리지=(select 평균마일리지 from 이사마일리지)
where 고객번호='ZZZAA';

-- 4. 사원번호 'E15'의 레코드가 없으면 레코드를 새로 삽입하고, 레코드가 있다면 데이터 값을 수정하는 문장을 작성하시오.
-- 사원번호: E15, 이름: 이석진, 직위: 수습사원
select * from 사원;

insert into 사원(사원번호,이름,직위)
values('E15','이석진','수습사원')
on duplicate key update
사원번호='E15', 이름='이석진', 직위='수습사원';

-- 5. 1번에서 삽입한  'ZZZAA' 고객의 레코드를 삭제하시오.
delete from 고객
where 고객번호='ZZZAA';

-- 6. 4번에서 삽입한 'E15' 사원의 레코드를 삭제하시오.
delete from 사원
where 사원번호='E15';
