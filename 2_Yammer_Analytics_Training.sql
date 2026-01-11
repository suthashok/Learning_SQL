----- Drop in User Engagement

--- The head of the Product team walks over to your desk and
--- asks you what you think about the latest activity on the user engagement dashboards.

--- Weekly Engagement Chart is showing drop in Users mainly from Phone and Tablet
--- Chart is showing Computer users are having stable engagement


----- Possible EDAs to check out reason for the drop
--- 1. Products level engagement -> to understand if it is related to particular product
--- 2. Event level engagement -> to understand if it is related to particular event
--- 3. Geo/Country level engagement -> to understand if it is related to particular Geo
--- 4. Company level engagement -> to understand if it is related to particular Company


----- Tables :
-- 1. tutorial.yammer_users
-- 2. tutorial.yammer_events
-- 3. tutorial.yammer_emails
-- 4. benn.dimension_rollup_periods

--- #1 Check Daily User SignUps & Activations
SELECT
date(created_at) as created_date,
date(activated_at) as activated_date,
company_id,
count(distinct user_id) as users
from tutorial.yammer_users
where 
--- Drop is observed starting Aug Wk1 hence taking enough Pre/Post period
date(created_at) between '2014-01-01' and '2014-10-31'
group by 1,2,3
order by 1

--- No obvious dip in User SignUp or Activation in above period


--- #2 Check for Event Name or Geo specific
SELECT
date(occurred_at) as occurred_date,
event_name,
location,
count(distinct user_id) as users
from tutorial.yammer_events
where event_type='engagement' and device not like ('%mac%','%book%','%laptop%','%desktop%','%thinkpad%','%windows%')
--- Drop is observed starting Aug Wk1 hence taking enough Pre/Post period
and date(occurred_at) between '2014-01-01' and '2014-10-31'
group by 1,2,3
order by 1

--- No Concentration in event name or location

---- #3 Use Email table check

SELECT
date(occurred_at) as occurred_date,
action,
count(distinct user_id) as users
from tutorial.yammer_emails
where --- Drop is observed starting Aug Wk1 hence taking enough Pre/Post period
date(occurred_at) between '2014-01-01' and '2014-10-31'
group by 1,2
order by 1

--- There is significant drop in Email clickthrough type, need to understand what is driving that

--- => Now Email Clickthrought rate can be further analyzed looking at each segment mentioned above.