--check for data type
exec sp_help 'dbo.coviddeaths'

select*
from Portfolioproject1..CovidDeaths

--basics data input
select location, date, population, total_cases, total_deaths
from Portfolioproject1..CovidDeaths
order by 1,2

--convert to float
select (convert(float,total_deaths)/nullif(convert(float,total_cases),0))
from Portfolioproject1..CovidDeaths

select location, date, total_deaths, total_cases, (convert(float,total_deaths)/nullif(convert(float,total_cases),0))*100 as DeathPercentage
from Portfolioproject1..CovidDeaths
order by 1,2

select location, date, total_deaths, total_cases, (convert(float,total_deaths)/nullif(convert(float,total_cases),0))*100 as DeathPercentage
from Portfolioproject1..CovidDeaths
where location like '%states%'
order by location, date

select location, date, total_cases, population, (convert(float,total_cases)/nullif(convert(float,population),0))*100 as totalcasepercentage
from Portfolioproject1..CovidDeaths
order by location, date

select location, date, total_cases, population, (convert(float,total_cases)/nullif(convert(float,population),0))*100 as totalcasepercentage
from Portfolioproject1..CovidDeaths
where location like '%states'
order by location, date

select location, date, total_cases, population, (convert(float,total_cases)/nullif(convert(float,population),0))*100 as totalcasepercentage
from Portfolioproject1..CovidDeaths
where location like 'japan'
order by location, date

--input covid vaccination data
select*
from Portfolioproject1..covidvaccinations

select location, date, total_cases, population, (convert(float,total_cases)/nullif(convert(float,population),0))*100 as totalcasepercentage
from Portfolioproject1..CovidDeaths
where location like '%states'
order by location, date

--max infection rate
select location, population, MAX(total_cases)
from Portfolioproject1..CovidDeaths
group by location, population
order by location, population

select location, population, MAX(total_cases) as HighestInfectionCount
from Portfolioproject1..CovidDeaths
group by location, population
order by location, population

select location, population, MAX(total_cases) as HighestInfectionCount, Max(convert(float,total_cases)/nullif(convert(float,population),0))*100 as infectionrate
from Portfolioproject1..CovidDeaths
group by location, population
order by location, population

select location, population, MAX(total_cases) as HighestInfectionCount, Max(convert(float,total_cases)/nullif(convert(float,population),0))*100 as infectionrate
from Portfolioproject1..CovidDeaths
where location like '%states'
group by location, population
order by location, population


select location, population, MAX(total_cases) as HighestInfectionCount, Max(convert(float,total_cases)/nullif(convert(float,population),0))*100 as infectionrate
from Portfolioproject1..CovidDeaths
group by location, population
order by infectionrate desc

--max death rate
select location, MAX(total_deaths) as highestdeathcount
from Portfolioproject1..CovidDeaths
group by location

select location, MAX(total_deaths) as highestdeathcount
from Portfolioproject1..CovidDeaths
where location like '%states'
group by location

select location, MAX(total_deaths) as highestdeathcount
from Portfolioproject1..CovidDeaths
group by location
order by highestdeathcount desc

exec sp_help 'dbo.coviddeaths'

select location, MAX(convert(int,total_deaths)) as highestdeathcount
from Portfolioproject1..CovidDeaths
group by location
order by highestdeathcount desc

select location, MAX(convert(int,total_deaths)) as highestdeathcount
from Portfolioproject1..CovidDeaths
where location not in ('World', 'European Union', 'Asia', 'Africa', 'Australia', 'North America', 'South America', 'Europe')
group by location 
order by highestdeathcount desc

select continent, MAX(convert(int,total_deaths)) as highestdeathcount
from Portfolioproject1..CovidDeaths
where continent in ('World', 'European Union', 'Asia', 'Africa', 'Oceania', 'North America', 'South America', 'Europe')
group by continent
order by highestdeathcount desc

--sum of death 
select continent, sum(convert(int,new_deaths)) as totaldeathcontinent
from coviddeaths
where continent in ('Europe', 'Asia', 'North America', 'South America', 'Oceania', 'Africa')
group by continent
order by totaldeathcontinent desc

select location, sum(convert(int,new_deaths)) as totaldeathworld
from CovidDeaths
group by location
order by totaldeathworld desc

select location, sum(convert(int,new_deaths)) as totaldeathworld
from CovidDeaths
group by location
order by totaldeathworld desc

select*
from Portfolioproject1..CovidDeaths

--Global Numbers
select date, total_cases, total_deaths, convert(float,total_deaths)/(nullif(convert(float,total_cases),0))*100 as DeathPercentage
from Portfolioproject1..CovidDeaths
order by 1,2


select date, SUM(convert(int,new_cases)) as totalnewcases, sum(convert(int,new_deaths)) as totalnewdeaths
from Portfolioproject1..CovidDeaths
group by date
order by 1,2

select date, SUM(convert(int,new_cases)) as total_cases, sum(convert(int,new_deaths)) as total_deaths, sum(convert(int,total_deaths))/sum(nullif(convert(int,total_cases),0))*100 as DeathPercentage
from Portfolioproject1..CovidDeaths
group by date
order by 1,2

-- Covid Vaccinations

select*
from Portfolioproject1..CovidVaccinations

select location, date, new_tests, total_vaccinations
from Portfolioproject1..CovidVaccinations
order by location, date 

select*
from Portfolioproject1..CovidDeaths dea
join Portfolioproject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolioproject1..CovidDeaths dea
join Portfolioproject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from Portfolioproject1..CovidDeaths dea
join Portfolioproject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
order by 2,3

--using cte

with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from Portfolioproject1..CovidDeaths dea
join Portfolioproject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--order by 2,3
)
select*, (rollingpeoplevaccinated/nullif(convert(float,population),0))*100
from PopvsVac

--temp table

drop table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population float, 
new_vaccniations float, 
rollingpeoplevaccinated float
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from Portfolioproject1..CovidDeaths dea
join Portfolioproject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--order by 2,3

select*, (rollingpeoplevaccinated/nullif(convert(float,population),0))*100
from #percentpopulationvaccinated

--create view to store data for later visualizations

create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) Over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from Portfolioproject1..CovidDeaths dea
join Portfolioproject1..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--order by 2,3

