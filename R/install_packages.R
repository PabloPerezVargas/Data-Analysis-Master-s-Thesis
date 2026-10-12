packages <- c('readr', 'psych', 'polycor', 'ltm', 'lavaan', 'MultBiplotR', 'nFactors', 'gridExtra', 'gplots')
missing <- packages[!sapply(packages, requireNamespace, quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = 'https://cloud.r-project.org')
