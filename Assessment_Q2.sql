WITH tran_mnthly AS (
    SELECT
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') AS tran_mnth,  -- Truncate transaction date to first day of the month for grouping
        COUNT(*) AS tran_in_mnth
    FROM
        adashi_staging.savings_savingsaccount
    GROUP BY
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01')
),
user_mnthly_counts AS (
    SELECT
        owner_id,
        AVG(tran_in_mnth) AS avg_mnth_tran  -- Calculate average monthly transactions per user
    FROM
        tran_mnthly
    GROUP BY
        owner_id
),
sel AS (
    SELECT
        *,
        CASE 
        -- Categorizing users based on avg monthly transactions
            WHEN avg_mnth_tran >= 10 THEN 'High Frequency'         
            WHEN avg_mnth_tran BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        user_mnthly_counts
)
SELECT
    frequency_category, 
    -- Averaging transactions per category, rounded
    ROUND(AVG(avg_mnth_tran), 1) AS avg_transactions_per_month,  
     -- Number of users in each frequency category
    COUNT(*) AS customer_count                                 
FROM
    sel
GROUP BY
    frequency_category
HAVING
-- Only include categories with more than one user
    COUNT(*) > 1;  
