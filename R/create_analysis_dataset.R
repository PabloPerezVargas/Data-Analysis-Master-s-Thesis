# Run: Rscript R/create_analysis_dataset.R path/to/original.csv
library(readr)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) stop('Provide the path to the original questionnaire CSV.')

raw <- as.data.frame(read_csv(args[1], col_types = cols(.default = col_character()),
                             name_repair = 'minimal'))
if (ncol(raw) != 99) stop('Expected the original Google Forms export with 99 columns.')
names(raw) <- paste0('V', seq_len(ncol(raw)))

score <- function(x) as.numeric(sub(' /.*', '', x))
items <- as.data.frame(lapply(raw[seq(16, 94, 3)], score))
names(items) <- paste0('X', 1:27)
if (anyNA(items) || !all(as.matrix(items) %in% 0:1)) stop('Check the item scores.')
if (!all(rowSums(items) == score(raw[[2]]))) stop('Item scores differ from total scores.')

education <- rep(NA_character_, nrow(raw))
education[grepl('primaria', raw[[9]])] <- 'Primary'
education[grepl('ESO', raw[[9]])] <- 'Secondary'
education[grepl('Bachillerato', raw[[9]])] <- 'Upper secondary / vocational'
education[grepl('Universitario', raw[[9]])] <- 'University'
education[grepl('posgrado', raw[[9]])] <- 'Postgraduate'
if (anyNA(education)) stop('Check the education categories.')

degree <- iconv(tolower(raw[[12]]), from = 'UTF-8', to = 'ASCII//TRANSLIT')
degree[is.na(degree)] <- ''
health <- grepl('psicolog|sicolog|mpgs|enfermer|medicina', degree)
psychology <- grepl('psicolog|sicolog|mpgs', degree)

data <- data.frame(
  id = seq_len(nrow(raw)),
  age = suppressWarnings(as.numeric(raw[[3]])),
  gender = ifelse(grepl('Femenino', raw[[6]]), 'Female', 'Male'),
  education = education,
  group = ifelse(health, 'Health training', 'Other training'),
  psychology = ifelse(psychology, 'Psychology', 'Other'),
  perceived_anxiety = as.numeric(raw[[96]]),
  total_score = score(raw[[2]]), items
)
if (anyNA(data$perceived_anxiety) || !all(data$perceived_anxiety %in% 1:10)) {
  stop('Check perceived anxiety scores.')
}

script <- sub('^--file=', '', grep('^--file=', commandArgs(), value = TRUE)[1])
root <- dirname(dirname(normalizePath(script)))
write.csv(data, file.path(root, 'data/analysis_data.csv'), row.names = FALSE, na = '')
cat('Saved', nrow(data), 'responses and 27 item scores.\n')
