-- From the IMDb dataset, print the title and rating of those movies which have a genre starting from 'C' released in 2014 with a budget higher than 4 Crore.

select i.title,i.rating
from imdb i 
join genre g 
on i.movie_id = g.movie_id
where genre like 'c%'
and title like '%2014%'
and budget > 40000000;

-- Print the title and ratings of the movies released in 2012 whose metacritic rating is more than 60 and Domestic collections exceed 10 Crores.

select i.title,i.rating
from imdb i
join earning e 
on i.movie_id = e.movie_id 
where title like '%2012%'
and MetaCritic > 60
and Domestic > 10
order by rating desc;

-- Print the genre and the maximum net profit among all the movies of that genre released in 2012 per genre. 
-- NOTE - 
-- 1. Do not print any row where either genre or the net profit is empty/null.
-- 2. net_profit = Domestic + Worldwide - Budget
-- 3. Keep the name of the columns as 'genre' and'net_profit'
-- 4. The genres should be printed in alphabetical order. 

with cte as (select i.title,i.movie_id,
(e.domestic + e.worldwide- i.budget) as Net_profit
from earning e
join imdb i 
on e.movie_id = i.movie_id) 
select g.genre as Genre, max(Net_profit) As Net_profit 
from cte c 
join genre g 
on g.movie_id = c.movie_id
where title like '%2012%'
and g.genre is not null and c.Net_profit is not null 
group by genre
order by genre asc;

-- Print the genre and the maximum weighted rating among all the movies of that genre released in 2014 per genre.
-- Note:
-- 1. Do not print any row where either genre or the weighted rating is empty/null.
-- 2. weighted_rating = avgerge of (rating + metacritic/10.0)/2
-- 3. Keep the name of the columns as 'genre' and 'weighted_rating'
-- 4. The genres should be printed in alphabetical order.

with cte as(select g.genre as Genre,(i.rating + i.metacritic/10)/2 as weight_rating
from imdb i 
join genre g
on g.movie_id = i.movie_id
where i.title like '%2014%')
select Genre, max(weight_rating) as weight_rating
from cte
where genre is not null and weight_rating is not null
group by genre
order by genre;


