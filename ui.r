# Cargar librerías necesarias
library(here)
library(kableExtra)
library(ggthemes)
library(ggrepel)
library(ggridges)
#analisis
library(ggpubr)
library(easystats) # multiples unciones analiticas
library(sf)
library(tidyverse, quietly = TRUE)
library(modelsummary)
library(terra) # replace raster
library(TropFishR)
library(mixR)
library(readxl)
library(shiny)
library(gt)


# Datos de ejemplo lfq (reemplazar por tus datos)
# Restore the object
lfq <- read_excel(here("DATA",
                      "BD_lfd_crec_salinas.xlsx"),
                 sheet="TropFish")

# Definir parámetros iniciales para Simulated Annealing (SA)
low_par <- list(Linf = 7.0, K = 0.1, t_anchor = 0, C = 0, ts = 0)
up_par <- list(Linf = 8.0, K = 0.9, t_anchor = 1, C = 1, ts = 1)
init_par <- list(Linf = 7.5, K = 0.5, t_anchor = 0.5, C = 0.5, ts = 0.5)

# Definir la interfaz de usuario (UI)
ui <- fluidPage(
  titlePanel("ELEFAN con Simulated Annealing (SA)"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("agemax",
                  "Edad máxima (agemax):",
                  min = 1,  # valor mínimo para agemax
                  max = 30,  # valor máximo para agemax
                  value = 20), # valor inicial
      actionButton("run", "Ejecutar ELEFAN_SA")
    ),
    
    mainPanel(
      plotOutput("plotELEFAN_SA"),  # Gráfico de resultados de ELEFAN_SA
      gt_output("resultTable")  # Tabla de resultados con gt
    )
  )
)

