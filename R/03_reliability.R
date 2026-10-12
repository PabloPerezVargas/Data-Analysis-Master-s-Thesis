# Cronbach's alpha: total questionnaire and the three item sets.
sets <- c(list(All = names(items)), factor_items)
reliability <- lapply(names(sets), function(name) {
  result <- alpha(items[sets[[name]]], check.keys = FALSE)$total
  data.frame(Factor = name, Items = length(sets[[name]]), Alpha = result$raw_alpha,
             Standardised_alpha = result$std.alpha, Guttman = result[['G6(smc)']],
             Signal_to_noise = result[['S/N']], Alpha_SE = result$ase)
})
save_table(do.call(rbind, reliability), 'table_10_reliability.csv')

# Item information: thesis Figures 13-15.
# The original curves have different slopes; ltm(~z1) recovers those curves.
irt_models <- list()
for (i in 1:3) {
  responses <- items[factor_items[[i]]]
  model <- ltm(responses ~ z1)
  irt_models[[i]] <- model
  parameters <- coef(model)
  information <- round(parameters[, 'Dscrmn'], 2)
  total_information <- sum(information)
  result <- data.frame(Item = rownames(parameters), Difficulty = parameters[, 'Dffclt'],
                       Discrimination = parameters[, 'Dscrmn'], Total_information = information,
                       Cutoff = total_information / length(information))
  save_table(result, paste0('factor_', i, '_item_information.csv'))
  png(file.path(figures, paste0('figure_', 12 + i, '_item_information.png')), width = 853, height = 589, pointsize = 16)
  plot(model, type = 'IIC')
  dev.off()
  display <- data.frame(Item = c(sub('X', 'Item ', names(responses)), 'TOTAL'),
                        Total_information = c(information, total_information),
                        Cutoff = c(rep('', length(information)), format(total_information / length(information), digits = 10)))
  cell_colours <- matrix('white', nrow(display), 3)
  cell_colours[seq_along(information), 1] <- 'grey90'
  cell_colours[seq_along(information), 2] <- ifelse(information >= result$Cutoff,
                                                 '#c6e0b4', ifelse(result$Cutoff - information <= .30, '#ffe699', '#f4a077'))
  names(display) <- c('Item number', 'Total information', 'Cutoff')
  png(file.path(figures, paste0('figure_', 12 + i, '_information_table.png')), width = 450, height = 23 * (nrow(display) + 1))
  image <- gridExtra::tableGrob(display, rows = NULL, theme = gridExtra::ttheme_default(
    base_family = 'serif', base_size = 14,
    core = list(bg_params = list(fill = cell_colours, col = 'black')),
    colhead = list(bg_params = list(fill = 'white', col = 'black'))))
  image$widths <- grid::unit(c(.36, .39, .25) * .98, 'npc')
  image$heights <- grid::unit(rep(.98 / (nrow(display) + 1), nrow(display) + 1), 'npc')
  grid::grid.draw(image)
  dev.off()
}
