### Project: Life History Parameter Estimation of *Ostrea edulis*

This repository contains data and code related to the estimation of life history parameters for *Ostrea eulisa*. The data comes from an experiment conducted by the Spanish Institute of Oceanography (IEO) of Murcia, in collaboration with the IEO of Cádiz.

### Repository Structure

- `DATA/`: Contains all raw and processed data from the experiment.
  - `raw_data.csv`: The raw experimental data.
  - `processed_data.csv`: Data cleaned and processed for analysis.

- `scripts/`: Contains all the R scripts used for data analysis and parameter estimation.
  - `data_cleaning.R`: Script for cleaning and processing raw data.
  - `parameter_estimation.R`: Main script for estimating life history parameters (growth rates, age, mortality, etc.).
  
- `results/`: Includes output results, figures, and tables generated from the analyses.
  - `life_history_parameters.csv`: Final table with estimated parameters.
  - `figures/`: Graphs illustrating key results.
  
### Experiment Overview

The goal of the experiment was to estimate vital life history parameters (e.g., growth rates, mortality, and reproductive output) for the species *Ostrea eulisa* under controlled laboratory conditions. Data collected during the experiment includes individual size, age, and survival over time.

### Requirements

To run the scripts, ensure you have the following R packages installed:

- `tidyverse`
- `kableExtra`
- `ggplot2`
- `nlme`
- `TropfishR`

You can install all required packages by running:

```R
install.packages(c("tidyverse", "kableExtra", "ggplot2", "nlme"))
```

### How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/username/repository.git
   ```
2. Load the `data_cleaning.R` script to preprocess the raw data.
3. Run the `parameter_estimation.R` script to estimate life history parameters.

### Authors and Acknowledgments

This project was conducted by researchers from the IEO of Murcia and IEO of Cádiz. We thank all participants and collaborators for their contributions.

