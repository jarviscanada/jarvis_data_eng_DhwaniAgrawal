-- Q0: Show table schema
\d+ retail;

-- Q1: Show first 10 rows
SELECT *
FROM retail
LIMIT 10;

-- Q2: Check number of records
SELECT COUNT(*) AS count
FROM retail;

-- Q3: Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS count
FROM retail;

-- Q4: Invoice date range
SELECT
  MAX(invoice_date) AS max,
  MIN(invoice_date) AS min
FROM retail;

-- Q5: Number of unique SKUs (stock codes)
SELECT COUNT(DISTINCT stock_code) AS count
FROM retail;

-- Q6: Average invoice amount (exclude negative invoices)
SELECT AVG(invoice_total) AS avg
FROM (
  SELECT
    invoice_no,
    SUM(quantity * unit_price) AS invoice_total
  FROM retail
  GROUP BY invoice_no
  HAVING SUM(quantity * unit_price) > 0
) t;

-- Q7: Total revenue
SELECT SUM(quantity * unit_price) AS sum
FROM retail;

-- Q8: Total revenue by YYYYMM
SELECT
  (EXTRACT(YEAR FROM invoice_date)::int * 100
   + EXTRACT(MONTH FROM invoice_date)::int) AS yyyymm,
  SUM(quantity * unit_price) AS sum
FROM retail
GROUP BY yyyymm
ORDER BY yyyymm;

