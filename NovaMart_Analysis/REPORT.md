# Retail Sales Performance Analysis

## 1. Project Overview

This project analyses retail sales performance using a consolidated dataset containing transactional, product, store, marketing campaign, cost, and inventory information.

The objective was to evaluate:

* Overall sales and profitability
* Product-category performance
* Store and regional performance
* Marketing campaign performance
* Monthly revenue trends
* Data-quality issues affecting the reliability of the analysis

The final analysis was performed using `Data_clean(1).csv` as the single analytical source.

---

## 2. Business Questions

The analysis was designed to answer the following questions:

1. How much net revenue and profit did the business generate?
2. What was the overall profit margin?
3. Which product categories generated the most revenue and profit?
4. Which stores and regions performed best?
5. Which marketing campaigns generated the strongest financial results?
6. How did revenue change between months?
7. Which areas require commercial or operational improvement?

---

## 3. Data Structure and Level of Detail

The consolidated dataset is structured at the **order-line level**.

This means:

> One row represents one product recorded within one customer order.

Consequently, the same order, customer, store, or campaign may appear on several rows when an order contains multiple products.

These repeated values are not necessarily duplicates. They represent legitimate one-to-many relationships between orders and order items.

However, exact duplicate rows should not be included because they would artificially increase revenue, quantities, costs, and profit.

### Final dataset size

The original consolidated file contained:

* 412 rows
* 21 columns

A duplicate check identified two exact duplicate records:

* Order `1326`, product `9`
* Order `1417`, product `16`

After removing one copy of each duplicate, the final analytical dataset contained:

* **410 order-line records**
* **195 unique orders**
* **95 unique customers**
* **30 unique products**
* **15 stores**
* **6 marketing campaigns**

---

## 4. Data-Quality Assessment

Before performing the analysis, several data-quality risks were evaluated.

### 4.1 Negative prices

Negative product prices would produce incorrect revenue calculations.

The source data was checked for values where:

```sql
unit_price < 0
```

For the analytical dataset, cleaned prices were stored in `unit_price_clean`.

---

### 4.2 Negative or invalid quantities

Negative quantities may represent returns, corrections, or data-entry errors. They should not automatically be treated as normal sales.

The analysis was based on records with:

```sql
quantity_clean > 0
```

Only positive quantities were included in sales and profitability metrics.

---

### 4.3 Invalid discounts

Valid percentage discounts must fall between 0% and 100%.

The validation rule was:

```sql
discount_pct BETWEEN 0 AND 100
```

In the final dataset, discounts ranged from:

* Minimum discount: **0%**
* Maximum discount: **20%**

Therefore, all remaining discount values were valid.

---

### 4.4 Missing product categories

Records with missing product categories cannot be reliably included in category-level analysis.

The filtering rule was:

```sql
category IS NOT NULL
```

The final analytical dataset did not contain null product categories.

---

### 4.5 Incorrect campaign dates

Marketing campaigns were checked for cases where the end date occurred before the start date.

The validation rule was:

```sql
end_date > start_date
```

Only campaigns with valid chronological date ranges were intended to be included.

---

### 4.6 Duplicate customer emails

Duplicate customer email addresses were tested in the original customer table because they can indicate repeated customer records.

Customer counts in the final analysis were calculated using:

```sql
COUNT(DISTINCT customer_id)
```

This avoids counting the same customer more than once because they made multiple purchases.

---

### 4.7 Exact duplicate rows

Although the consolidated dataset did not initially appear to have duplicates based on selected identifiers, a full-row duplicate check found two exact duplicated records.

These duplicates would have overstated the results by:

* Revenue: **1,289.29**
* Units sold: **4**
* Profit: **433.25**

The duplicates were therefore removed before calculating the final KPIs.

---

## 5. Analytical Scope and Assumptions

The analysis was based on the following criteria:

* Completed orders
* Positive quantities
* Valid discounts between 0% and 100%
* Non-null product categories
* Valid campaign date ranges
* Cleaned positive unit prices
* Exact duplicate records removed

### Completed-order limitation

The original normalized analysis filtered orders using:

```sql
order_status = 'Completed'
```

However, the consolidated `Data_clean(1)` file does not contain an `order_status` column.

Therefore, this report assumes that the completed-order filter was applied before the consolidated dataset was exported.

This condition cannot be independently verified using `Data_clean(1)` alone.

For stronger auditability, a future version of the consolidated dataset should retain the `order_status` field.

---

## 6. Metric Definitions

### Net revenue

Net revenue was calculated after applying the line-level discount:

```text
Net Revenue =
Unit Price × Quantity × (1 − Discount Percentage / 100)
```

### Total cost

```text
Total Cost =
Unit Cost × Quantity
```

### Gross profit

```text
Gross Profit =
Net Revenue − Total Cost
```

### Gross margin percentage

```text
Gross Margin % =
Gross Profit / Net Revenue × 100
```

The project uses a revenue-weighted gross margin for the overall business.

The `margin` column in the dataset represents the percentage margin of an individual order line. It should not be summed.

### Average order value

```text
Average Order Value =
Total Net Revenue / Number of Unique Orders
```

### Campaign return

Two campaign indicators can be reported:

```text
Revenue-to-Budget Ratio =
Campaign Revenue / Campaign Budget
```

```text
Profit Return on Budget % =
Campaign Profit / Campaign Budget × 100
```

Revenue divided by budget should not be described as profit ROI unless campaign-attributed profit is used in the numerator.

---

## 7. Executive KPIs

After removing the two duplicate records, the analysis produced the following results:

| KPI                 |     Result |
| ------------------- | ---------: |
| Net revenue         | 854,616.82 |
| Total cost          | 532,982.52 |
| Gross profit        | 321,634.30 |
| Gross margin        |     37.63% |
| Units sold          |      1,463 |
| Unique orders       |        195 |
| Unique customers    |         95 |
| Average order value |   4,382.65 |
| Unique products     |         30 |
| Stores              |         15 |
| Marketing campaigns |          6 |

The business generated approximately **854.6K in net revenue** and **321.6K in gross profit**, resulting in an overall gross margin of **37.63%**.

---

## 8. Category Performance

| Category    |    Revenue | Gross Profit | Margin |
| ----------- | ---------: | -----------: | -----: |
| Electronics | 289,756.28 |   107,693.92 | 37.17% |
| Home Office | 170,526.51 |    63,154.50 | 37.04% |
| Beauty      | 151,620.08 |    45,328.66 | 29.90% |
| Kitchen     | 134,539.11 |    63,085.51 | 46.89% |
| Fitness     | 108,174.84 |    42,371.71 | 39.17% |

### Insights

**Electronics was the largest revenue contributor**, generating approximately 289.8K. It represented around one-third of total revenue and produced the highest absolute gross profit.

**Kitchen produced the strongest margin**, at approximately 46.89%. Although its revenue was lower than Electronics, Home Office, and Beauty, it converted a greater share of revenue into profit.

**Beauty showed the lowest category margin**, at 29.90%. Its revenue was substantial, but its profitability was weaker than every other category.

### Interpretation

Revenue alone does not provide a complete view of performance.

Electronics is strategically important because of its sales volume and total profit, while Kitchen is attractive because of its high margin. Beauty requires further investigation into pricing, product cost, and discounting.

---

## 9. Store Performance

The leading stores by net revenue were:

| Store    |   Revenue | Gross Profit | Margin |
| -------- | --------: | -----------: | -----: |
| Store 11 | 97,324.20 |    35,574.64 | 36.55% |
| Store 12 | 92,776.09 |    37,788.57 | 40.73% |
| Store 7  | 91,015.56 |    32,562.22 | 35.78% |
| Store 1  | 87,168.76 |    30,692.67 | 35.21% |
| Store 6  | 71,324.43 |    24,162.49 | 33.88% |

### Insights

**Store 11 generated the highest revenue**, while **Store 12 generated the highest profit among the leading stores** and achieved a stronger margin.

Store 6 appeared among the stronger stores by revenue but had the lowest margin of all stores, at approximately 33.88%.

The lowest-revenue stores included:

* Store 3
* Store 4
* Store 5
* Store 15
* Store 9

Low store revenue should not immediately be interpreted as poor management. Store size, customer traffic, operating period, local market, and stock availability were not included in the dataset.

---

## 10. Regional Performance

| Region  |    Revenue | Gross Profit | Margin |
| ------- | ---------: | -----------: | -----: |
| South   | 260,057.85 |    98,892.35 | 38.03% |
| Central | 231,826.02 |    87,799.61 | 37.87% |
| East    | 219,873.10 |    80,789.40 | 36.74% |
| West    | 144,149.14 |    54,153.00 | 37.57% |

### Insights

The **South was the strongest region**, producing the highest revenue and gross profit.

The **West generated the lowest revenue**, but its margin remained broadly comparable with the other regions. This suggests that its primary challenge may be sales volume rather than unit profitability.

---

## 11. Marketing Campaign Performance

| Campaign       | Budget |    Revenue | Gross Profit | Revenue/Budget | Profit Return on Budget |
| -------------- | -----: | ---------: | -----------: | -------------: | ----------------------: |
| Winter Sale    |  7,612 | 171,717.79 |    69,273.33 |         22.56× |                 910.05% |
| Spring Refresh | 21,408 | 168,959.99 |    63,759.71 |          7.89× |                 297.83% |
| VIP Loyalty    | 16,481 | 123,694.83 |    45,196.38 |          7.51× |                 274.23% |
| Black Friday   | 23,229 | 167,935.33 |    61,986.68 |          7.23× |                 266.85% |
| Back to Office | 20,002 | 114,270.86 |    39,696.60 |          5.71× |                 198.46% |
| Summer Deals   | 22,662 | 108,038.02 |    41,721.60 |          4.77× |                 184.10% |

### Insights

**Winter Sale was the strongest campaign based on both revenue and profit relative to budget.**

It generated:

* 22.56 in revenue for every 1 of campaign budget
* Approximately 9.10 in gross profit for every 1 of campaign budget

**Summer Deals produced the weakest return relative to budget**, although it was still profitable based on the available gross-profit calculation.

### Campaign-analysis limitation

This analysis attributes the full revenue and gross profit of connected orders to each campaign.

It does not prove that the campaign directly caused those sales.

A true incremental marketing ROI analysis would require:

* A non-campaign control group
* Customer acquisition data
* Channel-specific campaign costs
* Baseline sales
* Incremental sales estimates
* Customer lifetime value

Therefore, the campaign results should be interpreted as **campaign-attributed performance**, not causal marketing effectiveness.

---

## 12. Monthly Revenue Trend

| Month Number |    Revenue | Gross Profit | Orders |
| -----------: | ---------: | -----------: | -----: |
|            1 | 100,017.77 |    38,334.22 |     24 |
|            2 | 128,257.64 |    46,958.25 |     30 |
|            3 | 144,563.75 |    53,410.62 |     34 |
|            4 | 111,299.71 |    42,677.33 |     26 |
|            5 | 127,193.06 |    51,084.42 |     27 |
|            6 | 102,379.74 |    36,369.44 |     25 |
|            7 | 140,905.15 |    52,800.02 |     29 |

### Insights

**Month 3 generated the highest revenue**, followed by Month 7.

The weakest revenue occurred in Month 1, with Month 6 producing the second-lowest result.

Revenue did not follow a consistent upward or downward trend. Performance fluctuated between months, potentially reflecting campaign timing, seasonal demand, product availability, or differences in order volumes.

Because the dataset contains only month numbers and not a complete analytical date field, year-over-year and seasonality conclusions cannot be made.

---

## 13. Principal Findings

### 1. Electronics drives business scale

Electronics generated the highest revenue and absolute profit. Maintaining product availability and competitive pricing in this category is likely to have a significant effect on total company performance.

### 2. Kitchen offers the strongest category margin

Kitchen produced a gross margin of approximately 46.89%, making it the most profitable category per unit of revenue.

### 3. Beauty requires a profitability review

Beauty generated meaningful revenue but had the lowest category margin at 29.90%.

Potential drivers include:

* High product costs
* Excessive discounting
* Low-margin product mix
* Inefficient supplier terms

### 4. Store 12 combines scale and profitability

Store 12 generated high revenue, the greatest profit among the leading stores, and a margin above 40%.

Its product mix and sales practices should be examined as a potential internal benchmark.

### 5. Store 6 has a margin challenge

Store 6 generated considerable revenue but recorded the lowest store margin.

The difference may result from its product mix, discount usage, or concentration of low-margin products.

### 6. Winter Sale generated the strongest budget-relative result

Winter Sale materially outperformed the other campaigns based on revenue and gross profit relative to recorded campaign budget.

However, causal marketing effectiveness cannot be confirmed without a baseline or control group.

### 7. Data quality materially affects reported results

The two duplicate rows increased revenue, quantities, cost, and profit. This demonstrates why full-row duplicate checks and reconciliation procedures are necessary before publishing KPIs.

---

## 14. Recommendations

### Product strategy

Protect the availability of high-revenue Electronics products while monitoring their margins.

Consider increasing visibility, assortment, or inventory allocation for high-margin Kitchen products.

Review Beauty pricing and supplier costs to determine why its margin is below the other categories.

Avoid discontinuing low-revenue products based only on sales. Their strategic role, inventory levels, customer demand, and contribution margin should also be examined.

### Store strategy

Study Store 12 as an internal benchmark for product mix, pricing, and commercial execution.

Review Store 6’s category mix and discount patterns to identify the source of its weaker margin.

Investigate whether low-revenue stores suffer from limited customer traffic, insufficient inventory, smaller store size, or regional market differences.

### Campaign strategy

Analyse the characteristics of Winter Sale to identify reusable elements, including:

* Products promoted
* Discount levels
* Customer segments
* Stores involved
* Campaign duration
* Timing

Review Summer Deals and Back to Office before repeating the same level of investment.

Future campaign reporting should distinguish between:

* Campaign-attributed revenue
* Campaign-attributed gross profit
* Incremental revenue
* Incremental profit
* Customer acquisition cost
* True marketing ROI

### Data-governance strategy

Add an automated duplicate check before every analysis.

Retain key audit fields in the consolidated dataset, particularly:

* Order status
* Order date
* Product status
* Original quantity
* Original unit price
* Data-cleaning flag
* Return or cancellation indicator

Create a documented data dictionary and a reproducible SQL cleaning pipeline.

Reconcile consolidated-table totals with normalized source-table totals after every transformation.

---

## 15. Limitations

The analysis has several limitations:

1. `order_status` is not present in the final consolidated file, so the completed-order condition cannot be independently verified.
2. Product names are not included, limiting product-level interpretation to product IDs.
3. Customer demographics and customer acquisition information are unavailable.
4. The dataset does not include operating expenses, so the reported profit is gross profit rather than net business profit.
5. Campaign revenue attribution does not demonstrate incremental campaign impact.
6. Month numbers are provided without a complete order date or reporting year.
7. Stock-on-hand values repeat across transaction rows and should not be summed.
8. Campaign budgets repeat across transaction rows and must not be summed directly.
9. The dataset does not identify returns separately from erroneous negative quantities.
10. Store size, traffic, staffing, and operating costs are not available.

---

## 16. Conclusion

The analysis identified a business generating approximately **854.6K in net revenue**, **321.6K in gross profit**, and a **37.63% gross margin** from 195 completed-order records represented across 410 cleaned order lines.

Electronics was the primary revenue driver, while Kitchen delivered the strongest category margin. Store 12 demonstrated a strong balance between sales and profitability, and Winter Sale produced the highest campaign-attributed return relative to budget.

The analysis also demonstrated that data preparation is a fundamental part of business intelligence. Two exact duplicate rows were enough to overstate multiple KPIs, while missing audit fields limited the ability to verify some of the original filtering conditions.

The main business opportunity is to combine the scale of Electronics with the margin strength of Kitchen, improve Beauty profitability, investigate store-level margin differences, and implement more rigorous campaign measurement and data-governance controls.
