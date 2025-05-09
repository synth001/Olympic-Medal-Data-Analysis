# Olympic Medal Data Analysis Project

A comprehensive R script that pulls the TidyTuesday Olympic medals dataset from GitHub and enriches it with 2016 population and GDP data via the World Bank API. It then produces a wide array of exploratory and analytical outputs, including mappings, distributions, regressions, and clustering.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features & Outputs](#features--outputs)
3. [Prerequisites](#prerequisites)
4. [Installation & Setup](#installation--setup)
5. [Usage](#usage)
6. [Script Breakdown](#script-breakdown)
7. [Interpreting the Results](#interpreting-the-results)
8. [Extending & Customizing](#extending--customizing)
9. [Data Sources & Citations](#data-sources--citations)
10. [License](#license)

---

## Project Overview

This project provides a single R script, `Olympic_Medal_Analysis.R`, that:

* **Automatically fetches** the TidyTuesday Olympic medals CSV from GitHub
* **Aggregates** all‐time medal counts by National Olympic Committee (NOC)
* **Augments** each NOC with 2016 population and GDP per capita from the World Bank API
* **Computes** two “efficiency” metrics: medals per million population and medals per USD 1,000 GDP per capita
* **Generates** a suite of visualizations and analyses (bar charts, choropleths, scatter plots, heatmaps, regression diagnostics, and k‐means clustering)

All plots render in sequence when you source the script; regression summaries and model diagnostics print to the console.

---

## Features & Outputs

1. **Top NOCs by Medals**

   * Bar chart of the top 10 NOCs by raw medal counts
2. **Efficiency Rankings**

   * Bar chart of the top 10 NOCs by medals per million inhabitants
3. **Global Choropleth**

   * World map shaded by total medals
4. **Medal‐Type Distribution**

   * Pie chart of Gold, Silver, and Bronze proportions
5. **Medal Distributions**

   * Histogram of total medals across all NOCs
6. **Pairwise Relationships**

   * Scatter plots:

     * Gold vs. Silver
     * Total vs. Population
     * Medals per Million vs. GDP per Capita
7. **Correlation Heatmap**

   * Heatmap of correlations among raw and efficiency variables
8. **Regression Analysis**

   * Linear model predicting total medals from population, GDP per capita, and efficiency
   * Summary statistics and residuals‐versus‐fitted diagnostic plot
9. **K-Means Clustering**

   * Four‐cluster segmentation of NOCs by medal profiles and efficiency
   * PCA–based cluster visualization

---

## Prerequisites

* **R** (≥ 4.0)
* **Internet access** (to fetch both the CSV and World Bank data)

### R Packages

The script will auto-install any missing packages. It relies on:

* **tidyverse** (ggplot2, dplyr, tidyr, readr, forcats)
* **countrycode** (country ↔ ISO code conversion)
* **WDI** (World Bank API interface)
* **maps** (world map boundaries)
* **viridis** (color scales)
* **corrplot** (correlation heatmaps)
* **factoextra** (cluster visualization)

---

## Installation & Setup

1. **Clone or download** this repository.
2. Ensure **R ≥ 4.0** is installed.
3. From an R console or RStudio, set your working directory to the project folder.

No additional build steps are required.

---

## Usage

In R or RStudio:

```r
# Source the analysis script
source("Olympic_Medal_Analysis.R")
```

Plots will appear one after another, and model summaries will print to the console. To save plots, wrap the plotting calls in your own `ggsave()` calls or modify the script accordingly.

---

## Script Breakdown

1. **Setup**

   * Defines package list; installs & loads missing ones.
2. **Data Fetch**

   * Reads Olympic medals CSV from TidyTuesday GitHub.
   * Queries World Bank API for 2016 population & GDP per capita.
3. **Data Preparation**

   * Aggregates medal counts by NOC.
   * Merges with population/GDP; computes efficiency metrics.
4. **Visualizations**

   * Bar charts (raw counts & efficiency)
   * Choropleth (world map)
   * Pie chart & histogram (distributional)
   * Scatter plots (pairwise relationships)
   * Correlation heatmap
5. **Statistical Modeling**

   * Linear regression predicting total medals.
   * Diagnostic plots.
6. **Clustering**

   * k-means on scaled medal & efficiency measures.
   * PCA cluster plot.

---

## Interpreting the Results

* **Top‐10 Charts:** Highlight traditional powerhouses vs. smaller but highly efficient NOCs.
* **Choropleth:** Shows geographic concentration of medal success.
* **Efficiency Metrics:** Reveal which countries “punch above their weight” relative to population or wealth.
* **Correlations:** Indicate how medal types co‐vary and how efficiency relates to GDP/population.
* **Regression:** Quantifies the contributions of population, GDP, and efficiency to raw medal counts.
* **Clustering:** Groups countries into distinct profiles (e.g., large teams vs. niche specialists).

---

## Extending & Customizing

* **Time‐Series**: Pull medals by year to study trends.
* **Additional Predictors**: Include variables like host‐nation status, GDP growth, or sports‐sector investment.
* **Alternative Models**: Try Poisson or negative‐binomial regression for count data.
* **Interactive Maps**: Use `leaflet` or `plotly` for web‐friendly exploration.

---

## Data Sources & Citations

* **Olympic Medals**: TidyTuesday “olympics.csv”
  [https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-07-27](https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-07-27)
* **Population & GDP**: World Bank API via the `WDI` package
  [https://data.worldbank.org/](https://data.worldbank.org/)
* **R & Packages**:

  * R Core Team (2023). *R: A language and environment for statistical computing.*
  * Hadley Wickham et al. for the `tidyverse` suite.
  * Other package authors per CRAN.

---

## License

This project is released under the **MIT License**. See [LICENSE](LICENSE) for details.
