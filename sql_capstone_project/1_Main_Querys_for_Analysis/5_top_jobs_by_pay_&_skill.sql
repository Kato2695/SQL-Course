/* 
What skills are required for top paying jobs?
- take top 10 highest paid jobs from 'top_jobs_by_pay' query
- add the specific skills required for these roles
*/

WITH top_paid_jobs AS (
    SELECT
        jpf.job_id,
        jpf.job_schedule_type,
        jpf.salary_year_avg,
        cd.name AS company_name
    FROM
        job_postings_fact jpf
    LEFT JOIN company_dim cd ON jpf.company_id = cd.company_id
    WHERE
        jpf.job_title_short = 'Data Analyst' AND
        jpf.job_location = 'Anywhere' AND
        jpf.salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    tpj.*,
    sd.skills
FROM
    top_paid_jobs tpj
INNER JOIN skills_job_dim sjd ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
ORDER BY
    salary_year_avg DESC;