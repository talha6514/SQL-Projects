select * from Portfolio_Projects..CovidDeaths
where continent is not null
order by 3,4

-- select data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Projects..CovidDeaths
order by 1,2

-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from Portfolio_Projects..CovidDeaths
where location = 'India'
order by 1,2

-- looking at total cases vs population
-- shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as percent_Of_Population
from Portfolio_Projects..CovidDeaths
where location = 'India'
order by 1,2

-- looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as highest_infection_count , max(total_cases/population)*100 as
 percent_population_infected
 from Portfolio_Projects..CovidDeaths
 group by location, population
 order by percent_population_infected desc

-- showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as total_deaths
from Portfolio_Projects..CovidDeaths
where continent is not null
group by location
order by total_deaths desc

-- showing same result by continent
-- showing continents with highest death count per population

select location, max(cast(total_deaths as int)) as total_deaths
from Portfolio_Projects..CovidDeaths
where continent is null
group by location
order by total_deaths desc

-- Global numbers

select date, sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as 
death_percentage
from Portfolio_Projects..CovidDeaths
where continent is not null
group by date
order by 1,2

-- total cases

select sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as total_new_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as 
death_percentage
from Portfolio_Projects..CovidDeaths
where continent is not null
order by 1,2

-- Using the 2nd table CovidVaccinations

select * from Portfolio_Projects..CovidVaccinations

-- Joining the 2 tables and looking at total population vs total vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as running_total
from Portfolio_Projects..CovidDeaths as dea
JOIN Portfolio_Projects..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- calculating percentage using Common Table Expression (CTE)

with PopVsVac (continent, location, date, population, new_vaccinations, running_total)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as running_total
from Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (running_total/population)*100 as people_vaccinated_percentage
from PopVsVac

-- TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Running_Total numeric
)

Insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as running_total
from Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (Running_Total/Population)*100 as people_vaccinated_percentage
from #PercentPopulationVaccinated

-- creating views to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as running_total
from Portfolio_Projects..CovidDeaths dea
JOIN Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated