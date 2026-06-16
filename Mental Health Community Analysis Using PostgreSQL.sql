-- Database Setup

create table authors(
	author_id int primary key,
	diagnostics varchar(50)
);

copy authors(author_id, diagnostics)
from 'C:\SQL\Project 2 Datasets\Authors2_export_2026-05-19_112531.csv'
delimiter ','
csv header;

create table posts(
	post_id int primary key,
	author_id int references authors(author_id),
	title varchar(300),
	posted_date date,
	content text
);

copy posts(post_id, author_id, title, posted_date, content)
from 'C:\SQL\Project 2 Datasets\Posts_export_2026-05-19_112519.csv'
delimiter ','
csv header;

create table comments(
	comment_id int primary key,
	post_id int references posts(post_id),
	author_id int references authors(author_id),
	content text,
	comment_date date
);

copy comments(comment_id, post_id, author_id, content, comment_date)
from 'C:\SQL\Project 2 Datasets\Comments_export_2026-05-19_112249.csv'
delimiter ','
csv header;

create table drugs(
	id int primary key,
	source_id int,
	source_type varchar(100),
	drug_name varchar(100)
);

copy drugs(id, source_id, source_type, drug_name)
from 'C:\SQL\Project 2 Datasets\drugs_export_2026-05-19_113140.csv'
delimiter ','
csv header;

create table drug_info(
	drug_name varchar(100) primary key,
	side_effects text
);

copy drug_info(drug_name, side_effects)
from 'C:\SQL\Project 2 Datasets\drug_info_export_2026-05-19_113135.csv'
delimiter ','
csv header;

-- Step 1:- Data Validation

select count(*) as total_authors from authors;
select count(*) as total_posts from posts;
select count(*) as total_comments from comments;
select count(*) as total_drugs from drugs;
select count(*) as total_drug_info from drug_info;

-- Step 2:- Dataset Understanding & Diagnosis Distribution Analysis

-- 2.1 Diagnosis Distribution
select diagnostics, count(*) as total_authors
from authors
group by diagnostics
order by total_authors desc;

-- 2.2 Total Unique Dignostics Categories
select count(distinct diagnostics) as total_diagnosis_types
from authors;

-- 2.3 Dignostics Percentage Share
select diagnostics, count(*) as total_authors,
round(count(*) * 100 /
(select count(*) from authors),2
)as percentage_share
from authors
group by diagnostics
order by total_authors desc;

-- Step 3:- Post Activity Analysis

-- 3.1 Total Posts by Diagnosis
select a.diagnostics, count(p.post_id) as total_posts
from authors a 
join posts p
on a.author_id = p.author_id
group by a.diagnostics
order by total_posts desc;

-- 3.2 Average Posts Per Author
select a.diagnostics,
round(
	count(p.post_id)::numeric /
	count(distinct a.author_id),2
) as avg_posts_per_author
from authors a 
left join posts p
on a.author_id = p.author_id
group by a.diagnostics;

-- 3.3 Top 10 Most Active Authors
select p.author_id, a.diagnostics, count(*) as total_posts
from posts p
join authors a
on p.author_id = a.author_id
group by p.author_id, a.diagnostics
order by total_posts desc
limit 10;

-- Step 4:- Comment Engagement Analysis

-- 4.1 Top 10 Most Commented Posts
select p.post_id,
	   left(p.title, 50) as post_title,
	   count(c.comment_id) as total_comments
from posts p
left join comments c
on p.post_id = c.post_id
group by p.post_id, p.title
order by total_comments desc
limit 10;

-- 4.2 Average Comments Per Post
select round(count(c.comment_id)::numeric /
			 count(distinct p.post_id), 2
) as avg_comments_per_post
from posts p
left join comments c
on p.post_id = c.post_id;

-- 4.3 Comment Activity by Diagnosis 
select a.diagnostics as diagnostics,
count(c.comment_id) as total_comments
from authors a
join posts p
on a.author_id = p.author_id
left join comments c
on p.post_id = c.post_id
group by a.diagnostics
order  by total_comments desc;

-- Step 4.4 Average Comments Received Per Post
select a.diagnostics as diagnostics,
round(count(c.comment_id)::numeric /
	  count(distinct p.post_id), 2
) as avg_comments_per_post
from authors a 
join posts p
on a.author_id = p.author_id
left join comments c
on p.post_id = c.post_id
group by a.diagnostics
order by avg_comments_per_post desc;

-- Step 5:- Monthly Posting trend Analysis

-- Step 5.1 Monthly Post Trend
select date_trunc('month', posted_date)::date as month,
count(*) as total_posts
from posts
group by month
order by month;

-- Step 5.2 Monthly Comment Trend
select date_trunc('month',comment_date)::date as month,
count(*) as total_comments
from comments
group by month
order by month;

-- Step 5.3 Posts & Comments By Month
select date_trunc('month', p.posted_date)::date as month,
count(distinct p.post_id) as total_posts,
count(c.comment_id) as total_comments
from posts p
left join comments c
on p.post_id = c.post_id
group by month
order by month;

-- Step 5.4 Highest Posting Month
select date_trunc('month', posted_date)::date as month,
count(*) as total_posts
from posts
group by month
order by total_posts desc
limit 1;

-- Step 6:- Drug Mention Analysis

-- Step 6.1 Most Mentioned Drugs
select drug_name, count(*) as mention_count
from drugs
group by drug_name
order by mention_count desc;

-- Step 6.2 Top 10 Mention Drugs
select drug_name, count(*) as mention_count
from drugs
group by drug_name
order by mention_count
limit 10;

-- Step 6.3 Drug Mentions By Source Type
select drug_name, source_type, count(*) as total_mentions
from drugs
group by drug_name, source_type
order by total_mentions
limit 10;

-- Step 6.4 Number of Unique Drugs Discussed
select count(distinct drug_name) as unique_drugs
from drugs;

-- Step 6.5 Drugs With Available Side Effect Information
select count(*) as drug_with_sid_effect_info
from drug_info;

-- Step 7:- Side Effect Analysis

-- Step 7.1 Drugs With Side Effects Information
select d.drug_name
from drugs d
join drug_info di
on lower(d.drug_name) = lower(di.drug_name)
group by d.drug_name;

-- Step 7.2 Total Drugs Having Side Effect Data
select count(distinct di.drug_name)
from drug_info di
join drugs d
on lower(d.drug_name) = lower(d.drug_name);

-- Step 7.3 Drug Mentions With Available Side Effect Information
select d.drug_name, count(*) as mention_count
from drugs d
join drug_info di
on lower(d.drug_name) = lower(di.drug_name)
group by d.drug_name
order by mention_count;

-- Step 7.4 Length of Side Effect Information
select drug_name, length(side_effects) as side_effect_text_length
from drug_info
order by side_effect_text_length desc;

-- Step 7.5 Average Side Effect Text Length
select round(avg(length(side_effects)),0) as avg_side_effect_length
from drug_info;

-- Step 8:- Author Behaviour Analysis

-- Step 8.1 Top 10 Most Active Authors (Posts + Comments)
select a.author_id, a.diagnostics,
count(distinct p.post_id) as total_posts,
count(distinct c.comment_id) as total_comments
from authors a
left join posts p
on a.author_id = p.author_id
left join comments c
on a.author_id = c.author_id
group by a.author_id, a.diagnostics
order by total_posts desc, total_comments desc
limit 10;

-- Step 8.2 Top 10 Most Active Commenters
select a.author_id, a.diagnostics,
count(c.comment_id) as total_comments
from authors a
join comments c
on a.author_id = c.author_id
group by a.author_id, a.diagnostics
order by total_comments desc
limit 10;

-- Step 8.3 Average Comments Per Author By Diagnosis
select a.diagnostics, round(
      count(c.comment_id)::numeric /
	  count(distinct a.author_id), 2
) as avg_comments_per_author
from authors a
left join comments c
on a.author_id = c.author_id
group by a.diagnostics
order by avg_comments_per_author desc;

-- Step 8.4 Authors Who Never Posted
select count(*) as author_without_posts
from authors a
left join posts p
on a.author_id = p.author_id
where p.post_id is null;

-- Step 8.5 Authors Who Never Commented
select count(*) as authors_without_comments
from authors a
left join comments c
on a.author_id = c.author_id
where c.comment_id is null;

-- Step 8.6 Authors Who Posted But Never Commented
select count(distinct a.author_id) as posted_but_never_commented
from authors a
join posts p
on a.author_id = p.author_id
left join comments c
on a.author_id = c.author_id
where c.comment_id is null;

-- Step 9:- Dashboard KPI Summary

-- Step 9.1 Total Community Size
select count(*) as total_authors
from authors;

-- Step 9.2 Total Posts
select count(*) as total_posts
from posts;

-- Step 9.3 Total Comments
select count(*) as total_comments
from comments;

-- Step 9.4 Total Drug Mentions
select count(*) as total_drug_mentions
from drugs;

-- Step 9.5 Unique Drugs Discussed
select count(distinct drug_name) as unique_drugs
from drugs;

-- Step 9.6 Average Comments Per Post
select round(
	count(comment_id)::numeric /
	count(distinct post_id), 2
) as avg_comments_per_post
from comments;

-- Step 9.7 Most Disussed Drugs
select drug_name, count(*) as mentions
from drugs
group by drug_name
order by mentions desc
limit 1;

-- Step 9.8 Highest Posting Month
select date_trunc('month', posted_date)::date as month,
count(*) as total_posts
from posts
group by month
order by total_posts desc
limit 1;

-- Project Summary
with summary as (
    select
        (select count(*) from authors) as total_authors,
        (select count(*) from posts) as total_posts,
        (select count(*) from comments) as total_comments,
        (select count(*) from drugs) as total_drug_mentions,
        (select count(distinct drug_name) from drugs) as unique_drugs,
        (select round(
            count(comment_id)::numeric / nullif(count(distinct post_id), 0),
            2
        ) from comments) as avg_comments_per_post
)
select * from summary;






