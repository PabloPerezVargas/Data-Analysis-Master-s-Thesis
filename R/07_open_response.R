# Study 2: the six-layer architecture from thesis Table 17.
# Original responses and training settings have not been recovered.
open_response_model <- function(dense_activation) {
  library(keras3)
  keras_model_sequential() |>
    layer_embedding(input_dim = 10000, output_dim = 512, input_shape = c(22)) |>
    layer_lstm(units = 128, return_sequences = TRUE) |>
    layer_dropout(rate = .20) |>
    layer_lstm(units = 64) |>
    layer_dense(units = 32, activation = dense_activation) |>
    layer_dense(units = 3, activation = 'softmax')
}

# Use recovered text, labels and saved train/test assignments only.
# Supply the original optimiser, epochs and batch size when recovered.
train_open_response <- function(responses, optimiser, epochs, batch_size, dense_activation) {
  library(keras3)
  stopifnot(all(c('text', 'level', 'split') %in% names(responses)),
            all(responses$level %in% 0:2),
            all(responses$split %in% c('train', 'test', 'human')))
  training <- responses[responses$split == 'train', ]
  testing <- responses[responses$split == 'test', ]
  if (!nrow(training) || !nrow(testing)) stop('Original training and test assignments are required.')
  tokenizer <- layer_text_vectorization(max_tokens = 10000, output_mode = 'int', output_sequence_length = 22)
  adapt(tokenizer, training$text)
  encode <- function(text) tokenizer(as.array(text))
  model <- open_response_model(dense_activation)
  model |> compile(optimizer = optimiser, loss = 'sparse_categorical_crossentropy', metrics = 'accuracy')
  model |> fit(encode(training$text), training$level, epochs = epochs, batch_size = batch_size)
  model |> evaluate(encode(testing$text), testing$level)
}

plot_word_cloud <- function(text, stopwords, colours, max_words, min_frequency) {
  words <- unlist(strsplit(tolower(text), '[^[:alpha:]]+'))
  words <- words[nzchar(words) & !words %in% stopwords]
  frequencies <- sort(table(words), decreasing = TRUE)
  wordcloud::wordcloud(names(frequencies), as.numeric(frequencies), min.freq = min_frequency,
                       max.words = max_words, random.order = FALSE, colors = colours)
}
