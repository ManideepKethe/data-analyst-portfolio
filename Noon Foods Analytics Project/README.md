# Noon Foods Analytics Project 🍔📊

A MySQL project to analyze customer behavior and order patterns for a food delivery platform.

## 🎯 **Problems Resolved**
1. **Outlet Performance Analysis**  
   - *Problem*: Identify top-performing restaurants per cuisine without using `LIMIT` or `TOP`.  
   - *Solution*: Used `ROW_NUMBER()` to rank outlets by order volume within each cuisine.

2. **Customer Acquisition Trends**  
   - *Problem*: Track daily new customer growth since launch.  
   - *Solution*: Aggregated first-order dates and counted daily registrations.

3. **One-Time Jan 2025 Customers**  
   - *Problem*: Find users who ordered once in Jan 2025 and never returned.  
   - *Solution*: Filtered orders within Jan 2025 and excluded customers with orders outside this month.

4. **Inactive Promo Customers**  
   - *Problem*: Target customers with no orders in 7 days, acquired >1 month ago, with promo-first orders.  
   - *Solution*: Combined `DATE_SUB()` for date ranges and joined first-order promo codes.

5. **Third-Order Trigger Automation**  
   - *Problem*: Trigger communication after every third order.  
   - *Solution*: Used `ROW_NUMBER()` to flag orders divisible by 3.

6. **Promo-Exclusive Customers**  
   - *Problem*: Identify users who *always* used promo codes.  
   - *Solution*: Compared total orders vs. promo-order counts.

7. **Organic Acquisition Rate**  
   - *Problem*: Measure % of customers who placed their first order without promos.  
   - *Solution*: Calculated ratio using conditional aggregation.

---

## 🔍 **Key Insights from Sample Data**
1. **Customer Retention**  
   - Customer `UFDDN1991918XUY1` placed 5 orders in Jan 2025 but none in the last 7 days (as of March 2025), making them a candidate for re-engagement campaigns.

2. **Promo Effectiveness**  
   - Customers like `JAN_ONLY_ORDER1` and `JAN_ONLY_ORDER2` were acquired with promos (`NEWUSER`, `FIRSTORDER`) but didn’t return, suggesting promos may not drive loyalty.

3. **Third-Order Behavior**  
   - Customer `THIRD_ORDER_CUST1` placed their third order on 2025-01-15, triggering a communication opportunity.

4. **Cuisine Preferences**  
   - Lebanese cuisine (`KMKMH6787`) had the highest order volume in the sample data, indicating popularity.

5. **Organic Acquisition**  
   - Customer `MNO7890123456XYZ` placed their first order without a promo code, contributing to the organic acquisition rate.

---

## 📂 Project Structure
- `Data.sql`: Database schema and sample data insertion.
- `queries.sql`: Analytical SQL queries for business insights.

## 🛠️ Setup Instructions
1. **Initialize Database**:
   ```sql
   mysql> source Data.sql;
   ```
2. **Run Queries**:
   ```sql
   mysql> source queries.sql;
   ```