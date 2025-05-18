# DataAnalytics-Assessment

**Per-Question Explanations**

**1. High-Value Customers with Multiple Products**
_Approach:_

My approach was to use conditional aggregation with CASE statements to sum/add investment and savings amounts per user.

I counted how many transactions each user made in each category and filtered users who have some level of activity in both investment and savings for better insights.


**2. Transaction Frequency Analysis**
_Approach:_

I grouped transactions by owner_id and month (using first day of month to normalize).

I counted the transactions per month and averaged across all months for each user.

I categorized the users into high, medium, or low frequency based on average monthly transactions.

I summarized the count and average transactions per frequency group to return the final output.



**3. Account Inactivity Alert** 
_Approach:_

I found customers with no transactions for over 365 days by grouping transactions by owner_id and checking the date differences.

I joined with the plans table to get their latest transaction using a subquery that selects the maximum transaction date for each user.

I selected only relevant plans (investment or savings) to classify their latest engagement.



**4. Customer Lifetime Value (CLV) Estimation **
_Approach:_

I joined user information with their transactions to get amounts and months since they signed up.

I converted amounts from kobo to naira for readability as it was stated in our assesment document that amounts were in kobo.

I calculated tenure_months and used average profit per transaction with total transactions to estimate CLV annually (as given in document).


**Challenges and How I Resolved Them**

**Slow Query Performance**
I was initially facing slow performance when joining savingsaccount and plan tables.

I resolved this by using CTEs to aggregate and filter before joins

**Understanding the Ask**
I spent most of the time trying to understand the requirements, especially the first assessment where I was trying to understand the tables and their relationships, I resolved this by taking my time, then, I finally understood the requirements and how to get the data from the tables.



**Handling Nulls in Joins**
LEFT JOINs caused nulls in some aggregated columns which could affect sums or averages.

I resolved this by using CASE to exclude nulls or setting default values during aggregation.
