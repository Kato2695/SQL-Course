/*
what are the top skills based on salary only?
- work out average salary associated with each skill. Specifically for data Analyst positions
- break down roles with specified salaries, regardless of locaton
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;