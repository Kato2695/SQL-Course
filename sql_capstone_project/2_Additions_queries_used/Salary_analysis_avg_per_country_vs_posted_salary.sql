-- CTE to calculate the average salary by country
WITH avg_salary_country AS (
    SELECT
        job_country,
        ROUND(AVG(salary_year_avg)) AS avg_salary
    FROM
        job_postings_fact
    GROUP BY
        job_country
)

/* 
Main query to show key job details 
and to compare average salary in the country 
posted to the listed salary.
All NULL values removed where comparison could not take place */

SELECT
    jpf.job_id,
    jpf.job_title,
    cd.name AS company_name,
    avg_salary_country.avg_salary AS avg_contry_salary,
    ROUND(jpf.salary_year_avg),
    CASE
        WHEN jpf.salary_year_avg > avg_salary_country.avg_salary THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_category,
    EXTRACT (
        MONTH
        FROM
            jpf.job_posted_date
    ) AS posted_month
FROM 
    job_postings_fact jpf
    INNER JOIN company_dim cd ON jpf.company_id = cd.company_id
    INNER JOIN avg_salary_country ON jpf.job_country = avg_salary_country.job_country
WHERE
    avg_salary_country.avg_salary IS NOT NULL
    AND jpf.salary_year_avg IS NOT NULL
ORDER BY
    posted_month DESC;