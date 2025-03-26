WITH top_demanded_skills AS(
SELECT skill_id,
COUNT(*) AS demand_skills
FROM skills_job_dim


INNER JOIN job_postings_fact ON job_postings_fact.job_id=skills_job_dim.job_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skill_id
)SELECT top_demanded_skills.skill_id,
        top_demanded_skills.demand_skills,
        skills_dim.skills AS skill_name
FROM skills_dim

INNER JOIN top_demanded_skills ON top_demanded_skills.skill_id = skills_dim.skill_id
ORDER BY demand_skills DESC
LIMIT 5;