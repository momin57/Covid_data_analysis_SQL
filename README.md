
# 🦠 COVID-19 Data Analysis with SQL (SSMS)

This project uses SQL Server Management Studio (SSMS) to analyze the impact of COVID-19 using data from [Our World in Data](https://ourworldindata.org/covid-deaths). The analysis focuses on infection trends, death rates, and vaccination progress across countries and continents.

---

## 📌 Objectives

- Explore global COVID-19 trends through data
- Identify countries with highest death and infection rates
- Analyze population vaccination progress over time
- Apply advanced SQL to uncover insights

---

## 🛠 Tools Used

- **SQL Server Management Studio (SSMS)**
- **T-SQL** (window functions, aggregations, CTEs, views)

---

## 📁 Files in This Repository

- `covid_data_SQL.sql` – All SQL queries used for analysis
- `covid_deaths.csv` – COVID deaths data (raw data from OWID)
- `covid_vaccinations.csv` – COVID vaccination data (raw data from OWID)
- `readme.md` – Project overview and documentation

---

## 📂 Dataset Description

Data sourced from:
**[Coronavirus (COVID-19) Deaths - Our World in Data](https://ourworldindata.org/covid-deaths)**

Tables used:
- `covid_deaths`: Contains information about total cases, new cases, deaths, population, and more.
- `covid_vaccinations`: Includes vaccination counts, testing, policy stringency, and demographic indicators.

These two datasets are joined on `location` and `date`.

---

## 🧠 SQL Concepts Demonstrated

- Aggregations using `SUM()`, `MAX()`, `ROUND()`
- Conditional logic with `NULLIF()`
- Joins between deaths and vaccinations data
- Window functions: `SUM() OVER()`, `RANK()`, `LAG()`
- Common Table Expressions (CTEs)
- Creating Views for Power BI/dashboard use

---

## 📊 Key Insights Extracted

### 📈 Trends & Metrics
- Total cases vs. total deaths (death percentage)
- Total cases vs. population (infection percentage)
- Rolling total of vaccinations by country
- Countries ranked by vaccination percentage
- Month-over-month new case growth per country
- Daily global trend of deaths and cases
- Comparison of cases and deaths in US, India, and Brazil

### 🧱 View Created
- `PercentPopulationVaccinated`: Used for tracking country-level vaccination progress as a percent of population.

---

## 📌 Next Steps

- Develop a **Power BI dashboard** to visualize the SQL analysis
- Create trendlines, country comparisons, and global summaries

---

## 🙌 Acknowledgment

**Data Source**:  
[Coronavirus (COVID-19) Deaths – Our World in Data](https://ourworldindata.org/covid-deaths)  
Provided by [Our World In Data](https://github.com/owid/covid-19-data)
