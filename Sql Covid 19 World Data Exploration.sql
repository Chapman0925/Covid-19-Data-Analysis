
-- Data Exploration (with Covid Death Dataset)

select * from [Portfolio Project]..['covid death$']
where continent is not null
order by 3,4;

Select
Location,Date,total_cases,new_cases,total_deaths,population
from [Portfolio Project]..['covid death$']
order by 1,2
 
-- 1. Total Death, Death Percentage and Total Cases of Covid in Canada

Select
Location,Date, total_cases,total_deaths, (Total_deaths/total_cases)*100 as Death_percentage
from [Portfolio Project]..['covid death$']
where location = 'canada'
order by 1,2

-- 2. Affected Population in Canada

Select
location,Date, total_cases,population, (Total_cases/population)*100 as infection_rate
from [Portfolio Project]..['covid death$']
where location like '%canada%'
order by 1,2

-- 3. Highest infection count and Highest Infection rate in diff countries

Select
Location,population, Max(total_cases) as highest_infection_count, Max((Total_cases/population))*100 as percentage_got_covid
from [Portfolio Project]..['covid death$']
group by Location,population
order by 4 desc

-- 4. Highest Death count for each country 

Select
Location,population,max(cast(total_deaths as int)) as total_death_count
from [Portfolio Project]..['covid death$']
where continent is not null
group by Location,population
order by 3 desc

-- 5. Highest Death Count in each continent

Select
continent, max(cast(total_deaths as int)) as total_death_count
from [Portfolio Project]..['covid death$']
where continent is not null
group by continent
order by 2 DESC

-- 6. Covid Cases per day and Death Cases per day Globally & Death Percentage Per Day
-- Highest Day is 2020-02-24 with 28% death Rate

Select
Date, Sum(new_cases) as Cases_Per_Day,sum(cast(new_deaths as int)) as Death_Per_Day, SUM(cast(new_deaths as int))/sum(new_cases)*100 as Death_Rate_PerDay
from [Portfolio Project]..['covid death$']
where continent is not null
Group by Date
order by 4 desc

-- 7. Total Case Numbers and Total Death Accross the world
-- death rate is around 1.09%

Select
Sum(new_cases) as caseperday,sum(cast(new_deaths as int)) as deathperday, SUM(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from [Portfolio Project]..['covid death$']
where continent is not null

-- 8. Joining Covid Death and Covid Vaccination Table Together

select * from [Portfolio Project]..['covid death$'] dea
join [Portfolio Project]..['cvoid vacination$'] vac
on dea.location = vac.location and dea.date = vac.date


-- 9. Accumulated_Vaccination_Count in each country for each day

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as Accumulated_Vaccination_Count
from [Portfolio Project]..['covid death$'] dea
join [Portfolio Project]..['cvoid vacination$'] vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- 10. CTE for Vaccinated_Rate

With population_vs_vaccinations
as
(select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as Accumulated_Vaccination_Count
from [Portfolio Project]..['covid death$'] dea
join [Portfolio Project]..['cvoid vacination$'] vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null)

select * , (Accumulated_Vaccination_Count/population)*100 as Vaccinated_Rate
from population_vs_vaccinations

-- 11. Temp Table for Vaccinated_Rate

drop table if exists #Percentpopulationvaccination
Create Table #Percentpopulationvaccination
( continent nvarchar(255),location nvarchar(255),date datetime,population numeric,new_vaccinations numeric, Accumulated_Vaccination_Count numeric)


Insert Into #Percentpopulationvaccination
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as Accumulated_Vaccination_Count
from [Portfolio Project]..['covid death$'] dea
join [Portfolio Project]..['cvoid vacination$'] vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

select * ,(Accumulated_Vaccination_Count/population)*100 as percentagevaccination
from #Percentpopulationvaccination

-- 12. Creating View for Data Visualization of Vaccinated_Rate Table

Create view percentpopulationvaccinated1 as
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as AccumulatedVaccination
from [Portfolio Project]..['covid death$'] dea
join [Portfolio Project]..['cvoid vacination$'] vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null