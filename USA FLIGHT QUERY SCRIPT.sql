create table cancellation_codes(
cancellation_reasons text primary key,
cancellation_description text
);


CREATE TABLE flight (
    year INT,
    month INT,
    day INT,
    day_of_week int,
    airline TEXT,
    flight_number INT,
    tail_number TEXT,
    origin_airport TEXT,
    destination_airport TEXT,
    scheduled_departure TEXT,
    departure_time INT,
    departure_delay INT,
    taxi_out INT,
    wheels_off INT,
    scheduled_time INT,
    elapsed_time INT,
    air_time INT,
    distance INT,
    wheels_on INT,
    taxi_in INT,
    scheduled_arrival INT,
    arrival_time INT,
    arrival_delay INT,
    diverted INT,
    cancelled INT,
    cancellation_reasons TEXT,
    air_system_delay INT,
    security_delay INT,
    airline_delay INT,
    late_aircraft_delay INT,
    weather_delay INT,
	
    FOREIGN KEY (cancellation_reasons) REFERENCES cancellation_codes (cancellation_reasons)


	create table airport(
iata_code text,
airport text,
city text,
state text,
country text,
latitude decimal(10,2),
longitude decimal(10,2)
);


create table airline(
iatacode text,
airline text
);

select *
from cancellation_codes;

select *
from airline;

select *
from airport;

SELECT * 
FROM airport
WHERE iata_code IS NULL
   OR airport IS NULL
   OR city IS NULL
   or state is null
   or country is null
   or latitude is null
   or longitude is null;
   
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY longitude) AS median_longitude
FROM airport
WHERE longitude IS NOT NULL;

select percentile_cont(0.5) within group (order by latitude) as median_latitude
from airport
where latitude is not null;

update airport
set latitude =39.3
where latitude =null

update airport
set longitude =93.4
where longitude =null

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY iata_code, airport, city, state, country, latitude, longitude 
           ORDER BY ctid) AS row_num
    FROM airport
)
SELECT * 
FROM cte
WHERE row_num > 1;


select *
from flight;

select *
from flight
where year is null
or month is null
or day is null
or day_of_week  is null
or airline is null 
or flight_number is null
or tail_number is null
or origin_airport is null
or destination_airport is null
or scheduled_departure is null
or departure_time is null
or departure_delay is null
or taxi_out is null
or wheels_off is null
or scheduled_time is null
or elapsed_time is null
or air_time is null
or distance is null
or wheels_on is null 
or taxi_in is null
or scheduled_arrival is null
or arrival_time is null
or arrival_delay is null
or diverted is null
or cancelled is null 
or cancellation_reasons is null
or air_system_delay is null
or security_delay is null
or airline_delay is null
or late_aircraft_delay is null
or weather_delay is null;

update flight
set air_system_delay =2
where air_system_delay is null;

SELECT COUNT(*)
FROM flight
WHERE air_system_delay IS NULL;


update flight
set security_delay =0
where security_delay is null;

SELECT COUNT(*)
FROM flight
WHERE security_delay IS NULL;


update flight
set airline_delay =2
where airline_delay is null;

update flight
set late_aircraft_delay =3
where late_aircraft_delay is null;

update flight
set weather_delay =0
where weather_delay is null;

select *
from flight
where departure_time is null
or departure_delay is null
or elapsed_time is null
or arrival_time is null
or arrival_delay is null;


update flight
set departure_time =1330
where departure_time is null;


update flight
set departure_delay =-2
where departure_delay  is null;

update flight
set elapsed_time =118
where elapsed_time is null;

update flight
set arrival_time =1512
where arrival_time is null;

update flight
set arrival_delay =-5
where arrival_delay is null;


UPDATE flight
SET cancellation_reasons = 'Unknown'
WHERE cancellation_reasons is null;

select *
from flight


select cancellation_reasons
from flight
where cancellation_reasons is null;


select *
from cancellation_codes


INSERT INTO cancellation_codes (cancellation_reasons,cancellation_description)
VALUES ('UNKNOWN', 'Unknown cancellation reasons');


UPDATE flight
SET cancellation_reasons = 'UNKNOWN'
WHERE cancellation_reasons IS NULL;


ALTER TABLE flight
DROP COLUMN taxi_out,
DROP COLUMN wheels_off,
DROP COLUMN air_time,
DROP COLUMN wheels_on,
DROP COLUMN Taxi_in;
----------- syntax to check for duplicate

	WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY year, month, day, day_of_week, airline, flight_number, Tail_number, origin_airport,
               destination_airport, scheduled_departure, departure_time, departure_delay, scheduled_time, elapsed_time,
               distance, scheduled_arrival, arrival_time, arrival_delay, diverted, cancelled, cancellation_reasons,
               air_system_delay, security_delay, airline_delay, late_aircraft_delay, weather_delay
               ORDER BY ctid
           ) AS row_num
    FROM flight
)
SELECT *
FROM cte
WHERE row_num > 1;


WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY year, month, day, day_of_week, airline, flight_number, Tail_number, origin_airport,
               destination_airport, scheduled_departure, departure_time, departure_delay, scheduled_time, elapsed_time,
               distance, scheduled_arrival, arrival_time, arrival_delay, diverted, cancelled, cancellation_reasons,
               air_system_delay, security_delay, airline_delay, late_aircraft_delay, weather_delay
               ORDER BY ctid
           ) AS row_num
    FROM flight
)
DELETE FROM flight
WHERE ctid IN (
    SELECT ctid
    FROM cte
    WHERE row_num > 1
);
--------question 1a)How does the overall flight volume vary by month?
select month,  count(*) as number_of_flights
from flight
group by month
order by month desc
----------------- question 1b) how does the overall flight volume vary By day of week?

select day_of_week,count(*) as number_of_flight
from flight
group by day_of_week
order by day_of_week desc

----- question 2)What percentage of flights  experienced a departure delay in 2015?
---- total number of flight in 2015

SELECT COUNT(*) AS number_of_flight
FROM flight
WHERE year = 2015;

---- total number of delayed flight in 2015

SELECT COUNT(*) AS number_of_flight
FROM flight
WHERE departure_delay > 0;

SELECT (COUNT(CASE WHEN departure_delay > 0 
THEN 1 END) * 100.0) / COUNT(*) AS percentage_delayed_flights
FROM flight
WHERE year = 2015;

------ Among those flights, what was the average delay time, in minutes?
 SELECT  AVG(CASE WHEN departure_delay > 0 THEN departure_delay END) AS avg_delay_minutes
FROM flight
WHERE year = 2015;

------------- How does the % of delayed flights vary throughout the year?
SELECT (MONTH) AS month, 
    (COUNT(CASE WHEN departure_delay > 0 THEN 1 END) * 100.0) / COUNT(*) AS percentage_delayed_flights
FROM flight
WHERE year = 2015
GROUP BY month
ORDER BY month desc;

----------------3a) how does the % of early flight vary throughout the year

select month,
(COUNT(CASE WHEN departure_delay < 0 then 1 end)* 100.0)/count(*) as percentage_earl_flight
from flight
where year =2015
group by month
order by month desc;

-------3b)What about for flights leaving from Boston (BOS) specifically? 

SELECT *
FROM FLIGHT

select origin_airport as flight_leaving,
(count(case when departure_delay >0 then 1 end)*100.0)/count(*) as percentage_flight
from flight
where origin_airport ='BOS' AND YEAR = 2015
GROUP BY origin_airport
order by origin_airport;

-------How many flights were cancelled in 2015?

select  count (*) as cancelled_flight
from flight
where year =2015 and cancelled =1


SELECT DISTINCT cancelled
FROM flight
WHERE cancelled != 0;

----- What % of cancellations were due to weather


select *
from flight

SELECT (COUNT(CASE WHEN cancelled = 1 AND cancellation_reasons = 'B' THEN 1 END) * 100.0) / 
    COUNT(CASE WHEN cancelled = 1 THEN 1 END) AS percentage_weather_cancellations
FROM flight;


-----What % were due to the Airline/Carrier?
SELECT 
    (COUNT(CASE WHEN cancelled = 1 AND cancellation_reasons = 'A' THEN 1 END) * 100.0) / 
    COUNT(CASE WHEN cancelled = 1 THEN 1 END) AS percentage_cancellation
FROM flight;


---------------5. Which airlines seem to be most and least reliable, in terms of on-time departure?
-----the most reliable airline in terms of on-time departure.

select airline, count (*) as on_time_departure
from flight
where departure_delay < 0
group by airline 
order by airline desc
limit 1;

--------least reliable, in terms of on-time departure?
SELECT 
    airline, 
    COUNT(*) AS on_time_departure
FROM flight
WHERE departure_delay <= 0
GROUP BY airline
ORDER BY on_time_departure asc
LIMIT 1;

