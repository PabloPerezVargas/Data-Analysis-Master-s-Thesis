library(psych)
library(polycor)
library(ltm)
library(lavaan)
library(MultBiplotR)

script <- grep('^--file=', commandArgs(), value = TRUE)
root <- if (length(script)) dirname(dirname(normalizePath(sub('^--file=', '', script[1])))) else getwd()
data <- read.csv(file.path(root, 'data/analysis_data.csv'), stringsAsFactors = FALSE)
items <- data[paste0('X', 1:27)]
stopifnot(nrow(data) == 174, all(as.matrix(items) %in% 0:1),
          all(rowSums(items) == data$total_score))

tables <- file.path(root, 'tables/reproduced')
figures <- file.path(root, 'figures/reproduced')
dir.create(tables, recursive = TRUE, showWarnings = FALSE)
dir.create(figures, recursive = TRUE, showWarnings = FALSE)
save_table <- function(x, name) write.csv(x, file.path(tables, name), row.names = FALSE, na = '')

# Factor membership in thesis Tables 12-14.
factor_items <- list(
  Factor1 = paste0('X', c(5, 7, 10, 12, 19, 20, 24, 25, 27)),
  Factor2 = paste0('X', c(3, 6, 8, 9, 18, 21, 22)),
  Factor3 = paste0('X', c(1, 2, 4, 14, 16, 17, 23, 26))
)

source(file.path(root, 'R/01_descriptives.R'))
source(file.path(root, 'R/02_factor_analysis.R'))
source(file.path(root, 'R/03_reliability.R'))
source(file.path(root, 'R/04_logistic_biplot.R'))
source(file.path(root, 'R/05_differential_functioning.R'))
source(file.path(root, 'R/06_confirmatory_analysis.R'))
source(file.path(root, 'R/08_compare_results.R'))
writeLines(capture.output(sessionInfo()), file.path(tables, 'session_info.txt'))
cat('Analysis complete. Tables and figures are in the reproduced folders.\n')
