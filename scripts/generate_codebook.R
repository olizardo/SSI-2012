# generate_codebook.R
# This script extracts detailed metadata (names, descriptive labels, types, 
# category codes, and missingness statistics) from the cleaned dataset 
# and exports a structured data dictionary for the Quarto website.

library(tidyverse)

cat("--- Starting Metadata Extraction for Codebook ---\n")

# 1. Load the cleaned R dataset
df <- readRDS("data/clean/ssi2012_cleaned.rds")
cat("Loaded cleaned dataset with", nrow(df), "rows and", ncol(df), "columns.\n")

# List of genres and characteristics for auto-labeling typical fans
genres <- c(
  "classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold", "country", 
  "blueg", "folk", "hymgos", "latspsal", "raphiphop", "blurb", "reggae", "toppop", 
  "controck", "indalt", "danclub", "hvymtl"
)
characteristics <- c(
  "female", "male", "white", "black", "hisp", "asian", "grad", "nocol", 
  "young", "midage", "old", "lc", "wc", "mc", "uc", "none"
)

# Helper function to auto-generate nice labels for typical fan variables
get_genre_char_label <- function(col_name) {
  for (g in genres) {
    if (str_starts(col_name, g)) {
      char_part <- str_remove(col_name, g)
      if (char_part %in% characteristics) {
        char_clean <- switch(char_part,
          "lc" = "lower class",
          "wc" = "working class",
          "mc" = "middle class",
          "uc" = "upper class",
          "grad" = "college graduate",
          "nocol" = "did not attend college",
          "midage" = "middle aged",
          "none" = "none of these",
          char_part
        )
        return(paste0("Typical ", str_to_title(g), " music fans: ", char_clean))
      }
    }
  }
  return(NULL)
}

# 2. Extract metadata for each variable
extract_metadata <- function(col_name, col_data) {
  # Retrieve or construct the label
  lbl <- attr(col_data, "label")
  lbl_str <- if (is.null(lbl) || length(lbl) == 0) "" else paste(lbl, collapse = " | ")
  
  # Auto-fill typical fan labels
  fan_label <- get_genre_char_label(col_name)
  if (!is.null(fan_label)) {
    lbl_str <- fan_label
  }
  
  # Enrich other empty or poorly labeled variables
  if (col_name == "id") lbl_str <- "Respondent Unique Identifier"
  if (col_name == "finished") lbl_str <- "Survey finished status (0 = No, 1 = Yes)"
  if (col_name == "control") lbl_str <- "Control group experimental ID"
  if (col_name == "alterlike") lbl_str <- "Experimental Condition: reference group liked (1) or disliked (0) the painting"
  
  if (col_name == "asian") lbl_str <- "Race/Ethnicity: Asian (0 = No, 1 = Yes)"
  if (col_name == "black") lbl_str <- "Race/Ethnicity: Black (0 = No, 1 = Yes)"
  if (col_name == "hisp") lbl_str <- "Race/Ethnicity: Hispanic (0 = No, 1 = Yes)"
  if (col_name == "white") lbl_str <- "Race/Ethnicity: White (0 = No, 1 = Yes)"
  if (col_name == "multirace") lbl_str <- "Race/Ethnicity: More than one race (0 = No, 1 = Yes)"
  if (col_name == "otherrace") lbl_str <- "Race/Ethnicity: Other race (0 = No, 1 = Yes)"
  
  if (col_name == "lower") lbl_str <- "Self-described Class: Lower class (0 = No, 1 = Yes)"
  if (col_name == "working") lbl_str <- "Self-described Class: Working class (0 = No, 1 = Yes)"
  if (col_name == "middle") lbl_str <- "Self-described Class: Middle class (0 = No, 1 = Yes)"
  if (col_name == "high") lbl_str <- "Self-described Class: Upper class (0 = No, 1 = Yes)"
  
  # Determine Data Type
  cl <- class(col_data)
  type_str <- if ("haven_labelled" %in% cl) {
    "Categorical (Labelled)"
  } else if ("numeric" %in% cl || "double" %in% cl || "integer" %in% cl) {
    "Numeric"
  } else if ("character" %in% cl) {
    "Character (Text)"
  } else {
    paste(cl, collapse = ", ")
  }
  
  # For typical fan variables, list 0 = No; 1 = Yes
  if (!is.null(fan_label)) {
    type_str <- "Binary Indicator (0/1)"
  }
  
  # Categories and Range
  val_labels <- attr(col_data, "labels")
  val_str <- ""
  if (!is.null(val_labels) && length(val_labels) > 0) {
    # Sort value labels by their code number
    sorted_idx <- order(as.numeric(val_labels))
    sorted_labels <- val_labels[sorted_idx]
    val_str <- paste(names(sorted_labels), sorted_labels, sep = " = ", collapse = "; ")
  } else if (!is.null(fan_label) || col_name %in% c("asian", "black", "hisp", "white", "multirace", "otherrace", "lower", "working", "middle", "high")) {
    val_str <- "0 = No; 1 = Yes"
  } else if (is.numeric(col_data)) {
    r <- range(col_data, na.rm = TRUE)
    if (!is.infinite(r[1])) {
      val_str <- paste0("Range: ", r[1], " to ", r[2])
    }
  } else if (is.character(col_data)) {
    val_str <- "Free text responses"
  }
  
  # Missingness stats
  missing_n <- sum(is.na(col_data))
  non_missing_n <- sum(!is.na(col_data))
  missing_pct <- round(missing_n / length(col_data) * 100, 2)
  
  tibble(
    Variable = col_name,
    Label = lbl_str,
    Type = type_str,
    Categories = val_str,
    Valid_N = non_missing_n,
    Missing_N = missing_n,
    Missing_Pct = missing_pct
  )
}

# 3. Compile metadata for all variables in the dataset
codebook_metadata <- map2_df(names(df), df, extract_metadata)

# 4. Save metadata in RDS and CSV formats
saveRDS(codebook_metadata, "data/clean/ssi2012_codebook_metadata.rds")
write_csv(codebook_metadata, "data/clean/ssi2012_codebook_metadata.csv")

cat("Generated data dictionary with info for", nrow(codebook_metadata), "variables.\n")
cat("Saved codebook metadata: data/clean/ssi2012_codebook_metadata.rds & data/clean/ssi2012_codebook_metadata.csv\n")
cat("--- Metadata Extraction Completed Successfully ---\n")
