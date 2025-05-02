CREATE DATABASE transactions_analyse;
UPDATE customer_info SET Gender = NULL WHERE Gender = '';
UPDATE customer_info SET Age = NULL WHERE Age = '';
ALTER TABLE customer_info MODIFY Age INT NULL;

SELECT * FROM customer_info;

CREATE TABLE transactions
(
	new_date DATE,
    Id_check INT,
    ID_client INT ,
    Count_products DECIMAL(10,3),
    Sum_payment DECIMAL(10,2)
    );
    
    LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions_info.xlsx - TRANSACTIONS (1).csv"
    INTO TABLE transactions
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;
    
    
SELECT * FROM transactions;
    
# Задача 1
    
SELECT 
    c.Id_client,
    c.Gender,
    AVG(t.Sum_payment) AS avg_check, 
    AVG(t.Sum_payment) / COUNT(DISTINCT EXTRACT(MONTH FROM t.new_date)) AS avg_monthly_spend, 
    COUNT(t.Id_check) AS total_operations 
FROM customer_info c
JOIN transactions t ON c.Id_client = t.ID_client
WHERE t.new_date BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY c.Id_client, c.Gender 
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM t.new_date)) = 12;  

# Задача 2
     
SELECT 
    EXTRACT(MONTH FROM t.new_date) AS month, 
    AVG(t.Sum_payment) AS avg_check,
    COUNT(t.Id_check) / COUNT(DISTINCT EXTRACT(MONTH FROM t.new_date)) AS avg_operations_per_month,
    COUNT(DISTINCT t.ID_client) AS active_clients,
	(COUNT(t.Id_check) / (SELECT COUNT(Id_check) FROM transactions WHERE new_date BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS operation_percentage,
    (SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions WHERE new_date BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS sum_percentage
FROM transactions t
WHERE t.new_date BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY EXTRACT(MONTH FROM t.new_date);   

SELECT 
    EXTRACT(MONTH FROM t.new_date) AS month, 
    c.Gender, 
    COUNT(t.Id_check) AS transaction_count,
    SUM(t.Sum_payment) AS total_spend,
    (COUNT(t.Id_check) / (SELECT COUNT(Id_check) FROM transactions WHERE new_date BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS operation_percentage,
    (SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions WHERE new_date BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS spend_percentage
FROM transactions t
JOIN customer_info c ON t.ID_client = c.Id_client
WHERE t.new_date BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY EXTRACT(MONTH FROM t.new_date), c.Gender; 

# Задача 3

SELECT 
    CASE 
        WHEN c.Age < 20 THEN 'Under 20'
        WHEN c.Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN c.Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.Age BETWEEN 60 AND 69 THEN '60-69'
        WHEN c.Age >= 70 THEN '70+'
        ELSE 'Unknown' 
    END AS age_group,
    COUNT(t.Id_check) AS transaction_count, 
    SUM(t.Sum_payment) AS total_spend 
FROM customer_info c
JOIN transactions t ON c.Id_client = t.ID_client
WHERE t.new_date BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY age_group;


SELECT 
    CASE 
        WHEN c.Age < 20 THEN 'Under 20'
        WHEN c.Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN c.Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.Age BETWEEN 60 AND 69 THEN '60-69'
        WHEN c.Age >= 70 THEN '70+'
        ELSE 'Unknown' 
    END AS age_group,
    QUARTER(t.new_date) AS quarter, 
    AVG(t.Sum_payment) AS avg_check_per_quarter,
    COUNT(t.Id_check) AS transaction_count_per_quarter, 
    SUM(t.Sum_payment) AS total_spend_per_quarter, 
    (COUNT(t.Id_check) / (SELECT COUNT(Id_check) FROM transactions WHERE new_date BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS operation_percentage, 
    (SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions WHERE new_date BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS spend_percentage 
FROM customer_info c
JOIN transactions t ON c.Id_client = t.ID_client
WHERE t.new_date BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY age_group, quarter;