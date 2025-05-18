WITH last_activity AS (
    -- Calculating the number of days since the last transaction for each owner
    -- Filtering only those owners who have been inactive for more than 365 days
    SELECT 
        owner_id,
        DATEDIFF(CURDATE(), MAX(transaction_date)) AS inactivity_days,
        MAX(transaction_date) AS last_transaction_date
    FROM 
        adashi_staging.savings_savingsaccount
    GROUP BY owner_id
    HAVING inactivity_days > 365
),
latest_tran AS (
    -- Finding the latest transaction ID per owner from the plans_plan table
    SELECT 
        owner_id,
        MAX(id) AS latest_tran_id
    FROM 
        adashi_staging.plans_plan
    GROUP BY owner_id
)

SELECT 
    B.id as plan_id,
    A.owner_id,
    -- Assigning type label based on whether the plan is an investment fund or regular savings
    CASE 
        WHEN B.is_a_fund = 1 THEN 'Investment'
        WHEN B.is_regular_savings = 1 THEN 'Savings'
    END AS type,
    -- Formatting the last transaction date as a date only (removing time)
    DATE(A.last_transaction_date) as last_transaction_date,
    A.inactivity_days
FROM 
    last_activity A
LEFT JOIN adashi_staging.plans_plan B
    -- Joining only the latest plan record per owner to get the relevant plan details
    ON A.owner_id = B.owner_id
    AND B.id IN (
        SELECT latest_tran_id FROM latest_tran WHERE owner_id = A.owner_id
    )
-- Filtering to include only records that are investment or savings
WHERE 
    (B.is_a_fund = 1 OR B.is_regular_savings = 1);
