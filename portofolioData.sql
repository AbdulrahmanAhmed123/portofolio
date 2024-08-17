select * 
from portfolio..['1data$']
order by 3,4

select * 
from portfolio..['2data$']
order by 3,4


select location,date,total_cases,new_cases,total_deaths,population
from portfolio..['1data$']
order by 1,2


select location,date,total_cases,population,(total_cases/population)*100 as casespercentage
from portfolio..['1data$']
where location like 'Egypt'
order by 1,2

select location,max(total_cases),population,max((total_cases/population))*100 as highestcasespercentage
from portfolio..['1data$']
group by location,population
--having location like 'Egypt'
order by highestcasespercentage desc


select location,max(total_deaths) as deathcount
from portfolio..['1data$']
where continent is not null
group by location,population
--having location like 'Egypt'
order by deathcount desc

select continent,max(total_deaths) as deathcount
from portfolio..['1data$']
where continent is not null
group by continent
--having location like 'Egypt'
order by deathcount desc




select date,SUM(new_cases)as totalcases,SUM(new_deaths)as totaldeath,(SUM(new_deaths)/nullif(SUM(new_cases),0))*100as deathpercentage
from portfolio..['1data$']
where continent is not null
group by date
order by 1,2




select SUM(new_cases)as totalcases,SUM(new_deaths)as totaldeath,(SUM(new_deaths)/nullif(SUM(new_cases),0))*100as deathpercentage
from portfolio..['1data$']
where continent is not null
order by 1,2









select d1.continent,d1.location ,d1.date,d1.population,d2.new_vaccinations
from portfolio..['1data$'] d1
join portfolio..['2data$'] d2
on d1.location=d2.location and d1.date=d2.date
where d1.continent is not null 
order by 2,3


select d1.continent,d1.location ,d1.date,d1.population,d2.new_vaccinations
,sum(
convert( BIGINT ,d2.new_vaccinations  )
) over (partition by d1.location 
order by d1.location,d1.date) as dividLocation
from portfolio..['1data$'] d1
join portfolio..['2data$'] d2
on d1.location=d2.location and d1.date=d2.date
where d1.continent is not null 
order by 2,3


--use CTE

with popvsVac (continent,location,date,population,new_vaccinations,dividLocation)
as 
(
select d1.continent,d1.location ,d1.date,d1.population,d2.new_vaccinations
,sum(
convert( BIGINT ,d2.new_vaccinations  )
) over (partition by d1.location 
order by d1.location,d1.date) as dividLocation
from portfolio..['1data$'] d1
join portfolio..['2data$'] d2
on d1.location=d2.location and d1.date=d2.date
where d1.continent is not null 
)

select *,(dividLocation/population)*100 locPopupercentage
from popvsVac
order by 2,3



create table #percentagepopulatevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
dividLocation numeric
)
insert into #percentagepopulatevaccinated
select d1.continent,d1.location ,d1.date,d1.population,d2.new_vaccinations
,sum(
convert( BIGINT ,d2.new_vaccinations  )
) over (partition by d1.location 
order by d1.location,d1.date) as dividLocation
from portfolio..['1data$'] d1
join portfolio..['2data$'] d2
on d1.location=d2.location and d1.date=d2.date
where d1.continent is not null 
order by 2,3


select *,(dividLocation/population)*100 locPopupercentage
from #percentagepopulatevaccinated

create view percentagepopulatevaccinated as
select d1.continent,d1.location ,d1.date,d1.population,d2.new_vaccinations
,sum(
convert( BIGINT ,d2.new_vaccinations  )
) over (partition by d1.location 
order by d1.location,d1.date) as dividLocation
from portfolio..['1data$'] d1
join portfolio..['2data$'] d2
on d1.location=d2.location and d1.date=d2.date
where d1.continent is not null 

select * 
from percentagepopulatevaccinated

