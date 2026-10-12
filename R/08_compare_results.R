# Compare recomputed results with the values printed in the thesis.
comparison <- list()
compare <- function(analysis, statistic, reported, recomputed, digits) {
  comparison[[length(comparison) + 1]] <<- data.frame(
    Analysis = analysis, Statistic = statistic, Thesis = reported, Recomputed = recomputed,
    Difference = recomputed - reported, Decimal_places = digits,
    Match = round(recomputed, digits) == reported)
}
compare('Descriptives', 'Age mean', 27.94, descriptives$Mean[1], 2)
compare('Descriptives', 'Age SD', 9.24, descriptives$SD[1], 2)
compare('Descriptives', 'Perceived anxiety mean', 5.81, descriptives$Mean[2], 2)
compare('Descriptives', 'Perceived anxiety SD', 2.18, descriptives$SD[2], 2)
compare('Descriptives', 'Knowledge mean', 19.31, descriptives$Mean[3], 2)
compare('Descriptives', 'Knowledge SD', 4.71, descriptives$SD[3], 2)

total_alpha <- reliability[[1]]
compare('Reliability', 'Total alpha', .81, total_alpha$Alpha, 2)
compare('Reliability', 'Standardised total alpha', .81, total_alpha$Standardised_alpha, 2)
compare('Reliability', 'Guttman', .84, total_alpha$Guttman, 2)
compare('Reliability', 'Signal-to-noise ratio', 4.37, total_alpha$Signal_to_noise, 2)
for (i in 1:3) {
  compare('EFA', paste('Factor', i, 'SS loadings'), c(3.916, 3.840, 2.843)[i], colSums(loadings^2)[i], 3)
  compare('EFA', paste('Factor', i, 'variance'), c(.145, .142, .105)[i], variance[i], 3)
  compare('Reliability', paste('Factor', i, 'alpha'), c(.73, .59, .70)[i], reliability[[i+1]]$Alpha, 2)
  compare('DFIT', paste('Factor', i, 'DTF'), c(2.509, 3.034, 5.297)[i], dtf_results[[i]]$DTF, 3)
}
compare('EFA', 'Cumulative variance', .393, sum(variance), 3)
compare('Parallel analysis', 'Retained components', 3, scree$Components$nparallel, 0)
compare('CFA complete', 'CFI', .807, fitMeasures(complete_fit, 'cfi'), 3)
compare('CFA complete', 'TLI', .789, fitMeasures(complete_fit, 'tli'), 3)
anova <- anova(anxiety_model)
for (i in 1:3) {
  compare('Anxiety interaction', paste('F', i), c(.654, 9.873, 1.559)[i], anova[['F value']][i], 3)
  compare('Anxiety interaction', paste('p', i), c(.521, .002, .214)[i], anova[['Pr(>F)']][i], 3)
}
for (i in 1:3) {
  result <- read.csv(file.path(tables, paste0('factor_', i, '_item_information.csv')))
  if (i == 1) compare('Item information', 'Factor 1 total', 11.81, sum(result$Total_information), 2)
}

original <- file.path(root, 'tables/original')
reported <- read.csv(file.path(original, 'table_11_logistic_biplot.csv'), check.names = FALSE)
for (i in 1:27) {
  compare('Logistic biplot', paste0('X', i, ' deviance'), reported$Deviances[i], biplot$VarInfo$Deviances[i], 2)
  compare('Logistic biplot', paste0('X', i, ' Nagelkerke'), reported$Nagelkerke[i], biplot$VarInfo$Nagelkerke[i], 2)
}
save_table(do.call(rbind, comparison), 'comparison_with_thesis.csv')

# Save all original-versus-recomputed cells for DFIT.
dif_comparison <- list()
for (i in 1:3) {
  reported <- read.csv(file.path(original, paste0('table_', 11+i, '_ncdif_factor', i, '.csv')), check.names = FALSE)
  calculated <- read.csv(file.path(tables, paste0('table_', 11+i, '_ncdif_factor', i, '.csv')))
  dif_comparison[[i]] <- data.frame(Factor = i, Item = calculated$Item,
                                   Thesis = as.numeric(reported[1, ]), Recomputed = calculated$NCDIF)
}
save_table(do.call(rbind, dif_comparison), 'dfit_comparison_with_thesis.csv')
