# =================================================================================
# Olympic_Medal_Analysis.R
#
# A comprehensive R script to fetch, clean, augment, and visualize Olympic medal data
# from the TidyTuesday GitHub CSV, augmented with population and GDP via the World Bank API.
#
# This script performs:
#   1. Downloads the “olympics.csv” dataset from GitHub.
#   2. Aggregates all‐time medal counts by National Olympic Committee (NOC).
#   3. Augments each NOC with 2016 population and GDP per capita via World Bank API.
#   4. Computes “medal efficiency” measures:
#        • medals per million population
#        • medals per USD 1,000 GDP per capita
#   5. Exploratory visualizations:
#        • Bar chart: Top 10 NOCs by total medals
#        • Bar chart: Top 10 NOCs by medals per million people
#        • Choropleth: World map of total medals
#        • Pie chart: Overall medal‐type distribution
#        • Histogram: Distribution of total medals
#        • Scatter: Gold vs Silver medals
#        • Scatter: Total medals vs population
#        • Scatter: Medal efficiency vs GDP per capita
#   6. Correlation heatmap among Gold, Silver, Bronze, Total, and efficiency
#   7. Linear regression: Predict total medals from population, GDP per capita,
#        and medal efficiency.
#   8. K-means clustering of NOCs on medal counts and efficiency, with cluster plot.
#
# Dependencies:
#   - tidyverse    (ggplot2, dplyr, tidyr, readr, forcats)
#   - countrycode  (for ISO conversions)
#   - WDI          (to fetch World Bank data)
#   - maps         (for world map boundaries)
#   - viridis      (color scales)
#   - corrplot     (heatmap)
#   - factoextra   (cluster visualization)
#
# Usage:
#   1. Ensure R ≥ 4.0 is installed and Internet access is enabled.
#   2. Run: source("Olympic_Medal_Analysis_API.R")
# =================================================================================

# 0. Install & load required packages
required_pkgs <- c(
  "tidyverse", "countrycode", "WDI",
  "maps", "viridis", "corrplot", "factoextra"
)
for(pkg in required_pkgs) {
  if(!requireNamespace(pkg, quietly=TRUE)) install.packages(pkg)
  library(pkg, character.only=TRUE)
}

# 1. Fetch the TidyTuesday Olympic medals CSV via URL
url_medals <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-27/olympics.csv"
athletes   <- read_csv(url_medals, show_col_types=FALSE)

# 2. Aggregate all‐time medal counts by NOC
medals <- athletes %>%
  filter(medal %in% c("Gold","Silver","Bronze"), !is.na(noc)) %>%
  group_by(noc) %>%
  summarize(
    gold   = sum(medal == "Gold"),
    silver = sum(medal == "Silver"),
    bronze = sum(medal == "Bronze"),
    total  = gold + silver + bronze,
    .groups="drop"
  )

# 3. Fetch 2016 population & GDP per capita from World Bank
wb_inds <- c(pop="SP.POP.TOTL", gdp_pc="NY.GDP.PCAP.KD")
wb_raw  <- WDI(
  country   = unique(medals$noc),
  indicator = wb_inds,
  start     = 2016, end = 2016
)
wb <- wb_raw %>%
  select(iso2c, population=pop, gdp_pc) %>%
  mutate(noc = countrycode(iso2c, "iso2c", "iso3c")) %>%
  filter(!is.na(noc)) %>%
  select(noc, population, gdp_pc)

# 4. Merge medals with population, GDP, and human‐readable name
medals <- medals %>%
  left_join(wb, by="noc") %>%
  mutate(
    country             = countrycode(noc, "iso3c", "country.name"),
    medals_per_million  = total / (population / 1e6),
    medals_per_gdp1000  = total / (gdp_pc / 1e3)
  )

# 5. Top 10 NOCs by raw total medals
top10_total <- medals %>% arrange(desc(total)) %>% slice(1:10)
p1 <- ggplot(top10_total, aes(
  fct_reorder(country, total), total, fill=country
)) +
  geom_col(show.legend=FALSE) + coord_flip() +
  labs(
    title="Top 10 NOCs by All-Time Olympic Medals",
    x=NULL, y="Total Medals"
  ) + theme_minimal()
print(p1)

# 6. Top 10 by medals per million population
top10_effpop <- medals %>% arrange(desc(medals_per_million)) %>% slice(1:10)
p2 <- ggplot(top10_effpop, aes(
  fct_reorder(country, medals_per_million),
  medals_per_million, fill=country
)) +
  geom_col(show.legend=FALSE) + coord_flip() +
  labs(
    title="Top 10 NOCs by Medals per Million People",
    x=NULL, y="Medals per Million"
  ) + theme_minimal()
print(p2)

# 7. Choropleth: world map of total medals
world_map <- map_data("world") %>%
  mutate(iso3 = countrycode(region, "country.name", "iso3c"))
map_df <- left_join(world_map, medals, by=c("iso3"="noc"))
p3 <- ggplot(map_df, aes(long, lat, group=group, fill=total)) +
  geom_polygon(color="gray70", size=0.1) +
  scale_fill_viridis(
    name="Total Medals", na.value="gray95"
  ) +
  labs(title="All-Time Olympic Medals by Country") +
  theme_void()
print(p3)

# 8. Pie chart: medal-type distribution
overall <- medals %>%
  summarize(across(c(gold, silver, bronze), sum, na.rm=TRUE)) %>%
  pivot_longer(everything(), names_to="Medal", values_to="Count")
p4 <- ggplot(overall, aes(x="", y=Count, fill=Medal)) +
  geom_col(width=1) + coord_polar("y") +
  scale_fill_viridis_d(option="plasma") +
  labs(title="Overall Medal-Type Distribution") + theme_void()
print(p4)

# 9. Histogram: distribution of total medals
p5 <- ggplot(medals, aes(total)) +
  geom_histogram(binwidth=1, fill="steelblue", color="white") +
  labs(
    title="Distribution of Total Medals Across NOCs",
    x="Total Medals", y="Frequency"
  ) + theme_minimal()
print(p5)

# 10. Scatter: Gold vs Silver
p6 <- ggplot(medals, aes(gold, silver)) +
  geom_point(alpha=0.7) +
  geom_smooth(method="lm", se=FALSE, color="darkred") +
  labs(
    title="Gold vs Silver Medals by NOC",
    x="Gold", y="Silver"
  ) + theme_minimal()
print(p6)

# 11. Scatter: Total medals vs Population
p7 <- ggplot(medals, aes(population, total)) +
  geom_point(alpha=0.7) +
  scale_x_log10(labels=scales::comma) +
  geom_smooth(method="lm", se=FALSE, color="darkgreen") +
  labs(
    title="Total Medals vs Population (2016)",
    x="Population (log scale)", y="Total Medals"
  ) + theme_minimal()
print(p7)

# 12. Scatter: Efficiency vs GDP per Capita
p8 <- ggplot(medals, aes(gdp_pc, medals_per_million)) +
  geom_point(alpha=0.7) +
  scale_x_log10(labels=scales::comma) +
  geom_smooth(method="lm", se=FALSE, color="purple") +
  labs(
    title="Medals per Million vs GDP per Capita (2016)",
    x="GDP per Capita (log scale)", y="Medals per Million"
  ) + theme_minimal()
print(p8)

# 13. Correlation heatmap
corr_vars <- medals %>%
  select(gold, silver, bronze, total,
         medals_per_million, medals_per_gdp1000)
corr_mat <- cor(corr_vars, use="pairwise.complete.obs")
corrplot(
  corr_mat, method="color", type="upper",
  tl.col="black", tl.cex=0.8,
  title="Correlation Matrix: Medals & Efficiency"
)

# 14. Linear regression: Predict total medals
mod <- lm(total ~ population + gdp_pc + medals_per_million, data=medals)
cat("\n=== Linear Regression Summary ===\n")
print(summary(mod))
plot(mod, which=1)

# 15. K-means clustering (k = 4)
#    Remove any rows with NA in our clustering variables
clustering_data <- corr_vars %>% drop_na()
set.seed(123)
km <- kmeans(scale(clustering_data), centers=4, nstart=25)
# Attach cluster labels back
medals <- medals %>%
  mutate(cluster = factor(ifelse(
    rownames(medals) %in% rownames(clustering_data),
    km$cluster, NA
  )))

# 16. Cluster plot (PCA-based)
fviz_cluster(
  km,
  data      = scale(clustering_data),
  geom      = "point",
  ellipse   = TRUE,
  show.clust.cent = FALSE,
  ggtheme   = theme_minimal(),
  main      = "K-means Clusters of NOCs by Medal Profile"
)

# =================================================================================
# End of Olympic_Medal_Analysis.R
# =================================================================================
