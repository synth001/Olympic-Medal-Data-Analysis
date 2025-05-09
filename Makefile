# Makefile for Olympic Medal Analysis

R_SCRIPT      := Olympic_Medal_Analysis_API.R
RMD_REPORT    := Olympic_Medal_Report.Rmd
TEX_REPORT    := report.tex
PDF_REPORT    := report.pdf
DOCKER_IMAGE  := olympic-medal-analysis

.PHONY: all run report clean docker-build docker-run

all: run report

# Run the R analysis script
run:
	@echo ">>> Running analysis script..."
	Rscript $(R_SCRIPT)

# Render R Markdown to PDF (requires pandoc + LaTeX)
report: $(RMD_REPORT)
	@echo ">>> Rendering R Markdown to PDF..."
	Rscript -e "rmarkdown::render('$(RMD_REPORT)', output_file='$(PDF_REPORT)')"

# Clean up generated files
clean:
	@echo ">>> Cleaning up..."
	rm -f *.png *.pdf *.html *.log *.aux

# Build the Docker image
docker-build:
	docker build -t $(DOCKER_IMAGE) .

# Run inside Docker
docker-run:
	docker run --rm -v $$PWD:/app -w /app $(DOCKER_IMAGE) make run

