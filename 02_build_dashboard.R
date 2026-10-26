# =====================================================================
# 02_build_dashboard.R
# Step 2: turn dashboard/superstore_dashboard.Rmd into docs/index.html.
# GitHub Pages publishes the docs/ folder as a website.
#
# Run R/01_load_data.R first (it creates superstore.db).
# =====================================================================

if (!file.exists("superstore.db")) {
  stop("superstore.db not found. Run R/01_load_data.R first.")
}

rmarkdown::render(
  input       = "dashboard/superstore_dashboard.Rmd",
  output_file = "index.html",
  output_dir  = "docs"
)

# Open the result in your web browser
browseURL("docs/index.html")
