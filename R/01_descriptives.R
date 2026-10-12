# Descriptive statistics: thesis Tables 3-5.
d <- subset(data, !is.na(age) & education != 'Primary')
variables <- c('age', 'perceived_anxiety', 'total_score')
descriptives <- data.frame(
  Variable = c('Age', 'Perceived anxiety', 'Anxiety knowledge'),
  n = sapply(d[variables], function(x) sum(!is.na(x))),
  Mean = sapply(d[variables], mean), SD = sapply(d[variables], sd)
)
save_table(descriptives, 'table_03_descriptives.csv')

d <- subset(data, education != 'Primary')
d$gender <- factor(d$gender, levels = c('Female', 'Male'))
d$education <- factor(d$education, levels = c('Upper secondary / vocational', 'Secondary', 'Postgraduate', 'University'))
d$group <- factor(d$group)
frequency_table <- function(x) {
  counts <- table(x)
  data.frame(Category = names(counts), n = as.integer(counts), Percentage = 100 * as.integer(counts) / sum(counts), row.names = NULL)
}
save_table(frequency_table(d$gender), 'table_04_gender.csv')
save_table(frequency_table(d$education), 'table_05_education.csv')

# Mean plots and 95% confidence intervals: thesis Figures 6-11.
mean_plot <- function(value, group, name, ylab, xlab) {
  labels <- gsub('Upper secondary / vocational', 'Upper secondary\n/ vocational', levels(group), fixed = TRUE)
  levels(group) <- labels
  png(file.path(figures, name), width = 800, height = 600, pointsize = 16)
  gplots::plotmeans(value ~ group, xlab = xlab, ylab = ylab)
  dev.off()
}
mean_plot(d$total_score, d$gender, 'figure_06_knowledge_gender.png', 'Total score', 'Gender')
mean_plot(d$perceived_anxiety, d$gender, 'figure_07_anxiety_gender.png', 'Perceived anxiety', 'Gender')
mean_plot(d$total_score, d$education, 'figure_08_knowledge_education.png', 'Total score', 'Education')
mean_plot(d$perceived_anxiety, d$education, 'figure_09_anxiety_education.png', 'Perceived anxiety', 'Education')
mean_plot(d$total_score, d$group, 'figure_10_knowledge_group.png', 'Total score', 'Training group')
mean_plot(d$perceived_anxiety, d$group, 'figure_11_anxiety_group.png', 'Perceived anxiety', 'Training group')

normality <- comparisons <- list()
for (outcome in c('total_score', 'perceived_anxiety')) {
  for (group in c('gender', 'education', 'group')) {
    test <- kruskal.test(d[[outcome]], d[[group]])
    comparisons[[length(comparisons) + 1]] <- data.frame(
      Outcome = outcome, Group = group, Statistic = unname(test$statistic),
      df = unname(test$parameter), p = test$p.value)
    for (level in levels(d[[group]])) {
      values <- d[[outcome]][d[[group]] == level]
      test <- shapiro.test(values)
      normality[[length(normality) + 1]] <- data.frame(
        Outcome = outcome, Group = group, Level = level, n = length(values),
        W = unname(test$statistic), p = test$p.value)
    }
  }
}
save_table(do.call(rbind, normality), 'normality.csv')
save_table(do.call(rbind, comparisons), 'group_comparisons.csv')

# Interactions: thesis Tables 6-7 (three education levels, n = 167).
interaction_data <- droplevels(subset(d, education != 'Secondary'))
anxiety_model <- lm(perceived_anxiety ~ education * gender, data = interaction_data)
knowledge_model <- lm(total_score ~ education * gender * group, data = interaction_data)
anova_table <- function(model) {
  results <- anova(model)
  data.frame(Term = rownames(results), results, check.names = FALSE, row.names = NULL)
}
save_table(anova_table(anxiety_model), 'table_06_anxiety_interaction.csv')
save_table(anova_table(knowledge_model), 'table_07_knowledge_interaction.csv')
