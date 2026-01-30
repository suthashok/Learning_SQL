--- Business Questions
/*
For each calendar month, compute:
    Active subscribers at month end
    Churned subscribers during the month
    Monthly churn rate

Where:
A user is active at month end if they have a subscription that includes the last day of the month
A user is churned in a month if their subscription ends in that month
Churn rate = churned users ÷ active users at the start of the month
Assume users can have only one active subscription at a time, but may resubscribe later.
*/


/*
Tables

users

user_id        INT
signup_date    DATE
country        STRING


subscriptions

user_id            INT
start_date         DATE
end_date           DATE   -- NULL if still active
plan               STRING


events

user_id        INT
event_date     DATE
event_type     STRING   -- e.g. 'login', 'purchase', 'cancel_click'
*/


------Approach :-
/*
Breaking down problem into multiple small problems:-

Time Period: 2025, Will assume there exists a dim_calendar table

1.Active Subscriber at month end
    where:
            in subcriptions
                start_date <= month_end_date and (end_date IS NULL or end_date>=month_end_date)

2. Churned Users in a month = Subscriber whose subscription ended that month
    where:
            in subcriptions
                (end_date between month_start_date and month_end_date)
3. Chruned user on last day of the month
    where:
            in subscriptions
                (end_date =month_end_date)

3. Active Users at start of the month = Active Subscriber in Prev Month End - Chrurned on last day of the month

4. Chrunrate = churned users ÷ active users at the start of the month

*/



---- Production Grade Code
WITH calendar_events AS (
    -- Month spine for reporting
    SELECT DISTINCT month_start_date, month_end_date
    FROM dim_calendar
    WHERE calendar_date BETWEEN DATE_TRUNC('year', CURRENT_DATE - INTERVAL '1 year') 
                            AND CURRENT_DATE
),
subs_months AS (
    -- Only months where subscription is relevant
    SELECT 
        s.user_id,
        c.month_start_date,
        c.month_end_date,
        s.start_date,
        s.end_date
    FROM subscriptions s
    JOIN calendar_events c
      ON s.start_date <= c.month_end_date
     AND (s.end_date IS NULL OR s.end_date >= c.month_start_date)
),
active_churn AS (
    SELECT
        month_start_date,
        COUNT(DISTINCT CASE WHEN start_date <= month_end_date AND (end_date IS NULL OR end_date >= month_end_date)
                            THEN user_id END) AS active_eom_users,
        COUNT(DISTINCT CASE WHEN end_date BETWEEN month_start_date AND month_end_date THEN user_id END) AS churned_in_month,
        COUNT(DISTINCT CASE WHEN end_date = month_end_date THEN user_id END) AS churned_eom_users
    FROM subs_months
    GROUP BY month_start_date
),
active_som AS (
    SELECT
        month_start_date,
        active_eom_users,
        active_eom_users - COALESCE(churned_eom_users,0) AS active_start_next_month,
        churned_in_month
    FROM active_churn
)
SELECT
    month_start_date,
    SAFE_DIVIDE(churned_in_month, active_start_next_month) AS churn_rate
FROM active_som
WHERE month_start_date < DATE_TRUNC('month', CURRENT_DATE)
ORDER BY month_start_date;


------ Ad Hoc Version of the Code

WITH calendar_events AS
(
SELECT month_start_date, month_end_date
FROM dim_calendar
WHERE calendar_date BETWEEN '2024-12-01' AND CURRENT_DATE()
GROUP BY 1,2
),
active_subs_eom AS
(
SELECT 
month_start_date,
(COUNT DISTINCT CASE WHEN start_date <= month_end_date and (end_date IS NULL or end_date>=month_end_date) THEN
user_id END) AS active_eom_users
FROM subscriptions 
CROSS JOIN calendar_events
GROUP BY 1
),
chruned_month AS
(
SELECT 
month_start_date,
(COUNT DISTINCT CASE WHEN (end_date between month_start_date and month_end_date) THEN
user_id END) AS churned_month_users
FROM subscriptions 
CROSS JOIN calendar_events
GROUP BY 1
)
,
chruned_eom AS
(
SELECT 
month_start_date,
(COUNT DISTINCT CASE WHEN (end_date=month_end_date) THEN
user_id END) AS churned_eom_users
FROM subscriptions 
CROSS JOIN calendar_events
GROUP BY 1
),
active_subs_som AS
(
SELECT 
a.month_start_date,
active_eom_users,
active_eom_users-COALESCE(churned_eom_users,0) as active_som_users_next_mth
FROM active_subs_eom a 
LEFT JOIN chruned_eom b
ON a.month_start_date=b.month_start_date
),
SELECT 
ADD_MONTH(a.month_start_date,1) as month_start_date,
SAFE_DIVIDE(churned_month_users,active_som_users_next_mth) AS churn_rate
FROM active_subs_som a
LEFT JOIN chruned_month b
ON ADD_MONTH(a.month_start_date,1)=b.month_start_date
WHERE ADD_MONTH(a.month_start_date,1)<START_MONTH(CURRENT_DATE())
ORDER BY 1