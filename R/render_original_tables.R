# Render the original thesis values with English labels.
library(gridExtra)
script <- sub('^--file=', '', grep('^--file=', commandArgs(), value = TRUE)[1])
root <- dirname(dirname(normalizePath(script)))
files <- list.files(file.path(root, 'tables/original'), pattern = '[.]csv$', full.names = TRUE)
for (file in files) {
  table <- read.csv(file, header = FALSE, fill = TRUE, check.names = FALSE, colClasses = 'character', na.strings = NULL)
  if (grepl('cfa_factors', file)) table <- table[-1, ]
  names(table) <- as.character(table[1, ])
  table <- table[-1, , drop = FALSE]
  table[is.na(table)] <- ''
  names(table) <- vapply(names(table), function(x) paste(strwrap(x, width = 28), collapse = '\n'), character(1))
  table[] <- lapply(table, function(column) vapply(column, function(x) paste(strwrap(x, width = 35), collapse = '\n'), character(1)))
  image <- sub('[.]csv$', '.png', file)
  png(image, width = max(800, 130 * ncol(table)), height = max(220, 50 + 32 * nrow(table)))
  grid.table(table, rows = NULL, theme = ttheme_minimal(base_family = 'serif', base_size = 12))
  dev.off()
}
