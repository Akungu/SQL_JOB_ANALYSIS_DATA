# Introduction
The purpose of the study is to analyse job data, specifically for data analysis roles, so as to gain insight into the most paying jobs and skills, most demanded skills, and the most optimal jobs (high slary meets high demand skills).

SQL queries? Check them here : 
[ project_sql ](/project_sql/)
# Background
The source of the dataset is [ SQL Course ](HTTPS://lukebarousse.com.sql). It contains insights such as job title, salaries, locations and skills.

### The questions I wanted to ask through my SQL queries were :
1 What are the top-paying jobs for my role (data anlyst)?
2 What are the skills required for these top paying roles?
3 What are the most in-demand skills for my role?
4 What are the top skills based on salary for my role?
5 What are the most optimal skills (high demand and high paying) to learn?
# Tools I used
- **SQL** - Used to query the databse
- **PostgreSQL** - Database Mangement System (DBMS) used
- **Visual Studio Code** - For database management and executing SQL queries
- **Git and Github** - For version control and ensuring collaborations
- **Microsoft Excel** - For data visualization

# Analysis
### What are the top-paying jobs for my role (data anlyst)?
For this query, I filtered data analyst jobs by average salary yearly and location focussing on remote jobs so as to gain insight into the highets paying jobs in the field.

```sql
SELECT
  job_id,
  job_title,
  job_location,
  job_schedule_type,
  salary_year_avg,
  job_posted_date,
  name AS company_name
FROM
 job_postings_fact
 LEFT JOIN company_dim ON job_postings_fact.company_id=company_dim.company_id
 WHERE job_title_short='Data Analyst' AND job_location='Anywhere' AND salary_year_avg IS NOT NULL
 ORDER BY salary_year_avg DESC
 LIMIT 10;
 ```
 ![top_paying_jobs](assets\top_paying_jobs.png)

 ### 2 What are the skills required for these top paying roles?
 To get the top paying skills for the above jobs, I joined the job_postingS_fact table with skill_dim table so as to get the skill required for each of the roles.
 ```sql
 WITH top_paying_skills  AS(
    SELECT
  job_id,
  job_title,
  job_location,
  salary_year_avg,
  name AS company_name
FROM
 job_postings_fact
 LEFT JOIN company_dim ON job_postings_fact.company_id=company_dim.company_id
 WHERE job_title_short='Data Analyst' AND job_location='Anywhere' AND salary_year_avg IS NOT NULL
 ORDER BY salary_year_avg DESC
 LIMIT 10
)
SELECT top_paying_skills.*,
       skills
FROM top_paying_skills
INNER JOIN skills_job_dim ON top_paying_skills.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
LIMIT 10;
```
![top_paying_skills](assets\top_paying_skills.png)

### 3 What are the most in-demand skills for my role?
These are the most demanded for skills in data analysis roles as of 2023. For these, I got the total amount of skills required from the skils_job_dim table, and filtered for only data analysis roles from job_postings_fact_table. I then joined it to skills_dim table to get the skill names.

```sql
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
```
![most_demanded_skills](assets\most_demanded_skills.png)

### 4 What are the top skills based on salary for my role?
These are the skills which fall under data analysis roles that are the most paying in tems of the year's average salary and skill name.

```sql
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
```
![top_paying_skills_by_avg_salary](assets\top_paying_skills_by_avg_salary.png)
![top_paying_skills_by_avg_salary_1](assets\top_paying_job_by_avg_salary_1.png)

### 5 What are the most optimal skills (high demand and high paying) to learn?
To find the most optimal skills, I joined the most_demanded_skills table (most demanded skills) and top_paying_skills_by_avg_table (top paid for skills). I then filtered the query based on skill count (demanded_skill) and salary_year_average, both in descending order.

```sql
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
    ORDER BY
             salary_year_avg DESC,
             demand_skills DESC
    LIMIT 25;
```
![optimal_skills_1](assets\optimal_skills_1.png)
![optimal_skills_2](assets\optimal_skills_2.png)
# What I learned
- Querying 
- Data aggregations
- Analysis

# Conclusions
- The top 10 paying jobs have a yearly average salary that ranges between $184,000 and $650,000. These companies range from tech to health copmanies. They include: Mantys, Meta AT&T, Uclahealthcareers among others.
- For the above top paying jobs, the skills needed for them include, sql, python, r, aws, and excel among others.
- The most in-demand skills for data analysis roles are sql, excel, python, tableau and power bi.
- The top skill based on salary for data anlysis jobs is kafka.
- The most optimal skill is sql.This means that sql ia the most demanded for and the most paid for skill in data analysis as of 2023.



