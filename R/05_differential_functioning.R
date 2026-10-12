# DFIT: NCDIF, CDIF and DTF for each factor.
probability <- function(theta, parameters) {
  sapply(seq_len(nrow(parameters)), function(j)
    plogis(parameters[j, 'Dscrmn'] * (theta - parameters[j, 'Dffclt'])))
}
dtf_results <- list()
for (i in 1:3) {
  responses <- items[factor_items[[i]]]
  focal <- coef(ltm(responses[data$group == 'Health training', ] ~ z1))
  reference <- coef(ltm(responses[data$group == 'Other training', ] ~ z1))
  difference <- function(theta) probability(theta, focal) - probability(theta, reference)
  ncdif <- cdif <- numeric(ncol(responses))
  for (j in seq_len(ncol(responses))) {
    ncdif[j] <- integrate(function(t) difference(t)[, j]^2 * dnorm(t), -Inf, Inf, subdivisions = 5000)$value
    cdif[j] <- integrate(function(t) difference(t)[, j] * rowSums(difference(t)) * dnorm(t),
                         -Inf, Inf, subdivisions = 5000)$value
  }
  result <- data.frame(Item = names(responses), NCDIF = ncdif, CDIF = cdif,
                       Critical_value = .024, Above_cutoff = ncdif > .024)
  save_table(result, paste0('table_', 11 + i, '_ncdif_factor', i, '.csv'))
  dtf_results[[i]] <- data.frame(Factor = i, Critical_value = .024 * ncol(responses), DTF = sum(cdif))
}
save_table(do.call(rbind, dtf_results), 'table_15_dtf.csv')
