#!/usr/bin/env bash
# run_analysis.sh — wrapper to run the Olympic Medal Analysis

set -euo pipefail

echo "1) Running R analysis..."
Rscript Olympic_Medal_Analysis_API.R

echo "2) Rendering report to PDF..."
# If you have an Rmd, otherwise compile LaTeX directly
if [ -f Olympic_Medal_Report.Rmd ]; then
  Rscript -e "rmarkdown::render('Olympic_Medal_Report.Rmd', output_file='report.pdf')"
else
  pdflatex report.tex
fi

echo "Done. Generated report.pdf"
