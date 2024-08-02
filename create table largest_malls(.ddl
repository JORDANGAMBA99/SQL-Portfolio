create table largest_malls(
Rank smallint,
Mall varchar(50),
Country varchar(50),
City varchar(60),
Year_Opened smallint,
Gross_leasable_area varchar(100),
Shops bigint
);

drop table largest_malls

COPY largest_malls
from 'D:\Data Science e-books\EDA  SQL Project\Largest-Malls.csv'
WITH (Format csv,header);

--  Ranking the top 10 malls 
select rank,Mall
from largest_malls
limit 10

-- #Ranking the Country with the highest no.of malls
select Country,count(*)
from largest_malls
group by Country
order by count(*) desc
limit 10

-- How does the gross leasable area (GLA) correlate with the overall performance of the malls?
select rank, Mall, Gross_leasable_area
from largest_malls
limit 10
-- ###The malls with the highest GLA are the ones with the highest rank.

-- Are there trends or patterns in the ranking of malls over the years?
select Country,count(*)
from largest_malls
group by Country
order by count(*) desc
limit 5

-- Phillipines has the highest amount of malls in the world
-- Phillipines has 10 malls.
-- Compared to the rest of the countries the Philippines has a smaller land mass as US,China. 
-- The reason that keeps popping up is because Philippines has a hot and humid climate. 
-- Therefore it makes sense to build malls in order ffor people to chill wwhen the Temperature goes up

-- Market Penetration
-- I used median to depict the number of shops in each mall in the dataset
-- The answer was 300
select round(avg(shops),2) as "Average_Shops",
percentile_cont(.5)
within group (order by shops) as "Median_shops "
from largest_malls

-- Is there a correlation between the number of shops and the success of a mall?

-- There are so many determinants of mall success. 
-- In our data set we have a few columns that we can’t actually have any metric to measure the healthiness of a  mall . 
-- However here are a few factors that are used to measure the healthiness of a mall.

-- This include:
-- - Retail mix
-- - Entertainment
-- - Dining Options

-- Temporal Analysis
-- Are there trends in the year of mall opening? Does the opening year correlate with performance?
-- ## I could not find an appropriate answer to Qn 1.
-- ## However using our mall success based on the number of shops we can make an assumption on the performance.

-- How has the gross leasable area (GLA) changed over the years in newly opened malls?
-- ## I was able to find the answer on Qn 2.
-- ## I exported the query to Excel

copy(
select Mall,Country,City,Year_opened,Gross_leasable_area
from largest_malls
order by Year_opened asc
TO 'C:\Data Science e-books\EDA  SQL Project\MallS_over_the_Years.csv'
WITH(FORMAT CSV,HEADER,DELIMITER ',');

-- ## There is generally a flat trend over the years the except when the Iran mall was built in 2018.
-- ## The years have been arranged in ascending order.

--  ### Regional Comparison
-- ## How do malls in different countries or cities compare in terms of size, rank, and number of shops?

-- The first Question is ambiguous so we can start corelating each factor with a specific metric let’s try Country, Rank, Shops,Year_Opened

select Rank,Country,Year_Opened,shops
from largest_malls
where Year_Opened > 2000
order by shops desc
limit 20

-- ### Apparently the increase in the number of shops has been in Asia. 
-- ### Most of the top 20 are in Asia. This can be attributed to the spending power of the Asian Market and also the increase in population in these countries.
-- ### Also according to our data the first mega mall could be West Edmonton Mall opened in 1981 with 800 stores.

-- ### Expansion Opportunities
-- ## Can you identify trends in the opening of new malls over the years?
-- ## Are there regions or cities where the client could potentially open new malls based on market demand?

-- ## Yeahh most of the malls that are being opened in the 2010s are in Asia

select Rank,Country,Year_Opened,shops
from largest_malls
where Year_opened >2010
order by shops desc

-- ### I would advise to open malls in the Asian market but specifically in the middle East. 
-- ### Because as much as these countries are oil dependent they would be moving away from fossil fuels in the future thus focusing on tourism and Renewables.
-- ### These economies have also shown to loose their social and restrictive rules towards their own. This Liberisation of women could open up new opportunities
-- ### Therefore, Opening up more shops would be a smart move also because the local purchasing power is not weak and will continue to grow

-- ### Customer Experience

-- Can you estimate the average shopping area per shop to understand customer experience?
-- How might the distribution of shops influence the overall shopping experience for customers?

-- We exported a query into an excel file and therefore performed data cleaning for the Gross leasable area from being a character to an integer

copy(
select Country,City,Gross_leasable_Area,Year_Opened,shops
from largest_malls
order by Year_Opened asc)
TO 'C:\Data Science e-books\EDA  SQL Project\Malls_Opened_Over_the_Years.csv'
WITH(FORMAT CSV,DELIMITER',')

-- We then created another Table in the Postgresql Database
Create table Malls_Opened_over_the_Years(
   Country varchar(50),
   City varchar(60),
   Gross_leasable_Area_in_m2 bigint,
   Year_Opened smallint,
   Shops smallint
)
-- Imported the data that we had

COPY Malls_Opened_Over_the_Years
from 'C:\Data Science e-books\EDA  SQL Project\Malls_Opened_Over_the_Years.csv'
WITH(FORMAT CSV,HEADER)

-- The average shopping area per shop per country

select Country,avg(round((Shops/Gross_leasable_Area_in_m2::numeric(10,1))*1000,4)) as avg_shop_per_Country  
from Malls_Opened_Over_the_Years
Group by Country 

-- How might the distribution of shops affect the customer experience?
-- Customer Experience in a shopping mall is affected by various factors:
-- •	Quality of service
-- •	Product costs
-- •	Distribution of shops to customers
-- All these affect the customer experience. It should be noted all these factors have to be harmonized in order for the customer experience to be positive. 
-- All negative deviation of one of this factors can jeopardize the customer experience and it will require for the rest of these other factors to readjust in order for the customer experience to remain positive






