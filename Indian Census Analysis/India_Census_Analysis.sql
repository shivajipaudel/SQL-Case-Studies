-- NO of rows in the dataset

select count(*) from population;
select count(*) from growth;

-- dataset from jharkhand and bihar 

select * from population
where state in ('Bihar','Jharkhand');

-- population of India 

select sum(population) as total_population 
from population;

-- Average growth of India in the year 2011

select round(avg(growth)*100,2) as Average_growth
from growth;

-- Average growth percentage for each state

select state,round(avg(growth)*100,2) as Average_growth
from growth
group by state;

-- All the state names ending with 'H'

select state from growth 
where state like '%h'; 

-- Average Sex ratio for each state

select state,round(avg(sex_ratio),2) as avg_sex_ratio
from growth
group by state
order by state desc;

-- Average literacy rate for each state 

select state,round(avg(Literacy),2) as avg_literacy
from growth
group by state
order by avg_literacy desc;

-- Top 5 states displaying highest growth percentage ratio 

select state,round(avg(growth),2) as "growth percentage"
from growth
group by state
order by "growth percentage" desc
limit 5;

-- 5 states showing Least Sex Ratio

select state, round(avg(sex_ratio),2) as avg_Sexratio
from growth 
group by state
order by avg_Sexratio asc
limit 5;

-- fetch Top and Bottom 3 states for literacy rate in a single result set 
select * from(
select state,round(avg(literacy),2) As avg_Literacy
from growth
group by state
order by avg_Literacy desc
limit 3) T
Union
select * from(select state,round(avg(literacy),2) As avg_Literacy
from growth
group by state
order by avg_Literacy asc
limit 3) B;

-- states starting with letter 'A' and ending with 'H'
select state from growth
where state like 'a%h';

-- Find out the top 3 district from each states having high literacy ratio

select g.* from 
(select state,district,Literacy,
dense_rank() over (partition by state order by literacy desc) as rnk
from growth ) g 
where g.rnk<=3; 



