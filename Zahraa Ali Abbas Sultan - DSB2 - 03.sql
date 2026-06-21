-- # Joins
-- 
-- This file contains several exercises on joins. These topics are a step more involved and confusing than in the previous two files.
-- * [Tutorial on Joins](https://www.sqlitetutorial.net/sqlite-join/)
-- 
-- Here are a few other important notes I'd like you read before beginning:
-- * Make sure you read each question thoroughly.
-- * Don't skip problems, as some problems may rely on previous problems being done correctly.
-- * Make sure you are saving your answers as you go, as some answers will simply be reworkings of previous answers.
-- * A View is a virtual table that represents the result of a stored SELECT query. Unlike a physical table, it does not store data, but it can be queried like a table.
-- 
-- ## Joins
-- 
-- 62) Which employee made which sale? Join the `employees` table onto the `transactions` table by `employee_id`. You only need to include the employee's first/last name from `employees`.
select employees.firstname,employees.lastname,transactions.order_id
FROM employees JOIN transactions 
 on employees.ID= transactions.employee_id;

-- 63) What is the name of the employee who made the most in sales? Find this answer by doing a join as in the previous problem. Your resulting query will be difficult for someone else to read.
SELECT employees.firstname,
       employees.lastname,
       SUM(transactions.unit_price * transactions.quantity) AS total_sales
FROM employees
JOIN transactions
    ON employees.id = transactions.employee_id
GROUP BY employees.id
ORDER BY total_sales DESC
LIMIT 1;

-- 64) Solve the previous problem by joining `employees` onto the `trans_by_employee` view.
SELECT employees.firstname,
       employees.lastname, total_cost
FROM employees JOIN trans_by_employee on employees.id = trans_by_employee.employee_id
ORDER BY trans_by_employee.total_cost DESC
LIMIT 1;

-- 65) Next, the company will try to give bonuses based on performance. Show all employees who've made more in sales than 1.5 times their salary.
SELECT employees.firstname,
       employees.lastname,
       employees.salary,
       trans_by_employee.total_cost
FROM employees
JOIN trans_by_employee
    ON employees.id = trans_by_employee.employee_id
WHERE trans_by_employee.total_cost > 1.5 * employees.salary;

-- 66) Do we have potentially erroneous rows? Find all transactions which occurred _before_ the employee was even hired! (Make sure each transaction only occupies one row).
SELECT DISTINCT
       transactions.order_id,
       transactions.customer,
       transactions.orderdate,
       employees.firstname,
       employees.lastname,
       employees.startdate
FROM transactions
JOIN employees
    ON employees.id = transactions.employee_id
WHERE transactions.orderdate < employees.startdate;

-- 67) Among all transactions that occurred from 2015 to 2019, create a table that is the monthly revenue of our company versus the total trading volume of Yum! in that month. Format the columns nicely. (Hint: look at the views) That is, a sample row of your result might look like this:
SELECT yum_by_month.year,
       yum_by_month.month,
       PRINTF('$%,.2d', trans_by_month.total_cost) AS company_revenue,
       PRINTF('%,.2d', yum_by_month.tot_volume) AS yum_trade_volume
FROM yum_by_month
LEFT JOIN trans_by_month
    ON trans_by_month.year = yum_by_month.year
   AND trans_by_month.month = yum_by_month.month;
--
-- | year | month | company_revenue | yum_trade_volume |
-- |------|-------|-----------------|------------------|
-- | 2017 |    03 |        $100,000 |      125,000,000 |
-- ```
-- * _Hint:_ You don't need any `WHERE` statements here. You can get the right answer simply by changing what kind of join you do!