# Analysis notes

The original tables keep the values printed in the thesis. The R results are calculated from the recovered CSV.

| Analysis | Settings used in R | Result |
|---|---|---|
| Numeric descriptives | Exclude the nonnumeric age and the primary education response; n = 172 | Anxiety and knowledge means and SDs match. Age mean is 27.92 rather than 27.94. Age SD rounds to 9.25 rather than 9.24. |
| Gender and education | Exclude primary education; n = 173 | Counts match Tables 4–5. Their original totals remain 172. |
| Anxiety interaction | Upper secondary, university and postgraduate groups; n = 167; sequential sums of squares | All F and p values match Table 6. |
| Health group | Psychology, nursing and medicine in the reported field of study | The original group coding was not saved. The reconstructed coding is kept in the dataset. Group-dependent results differ. |
| Parallel analysis | Pearson correlations, 95th percentile, 100 simulations, seed 123 | This calculation retains two components. The thesis retained three, which are used for the factor model. The original seed and simulation settings were not reported. |
| Exploratory factor analysis | Binary items as factors, `polycor::hetcor`, `factanal`, maximum likelihood, varimax; n = 174 | Variance proportions match Table 8. Small differences remain in loadings and sums of squares. |
| Total reliability | `psych::alpha`, all 27 items, n = 174 | Alpha, standardised alpha, Guttman and signal-to-noise ratio match Table 10. |
| Factor reliability | Item sets listed in Tables 12–14 | The original reliability item sets were not listed. Factors 1–2 differ from Table 10. |
| Item information | `ltm(items ~ z1)`, item sets in Tables 12–14 | The curves and item information values follow Figures 13–15. This fits different slopes, as shown in the original curves. The thesis calls this section Rasch. |
| Logistic biplot | Jaccard, two principal coordinates, unpenalised external logistic fits | Results are close to Table 11, with remaining differences. The original Figure 16 is preserved. |
| DFIT | Separate one-factor logistic fits by health group; standard normal ability distribution; cutoff .024 | The original group assignments and common-scale transformation were not saved. These results are reconstructed and differ from Tables 12–15. |
| Complete CFA | Table 16 membership, ML, n = 174 | CFI .807 and TLI .789 match. |
| Reduced CFA | Six candidate sets derived from the problem items named in the text | The text states six removals but does not identify the complete set. The reported reduced fit is retained in the original results. No candidate is labelled as the original model. |
| Open-ended questionnaire | Architecture from Table 17 | Response data, tokeniser, train/test assignments and training settings were not recovered. The original accuracy tables and word clouds are preserved. |

The original column labelled “composite reliability” contains `ase`, the standard error of alpha. That label is preserved in the original table; the R table uses `Alpha_SE`.

The original item 11 biplot entry reports p < .001 with deviance 8.93 and df = 2. The corresponding chi-squared p value is about .0115. The original value is preserved and the script exports the calculated p value.

Package documentation: [MultBiplotR](https://stat.ethz.ch/CRAN/web/packages/MultBiplotR/MultBiplotR.pdf), [DFIT NCDIF](https://search.r-project.org/CRAN/refmans/DFIT/html/Ncdif.html), [DFIT DTF](https://search.r-project.org/CRAN/refmans/DFIT/html/Dtf.html).
