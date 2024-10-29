### Project: Life History Parameter Estimation of *Ostrea edulis*

This repository contains data and code related to the estimation of life history parameters for *Ostrea edulis*. The data comes from an experiment conducted by the Spanish Institute of Oceanography (IEO) of Murcia, in collaboration with the IEO of Cádiz.

### Repository Structure

- Main directory

- `DATA/`: Contains all raw and processed data from the experiment.
  - `BD_lfd_crec_salinas.xlsx`: The raw experimental data w/ length frecuencies.
  - `Datos ostras.doc`: Data with most relevant information about life history of *O. edulis*.
  - This folder is private by right permission on data

- `scripts/`: Contains all the R scripts used for data analysis and parameter estimation.
  - `ui.r` and `server.r`:  Initial conditioning for a Shiny App based on testing key parameters such as maximum Age and their impact on LH parameter calculation in *O. edulis*
  - `data_cleaning.R`: Script for cleaning and processing raw data.
  - `parameter_estimation.R`: Main script for estimating life history parameters (growth rates, age, mortality, etc.).
  
- `results/`: Not included yet.
  - two files `.Rdata` with result objetc from ELEFEAN analysis
  
- `Figs/`: 
  - main captions and figures used in `index.Rmd` files
  
  
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
install.packages(c("tidyverse", "kableExtra", "ggplot2", "nlme" "TropfishR"))
```

### How to Use

1. Clone the repository:

   ```bash
   git clone https://github.com/username/repository.git
   ```
   
2. Load the `data_cleaning.R` script to preprocess the raw data.
3. Run the `index.Rmd` script to estimate life history parameters.

### Results

Principal outpus and results can be found in this link: [Parameters Ostrea edulis](https://mauromardones.github.io/ReSalar_Project_IEO/)

### Authors and Acknowledgments

This project was conducted by researchers from the IEO of Murcia and IEO of Cádiz. We thank all participants and collaborators for their contributions.

