# Superstore Sales Analysis: Excel · SQL · R · Tableau

**Business question:** Where is Superstore losing profit, and what should it change?

I analysed 10,194 order lines (2023–2026, United States and Canada) with four tools and built the same dashboard in Tableau and in R.

| | Link |
|---|---|
| 📊 Interactive Tableau dashboard | [View on Tableau Public](https://public.tableau.com/shared/4HXN8N2MS?:display_count=n&:origin=viz_share_link) |
| 📈 R dashboard (GitHub Pages) | `https://YOUR-USERNAME.github.io/superstore-sales-analysis/` ← replace after publishing |

![Tableau dashboard](images/tableau_dashboard.png)

---

## Key findings

| # | Finding | Evidence |
|---|---|---|
| 1 | The business is growing | Sales $494K (2023) → $746K (2026), +51%; profit +86% |
| 2 | Discounts above 20% destroy profit | 21–40% discount: −$36K · 41–80% discount: −$100K (−77% margin) |
| 3 | Furniture barely makes money | 2.6% margin; Tables −$17.8K, Bookcases −$3.6K |
| 4 | Texas discounts everything | Average discount 37% (California 7%), 0% of lines at full price, −$25.7K profit |
| 5 | West has a returns problem *(found with SQL)* | 11.6% of West orders are returned vs about 3% in other regions |

**Recommendation:** cap discounts at 20%, review the Texas discount policy, re-price Tables and Bookcases, and investigate returns in the West region.

### KPIs

| Total sales | Total profit | Profit margin | Orders | Return rate |
|---|---|---|---|---|
| $2,326,534 | $292,297 | 12.6% | 5,111 | 5.8% |

---

## Project structure

```
superstore-sales-analysis/
├── data/                  raw data as CSV (orders, returns, people)
├── excel/                 Excel workbook: helper columns, PivotTables, SUMIFS analysis
├── sql/
│   ├── 01_create_tables.sql   table definitions (SQLite)
│   ├── 02_create_view.sql     the 7 helper columns as a SQL view
│   ├── 03_data_quality.sql    blanks, duplicates, date range, impossible values
│   ├── 04_kpis.sql            the 4 dashboard KPIs
│   └── 05_analysis.sql        one query per chart + the "why" questions
├── R/
│   ├── 01_load_data.R         builds superstore.db and runs all SQL
│   └── 02_build_dashboard.R   renders the R dashboard to docs/index.html
├── dashboard/
│   └── superstore_dashboard.Rmd   R dashboard (flexdashboard + ggplot2 + plotly)
├── docs/                  the published R dashboard (GitHub Pages)
└── images/                screenshots
```

## How to run it

1. Install [R](https://cran.r-project.org/) and [RStudio](https://posit.co/download/rstudio-desktop/).
2. Open `superstore-sales-analysis.Rproj` in RStudio.
3. Open `R/01_load_data.R` → click **Source**. It installs the packages, builds `superstore.db` and prints every SQL result.
4. Open `R/02_build_dashboard.R` → click **Source**. It creates `docs/index.html` and opens it in your browser.

## Skills shown

| Tool | What I did |
|---|---|
| **Excel** | Data quality checks, helper columns (`IF`, nested `IF`, `INDEX/MATCH`, `ISNUMBER/MATCH`), `SUMIFS` report, PivotTables, calculated fields |
| **SQL** | `CREATE TABLE`, `VIEW`, `LEFT JOIN`, `CASE WHEN`, `GROUP BY`, `COUNT(DISTINCT)`, date functions, data-quality queries |
| **R** | `DBI`/`RSQLite` database connection, `ggplot2` charts, `plotly` interactivity, `flexdashboard` |
| **Tableau** | Calculated fields, dual-axis chart, filled map, heat map, dashboard filters and actions |

## What I learned

- **Ratios must be calculated from totals.** Adding up row-level margins gave 25,086%; averaging them gave 12.2%. The correct margin is `SUM(profit) / SUM(sales)` = 12.6%.
- **Count orders with `COUNT(DISTINCT)`.** One order can contain products from several categories, so category order counts add up to more than the total.
- **Duplicate checks depend on the columns you compare.** Excel found no duplicates because Row IDs differ, but SQL found 2 identical order lines (documented in `03_data_quality.sql`).

*Data: Sample – Superstore (Tableau sample dataset).*
