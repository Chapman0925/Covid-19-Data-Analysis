-- The Following Queries is used to apply on the tableau Project

-- Part 1 ( Death Percentage with total cases and total deaths)

Select Sum(new_cases) as total_cases, sum(convert(int,new_deaths)) as total_deaths, sum(convert(int, new_deaths))/Sum(new_cases)*100 as Death_Percentage
from [Portfolio Project]..['covid death$']
where continent is not null
order by 1,2

-- Part 2 ( death count for each continent)
-- using the location col as continent col have some missing value

Select location, sum(cast(new_deaths as int))as total_death_count
from [Portfolio Project]..['covid death$']
where continent is null and location not in ('World', 'European Union', 'International','upper middle income','high income','lower middle income','low income')
group by location
order by 2 desc

-- The following queries is same as above but prefer using location instead of continent

--Select continent, sum(cast(new_deaths as int))as total_death_count
--from [Portfolio Project]..['covid death$']
--where continent is not null --and location not in ('World', 'European Union', 'International','upper middle income','high income','lower middle income','low income')
--group by continent
--order by 2 desc

-- Part 3 ( infected percentage rate for each country's population)

Select location,population, max(total_cases) as highest_infected_count,  max((total_cases/population))*100 as percentage_population_infected
From [Portfolio Project]..['covid death$']
where location not in ('upper middle income','high income','lower middle income','low income')
group by location,population
order by 4 desc

-- Part 4 (infected percentage rate for diff country and be able to observe on each day)

Select location,population,date, max(total_cases) as highest_infected_count, max((total_cases/population))*100 as percentage_population_infected
From [Portfolio Project]..['covid death$']
where location not in ('upper middle income','high income','lower middle income','low income')
group by location, population, date
order by 5 desc

