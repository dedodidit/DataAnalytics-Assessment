WITH inv AS (
    SELECT 
        A.owner_id,
        -- Sum of amount for investments only (where is_a_fund = 1), converted to naira by dividing by 100
        SUM(CASE WHEN A.is_a_fund = 1 THEN A.amount ELSE 0 END) / 100.0 AS inv_in_naira,
        -- Counting the number of investment records per customer
        COUNT(CASE WHEN A.is_a_fund = 1 THEN 1 END) AS investment_count,
        -- Sum of amount for regular savings only (where is_regular_savings = 1), converted to naira
        SUM(CASE WHEN A.is_regular_savings = 1 THEN A.amount ELSE 0 END) / 100.0 AS savings_in_naira,
        -- Counting the number of savings records per owner
        COUNT(CASE WHEN A.is_regular_savings = 1 THEN 1 END) AS savings_count
    FROM adashi_staging.plans_plan A
    GROUP BY A.owner_id
),

sav AS (
    SELECT 
        B.owner_id,
        B.investment_count,
        B.savings_count,
        -- Calculating total deposits as the sum of investments and savings, rounded to 2 decimals
        ROUND(B.inv_in_naira + B.savings_in_naira, 2) AS total_deposits
    FROM inv B
    -- Filtering to only owners with more than 1 investment and more than 1 savings record
    WHERE B.investment_count > 1 AND B.savings_count > 1
),

sv_inv AS (
    -- selecting from previous filtered results; could be used for clarity or further extension
    SELECT 
        C.owner_id,
        C.investment_count,
        C.savings_count,
        C.total_deposits
    FROM sav C
)

SELECT 
    D.owner_id,
    CONCAT(E.first_name, ' ', E.last_name) AS name,
    D.savings_count,
    D.investment_count,
    D.total_deposits
FROM sv_inv D
JOIN adashi_staging.users_customuser E ON D.owner_id = E.id;
