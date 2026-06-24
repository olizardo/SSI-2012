# clean_data.R
# This script cleans the raw SSI-2012 dataset by keeping only the core variables,
# removing all redundant recoded variables, interaction terms, centered variables,
# and complex mathematically constructed indices.
# It exports the final dataset into multiple formats for broad accessibility.

library(haven)
library(tidyverse)

cat("--- Starting Data Cleaning and Reorganization ---\n")

# 1. Load the raw Stata dataset
raw_data <- read_dta("data/raw/SSI2012.dta")
cat("Loaded raw dataset with", nrow(raw_data), "rows and", ncol(raw_data), "columns.\n")

# 2. Define the core variables to keep
# These represent the main raw questionnaire responses from the survey.
demographics <- c(
  "id", "finished", "age", "female", "region", "raceeth", "smartphone", 
  "nodipdeg", "hsged", "somcol", "aadeg", "bach", "ma", "docprof", 
  "socloc", "major", "parented", "empstat", "occ", "income", "percclass",
  "asian", "black", "hisp", "white", "multirace", "otherrace",
  "lower", "working", "middle", "high"
)

experimental <- c(
  "taste1", "similarity", "siminf", "taste2", 
  "alterjob", "altered", "alterclass", "altertaste", "control", "alterlike",
  "surprise"
)

# The 20 genres surveyed in the project
genres <- c(
  "classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold", "country", 
  "blueg", "folk", "hymgos", "latspsal", "raphiphop", "blurb", "reggae", "toppop", 
  "controck", "indalt", "danclub", "hvymtl"
)

music_tastes <- c(
  paste0(genres, "taste"), 
  paste0(genres, "lis"), 
  "nonelis", "favgen"
)

# 16 typical fan characteristics checked for each of the 20 genres
characteristics <- c(
  "female", "male", "white", "black", "hisp", "asian", "grad", "nocol", 
  "young", "midage", "old", "lc", "wc", "mc", "uc", "none"
)

typical_fans <- c()
for (g in genres) {
  for (ch in characteristics) {
    typical_fans <- c(typical_fans, paste0(g, ch))
  }
}

final_variable_list <- c(demographics, experimental, music_tastes, typical_fans)

# 3. Filter dataset to keep only these core variables
cleaned_data <- raw_data |> 
  select(all_of(final_variable_list))

cat("Filtered dataset to", ncol(cleaned_data), "core variables.\n")

# 4. Save native R RDS format (preserves haven_labelled class and Stata attributes)
saveRDS(cleaned_data, "data/clean/ssi2012_cleaned.rds")
cat("Saved cleaned dataset in RDS format: data/clean/ssi2012_cleaned.rds\n")

# 5. Save Stata DTA format (preserving Stata variable and value labels)
write_dta(cleaned_data, "data/clean/ssi2012_cleaned.dta")
cat("Saved cleaned dataset in Stata format: data/clean/ssi2012_cleaned.dta\n")

# 6. Save SPSS SAV format (preserving variable and value labels)
write_sav(cleaned_data, "data/clean/ssi2012_cleaned.sav")
cat("Saved cleaned dataset in SPSS format: data/clean/ssi2012_cleaned.sav\n")

# 7. Save Coded CSV format (categorical columns as raw numeric codes)
# This version writes the raw numeric values for categorical variables.
write_csv(cleaned_data, "data/clean/ssi2012_cleaned_coded.csv")
cat("Saved cleaned coded CSV format: data/clean/ssi2012_cleaned_coded.csv\n")

# 8. Save Descriptive CSV format (categorical columns converted to text labels)
# This version is highly self-documenting and user-friendly for non-programmers.
# We convert all haven_labelled columns to standard R factors so they write as text.
descriptive_data <- cleaned_data |> 
  mutate(across(where(is.labelled), as_factor))

write_csv(descriptive_data, "data/clean/ssi2012_cleaned.csv")
cat("Saved cleaned descriptive CSV format: data/clean/ssi2012_cleaned.csv\n")

cat("--- Data Cleaning and Export Completed Successfully ---\n")
