
-- Total Cases vs Total Deaths (Death Percentage per Day for US)
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    ROUND((CAST(total_deaths AS FLOAT) / NULLIF(total_cases, 0)) * 100, 2) AS death_percentage 
FROM PortfolioProject..covid_deaths
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY location, date;

-- Total Cases vs Population (Infection Percentage per Day for US)
SELECT 
    location, 
    date, 
    total_cases, 
    population, 
    ROUND((CAST(total_cases AS FLOAT) / NULLIF(population, 0)) * 100, 2) AS population_infected_percentage 
FROM PortfolioProject..covid_deaths
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY location, date;

-- Highest Infection Rate by Country (Max Total Cases vs Population)
SELECT 
    location, 
    population, 
    MAX(total_cases) AS highest_infection_count, 
    ROUND((MAX(CAST(total_cases AS FLOAT)) / NULLIF(population, 0)) * 100, 2) AS max_infection_population_percentage
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY max_infection_population_percentage DESC;

-- Countries with Highest Total Deaths
SELECT 
    location,
    MAX(total_deaths) AS max_death_count
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY max_death_count DESC;

-- Continents with Highest Total Deaths
SELECT 
    continent,
    MAX(total_deaths) AS max_death_count
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY max_death_count DESC;

-- Global Trend: Total Cases, Deaths, and Death Percentage Over Time
SELECT 
    date, 
    SUM(new_cases) AS total_cases, 
    SUM(CONVERT(FLOAT, new_deaths)) AS total_deaths, 
    ROUND(SUM(CONVERT(FLOAT, new_deaths)) / NULLIF(SUM(new_cases), 0) * 100, 2) AS death_percentage
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- Population vs Vaccinations (Joined Data)
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations
FROM PortfolioProject..covid_deaths d
JOIN PortfolioProject..covid_vaccinations v
    ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date;

-- Rolling Count of People Vaccinated (Cumulative Total)
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations, 
    SUM(CONVERT(FLOAT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_count_people_vaccinated
FROM PortfolioProject..covid_deaths d
JOIN PortfolioProject..covid_vaccinations v
    ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date;

-- CTE: Percent of Population Vaccinated
WITH pop_vs_vac AS (
    SELECT 
        d.continent, 
        d.location, 
        d.date, 
        d.population, 
        v.new_vaccinations, 
        SUM(CONVERT(FLOAT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_count_people_vaccinated
    FROM PortfolioProject..covid_deaths d
    JOIN PortfolioProject..covid_vaccinations v
        ON d.location = v.location AND d.date = v.date
    WHERE d.continent IS NOT NULL
)
SELECT 
    *, 
    ROUND((rolling_count_people_vaccinated / NULLIF(population, 0)) * 100, 2) AS percent_population_vaccinated
FROM pop_vs_vac;

-- 10. Create View for Visualization
CREATE OR ALTER VIEW PercentPopulationVaccinated AS
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations, 
    SUM(CONVERT(FLOAT, v.new_vaccinations)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_count_people_vaccinated
FROM PortfolioProject..covid_deaths d
JOIN PortfolioProject..covid_vaccinations v
    ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL;

-- Compare US, India, Brazil: New Cases and Deaths Over Time
SELECT 
    location,
    date, 
    new_cases, 
    new_deaths
FROM PortfolioProject..covid_deaths
WHERE location IN ('United States', 'India', 'Brazil') AND continent IS NOT NULL
ORDER BY date, location;

-- Rank Countries by Vaccination Rate
SELECT 
    location,
    MAX(people_vaccinated_per_hundred) AS max_vaccinated_percent,
    RANK() OVER (ORDER BY MAX(people_vaccinated_per_hundred) DESC) AS rank_vaccination
FROM PortfolioProject..covid_vaccinations
WHERE continent IS NOT NULL
GROUP BY location;

-- Month-over-Month Growth in Cases using LAG()
SELECT 
    location,
    FORMAT(date, 'yyyy-MM') AS year_month,
    SUM(new_cases) AS monthly_cases,
    LAG(SUM(new_cases)) OVER (PARTITION BY location ORDER BY FORMAT(date, 'yyyy-MM')) AS previous_month_cases,
    SUM(new_cases) - LAG(SUM(new_cases)) OVER (PARTITION BY location ORDER BY FORMAT(date, 'yyyy-MM')) AS case_growth
FROM PortfolioProject..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, FORMAT(date, 'yyyy-MM')
ORDER BY location, year_month;
