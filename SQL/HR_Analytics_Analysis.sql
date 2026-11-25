USE HR_Analytics;
GO

-- Total employee records
SELECT COUNT(*) AS Total_Employees
FROM HR_Data;

--Check attrition distribution
SELECT
    Attrition,
    COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY Attrition

--Overall HR KPIs
SELECT
    COUNT(*) AS Total_Employees,

    SUM(CASE
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END) AS Attrition_Count,

    SUM(CASE
        WHEN Attrition = 'No' THEN 1
        ELSE 0
    END) AS Active_Employees,

    CAST(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*) AS DECIMAL(10,2)
    ) AS Attrition_Rate

FROM HR_Data;

--Average employee age
SELECT
    AVG(CAST(Age AS DECIMAL(10,2))) AS Average_Age
FROM HR_Data;

--Attrition by department
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END) AS Attrition_Count
FROM HR_Data
GROUP BY Department
ORDER BY Attrition_Count DESC;

--Department-wise attrition rate
SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count,

    CAST(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*) AS DECIMAL(10,2)
    ) AS Attrition_Rate

FROM HR_Data
GROUP BY Department
ORDER BY Attrition_Rate DESC;

--Gender-wise attrition
SELECT
    Gender,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count
FROM HR_Data
GROUP BY Gender;

--Attrition by marital status
SELECT
    Marital_Status,
    COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY Marital_Status
ORDER BY Attrition_Count DESC;

--Attrition by job role
SELECT
    Job_Role,
    COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY Job_Role
ORDER BY Attrition_Count DESC;

--Employee Behaviour Analysis
SELECT
    Over_Time,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    CAST(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*) AS DECIMAL(10,2)
    ) AS Attrition_Rate
FROM HR_Data
GROUP BY Over_Time
ORDER BY Attrition_Rate DESC;

--Attrition by Job Satisfaction
SELECT
    Job_Satisfaction,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM HR_Data
GROUP BY Job_Satisfaction
ORDER BY Job_Satisfaction;

--Attrition by Education Field
SELECT
    Education_Field,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count
FROM HR_Data
GROUP BY Education_Field
ORDER BY Attrition_Count DESC;

--Attrition by Age Group
SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and Above'
    END AS Age_Group,

    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count

FROM HR_Data
GROUP BY
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and Above'
    END
ORDER BY MIN(Age);

--Salary and Experience Analysis
SELECT
    Attrition,
    COUNT(*) AS Employee_Count,
    CAST(AVG(CAST(Monthly_Income AS DECIMAL(12,2)))
        AS DECIMAL(12,2)) AS Average_Salary
FROM HR_Data
GROUP BY Attrition;

--Attrition by Total Working Years
SELECT
    CASE
        WHEN Total_Working_Years <= 5 THEN '0-5 Years'
        WHEN Total_Working_Years <= 10 THEN '6-10 Years'
        WHEN Total_Working_Years <= 20 THEN '11-20 Years'
        ELSE '20+ Years'
    END AS Experience_Group,

    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count

FROM HR_Data
GROUP BY
    CASE
        WHEN Total_Working_Years <= 5 THEN '0-5 Years'
        WHEN Total_Working_Years <= 10 THEN '6-10 Years'
        WHEN Total_Working_Years <= 20 THEN '11-20 Years'
        ELSE '20+ Years'
    END
ORDER BY MIN(Total_Working_Years);

--Attrition by Years at Company
SELECT
    Years_At_Company,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count
FROM HR_Data
GROUP BY Years_At_Company
ORDER BY Years_At_Company;

--Attrition by Work-Life Balance
SELECT
    Work_Life_Balance,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        AS Attrition_Count
FROM HR_Data
GROUP BY Work_Life_Balance
ORDER BY Work_Life_Balance;

--Rank departments by attrition count
SELECT
    Department,
    COUNT(*) AS Attrition_Count,
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS Department_Rank
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY Department;

--Find the top 5 job roles by attrition
SELECT TOP 5
    Job_Role,
    COUNT(*) AS Attrition_Count
FROM HR_Data
WHERE Attrition = 'Yes'
GROUP BY Job_Role
ORDER BY Attrition_Count DESC;

--CTE for department-wise attrition rate
WITH Department_Analysis AS
(
    SELECT
        Department,
        COUNT(*) AS Total_Employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
            AS Attrition_Count
    FROM HR_Data
    GROUP BY Department
)
SELECT
    Department,
    Total_Employees,
    Attrition_Count,
    CAST(
        Attrition_Count * 100.0 / Total_Employees
        AS DECIMAL(10,2)
    ) AS Attrition_Rate
FROM Department_Analysis
ORDER BY Attrition_Rate DESC;

--DENSE_RANK(): Rank employees by salary within each department
SELECT
    Employee_Number,
    Department,
    Job_Role,
    Monthly_Income,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY Monthly_Income DESC
    ) AS Salary_Rank
FROM HR_Data;

--ROW_NUMBER(): Find top 3 highest-paid employees in each department
WITH Salary_Ranking AS
(
    SELECT
        Employee_Number,
        Department,
        Job_Role,
        Monthly_Income,
        ROW_NUMBER() OVER (
            PARTITION BY Department
            ORDER BY Monthly_Income DESC
        ) AS Row_Num
    FROM HR_Data
)
SELECT *
FROM Salary_Ranking
WHERE Row_Num <= 3;

--Subquery: Employees earning above average salary
SELECT
    Employee_Number,
    Department,
    Job_Role,
    Monthly_Income
FROM HR_Data
WHERE Monthly_Income >
(
    SELECT AVG(CAST(Monthly_Income AS FLOAT))
    FROM HR_Data
)
ORDER BY Monthly_Income DESC;

--CASE WHEN: Categorize employees by salary
SELECT
    Employee_Number,
    Monthly_Income,
    CASE
        WHEN Monthly_Income < 3000 THEN 'Low Salary'
        WHEN Monthly_Income BETWEEN 3000 AND 7000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS Salary_Category
FROM HR_Data;

--CTE: Compare attrition rates across departments
WITH Department_Stats AS
(
    SELECT
        Department,
        COUNT(*) AS Total_Employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
            AS Employees_Left
    FROM HR_Data
    GROUP BY Department
)
SELECT
    Department,
    Total_Employees,
    Employees_Left,
    CAST(
        Employees_Left * 100.0 / Total_Employees
        AS DECIMAL(10,2)
    ) AS Attrition_Rate
FROM Department_Stats
ORDER BY Attrition_Rate DESC;