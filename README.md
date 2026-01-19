# Pizza Sales Data Analysis Project

## Project Overview
This project involves a comprehensive analysis of a retail pizza dataset using **PostgreSQL**. [cite_start]The objective was to build a structured database, perform rigorous data cleaning, and execute complex SQL queries to extract actionable business insights regarding sales performance, menu popularity, and revenue trends[cite: 5, 27].

---

## Database Schema
The analysis is built upon four interconnected tables:
* **`pizza_types`**: Metadata including pizza names, categories, and ingredients.
* **`pizzas`**: Pricing and size variations for each pizza type.
* **`orders`**: Transaction dates and timestamps.
* **`order_details`**: Mapping individual orders to specific pizza items and quantities.

---

## Data Cleaning & Validation
Before analysis, the following data integrity checks were performed to ensure accuracy:
* **Null Value Audit**: Scanned all tables for missing values across every column.
* **Validation**: Confirmed that all quantity and price entries are greater than zero.
* **Orphan Records**: Performed `LEFT JOIN`s to ensure every order detail and pizza ID corresponds to a valid master record.
* [cite_start]**Duplicates**: Used `GROUP BY` and `HAVING` clauses to verify there are no duplicate primary keys in the `orders` or `pizza_types` tables[cite: 18, 30].

---

## Business Insights Derived
The following insights were extracted through advanced SQL querying:

### 1. Sales & Operations
* **Peak Day Analysis**: Identified high-volume days with over 100 unique orders to assist in resource allocation.
* [cite_start]**Chronological Tracking**: Filtered and sorted orders by timestamp to understand daily peak hours[cite: 16].

### 2. Revenue Performance
* [cite_start]**Total Revenue**: Calculated the total annual revenue and the average revenue generated per order[cite: 17].
* **Category Leaders**: Identified pizza categories (e.g., Classic, Veggie) generating more than ₹50,000 in revenue.

### 3. Menu Optimization
* [cite_start]**Best-Sellers**: Ranked the top 5 pizzas based on total units sold[cite: 33].
* **Low-Performing Items**: Identified specific pizza types that have never been ordered by customers.
* **Category Ranking**: Used Window Functions (`DENSE_RANK`) to find the top 3 revenue-generating pizzas within every category.

---

## SQL Techniques Implemented
* **Aggregations**: `SUM`, `AVG`, `COUNT`[cite: 17].
* [cite_start]**Filtering & Logic**: `WHERE`, `HAVING`, `IS NULL`, `BETWEEN`, and `LIKE`[cite: 16, 18, 19, 29].
* [cite_start]**Sorting**: `ORDER BY` for finding top sales and chronological data[cite: 16, 31].
* **Joins**: `JOIN`, `LEFT JOIN`, and `USING` for relational data retrieval.
* **Window Functions**: `RANK()` and `DENSE_RANK()` for advanced categorization and ranking.
