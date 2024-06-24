-- Counts the distinct skills required for each company's job posting
WITH
    required_skills AS (
        SELECT
            cd.company_id,
            COUNT(DISTINCT sjd.skill_id) AS unique_skills_required
        FROM
            company_dim cd
            LEFT JOIN job_postings_fact jpf ON cd.company_id = jpf.company_id
            LEFT JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
        GROUP BY
            cd.company_id
    ),
    -- Gets the highest average yearly salary from the jobs that require at least one skills 
    max_salary AS (
        SELECT
            jpf.company_id,
            MAX(jpf.salary_year_avg) AS highest_average_salary
        FROM
            job_postings_fact jpf
        WHERE
            jpf.job_id IN (
                SELECT
                    job_id
                FROM
                    skills_job_dim
            )
        GROUP BY
            jpf.company_id
    )
    -- Joins 2 CTEs with table to get the query
SELECT
    cd.name,
    required_skills.unique_skills_required as unique_skills_required,
    ROUND(max_salary.highest_average_salary) AS highest_avg_salary
FROM
    company_dim cd
    LEFT JOIN required_skills ON cd.company_id = required_skills.company_id
    LEFT JOIN max_salary ON cd.company_id = max_salary.company_id
WHERE
    highest_average_salary IS NOT NULL
ORDER BY
    cd.name;