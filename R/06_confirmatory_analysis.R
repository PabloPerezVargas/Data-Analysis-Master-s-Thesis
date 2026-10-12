# The complete model uses the exact item membership from thesis Table 16.
complete_model <- '
  Techniques =~ X5 + X10 + X11 + X20 + X24 + X25 + X26
  Symptoms =~ X9 + X12 + X14 + X15 + X17 + X22 + X23 + X27
  General =~ X1 + X2 + X3 + X4 + X6 + X7 + X8 + X13 + X16 + X18 + X19 + X21
'
complete_fit <- cfa(complete_model, data = items, estimator = 'ML')
measures <- c('chisq', 'df', 'pvalue', 'cfi', 'tli', 'rmsea', 'srmr')
save_table(data.frame(Model = 'Complete', t(unclass(fitMeasures(complete_fit, measures)))), 'cfa_complete_fit.csv')
save_table(parameterEstimates(complete_fit, standardized = TRUE), 'cfa_complete_parameters.csv')

# The thesis specifies six removals but does not list all six.
# Keep the six candidate sets visible instead of choosing one by its fit.
theoretical_sets <- list(
  Techniques = c(5, 10, 11, 20, 24, 25, 26),
  Symptoms = c(9, 12, 14, 15, 17, 22, 23, 27),
  General = c(1, 2, 3, 4, 6, 7, 8, 13, 16, 18, 19, 21)
)
candidate_fits <- list()
for (retained in c(11, 13, 15, 21, 23, 24)) {
  removed <- setdiff(c(11, 13, 15, 18, 21, 23, 24), retained)
  reduced_sets <- lapply(theoretical_sets, setdiff, y = removed)
  model <- paste(sapply(names(reduced_sets), function(name)
    paste(name, '=~', paste0('X', reduced_sets[[name]], collapse = ' + '))), collapse = '\n')
  fit <- cfa(model, data = items, estimator = 'ML')
  candidate_fits[[length(candidate_fits) + 1]] <- data.frame(
    Removed_items = paste0('X', removed, collapse = ', '), t(unclass(fitMeasures(fit, measures))))
}
save_table(do.call(rbind, candidate_fits), 'cfa_reduced_candidates.csv')
