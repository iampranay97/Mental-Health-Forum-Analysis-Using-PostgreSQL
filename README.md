# Mental Health Forum Analysis using PostgreSQL

## Project Overview

This project analyzes a Mental Health Forum dataset using PostgreSQL to understand community engagement, diagnosis distribution, posting behavior, commenting activity, and drug-related discussions.

The goal was to perform end-to-end SQL analysis and generate meaningful business insights from user-generated forum data.

---

## Dataset Information

Dataset Source:
Mental Health Forum Dataset

Files Used:
- Authors
- Posts
- Comments
- Drugs
- Drug Info

Note:
Dataset files are not included in this repository due to size and licensing considerations.

---

## Dataset Summary

| Table            | Records |
| ---------------- | ------: |
| Authors          |   5,531 |
| Posts            |   2,896 |
| Comments         |  17,362 |
| Drug Mentions    |      28 |
| Drug Information |       6 |

---

## Project Objectives

* Analyze diagnosis distribution among users
* Measure posting and commenting activity
* Identify highly active community members
* Study monthly engagement trends
* Analyze drug discussion patterns
* Link drug mentions with available side-effect information
* Generate community-level KPIs

---

## Analysis Performed

### Step 1: Data Validation

* Verified imported data
* Checked record counts
* Validated table relationships

### Step 2: Diagnosis Distribution

* Author distribution by diagnosis
* Percentage share analysis

### Step 3: Post Activity Analysis

* Posts by diagnosis
* Average posts per author
* Most active authors

### Step 4: Comment Engagement Analysis

* Most commented posts
* Comment activity by diagnosis
* Average comments per post

### Step 5: Monthly Trend Analysis

* Monthly posting trends
* Monthly commenting trends
* Highest activity month

### Step 6: Drug Mention Analysis

* Most discussed drugs
* Drug mentions by source type
* Unique drugs discussed

### Step 7: Side Effect Analysis

* Drugs with side-effect information
* Drug mention frequency
* Side-effect data coverage

### Step 8: Author Activity Analysis

* Most active contributors
* Top commenters
* Inactive user analysis

### Step 9: Community Summary KPIs

* Total community size
* Total posts
* Total comments
* Drug discussion metrics

---

## Key Insights

* 66% of authors belonged to the "Unknown" diagnosis category.
* 34% of authors belonged to the "Bipolar 2" category.
* The community generated 17,362 comments across 2,896 posts.
* April 2026 recorded the highest activity with 2,084 posts.
* Strattera was the most frequently discussed medication.
* More than 3,500 authors never created a post.
* Commenting activity was significantly higher than posting activity.

---

## SQL Skills Demonstrated

* CREATE TABLE
* COPY Command
* Joins
* Aggregations
* GROUP BY
* COUNT
* AVG
* Date Analysis
* String Functions
* Data Validation
* Business Insight Generation

---

## Tools Used

* PostgreSQL
* pgAdmin 4
* GitHub

