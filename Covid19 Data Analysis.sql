
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
    HAVING MAX(total_cases)  IS NOT NULL
    ORDER BY Highest_Infection_Rate
    LIMIT 10;
-- "location","highest_infection_rate","infection_rate_persentage"
-- "Anguilla",3543,0
-- "Cook Islands",5847,0
-- "British Virgin Islands",7131,0
-- "Chad",7432,0
-- "Comoros",8270,0
-- "Antigua and Barbuda",8736,0
-- "Bonaire Sint Eustatius and Saba",10738,0
-- "Djibouti",13489,0
-- "Central African Republic",14712,0
-- "Bermuda",16988,0


--Top 10 countries which has top infection rate
SELECT location,
    MAX(total_cases) as Highest_Infection_Rate ,
    MAX((total_cases/population))*100 as Infection_Rate_Persentage
FROM death
GROUP BY location,population
ORDER BY Infection_Rate_Persentage DESC
LIMIT 10;
-- "location","highest_infection_rate","infection_rate_persentage"
-- "Asia",162934777,""
-- "Brunei",200279,0
-- "Belgium",4398161,0
-- "Chad",7432,0
-- "Afghanistan",184819,0
-- "Antigua and Barbuda",8736,0
-- "Bulgaria",1198359,0
-- "Bonaire Sint Eustatius and Saba",10738,0
-- "Belize",66767,0
-- "Austria",4734005,0


--Infection percentage of India
SELECT 
    location, 
    MAX(total_cases) as Highest_Infection_Rate ,
    MAX((total_cases/population))*100 as Infection_Rate_Persentage
FROM death
WHERE location = 'India'
GROUP BY location,population;
-- Output
-- location	Highest_Infection_Rate	Infection_Rate_Persentage
-- India	43920451	3.12031679768029


--Countries with highest death count
SELECT location,
        MAX(total_deaths) as deaths
FROM death
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY deaths DESC
LIMIT 10;
-- Output
-- United States
-- South Africa
-- Belgium
-- Iran
-- Bosnia and Herzegovina
-- Egypt
-- Switzerland
-- Nepal
-- Colombia
-- Tunisia


--Max death count
SELECT location,
        SUM(total_deaths) AS deaths
    FROM death
    WHERE continent IS NOT NULL
    GROUP BY location
    ORDER BY deaths DESC
    LIMIT 10;
--Output
-- United States
-- Brazil
-- India
-- Mexico
-- Russia
-- Peru
-- United Kingdom
-- Italy
-- France
-- Colombia


--Which Continent have the max death
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeaths
    FROM death
    WHERE continent is not NULL
    GROUP BY continent
    ORDER BY TotalDeaths desc;
-- Output
-- North America
-- South America
-- Asia
-- Europe
-- Africa
-- Oceania


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
-- Output 
-- location	Total_Cases	Total_Deaths	DeathPercentage
-- India	43920451	518737	1.1810830448895
-- Indonesia	6172390	156916	2.54222432477533
-- Iran	7337928	141717	1.93129450166314
-- Turkey	14700846	99184	0.674682259782872
-- Philippines	3756048	60702	1.61611353209544
-- Vietnam	10768844	43277	0.401872290099104
-- Malaysia	4654951	35923	0.77171596435709
-- Japan	11499016	31946	0.277815075655169
-- Thailand	4586933	31264	0.681588329282333
-- Pakistan	1551251	30470	1.96422113507098


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
) AS CONT
WHERE rn <= 5 ;
 -- Output
-- location	continent
-- South Africa	Africa
-- Tunisia	Africa
-- Egypt	Africa
-- Morocco	Africa
-- Ethiopia	Africa
-- India	Asia
-- Indonesia	Asia
-- Iran	Asia
-- Turkey	Asia
-- Philippines	Asia
-- Russia	Europe
-- United Kingdom	Europe
-- Italy	Europe
-- France	Europe
-- Germany	Europe
-- United States	North America
-- Mexico	North America
-- Canada	North America
-- Guatemala	North America
-- Honduras	North America
-- Australia	Oceania
-- New Zealand	Oceania
-- Fiji	Oceania
-- Papua New Guinea	Oceania
-- French Polynesia	Oceania
-- Brazil	South America
-- Peru	South America
-- Colombia	South America
-- Argentina	South America
-- Chile	South America



--The impact of covid 19 on earth
SELECT SUM(new_cases) as Total_Cases ,
    SUM(cast(new_deaths as int)) as Total_Deaths,
    SUM(cast(new_deaths as int)) / SUM(CAST(new_cases AS INT) ) *100 as Death_percentage
    FROM death
    WHERE continent is not NULL
    ORDER BY Total_Deaths;
-- Output
-- Death_percentage	Total_Cases	Total_Deaths
-- 1.11300317157945	570082203	6345033


--Finding the least gdp contries deaths which has gdp below 2000
SELECT de.location, vac.gdp_per_capita as gdp ,SUM(cast(de.new_deaths as int)) as Total_Deaths,
    SUM(cast(de.new_deaths as int)) / SUM(de.new_cases ) *100 as Death_percentage
FROM vaccine vac
JOIN death de ON de.location = vac.location
WHERE de.continent is not NULL AND vac.gdp_per_capita IS NOT NULL AND vac.gdp_per_capita < 2000.00
GROUP BY de.location, vac.gdp_per_capita
ORDER BY Death_percentage DESC
LIMIT 10;
-- Output
-- Yemen
-- Afghanistan
-- Liberia
-- Niger
-- Malawi
-- Gambia
-- Haiti
-- Chad
-- Zimbabwe
-- Uganda


--Life expectancy of India
SELECT location,life_expectancy
FROM vaccine
WHERE continent IS NOT NULL AND location = 'India'
GROUP BY location,life_expectancy
ORDER BY location;
-- outPut
-- location	life_expectancy
-- India	69.66


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
-- Output
-- location	total_cases
-- India	43920451