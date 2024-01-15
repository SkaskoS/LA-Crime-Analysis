SELECT * FROM crime;

### Data Analysis ###

## Counting occurrences of each crime type for each year ##
SELECT YEAR(STR_TO_DATE(`DATE OCC`, '%m/%d/%y')) AS year, `Crm Cd Desc`, COUNT(*) AS crime_count
FROM crime
GROUP BY year, `Crm Cd Desc`
ORDER BY year, `Crm Cd Desc`;

## Showing the Area with the most amount of crime based on time of day ##
SELECT `AREA NAME`,
       `TIME OCC`,
       COUNT(*) AS crime_count
FROM crime
GROUP BY `AREA NAME`, `TIME OCC`
ORDER BY crime_count DESC;

## Showing wether age is relative to crime increases or decreases ##
SELECT CASE
           WHEN `VICT AGE` BETWEEN 0 AND 18 THEN '0-18'
           WHEN `VICT AGE` BETWEEN 19 AND 25 THEN '19-25'
           WHEN `VICT AGE` BETWEEN 26 AND 35 THEN '26-35'
           WHEN `VICT AGE` BETWEEN 36 AND 45 THEN '36-45'
           WHEN `VICT AGE` BETWEEN 46 AND 55 THEN '46-55'
           WHEN `VICT AGE` BETWEEN 56 AND 65 THEN '56-65'
           WHEN `VICT AGE` BETWEEN 66 AND 75 THEN '66-75'
           WHEN `VICT AGE` BETWEEN 76 AND 85 THEN '76-85'
           ELSE '86+'
       END AS age_group,
       COUNT(*) AS crime_count
FROM crime
GROUP BY age_group
ORDER BY age_group;


## Showing wether race and age indicates the type of crime more likely to occur ##
SELECT `VICT DESCENT`,
       CASE
           WHEN `VICT AGE` BETWEEN 0 AND 18 THEN '0-18'
           WHEN `VICT AGE` BETWEEN 19 AND 25 THEN '19-25'
           WHEN `VICT AGE` BETWEEN 26 AND 35 THEN '26-35'
           WHEN `VICT AGE` BETWEEN 36 AND 45 THEN '36-45'
           WHEN `VICT AGE` BETWEEN 46 AND 55 THEN '46-55'
           WHEN `VICT AGE` BETWEEN 56 AND 65 THEN '56-65'
           WHEN `VICT AGE` BETWEEN 66 AND 75 THEN '66-75'
           WHEN `VICT AGE` BETWEEN 76 AND 85 THEN '76-85'
           ELSE '86+'
       END AS age_group,
       `CRM CD DESC`,
       COUNT(*) AS crime_count
FROM crime
GROUP BY `VICT DESCENT`, age_group, `CRM CD DESC`
ORDER BY crime_count DESC;

## Showing wether gender also indicates the type of crime more likely to happen
SELECT `VICT SEX`,
       `CRM CD DESC`,
       COUNT(*) AS crime_count
FROM crime
GROUP BY `VICT SEX`, `CRM CD DESC`
ORDER BY crime_count DESC;

### Agregation and Grouping of Crime Data ###

## Total Incidents by Crime Type ##
SELECT `CRM CD DESC`,
       COUNT(*) AS total_incidents
FROM crime
GROUP BY `CRM CD DESC`
ORDER BY total_incidents DESC;

## Overall Average Incidents Per Day ##
SELECT AVG(avg_daily_incidents) AS avg_incidents_per_day
FROM (
    SELECT COUNT(*) / COUNT(DISTINCT `DATE OCC`) AS avg_daily_incidents
    FROM crime
    GROUP BY `DATE OCC`
) AS daily_incidents;


## Crime Rates by Area ## 
SELECT `AREA NAME`,
       COUNT(*) AS total_incidents,
       COUNT(*) / COUNT(DISTINCT `DATE OCC`) AS crime_rate_per_day
FROM crime
GROUP BY `AREA NAME`
ORDER BY total_incidents DESC;

## Average Crime Rate by type of crime per day ##
SELECT `CRM CD DESC`,
    COUNT(*) / COUNT(DISTINCT `DATE OCC`) AS avg_crime_rate_per_day
FROM crime
GROUP BY `CRM CD DESC`
ORDER BY avg_crime_rate_per_day DESC;

## Average Crime Rate by type of crime per day  based on year ##
SELECT YEAR(STR_TO_DATE(`DATE OCC`, '%m/%d/%y')) AS year, 
`CRM CD DESC`, COUNT(*) / COUNT(DISTINCT `DATE OCC`) AS avg_crime_rate_per_day
FROM crime
GROUP BY year, `CRM CD DESC`
ORDER BY year, avg_crime_rate_per_day DESC;


### Subqueries ### 

## Finding areas with crime rates above the city average ##

-- Subquery to calculate the overall average crime rate, where 
-- Common Table Expression (CTE) to calculate the overall average crime rate
WITH city_avg AS (
    SELECT `AREA NAME`, COUNT(*) / COUNT(DISTINCT `DATE OCC`) AS avg_crime_rate_per_day
    FROM crime
    GROUP BY `AREA NAME`)

-- Main query using the CTE to find areas with crime rates above the city average
SELECT `AREA NAME`, COUNT(*) / COUNT(DISTINCT `DATE OCC`) AS avg_crime_rate_per_day
FROM crime
GROUP BY `AREA NAME`
HAVING avg_crime_rate_per_day > (SELECT AVG(avg_crime_rate_per_day) FROM city_avg);


### Data Modification ###

-- Toggleing SafeMode 
SET SQL_SAFE_UPDATES = 0;

## Insert a new crime incident ##
INSERT INTO crime (`DR_NO`, `Date Rptd`, `DATE OCC`, `TIME OCC`, `AREA`, `AREA NAME`, `Rpt Dist No`, `Part 1-2`, `Crm Cd`, `Crm Cd Desc`, `Mocodes`, `Vict Age`, `Vict Sex`, `Vict Descent`, `Premis Cd`, `Premis Desc`, `Weapon Used Cd`, `Weapon Desc`, `Status`, `Status Desc`, `Crm Cd 1`, `Crm Cd 2`, `Crm Cd 3`, `Crm Cd 4`, `LOCATION`, `Cross Street`, `LAT`, `LON`)
VALUES (100000000, '1/1/20 0:00', '1/1/20 0:00', 1200, 'Central', 'RandomLand', 123, 1, 624, 'BATTERY - SIMPLE ASSAULT', 'Mocodes_value', 30, 'M', 'Descent_value', 501, 'PREMISE DESCRIPTION', 400, 'WEAPON DESCRIPTION', 'Status_value', 'Status Desc_value', 123, 'Crm Cd 2_value', 'Crm Cd 3_value', 'Crm Cd 4_value', 'Location_value', 'Cross Street_value', 34.1234, -118.5678);


## Updating Premis Desc for a specific incident ##
UPDATE crime
SET `AREA NAME` = 'Central'
WHERE `DR_NO` = 100000000;


## Delete records with crime type ## 
DELETE FROM crime
WHERE `DR_NO` = '100000000';


### Temportal Analysis ###

## Monthly Crime Counts ##
SELECT DATE_FORMAT(`DATE OCC`, '%m/%d/%y') AS month, COUNT(*) AS crime_count
FROM crime
GROUP BY month
ORDER BY month;

## Day of the Week ## 
SELECT 
    CASE
        WHEN DAYOFWEEK(`DATE OCC`) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(`DATE OCC`) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(`DATE OCC`) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(`DATE OCC`) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(`DATE OCC`) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(`DATE OCC`) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(`DATE OCC`) = 7 THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS crime_count
FROM crime
GROUP BY day_of_week
ORDER BY MIN(`DATE OCC`);



## Yearly Crime Trends ## 
SELECT YEAR(STR_TO_DATE(`DATE OCC`, '%m/%d/%y')) AS year, COUNT(*) AS crime_count
FROM crime
GROUP BY year
ORDER BY year;

## Yearly crime trends based on race and crime type ## 
SELECT YEAR(STR_TO_DATE(`DATE OCC`, '%m/%d/%y')) AS year, `VICT DESCENT` AS race, `Crm Cd Desc` AS crime_type, COUNT(*) AS crime_count
FROM crime
GROUP BY year, race, crime_type
ORDER BY year, race, crime_count DESC;

## Yearly crime trends based on age via crime type ## 
SELECT YEAR(STR_TO_DATE(`DATE OCC`, '%m/%d/%y')) AS year,
    CASE
        WHEN `VICT AGE` BETWEEN 0 AND 18 THEN '0-18'
        WHEN `VICT AGE` BETWEEN 19 AND 25 THEN '19-25'
        WHEN `VICT AGE` BETWEEN 26 AND 35 THEN '26-35'
        WHEN `VICT AGE` BETWEEN 36 AND 45 THEN '36-45'
        WHEN `VICT AGE` BETWEEN 46 AND 55 THEN '46-55'
        WHEN `VICT AGE` BETWEEN 56 AND 65 THEN '56-65'
        WHEN `VICT AGE` BETWEEN 66 AND 75 THEN '66-75'
        WHEN `VICT AGE` BETWEEN 76 AND 85 THEN '76-85'
        ELSE '86+'
    END AS age_group, `Crm Cd Desc` AS crime_type, COUNT(*) AS crime_count
FROM crime
GROUP BY year, age_group, crime_type
ORDER BY year, age_group, crime_count DESC;


