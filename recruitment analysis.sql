#How many candidates are in the dataset?
SELECT COUNT(*) AS TotalCandidates
FROM recruitment_mydata;

#How many candidates were hired?
SELECT COUNT(*) AS HiredCandidates
FROM recruitment_mydata
WHERE HiringDecision = 1;

#clean
SELECT
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS MissingAge,
SUM(CASE WHEN EducationLevel IS NULL THEN 1 ELSE 0 END) AS MissingEducation,
SUM(CASE WHEN ExperienceYears IS NULL THEN 1 ELSE 0 END) AS MissingExperience,
SUM(CASE WHEN InterviewScore IS NULL THEN 1 ELSE 0 END) AS MissingInterview,
SUM(CASE WHEN SkillScore IS NULL THEN 1 ELSE 0 END) AS MissingSkill,
SUM(CASE WHEN PersonalityScore IS NULL THEN 1 ELSE 0 END) AS MissingPersonality,
SUM(CASE WHEN RecruitmentStrategy IS NULL THEN 1 ELSE 0 END) AS MissingStrategy
FROM recruitment_mydata;

SELECT COUNT(DISTINCT
CONCAT(
Age,
Gender,
EducationLevel,
ExperienceYears,
PreviousCompanies,
DistanceFromCompany,
InterviewScore,
SkillScore,
PersonalityScore,
RecruitmentStrategy,
HiringDecision
))
AS UniqueRows
FROM recruitment_mydata;

SELECT
MIN(Age),
MAX(Age),
MIN(ExperienceYears),
MAX(ExperienceYears),
MIN(SkillScore),
MAX(SkillScore)
FROM recruitment_mydata;

SELECT
SUM(CASE WHEN EducationLevel = '' THEN 1 ELSE 0 END) AS BlankEducation,
SUM(CASE WHEN RecruitmentStrategy = '' THEN 1 ELSE 0 END) AS BlankStrategy
FROM recruitment_mydata;

DELETE FROM recruitment_mydata
WHERE EducationLevel = ''
   OR RecruitmentStrategy = '';

#EDA
SELECT *
FROM recruitment_mydata
LIMIT 10;

SELECT
HiringDecision,
COUNT(*) AS Total
FROM recruitment_mydata
GROUP BY HiringDecision;

#Does Interview Score influence hiring decisions?
SELECT
HiringDecision,
AVG(InterviewScore) AS AvgInterviewScore
FROM recruitment_mydata
GROUP BY HiringDecision;

SELECT
HiringDecision,
AVG(SkillScore) AS AvgSkillScore
FROM recruitment_mydata
GROUP BY HiringDecision;

SELECT
HiringDecision,
AVG(PersonalityScore) AS AvgPersonalityScore
FROM recruitment_mydata
GROUP BY HiringDecision;

SELECT
HiringDecision,
AVG(ExperienceYears) AS AvgExperience
FROM recruitment_mydata
GROUP BY HiringDecision;

SELECT
EducationLevel,
COUNT(*) AS TotalCandidates,
SUM(HiringDecision) AS HiredCandidates
FROM recruitment_mydata
GROUP BY EducationLevel;

SELECT
EducationLevel,
COUNT(*) AS TotalCandidates,
SUM(HiringDecision) AS HiredCandidates,
ROUND(
    SUM(HiringDecision) * 100.0 / COUNT(*),
    2
) AS HiringRate
FROM recruitment_mydata
GROUP BY EducationLevel;

#Which recruitment strategy produces the best hiring outcomes?
SELECT
RecruitmentStrategy,
COUNT(*) AS TotalCandidates,
SUM(HiringDecision) AS HiredCandidates,
ROUND(
    SUM(HiringDecision) * 100.0 / COUNT(*),
    2
) AS HiringRate
FROM recruitment_mydata
GROUP BY RecruitmentStrategy;

CREATE TABLE recruitment_cleaned AS
SELECT *
FROM recruitment_mydata
WHERE EducationLevel <> ''
  AND RecruitmentStrategy <> '';
  
SELECT COUNT(*)
FROM recruitment_cleaned;

SELECT *,
CASE
    WHEN ExperienceYears < 3 THEN 'Junior'
    WHEN ExperienceYears < 8 THEN 'Mid-Level'
    ELSE 'Senior'
END AS ExperienceGroup,

CASE
    WHEN SkillScore < 40 THEN 'Low'
    WHEN SkillScore < 70 THEN 'Medium'
    ELSE 'High'
END AS SkillGroup,

CASE
    WHEN InterviewScore < 40 THEN 'Low'
    WHEN InterviewScore < 70 THEN 'Medium'
    ELSE 'High'
END AS InterviewGroup,

CASE
    WHEN PersonalityScore < 40 THEN 'Low'
    WHEN PersonalityScore < 70 THEN 'Medium'
    ELSE 'High'
END AS PersonalityGroup

FROM recruitment_cleaned
limit 1500;