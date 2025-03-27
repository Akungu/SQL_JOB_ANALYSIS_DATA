WITH top_demanded_skills AS (
    SELECT skill_id,
           COUNT(*) AS demand_skills
    FROM skills_job_dim
    INNER JOIN job_postings_fact 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_title_short = 'Data Analyst' 
      AND salary_year_avg IS NOT NULL 
    GROUP BY skill_id
),
top_skills_avg AS (
    SELECT skill_id,
           ROUND(AVG(salary_year_avg), 0) AS salary_year_avg
    FROM skills_job_dim
    INNER JOIN job_postings_fact 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_title_short = 'Data Analyst' 
      AND salary_year_avg IS NOT NULL
    GROUP BY skill_id
)
SELECT top_demanded_skills.skill_id,
       skills_dim.skills AS skill_name,
       top_demanded_skills.demand_skills,
       top_skills_avg.salary_year_avg
FROM top_demanded_skills



INNER JOIN top_skills_avg 
    ON top_demanded_skills.skill_id = top_skills_avg.skill_id
INNER JOIN skills_dim 
    ON top_demanded_skills.skill_id = skills_dim.skill_id
    WHERE demand_skills>10
   ORDER BY salary_year_avg DESC,
            demand_skills DESC
LIMIT 20;