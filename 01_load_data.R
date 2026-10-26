# =====================================================================
# 01_load_data.R
# Step 1 of the project: build the SQLite database and run the SQL.
#
# How to run: open superstore-sales-analysis.Rproj in RStudio,
# open this file, then click "Source" (top-right of the script).
# =====================================================================

# ---- 1. Install any missing packages (first run only) ----------------
pkgs <- c("DBI", "RSQLite", "dplyr", "ggplot2", "scales",
          "plotly", "flexdashboard", "rmarkdown", "maps")
missing <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(missing) > 0) install.packages(missing)

library(DBI)
library(RSQLite)

# ---- 2. Helper: split a .sql file into single statements -------------
read_sql_statements <- function(path) {
  lines <- readLines(path, warn = FALSE)
  lines <- lines[!grepl("^\\s*--", lines)]          # drop comment lines
  sql   <- paste(lines, collapse = "\n")
  stmts <- trimws(strsplit(sql, ";", fixed = TRUE)[[1]])
  stmts[nchar(stmts) > 0]
}

run_sql_file <- function(con, path) {
  for (s in read_sql_statements(path)) dbExecute(con, s)
}

print_sql_file <- function(con, path) {
  cat("\n==============", path, "==============\n")
  for (s in read_sql_statements(path)) {
    print(dbGetQuery(con, s))
    cat("\n")
  }
}

# ---- 3. Create the database and tables -------------------------------
con <- dbConnect(SQLite(), "superstore.db")
run_sql_file(con, "sql/01_create_tables.sql")

# ---- 4. Load the CSV files into the tables ---------------------------
orders  <- read.csv("data/orders.csv",  colClasses = c(postal_code = "character"))
returns <- read.csv("data/returns.csv")
people  <- read.csv("data/people.csv")

dbWriteTable(con, "orders",  orders,  append = TRUE)
dbWriteTable(con, "returns", returns, append = TRUE)
dbWriteTable(con, "people",  people,  append = TRUE)

# ---- 5. Create the enriched view (the 7 helper columns) --------------
run_sql_file(con, "sql/02_create_view.sql")

# ---- 6. Run the checks and the analysis, print the results -----------
print_sql_file(con, "sql/03_data_quality.sql")
print_sql_file(con, "sql/04_kpis.sql")
print_sql_file(con, "sql/05_analysis.sql")

dbDisconnect(con)
cat("\nDone! superstore.db is ready. Next: run R/02_build_dashboard.R\n")
