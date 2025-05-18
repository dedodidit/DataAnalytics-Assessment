WITH data AS (
    SELECT 
        A.id AS owner_id,  
        -- Concatenating first and last names into a single full name field
        CONCAT(A.first_name, ' ', A.last_name) AS fullname,
        -- Converting amount from kobo to naira by dividing by 100
        (B.amount / 100) AS amount_naira, 
        -- Calculating the number of months since the user signed up
        TIMESTAMPDIFF(MONTH, A.date_joined, SYSDATE()) AS months_since_signup,
        -- Calculating estimated profit per transaction as 0.1% of the amount in kobo
        (B.amount * 0.1 / 100) AS profit_per_transaction
    FROM 
        adashi_staging.users_customuser A
    LEFT JOIN 
        adashi_staging.savings_savingsaccount B
        ON A.id = B.owner_id
)
SELECT 
    owner_id AS customer_id, 
    fullname AS name, 
    months_since_signup AS tenure_months, 
    -- Summing transaction amounts to get total transactions per customer
    SUM(amount_naira) AS total_transactions, 
    -- Calculating estimated Customer Lifetime Value (CLV) based on total transactions, tenure, and average profit per transaction
    (SUM(amount_naira) / months_since_signup) * 12 * AVG(profit_per_transaction) AS estimated_clv
FROM 
    data
GROUP BY 
    owner_id, 
    months_since_signup, 
    name
ORDER BY 
    estimated_clv DESC;
