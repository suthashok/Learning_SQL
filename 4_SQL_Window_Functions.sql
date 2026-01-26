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


