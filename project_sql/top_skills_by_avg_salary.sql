WITH top_skills_avg AS(
SELECT skill_id,
 ROUND(AVG(salary_year_avg),0 )AS salary_year_avg
FROM skills_job_dim


INNER JOIN job_postings_fact ON job_postings_fact.job_id=skills_job_dim.job_id
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY skill_id
)SELECT top_skills_avg.skill_id,
        top_skills_avg.salary_year_avg,
        skills_dim.skills AS skill_name
FROM skills_dim

INNER JOIN top_skills_avg ON top_skills_avg.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
LIMIT 20;