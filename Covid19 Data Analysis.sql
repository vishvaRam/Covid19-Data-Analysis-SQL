
-- Covid19 Data Analysis

-- Getting to Know the data and data types
SELECT COUNT(*) AS ROWS FROM death;

SELECT COUNT(*) AS ROWS FROM vaccine;

DESCRIBE death;

DESCRIBE vaccine;

SELECT * FROM death LIMIT 1;

SELECT * FROM vaccine LIMIT 1;

SELECT * FROM vaccine ORDER BY location LIMIT 1


--Getting selected field which we are intrested
SELECT 
    location,population,date,total_cases,new_cases,total_deaths 
FROM death 
ORDER BY location,date 
LIMIT 5;


SELECT COUNT(DISTINCT location) AS loc
FROM death
ORDER BY loc ASC;


--Least infection rate of countries
SELECT location, MAX(total_cases) as Highest_Infection_Rate ,MAX((total_cases/population))*100 as Infection_Rate_Persentage
    FROM death
    WHERE continent IS NOT NULL
    GROUP BY location,population
    HAVING Highest_Infection_Rate IS NOT NULL
    ORDER BY Highest_Infection_Rate
    LIMIT 10;


--Top 10 countries which has top infection rate
SELECT location,
    MAX(total_cases) as Highest_Infection_Rate ,
    MAX((total_cases/population))*100 as Infection_Rate_Persentage
FROM death
GROUP BY location,population
ORDER BY Infection_Rate_Persentage DESC
LIMIT 10;



--Analysisng death percentage of india
SELECT location,
        date,
        total_cases,
        total_deaths, 
        (total_deaths/total_cases)*100 as DeathPercentage
FROM death
WHERE location = 'India'
ORDER BY location,date
LIMIT 20;


--Infection percentage of India
SELECT 
    location, 
    MAX(total_cases) as Highest_Infection_Rate ,
    MAX((total_cases/population))*100 as Infection_Rate_Persentage
FROM death
WHERE location = 'India'
GROUP BY location,population;


--Countries with highest death count
SELECT location,
        MAX(total_deaths) as deaths
FROM death
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY deaths DESC
LIMIT 10;


--Max death count
SELECT location,
        SUM(total_deaths) AS deaths
    FROM death
    WHERE continent IS NOT NULL
    GROUP BY location
    ORDER BY deaths DESC
    LIMIT 10;


--Which Continent have the max death
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeaths
    FROM death
    WHERE continent is not NULL
    GROUP BY continent
    ORDER BY TotalDeaths desc;


--Top contries affected in Asia
SELECT location,SUM(new_cases) as Total_Cases ,
    SUM(cast(new_deaths as int)) as Total_Deaths,
    SUM(cast(new_deaths as int)) / SUM(CAST(new_cases AS INT) ) *100 as Death_percentage
    FROM death
    WHERE continent = 'Asia'
    GROUP BY location
    HAVING Total_Deaths IS NOT NULL AND Total_Cases IS NOT NULL
    ORDER BY Total_Deaths DESC
    LIMIT 10;


--Top 5 contries from each continent which has the highest death rate
SELECT * FROM (
    WITH CTC AS(
    select location,continent,
        SUM(CAST(new_cases as int)) as total_cases,
        SUM(CAST(new_deaths as int)) as total_deaths
        FROM death
        WHERE continent IS NOT NULL 
        GROUP BY location,continent
    )
    SELECT location,continent,total_cases,total_deaths, 
        ROW_NUMBER() OVER(PARTITION BY continent ORDER BY total_deaths DESC) AS rn
        FROM CTC
)
WHERE rn <= 5 ;


--The impact of covid 19 on earth
SELECT SUM(new_cases) as Total_Cases ,
    SUM(cast(new_deaths as int)) as Total_Deaths,
    SUM(cast(new_deaths as int)) / SUM(new_cases ) *100 as Death_percentage
    FROM death
    WHERE continent is not NULL
    ORDER BY Total_Deaths;



--Finding the least gdp contries deaths which has gdp below 2000
SELECT de.location, vac.gdp_per_capita as gdp ,SUM(cast(de.new_deaths as int)) as Total_Deaths,
    SUM(cast(de.new_deaths as int)) / SUM(de.new_cases ) *100 as Death_percentage
FROM vaccine vac
JOIN death de ON de.location = vac.location
WHERE de.continent is not NULL AND vac.gdp_per_capita IS NOT NULL AND vac.gdp_per_capita < 2000.00
GROUP BY de.location, vac.gdp_per_capita
ORDER BY Death_percentage DESC
LIMIT 10;


--Life expectancy of India
SELECT location,life_expectancy
FROM vaccine
WHERE continent IS NOT NULL AND location = 'India'
GROUP BY location,life_expectancy
ORDER BY location;



--Find the total cases in India using PARTITION BY
with india as(
SELECT location,
        new_cases,
        date, 
        SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) as total
FROM death
WHERE location ='India'
)
SELECT location,MAX(total) as total_cases
FROM india
GROUP BY location