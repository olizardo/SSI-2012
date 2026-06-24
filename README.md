# Survey Sample International 2012 (SSI-2012) Cultural Tastes Dataset

[![Quarto Website](https://img.shields.io/badge/Quarto-Website-blue?logo=quarto)](https://omarlizardo.github.io/SSI-2012/)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

A clean, documented, and public-ready dataset of American cultural tastes, social demographics, and aesthetic perceptions collected by **Omar Lizardo** (UCLA) and **Sara Skiles** in 2012.

This repository hosts the cleaned dataset in multiple formats, the automated metadata codebook generator, and the source files for the project's Quarto documentation website.

---

## 📁 Repository Layout

The repository is structured following best practices for reproducibility, separating raw source data, processing scripts, cleaned data exports, and website source files:

```text
SSI-2012/
├── .gitignore                    # Ignore temporary cache and local IDE files
├── .nojekyll                     # Directs GitHub Pages to bypass Jekyll processing
├── LICENSE                       # Creative Commons Attribution 4.0 International License
├── README.md                     # This documentation file
├── data/
│   ├── raw/                      # Raw, unaltered source data
│   │   └── SSI2012.dta           # Original Stata dataset (15.4 MB, 1,218 variables)
│   └── clean/                    # Cleaned and properly labeled distribution files
│       ├── ssi2012_cleaned.csv   # Self-Documenting CSV (categorical as descriptive text)
│       ├── ssi2012_cleaned_coded.csv # Coded CSV (categorical as numeric codes)
│       ├── ssi2012_cleaned.rds   # R RDS format (preserves labels and classes)
│       ├── ssi2012_cleaned.dta   # Stata DTA dataset (with embedded labels)
│       ├── ssi2012_cleaned.sav   # SPSS SAV dataset (with embedded labels)
│       ├── ssi2012_codebook_metadata.csv # Auto-extracted variable metadata (CSV)
│       └── ssi2012_codebook_metadata.rds # Auto-extracted variable metadata (RDS)
├── scripts/
│   ├── clean_data.R              # R script to clean variables and export formats
│   └── generate_codebook.R       # R script to auto-generate the metadata dictionary
├── website/                      # Quarto website source files
│   ├── _quarto.yml               # Quarto configuration (theme, navbar, docs/ output path)
│   ├── index.qmd                 # Homepage source
│   ├── codebook.qmd              # Searchable, interactive codebook page
│   ├── download.qmd              # Download links and quick-start loading snippets
│   ├── explore.qmd               # Exploratory data visualizations
│   └── styles.css                # Custom styling for the website
└── docs/                         # Rendered Quarto website (served by GitHub Pages)
    ├── index.html
    ├── codebook.html
    ├── download.html
    ├── explore.html
    └── ...
```

---

## 📊 Dataset Scope & Variables

The original dataset contained 1,218 variables, many of which were temporary draft analyses, product interactions, and publication-specific indices. 

The cleaned dataset filters this down to **404 core variables** representing the raw questionnaire items:

1. **Social Demographics** (31 variables): Age, Gender, Census Region, Race/Ethnicity (categorical and binary indicators), Education degrees, Parents' college status, Employment status, Occupation, Income, and Subjective Social Class.
2. **Experimental Variables** (11 variables): Initial painting taste rating (`taste1`), perceived similarity to reference group (`similarity`), influential factors (`siminf`), final painting rating (`taste2`), experimental group assignment indicator (`control`), and manipulation check variables.
3. **Music Tastes** (42 variables): Ordinal taste ratings (1–4 scale) for **20 genres**, monthly listening history indicators (0/1) for all 20 genres, and overall favorite genre.
4. **Typical Fan Stereotypes** (320 variables): A complete grid (20 genres × 16 characteristics) indicating whether the respondent thinks the typical fans of each genre are female, male, white, black, college graduates, working-class, young, old, etc.

*Note: Missing value codes have been systematically audited. Missing values are strongly correlated with survey incompletion (`finished == 0`).*

---

## 🛠️ Reproducing the Pipeline

If you want to modify the cleaning process or re-extract the codebook metadata, you can run the R scripts inside the `scripts/` folder:

```bash
# 1. Clean the raw data and export into five major formats
Rscript scripts/clean_data.R

# 2. Extract variable metadata and compile the data dictionary
Rscript scripts/generate_codebook.R
```

---

## 🌐 Building and Compiling the Website

The website is authored in Quarto and compiled into the `docs/` folder in the repository root (making it immediately compatible with GitHub Pages):

1. **Prerequisites**: Install [Quarto CLI](https://quarto.org/docs/get-started/) and the R packages `tidyverse` and `haven`.
2. **Preview the site locally**:
   ```bash
   quarto preview website
   ```
3. **Build/Render the site**:
   ```bash
   quarto render website
   ```
   This will update all compiled HTML, CSS, and interactive codebook files inside the `docs/` folder.

---

## 🚀 Setting Up Publishing via GitHub Pages

To host and publish this Quarto website for free via **GitHub Pages**, follow these simple steps once you push this repository to GitHub:

### Step 1: Create Your GitHub Repository
1. Initialize a git repository locally:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: clean dataset, scripts, and website"
   ```
2. Create a new repository on GitHub named `SSI-2012`.
3. Link and push your local commits to GitHub:
   ```bash
   git remote add origin https://github.com/YOUR_GITHUB_USERNAME/SSI-2012.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Configure GitHub Pages Settings
1. Go to your repository page on GitHub.
2. Click on the **Settings** tab at the top.
3. In the left-hand sidebar, scroll down to the *Code and automation* section and click on **Pages**.
4. Under **Build and deployment**:
   * Set **Source** to `Deploy from a branch`.
   * Under **Branch**:
     * Select `main` (or `master`) from the dropdown.
     * Select `/docs` from the folder dropdown (this directs GitHub to serve the compiled website from our `docs/` folder instead of the root).
5. Click **Save**.

### Step 3: Access Your Website!
Within 1–2 minutes, GitHub will build and host your site. You can access it at:
`https://YOUR_GITHUB_USERNAME.github.io/SSI-2012/`

*(Any future updates you commit and push to the `docs/` folder of the `main` branch will automatically update on the live website!)*

---

## 📝 Citation Guide

If you use this dataset or codebook in a research paper, presentation, or project, please cite it as follows:

```text
Lizardo, Omar, and Sara Skiles. 2012. Survey Sample International (SSI) Cultural Tastes Survey. [Dataset].
```

---

## ⚖️ License

The dataset, metadata, and code are distributed under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.
