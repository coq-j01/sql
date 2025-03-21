-- ch05.sql

-- 조인 : 2개 이상의 테이블을 조회하여 하나의 결과를 반환.
-- ANSI SQL 문법을 사용하여, DBMS마다 SQL문의 호환이 가능하다.

-- 크로스 조인 : 테이블A와 테이블B의 모든 행의 조합(AxB)
use 세계무역;
select count(*)
from 부서; -- 4

select count(*)
from 사원; -- 10

select count(*)
from 부서
cross join 사원; -- 40

select 부서.부서번호, 부서명, 이름, 사원.부서번호
from 부서
cross join 사원
where 이름='배재용';

-- 내부조인
-- INNER 조인 : 두 테이블 사이의 공통된 값을 기준으로 결과를 반환
--   1. 등가조인(이퀴 조인) : = 등호로 조인한다.
--   2. 비등가조인(논이퀴 조인) : 등호 외 비교 연산자로 조인한다.

-- '이소미'사원의 사원번호,직위,부서번호,부서명을 출력하시오.
-- 사원테이블, 부서테이블 2개를 조회한다.
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
INNER JOIN 부서
ON 사원.부서번호 = 부서.부서번호
WHERE 이름 = '이소미';

-- 조인 + GROUP BY절
SELECT 고객.고객번호, 담당자명, 고객회사명, COUNT(*) AS 주문건수
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
GROUP BY 1, 2, 3;

-- 3개의 테이블에서 INNER 등가조인 예)
-- 고객번호별로 주문금액합을 구하자.
SELECT 고객.고객번호, 담당자명, 고객회사명, SUM(주문수량 * 단가) AS 주문금액합
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
INNER JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
GROUP BY 1, 2, 3
ORDER BY 4 DESC; 

DESC 고객;
DESC 마일리지등급;

SELECT * 
FROM 마일리지등급;

-- INNER 조인 : 비등가조인
SELECT 고객번호, 고객회사명, 담당자명, 마일리지, 등급명
FROM 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
WHERE 담당자명 = '이은광';

-- OUTER JOIN : 조건(등가,비등가)에 맞지 않는 행도 결과값으로 나옴.

-- 사원 테이블에서 부서번호가 null인 행도 출력한다.
SELECT 부서명, 사원.*
FROM 사원
RIGHT OUTER JOIN 부서
ON 사원.부서번호 = 부서.부서번호;

-- 부서번호가 null인 사원만 출력한다.
SELECT 이름, 부서.*
FROM 사원
LEFT OUTER JOIN 부서
ON 사원.부서번호 = 부서.부서번호
WHERE 부서.부서번호 IS NULL; 

-- 셀프 조인 : 한개의 테이블을 대상으로 조인하는 것.
select * from 사원;

select 상사번호 from 사원
where 이름='이소미';

select 상사번호,이름 from 사원
where 사원번호='E06';

SELECT 사원.사원번호, 사원.이름
		, 상사.사원번호 AS '상사의 사원번호'
		, 상사.이름 AS '상사의 이름'
FROM 사원
INNER JOIN 사원 AS 상사
ON 사원.상사번호 = 상사.사원번호;

-- 예제 5-12
select 사원.사원번호, 사원.이름, 상사.사원번호 as '상사 사번', 상사.이름 as '상사이름'
from 사원 as 상사
right outer join 사원 -- 상사번호가 없는 사원도 같이 출력
on 사원.상사번호 = 상사.사원번호;

-- 연습문제                                    

-- 1. 세계무역 데이터베이스의 제품 테이블과 주문 세부 테이블을 조인하여 
--   제품명별로 주문수량합과 주문금액합을 보이시오.
select 제품명, sum(주문수량)as'주문수량 합', sum(주문수량*주문세부.단가) as '주문금액 합'
from 주문세부
inner join 제품
on 주문세부.제품번호 = 제품.제품번호
group by 제품명;

-- 2. 주문, 주문세부, 제품 테이블을 활용하여 '아이스크림'제품에 대해서
-- (주문년도 제품명)별로 주문수량합을 보이시오.
select 제품명,year(주문일)as'주문년도', sum(주문수량)as'주문수량 합'
from 주문세부
inner join 제품
on 주문세부.제품번호 = 제품.제품번호
inner join 주문
on 주문세부.주문번호 = 주문.주문번호
group by 제품명, year(주문일)
having 제품명 like '%아이스크림%'
order by year(주문일),제품명 ;

-- 3. 제품, 주문세부 테이블을 활용하여 제품명별로 주문수량합을 보이시오.
--   이때 주문이 한 번도 안 된 제품에 대한 정보도 함께 나타내시오.
select 제품명, sum(주문수량)as'주문수량 합'
from 주문세부
right outer join 제품
on 주문세부.제품번호 = 제품.제품번호
group by 제품명;

-- 4. 고객 회사 중 마일리지 등급이 'A'인 고객의 정보를 조회하시오. 
--  조회할 컬럼은 고객번호, 담당자명, 고객회사명, 등급명, 마일리지입니다.
select 고객번호, 담당자명, 고객회사명, 등급명,마일리지
from 고객
inner join 마일리지등급
on 마일리지 between 하한마일리지 and 상한마일리지 
where 등급명 = 'A';

select * from 마일리지등급;

-- 실전문제

-- 1. 마일리지 등급명별로 고객수를 보이시오.
select 등급명, count(고객번호) as '고객 수'
from 고객
inner join 마일리지등급
on 마일리지 between 하한마일리지 and 상한마일리지 
group by 등급명
order by 등급명;

-- 2. 주문번호 'H0249'를 주문한 고객의 모든 정보를 보이시오.
select * 
from 고객
inner join 주문
on 고객.고객번호 = 주문.고객번호
where 주문번호 = 'H0249';

-- 3. 2020년 4월 9일에 주문한 고객의 모든 정보를 보이시오.
select * 
from 고객
inner join 주문
on 고객.고객번호 = 주문.고객번호
where 주문일 = '2020-04-09';

-- 4. 도시별로 주문금액합을 보이되 주문금액합이 많은 상위 5개의 도시에 대한 
-- 결과만 보이시오.
select 도시, sum(주문수량*주문세부.단가) as '주문금액 합'
from 고객 
inner join 주문
on 고객.고객번호 = 주문.고객번호
inner join 주문세부
on 주문.주문번호 = 주문세부.주문번호
group by 도시
order by sum(주문수량*주문세부.단가) desc
limit 5;
