# Data

`analysis_data.csv` contains all 174 recovered response patterns, the 27 scored items and the variables used in the analyses. Each item is coded 0 for an incorrect answer and 1 for a correct answer. The total is the sum of the 27 items.

The age field has one missing value because the original response was text. Gender, education and training groups use English labels. Timestamps, comments, answer text and the free-text degree field are omitted.

The original file can be processed again with:

```bash
Rscript R/create_analysis_dataset.R path/to/original.csv
```

The script checks that every item score is 0 or 1 and that the item scores sum to the exported total score. Training groups are reconstructed from psychology, nursing and medicine terms in the degree field.
