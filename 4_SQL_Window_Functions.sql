-----Ex.1 Write a query that shows the duration of each ride as a percentage of the total time accrued by riders from each start_terminal.

--Table : tutorial.dc_bikeshare_q1_2012

--- Logic:
        ---- From Each start terminal calculate total duration in second
        ---- Divide duration second for each ride by the above total duration in seconds


SELECT id, duration_seconds, 
        SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS start_terminal_total,
        duration_seconds*100.00/start_terminal_total as perc
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'


-----Ex. 2  Write a query that shows a running total of the duration of bike rides grouped by end_terminal,
-----           and with ride duration sorted in descending order.

SELECT id, duration_seconds, 
        SUM(duration_seconds) OVER (PARTITION BY end_terminal ORDER BY duration_seconds DESC) AS end_terminal_total,
        duration_seconds*100.00/start_terminal_total as perc
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'


-----Ex. 3 Write a query that shows the 5 longest rides from each starting terminal, ordered by terminal, and longest to shortest rides within each terminal.
-----            Limit to rides that occurred before Jan. 8, 2012.

--Table : tutorial.dc_bikeshare_q1_2012

--- Logic:
        ---- For each start terminal calculate each ride total duration
        ---- Order each ride by total duration desc
        ---- Select rides comeplelted in 5 longest durations 
        ---- Use Dense rank to avoid skipping the records

SELECT *
FROM
(
SELECT *, DENSE_RANK() OVER (PARTITION BY start_terminal
                    ORDER BY duration_seconds DESC)
              AS ranks
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
)a
WHERE ranks<=5
ORDER BY duration_seconds DESC


-----Ex. 4 Write a query that shows only the duration of the trip 
-----and the percentile into which that duration falls (across the entire dataset—not partitioned by terminal).

SELECT duration_seconds,NTILE(100) OVER
         (ORDER BY duration_seconds)
         AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'


-----Ex. 5 Write a query that shows only the duration of the trip 
-----and the percentile into which that duration falls (across the entire dataset—not partitioned by terminal).
----- Re-wrtie the query with Window Keyword

SELECT duration_seconds,NTILE(100) OVER
         ntile_window
         AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
WINDOW ntile_window AS (ORDER BY duration_seconds)