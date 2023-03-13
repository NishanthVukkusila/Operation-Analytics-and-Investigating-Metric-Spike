-- A. User Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service.
-- Task: Calculate the weekly user engagement?

SELECT  
 EXTRACT(week FROM occurred_at) AS WEEK_NO,
 COUNT(DISTINCT user_id) AS NO_OF_USERS
FROM tutorial.yammer_events
GROUP BY  WEEK_NO;

-- B. User Growth: Amount of users growing over time for a product.

SELECT 
  COUNT(user_id) as count
from tutorial.yammer_users
where state = 'active';


SELECT
  year_no,
  week_no,
  no_of_active_users,
  SUM(no_of_active_users) OVER(ORDER BY year_no, week_no) AS CUM_ACTIVE_USERS
FROM
(
SELECT
  EXTRACT(year from a.activated_at) as year_no,
  EXTRACT(week from a.activated_at) as week_no,
  COUNT(distinct user_id) as no_of_active_users
FROM
  tutorial.yammer_users a
WHERE 
  state = 'active'
GROUP BY year_no, week_no
ORDER BY year_no, week_no
) a;

-- C.Weekly Retention: Users getting retained weekly after signing-up for a product.
-- Your task: Calculate the weekly retention of users-sign up cohort?
select count(user_id),
       sum(case when retention_week = 1 then 1 else 0 end) as per_week_retention
from
(
select a.user_id,
       a.sign_up_week,
       b.engagement_week,
       b.engagement_week - a.sign_up_week as retention_week
from
(
(select distinct user_id, extract(week from occured_at) as sign_up_week
from tutorial.yammer_events
where event_type = 'signup_flow'
and event_name = 'complete_signup'
and extract(week from occured_at)=18)a
left join
(select distinct user_id, extract(week from occured_at) as engagement_week
from tutorial.yammer_events
where event_type = 'engagement')b
on a.user_id = b.user_id
)
group by user_id
order by user_id;

select extract(year from occurred_at)as year,
extract(week from occurred_at)as week,
device,
count(distinct user_id)
from tutorial.yammer_events 
where event_type="engagement" 
group by 1,2,3 
order by 1,2,3;



SELECT 
COUNT(user_id)as users,
SUM(CASE WHEN retention_week = 1 THEN 1 ELSE 0 END ) AS  week_1, 
SUM(CASE WHEN retention_week = 2 THEN 1 ELSE 0 END ) AS  week_2, 
SUM(CASE WHEN retention_week = 3 THEN 1 ELSE 0 END ) AS  week_3, 
SUM(CASE WHEN retention_week = 4 THEN 1 ELSE 0 END ) AS  week_4,
SUM(CASE WHEN retention_week = 5 THEN 1 ELSE 0 END ) AS  week_5
FROM 
(
SELECT a.user_id,
a.sign_up_week,
b.engagement_week,
b.engagement_week - a.sign_up_week as retention_week 
FROM 
(
(select distinct user_id, extract(week from occurred_at) as sign_up_week  
from tutorial.yammer_events
where event_type='signup_flow'
and event_name='complete_signup'
and extract(week from occurred_at)=18
)a 
left JOIN 
(
select distinct user_id,
extract(week from occurred_at) as engagement_week
from tutorial.yammer_events
where event_type='engagement'
)b 
on a.user_id=b.user_id 
)
order by 
a.user_id )a


 
-- D.Weekly Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service weekly.

select
extract(year from occurred_at)as year,
extract(week from occurred_at)as week,
device,
COUNT(distinct user_id) as num_users
FROM 
tutorial.yammer_events
WHERE
event_type='engagement'
group by 
year, week, device
order BY
year, week, device;


-- E.Email Engagement: Users engaging with the email service.
-- Your task: Calculate the email engagement metrics?

select
  100.0 *SUM(case when email_cat ='email_open' then 1 else 0 end )/SUM(case when email_cat='email_sent' then 1 else 0 end )as email_opened_rate,
 100.0* SUM(case when email_cat ='email_clicked' then 1 else 0 end )/SUM(case when email_cat='email_sent' then 1 else 0 end )as email_clicked_rate
FROM 
(
SELECT 
*,
CASE
  WHEN action in('sent_weekly_digest','sent_reenagagement_email')
    then 'email_sent'
  WHEN action in('email_open')
    then 'email_open'
  WHEN action in('email_clickthrough')
    then 'email_clicked'
  end as email_cat
from tutorial.yammer_emails
) a
