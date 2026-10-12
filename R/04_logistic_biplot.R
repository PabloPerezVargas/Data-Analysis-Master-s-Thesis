# External logistic biplot: thesis Figure 16 and Table 11.
proximities <- BinaryProximities(as.matrix(items), coefficient = 'Jaccard')
coordinates <- PrincipalCoordinates(proximities, dimension = 2)
biplot <- ExternalBinaryLogisticBiplot(coordinates, penalization = 0)

save_table(data.frame(Item = rownames(biplot$VarInfo), biplot$VarInfo, row.names = NULL),
           'table_11_logistic_biplot.csv')
save_table(data.frame(id = data$id, biplot$RowCoordinates), 'biplot_coordinates.csv')

png(file.path(figures, 'figure_16_logistic_biplot.png'), width = 600, height = 599)
plot(biplot, LabelRows = FALSE, ColLabels = as.character(1:27),
     RowColors = ifelse(data$group == 'Health training', 'cyan', 'red'),
     PchRows = rep(5, nrow(data)), PlotClus = FALSE, Mode = 'a')
for (group in c('Health training', 'Other training')) {
  points <- biplot$RowCoordinates[data$group == group, 1:2]
  hull <- chull(points)
  polygon(points[c(hull, hull[1]), ], border = ifelse(group == 'Health training', 'cyan', 'red'))
}
dev.off()
