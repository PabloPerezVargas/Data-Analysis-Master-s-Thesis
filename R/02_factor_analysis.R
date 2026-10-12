# Binary item correlations and three-factor exploratory analysis.
correlations <- hetcor(as.data.frame(lapply(items, factor)), std.err = FALSE)$correlations
efa <- factanal(covmat = correlations, factors = 3, n.obs = nrow(items), rotation = 'varimax')
loadings <- unclass(efa$loadings)
variance <- colSums(loadings^2) / ncol(items)
save_table(data.frame(Statistic = c('SS loadings', 'Proportion of variance', 'Cumulative variance'),
                     rbind(colSums(loadings^2), variance, cumsum(variance))), 'table_08_efa_variance.csv')
save_table(data.frame(Item = rownames(loadings), loadings, row.names = NULL), 'table_09_efa_loadings.csv')
save_table(data.frame(Item = rownames(correlations), correlations), 'item_correlations.csv')

# Parallel analysis and scree plot: thesis Figure 12.
set.seed(123)
if (requireNamespace('nFactors', quietly = TRUE)) {
  eigenvalues <- eigen(cor(items))$values
  random <- nFactors::parallel(subject = nrow(items), var = ncol(items), rep = 100, cent = .95)
  scree <- nFactors::nScree(x = eigenvalues, aparallel = random$eigen$qevpea)
  png(file.path(figures, 'figure_12_parallel_analysis.png'), width = 1200, height = 565)
  nFactors::plotnScree(scree, main = 'Solution for determining the number of factors')
  dev.off()
  save_table(data.frame(Component = seq_along(eigenvalues), Observed = eigenvalues,
                       Parallel = random$eigen$qevpea), 'parallel_analysis.csv')
  save_table(scree$Components, 'parallel_analysis_factors.csv')
} else stop('Install nFactors with R/install_packages.R.')
