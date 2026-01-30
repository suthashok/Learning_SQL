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