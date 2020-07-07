-- For implementing duplicates count percentage on any table

SELECT ifnull(tab1.YEAR,tab2.YEAR) AS year, ifnull(tab1.MONTH,tab2.MONTH) AS month,-- ifnull(duplicate_records_count,0),total_records_count,
(ifnull((duplicate_records_count-number_of_cases),0)*100/total_records_count) AS duplicates_percent
FROM
(SELECT YEAR , MONTH  , sum(count) AS duplicate_records_count, sum(number_of_cases) AS  number_of_cases
FROM (select ROW_TIMESTAMP ,aeic,UNIT_COUNTRY_CODE ,DIM_PLANT_ID , year(ROW_TIMESTAMP ) AS year,month(ROW_TIMESTAMP ) AS MONTH
, count(*) AS count, 1 AS number_of_cases FROM SVC_MKTCOND.PM_COMBINED_OP_HOURLY_MAT
GROUP BY 1,2,3,4 HAVING count(*)> 1) GROUP BY YEAR, MONTH) tab1
RIGHT  JOIN
(SELECT YEAR(ROW_TIMESTAMP) AS year, MONTH(ROW_TIMESTAMP) AS month,count(*) AS total_records_count FROM SVC_MKTCOND.PM_COMBINED_OP_HOURLY_MAT GROUP BY YEAR(ROW_TIMESTAMP), MONTH(ROW_TIMESTAMP)) tab2
ON tab1.YEAR = tab2.YEAR AND tab1.MONTH = tab2.MONTH;
