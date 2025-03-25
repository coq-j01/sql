-- ch06.sql

-- 서브쿼리 : SQL문 내부에서 사용하는 SELECT문

-- 단일행 서브쿼리
-- 예제 6-1
-- 최고 마일리지를 보유한 고객의 정보를 구하시오
use 세계무역;
-- 최고 마일리지 찾기 ->128790
select max(마일리지)
from 고객;

SELECT *
FROM 고객
WHERE 마일리지 = 128790;

-- 합치기
select * from 고객
where 마일리지 = (select max(마일리지) from 고객);

-- 예제 6-2
-- 주문번호 'H0250'인 고객의 고객회사명, 담당자명을 출력하시오.
select 고객회사명, 담당자명
from 고객
where 고객번호 = (select 고객번호
from 주문
where 주문번호 = 'H0250');

-- 예제 6-4
-- 복수행 서브쿼리 : 복수행 비교연산자 IN, ANY(SOME), ALL, EXISTS

-- '부산광역시' 고객이 주문한 주문건수를 출력하기
-- IN : ~중의 하나라도 
SELECT COUNT(*) AS 주문건수
FROM 주문
WHERE 고객번호 IN ( SELECT 고객번호 FROM 고객
                    WHERE 도시 = '부산광역시' );

-- ANY :  마일리지 > 부산마일리지 OR ... OR ... OR                    
SELECT 담당자명, 고객회사명, 마일리지
FROM 고객
WHERE 마일리지 > ANY( SELECT 마일리지 FROM 고객
WHERE 도시 = '부산광역시' ); 

-- ALL :  AND ... AND ... AND 
SELECT 담당자명, 고객회사명, 마일리지
FROM 고객
WHERE 마일리지 > ALL ( SELECT AVG(마일리지) FROM 고객 
                        GROUP BY 지역 );

-- EXISTS :  행의 존재여부로 비교
-- 주문이력이 있는 고객의 정보만 출력하기
SELECT 고객번호, 고객회사명
FROM 고객
WHERE EXISTS ( SELECT * FROM 주문 WHERE 고객번호 = 고객.고객번호 );

-- 인라인 뷰 : FROM절 안의 서브쿼리
SELECT 담당자명, 고객회사명, 마일리지, 고객.도시, 도시_평균마일리지,
       도시_평균마일리지 - 마일리지 AS 차이
FROM 고객,
     (
     	SELECT 도시, AVG(마일리지) AS 도시_평균마일리지
     	FROM 고객
     	GROUP BY 도시
     ) AS 도시별요약
WHERE 고객.도시 = 도시별요약.도시;

-- 스칼라 서브쿼리 : 메인 쿼리의 SELECT문안에 사용되는 서브쿼리
-- 행을 0개 반환하면 null이 되고, 2개이상 반환하면 오류 발생
SELECT 고객번호, 담당자명, (SELECT MAX(주문일) FROM 주문
                            WHERE 주문.고객번호 = 고객.고객번호) AS 최종주문일
FROM 고객;

-- CTE(Common Table Expression)
WITH 도시별요약 AS 
(
	SELECT 도시, AVG(마일리지) AS 도시_평균마일리지
	FROM 고객 
	GROUP BY 도시
)
SELECT 담당자명
      ,고객회사명
      ,마일리지
      ,고객.도시
      ,도시_평균마일리지
      ,도시_평균마일리지 - 마일리지 AS 차이
FROM 고객
	,도시별요약
WHERE 고객.도시 = 도시별요약.도시;

-- 연습문제
-- 1. '배재용' 사원의 부서명을 보이시오.
-- 서브쿼리 또는 조인 방법으로 해결하시오.
select 부서명 from 부서 
where 부서번호 = (select 부서번호 from 사원 where 이름 = '배재용');

-- 2. 한번도 주문한 적이 없는 제품의 정보를 보이시오.
-- 서브쿼리 또는 조인 방법으로 해결하시오.
select * from 제품
where not exists (select * from 주문세부 where 제품번호 = 제품.제품번호);

-- 3. 담당자명, 고객회사명, 주문건수, 최초주문일과 최종주문일을 보이시오.
select 담당자명, 고객회사명,주문건수, 최초주문일, 최종주문일
from 고객,(select 고객번호, count(고객번호)as 주문건수 ,min(주문일) as 최초주문일, max(주문일) as 최종주문일 
from 주문 group by 고객번호)as 주문정보
where 주문정보.고객번호 = 고객.고객번호;


-- 실전문제
-- 1. 제품 테이블에 있는 제품 중 단가가 가장 높은 제품명은 무엇인가?
select 제품명 from 제품
where 단가 = (select max(단가)from 제품);

-- 2. 제품 테이블에 있는 제품 중 단가가 가장 높은 제품의 주문수량합은 얼마인가?
select count(제품번호) from 주문세부 
where 제품번호 = (select 제품번호 from 제품
where 단가 = (select max(단가)from 제품)) group by 제품번호;

-- 3. '아이스크림' 제품의 주문수량합은 얼마인가?
select sum(주문수량) from 주문세부
where 제품번호 in (select 제품번호 from 제품
where 제품명 like '%아이스크림%');

-- 4. '서울특별시' 고객들에 대한 주문년도별 주문건수를 보이시오.
select year(주문일), count(*) from 주문
where 고객번호 in (select 고객번호 from 고객 where 도시='서울특별시')
group by year(주문일);

