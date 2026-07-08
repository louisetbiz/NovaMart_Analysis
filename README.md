# NovaMart_Analysis
Retail sales analytics project using MySQL and Tableau.

## Project Overview
NovaMart Retail is a fictional retail company. The objective of this project was to analyze sales, product performance, store performance, marketing campaigns, and data quality using SQL and Tableau.

## Business Questions
- What is the overall business performance?
- Which product categories generate the most revenue and profit?
- Which stores and regions perform best?
- Which marketing campaigns deliver the strongest ROI?
- Are there data quality issues that could affect reporting accuracy?

## Tools Used
- MySQL
- Tableau
- GitHub

## Data Model
The project uses multiple related tables:
- customers
- orders
- order_items
- products
- stores
- marketing_campaigns
- inventory
- returns

## SQL Process
The SQL workflow included:
1. Data quality checks
2. Cleaning invalid records
3. Creating executive KPIs
4. Calculating revenue, profit, and margin
5. Building reporting tables for Tableau

## Key Insights
- Electronics generated the highest revenue at 935,839.98. However, the Kitchen category achieved the highest profit margin at 50.30%, despite having the lowest revenue of 278,645.15.
  
- Based on the data, the Winter Sale campaign delivered the highest return on investment (ROI), achieving 31.28%.
  
- The Central region has the largest store presence, with four stores. However, the West region is home to the top two best-performing stores, which generated a combined revenue of 305,650.11.

## Recommendations
- Based on the data, my first recommendation would be to expand the store network in the West region. Although the Central region has the highest number of stores, the top two highest-performing stores are located in the West. I would also recommend gathering more geographic and demographic data for the South region, as one store ranks among the top three in revenue while the other two are the lowest-performing stores.
  
- Out of 120 customers in the database, only 109 are active, meaning approximately 9% are inactive. I recommend analyzing customer churn to better understand why these customers stopped purchasing. This could reveal opportunities to improve customer retention through targeted marketing, loyalty programs, or product offerings.
  
- The Kitchen category has the highest profit margin but the lowest revenue, suggesting an opportunity to increase sales through promotions or improved product visibility. At the same time, I recommend reviewing the cost structure of the Electronics category. Since it generates the highest revenue, identifying opportunities to reduce production or procurement costs could significantly improve its profit margin without compromising sales.


