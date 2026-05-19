CREATE DATABASE bank_customer_analysis;
-- 1Total number of customers

select count(*) as Number_of_customer 
from customer_churn;

-- 2 Total churned customers

select Exited,count(*)
from customer_churn
group by Exited;

-- 3 Churn percentage

select Exited,count(*) * 100 / (select count(*) from customer_churn) as churn_average
from customer_churn
group by Exited;

-- 4 Average customer balance

select avg(Balance),avg(EstimatedSalary) 
from customer_churn;

-- 5 Which geography has highest churn?

select Geography,100 *sum(case
	when Exited=1 then 1 else 0 end)/count(*) as churn_percentage
from customer_churn
group by Geography;

-- 6 Which gender churns more?

select Gender,sum(case 
when Exited=1 then 1 else 0 end) as churn_value
from customer_churn
group by Gender;

-- 7 Average balance by gender

select Gender,avg(Balance) 
from customer_churn
group by Gender;

-- 8 Which geography has the highest average balance?

select Geography,avg(Balance) as avg_Balance
from customer_churn
group by Geography
order by avg_Balance desc;

-- 9 Which age group has highest churn?

select 
	case
		when Age between 18 and 40 then "young"
        when Age between 41 and 60 then "Middle Age"
        else "Senior"
        end as age_group,
	100 * sum(case
			when Exited = 1 then 1 else 0 end)/count(*) as churn_ratio
from customer_churn
group by age_group
order by churn_ratio desc;

-- 10 Do inactive customers churn more than active customers?

select IsActiveMember,
	100 * sum(case
		when Exited =1 then 1 else 0 end)/count(*) as churn_ratio
from customer_churn
group by IsActiveMember
order by churn_ratio desc;

-- 11 Which number of products category has highest churn?

select  NumOfProducts as Product,
	100 * sum(case 
					when Exited=1 then 1 else 0 end)/count(*) as churn_ratio
from customer_churn
group by NumOfProducts
order by churn_ratio desc;

-- 12 Top 5 customers with highest balance

select CustomerId,
		Surname,
        Balance
from customer_churn
order by Balance desc
limit 5;

-- 13 Rank customers based on highest balance

select CustomerId,
		Surname,
        Balance,
        rank() over(order by Balance desc) as Rank_Customers  
from customer_churn;

-- 14 Create customer segments based on balance
select min(Balance),max(Balance)
from customer_churn;
select  
	case 
		when Balance between 0 and 50000 then "Low Balance"
        when Balance between 50001 and 150000 then "Medium Balance"
        else "High Balance"
        end as customer_segement,
        count(*) as count
from customer_churn
group by customer_segement;

-- 14 Which balance segment has highest churn?

select  
	case 
		when Balance between 0 and 50000 then "Low Balance"
        when Balance between 50001 and 150000 then "Medium Balance"
        else "High Balance"
        end as customer_segement,
        100 * sum(case when Exited = 1 then 1 else 0 end)/count(*) as churn_ratio
from customer_churn
group by customer_segement
order by churn_ratio desc;

-- 15 Compare average salary of churned vs retained customers

select Exited,avg(EstimatedSalary)
from customer_churn
group by Exited;

-- 16 Find average credit score by geography

select Geography,avg(CreditScore)
from customer_churn
group by Geography
ORDER BY avg(CreditScore) DESC;

-- 17 Find churn percentage by geography and gender together

select 	Gender,
		Geography,
        100 * sum(case when Exited=1 then 1 else 0 end)/count(*) as churn_ratio 
from customer_churn
group by Gender,Geography;

-- 18 Find average tenure of churned and retained customers

select Exited,avg(Tenure) 
from customer_churn
group by Exited;

-- 19 Find customers whose balance is higher than average balance

select 	Surname,
		Balance
from customer_churn
where Balance > (select avg(Balance) from customer_churn);

-- 20 Find top 3 geographies with highest churn percentage

select 	Geography,
		100 * sum(case when Exited=1 then 1 else 0 end)/count(*) as churn_ratio
from customer_churn
group by Geography
order by churn_ratio desc
limit 3;

-- 1. Find churn percentage by tenure segment

SELECT 
    CASE
        WHEN Tenure BETWEEN 0 AND 3 THEN 'New Customer'
        WHEN Tenure BETWEEN 4 AND 7 THEN 'Regular Customer'
        ELSE 'Loyal Customer'
    END AS tenure_segment,
    
    100 * SUM(
        CASE 
            WHEN Exited = 1 THEN 1 
            ELSE 0 
        END
    ) / COUNT(*) AS churn_ratio

FROM customer_churn
GROUP BY tenure_segment
ORDER BY churn_ratio DESC;



-- 2. Find average balance of active vs inactive customers

SELECT 
    IsActiveMember,
    AVG(Balance) AS avg_balance
FROM customer_churn
GROUP BY IsActiveMember;



-- 3. Find geography with highest average salary

SELECT 
    Geography,
    AVG(EstimatedSalary) AS avg_salary
FROM customer_churn
GROUP BY Geography
ORDER BY avg_salary DESC;



-- 4. Find gender-wise average credit score

SELECT 
    Gender,
    AVG(CreditScore) AS avg_credit_score
FROM customer_churn
GROUP BY Gender;



-- 5. Find customers with salary higher than average salary

SELECT 
    CustomerId,
    Surname,
    EstimatedSalary
FROM customer_churn
WHERE EstimatedSalary > (
    SELECT AVG(EstimatedSalary)
    FROM customer_churn
);



-- 6. Find top 5 oldest customers

SELECT 
    CustomerId,
    Surname,
    Age
FROM customer_churn
ORDER BY Age DESC
LIMIT 5;



-- 7. Find top 5 youngest churned customers

SELECT 
    CustomerId,
    Surname,
    Age
FROM customer_churn
WHERE Exited = 1
ORDER BY Age ASC
LIMIT 5;



-- 8. Find average number of products used by churned customers

SELECT 
    AVG(NumOfProducts) AS avg_products
FROM customer_churn
WHERE Exited = 1;



-- 9. Find which age group has highest average balance

SELECT 
    CASE
        WHEN Age BETWEEN 18 AND 35 THEN 'Young'
        WHEN Age BETWEEN 36 AND 55 THEN 'Middle Age'
        ELSE 'Senior'
    END AS age_group,

    AVG(Balance) AS avg_balance

FROM customer_churn
GROUP BY age_group
ORDER BY avg_balance DESC;



-- 10. Find churn ratio by credit card holders

SELECT 
    HasCrCard,
    
    100 * SUM(
        CASE 
            WHEN Exited = 1 THEN 1 
            ELSE 0 
        END
    ) / COUNT(*) AS churn_ratio

FROM customer_churn
GROUP BY HasCrCard;



-- 11. Find customers having zero balance

SELECT 
    CustomerId,
    Surname,
    Balance
FROM customer_churn
WHERE Balance = 0;



-- 12. Find geography-wise active customer percentage

SELECT 
    Geography,

    100 * SUM(
        CASE 
            WHEN IsActiveMember = 1 THEN 1 
            ELSE 0 
        END
    ) / COUNT(*) AS active_percentage

FROM customer_churn
GROUP BY Geography;



-- 13. Find customer segment with highest average salary

SELECT 
    CASE
        WHEN Balance BETWEEN 0 AND 50000 THEN 'Low Balance'
        WHEN Balance BETWEEN 50001 AND 150000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS customer_segment,

    AVG(EstimatedSalary) AS avg_salary

FROM customer_churn
GROUP BY customer_segment
ORDER BY avg_salary DESC;



-- 14. Find average balance by number of products

SELECT 
    NumOfProducts,
    AVG(Balance) AS avg_balance
FROM customer_churn
GROUP BY NumOfProducts;



-- 15. Find customers whose credit score is below average

SELECT 
    CustomerId,
    Surname,
    CreditScore
FROM customer_churn
WHERE CreditScore < (
    SELECT AVG(CreditScore)
    FROM customer_churn
);

-- 16. Find top geography by active members

SELECT 
    Geography,
    COUNT(*) AS active_members
FROM customer_churn
WHERE IsActiveMember = 1
GROUP BY Geography
ORDER BY active_members DESC
LIMIT 1;



-- 17. Find average tenure by geography

SELECT 
    Geography,
    AVG(Tenure) AS avg_tenure
FROM customer_churn
GROUP BY Geography;



-- 18. Find churn ratio by balance segment and gender

SELECT 
    Gender,

    CASE
        WHEN Balance BETWEEN 0 AND 50000 THEN 'Low Balance'
        WHEN Balance BETWEEN 50001 AND 150000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS balance_segment,

    100 * SUM(
        CASE
            WHEN Exited = 1 THEN 1
            ELSE 0
        END
    ) / COUNT(*) AS churn_ratio

FROM customer_churn
GROUP BY Gender, balance_segment
ORDER BY churn_ratio DESC;



-- 19. Find number of customers in each credit score segment

SELECT 
    CASE
        WHEN CreditScore BETWEEN 300 AND 500 THEN 'Low Score'
        WHEN CreditScore BETWEEN 501 AND 700 THEN 'Medium Score'
        ELSE 'High Score'
    END AS credit_segment,

    COUNT(*) AS total_customers

FROM customer_churn
GROUP BY credit_segment;



-- 20. Find which salary segment has highest churn

SELECT 
    CASE
        WHEN EstimatedSalary BETWEEN 0 AND 50000 THEN 'Low Salary'
        WHEN EstimatedSalary BETWEEN 50001 AND 100000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_segment,

    100 * SUM(
        CASE
            WHEN Exited = 1 THEN 1
            ELSE 0
        END
    ) / COUNT(*) AS churn_ratio

FROM customer_churn
GROUP BY salary_segment
ORDER BY churn_ratio DESC;



-- 21. Find top 10 customers by estimated salary using RANK()

SELECT 
    CustomerId,
    Surname,
    EstimatedSalary,

    RANK() OVER(
        ORDER BY EstimatedSalary DESC
    ) AS salary_rank

FROM customer_churn
LIMIT 10;



-- 22. Find difference between churned and retained average balance

SELECT 
    Exited,
    AVG(Balance) AS avg_balance
FROM customer_churn
GROUP BY Exited;



-- 23. Find percentage of customers with credit card

SELECT 
    100 * SUM(
        CASE
            WHEN HasCrCard = 1 THEN 1
            ELSE 0
        END
    ) / COUNT(*) AS creditcard_percentage

FROM customer_churn;



-- 24. Find active members percentage by geography

SELECT 
    Geography,

    100 * SUM(
        CASE
            WHEN IsActiveMember = 1 THEN 1
            ELSE 0
        END
    ) / COUNT(*) AS active_percentage

FROM customer_churn
GROUP BY Geography;



-- 25. Find customers having both high balance and high salary

SELECT 
    CustomerId,
    Surname,
    Balance,
    EstimatedSalary

FROM customer_churn

WHERE Balance > (
    SELECT AVG(Balance)
    FROM customer_churn
)

AND EstimatedSalary > (
    SELECT AVG(EstimatedSalary)
    FROM customer_churn
);