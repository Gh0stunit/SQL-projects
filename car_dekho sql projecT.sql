create schema cars;
use cars;
-- Read Cars data
select * from car_dekho;
select count(*) from car_dekho;

-- The manager asked the employee How many cars will be available in 2023?
select count(*) from car_dekho where year=2023;

-- The manager asked the employee How many cars is available in 2020,2021,2022
select count(*) from car_dekho where year in (2020, 2021 ,2022) group by year;

-- Clint asked me to print the total of all cars by year. I don't see all the details.
select count(*),year from car_dekho  group by year;

-- Clint asked to car dealer agent How many diesel cars will there be in 2020?
select count(*) from car_dekho where fuel='diesel' and year=2020;

-- Clint requested a car dealer agent How many petrol cars will there be in 2020
select count(*) from car_dekho where fuel='petrol' and year=2020;


-- The manager told the employee to give a print All the fuel cars (petrol, diesel, and CNG) come by all year.
select year, count(*) from car_dekho where fuel='diesel' group by year;
select year, count(*) from car_dekho where fuel='petrol' group by year;
select year, count(*) from car_dekho where fuel='cng' group by year;

-- Manager said there were more than 100 cars in a given year, which year had more than 100 cars?
select year, count(*) from car_dekho group by year having count(*)>100 ;

-- The manager said to the employee All cars count details between 2015 and 2023; we need a complete list.
select count(*) from car_dekho where year between 2015 and 2023;

-- The manager said to the employee All cars details between 2015 to 2023 we need complete list
select * from car_dekho where year between 2015 and 2023;