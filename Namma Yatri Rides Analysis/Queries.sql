-- Total trips
Select count(distinct tripid) as total_trips from trips_details;

-- Total drivers
Select count(distinct driverid) total_drivers from trips;

-- total earnings 
Select sum(fare) Driver_Earnings from trips;

-- Total Trips completed
select count(*) total_trips from trips;
select count(distinct tripid) total_trips from trips_details where end_ride = 1;

-- Total searches which took place
select count(searches) 'searches took place' from trips_details where searches = 1;
-- select sum( searches) 'searches took place' from trips_details;

-- total searches which got estimate
select count(searches_got_estimate ) 'searches got estimate' from trips_details where searches_got_estimate = 1;
-- select sum( searches_got_estimate) 'searches got estimate' from trips_details;

-- total searches for quotes
select count(searches_for_quotes) 'searches for quotes' from trips_details where searches_for_quotes = 1;
-- select sum( searches_for_quotes) 'searches for quotes' from trips_details;

-- total searches which got quotes
select count(searches_got_quotes) 'searches got quotes' from trips_details where searches_got_quotes = 1;
-- select sum( searches_got_quotes) 'searches got quotes' from trips_details;

-- total driver cancelled
select count(*) - sum(driver_not_cancelled) 'total driver cancelled' from trips_details;

-- total otp entered
select count(*) otp_entered from trips_details where otp_entered = 1;

-- total end ride
select count(*) total_end_rides from trips_details where end_ride = 1;

-- cancelled bookings by customer
select count(*) - sum(customer_not_cancelled) 'cancelled bookings by customer' from trips_details;

-- average distance per trip
select round(avg(distance),2) average_distance from trips;

-- average fare per trip
select avg(fare) average_fare from trips;

-- distance travelled
select sum(distance) distance_travelled from trips;

-- which is the most used payment method 
select p.method from payment p inner join 
( select faremethod, count(distinct tripid) count from trips
group by faremethod
order by count(distinct tripid) desc
limit 1 ) b on p.id = b.faremethod;

-- the highest payment was made through which instrument
select p.method from payment p inner join 
(select * from trips
order by fare desc limit 1) b on p.id = b.faremethod;

-- By which payment method got highest amount in the day
select p.method from payment p inner join 
( select faremethod, sum(fare) from trips
group by faremethod
order by sum(fare) desc limit 1 ) b on p.id = b.faremethod;

-- which two locations had the most trips
SELECT * FROM (
SELECT loc_from, loc_to, COUNT(DISTINCT tripid) AS total_trips,
DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT tripid) DESC) AS rnk
FROM trips GROUP BY loc_from, loc_to) ranked WHERE rnk = 1;

-- top 5 earning drivers
SELECT * FROM (
SELECT *, DENSE_RANK() OVER(ORDER BY earning DESC) AS driver_rank
FROM (
SELECT  driverid, SUM(fare) AS earning FROM trips GROUP BY driverid) a
) ranked_drivers WHERE driver_rank <= 5;

-- which duration had more trips
SELECT * FROM (
SELECT *, RANK() OVER(ORDER BY cnt DESC) AS rnk
FROM (
SELECT  duration, count(distinct tripid) AS cnt FROM trips GROUP BY duration) b ) a;

-- which driver , customer pair had more orders
SELECT * FROM (
SELECT driverid, custid, COUNT(DISTINCT tripid) AS total_trips,
DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT tripid) DESC) AS rnk
FROM trips GROUP BY driverid, custid) ranked WHERE rnk = 1;

-- search to estimate rate
select sum(searches_got_estimate)*100.0/sum(searches) " search to estimate rate " from trips_details;

-- estimate to search for quote rates
select sum(searches_for_quotes )*100.0/sum(searches) " estimate to search for quote rates " from trips_details;

-- quote acceptance rate
select sum( customer_not_cancelled )*100.0/sum(searches_got_quotes) " estimate to search for quote rates " from trips_details;

-- quote to booking rate
select SUM(customer_not_cancelled) * 100.0 / SUM(searches_got_quotes) AS quote_to_booking_rate  from trips_details;

-- booking cancellation rate
select SUM(searches_got_quotes) - SUM(end_ride) * 100.0 / SUM(searches_got_quotes) AS booking_cancellation_rate  from trips_details;

-- conversion rate
select sum(end_ride)*100.0/sum(searches) from trips_details;

-- which area got highest trips in which duration
select * from
(select *, rank() over( partition by duration order by cnt desc) rnk from
(select duration, loc_from, count( distinct tripid) cnt from trips
group by  duration, loc_from)a)b where rnk =1;

-- which area got the highest fares, cancellations,trips,
select * from (
select *, rank() over( order by total_fare desc) rnk from
(select loc_from, sum(fare) total_fare from trips
group by loc_from) a)b where rnk = 1;

select * from (
select *, rank() over( order by cancelled_by_drivers desc) rnk from
(select loc_from, count(distinct tripid) - sum(driver_not_cancelled) cancelled_by_drivers from trips_details
group by loc_from) a)b where rnk = 1;

select * from (
select *, rank() over( order by cancelled_by_customer desc) rnk from
(select loc_from, count(distinct tripid) - sum(customer_not_cancelled) cancelled_by_customer from trips_details
group by loc_from) a)b where rnk = 1;

-- which duration got the highest trips and fares
select * from (
select *, rank() over( order by total_fare desc) rnk from
(select duration, sum(fare) total_fare from trips
group by duration) a)b where rnk = 1;

select * from (
select *, rank() over( order by total_trips desc) rnk from
(select duration, count(distinct tripid) total_trips from trips
group by duration) a)b where rnk = 1;