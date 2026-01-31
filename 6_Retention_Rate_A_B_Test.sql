---- Problem Statement

/*
You work at a large consumer tech company.
A product team ran an A/B experiment to improve user retention.

Tables:
users
    column	type
    user_id	INT
    signup_date	DATE
    country	STRING

experiment_assignments
    column	type
    user_id	INT
    experiment_name	STRING
    variant	STRING
    assigned_at	TIMESTAMP
events
    column	type
    user_id	INT
    event_type	STRING
    event_time	TIMESTAMP

Business Question: For experiment retention_v1, calculate 7-day retention for each variant.

Definition of 7-day retention:
    -A user is retained if they have at least one app_open event
    -Occurring between day 1 and day 7 after experiment assignment
    -Ignore any events before assignment
    -Users who cancel (event_type = 'cancel') before day 7 should still count if they opened the app before canceling

Write a SQL query that returns:

variant|total_users|retained_users|retention_rate

*/