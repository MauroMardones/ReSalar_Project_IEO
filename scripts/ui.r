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

lfq$Date <- as.Date(lfq$Date)
# Crear un objeto lfq para el ID actual
lfq <- lfqCreate(data = lfq,
                 Lname = "size",
                 Dname = "Date",
                 bin_size = 0.1,
                 length_unit = "mm",
                 Lmin = 0.8,
                 aggregate_dates=T)

# Definir valores iniciales de parámetros
low_par <- list(Linf = 7.0, K = 0.1, t_anchor = 0, C = 0, ts = 0)
up_par <- list(Linf = 8.0, K = 0.9, t_anchor = 1, C = 1, ts = 1)
init_par <- list(Linf = 7.5, K = 0.5, t_anchor = 0.5, C = 0.5, ts = 0.5)

# Definir la interfaz de usuario (UI)
ui <- fluidPage(
  titlePanel("ELEFAN con Simulated Annealing (SA) to Ostrea edulis in Minor Sea"),
  
  # Estilos para hacer más compactos los elementos
  tags$style(HTML("
    .sidebar { width: 250px !important; padding: 5px; }
    .well { padding: 10px; margin: 5px 0; }
    .shiny-input-container { margin-bottom: 5px; }
    .main-panel { padding: 10px; }
  ")),
  
  # Crear layout principal
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",
      
      # Configuración de Parámetros Iniciales
      h3("Configuración de Parámetros"),
      wellPanel(
        h4("Inicialización de Parámetros"),
        sliderInput("init_Linf", "Linf", min = 7.0, max = 8.0, value = init_par$Linf),
        sliderInput("init_K", "K", min = 0.1, max = 0.9, value = init_par$K),
        sliderInput("init_t_anchor", "t_anchor", min = 0, max = 1, value = init_par$t_anchor),
        sliderInput("init_C", "C", min = 0, max = 1, value = init_par$C),
        sliderInput("init_ts", "ts", min = 0, max = 1, value = init_par$ts)
      ),
      
      # Configuración de Límites Inferiores y Superiores
      wellPanel(
        h4("Límites Inferiores y Superiores"),
        # Linf
        sliderInput("Linf_range", "Linf", 
                    min = 7.0, max = 8.0, value = c(low_par$Linf, up_par$Linf), 
                    step = 0.1, pre = "Linf: "),
        # K
        sliderInput("K_range", "K", 
                    min = 0.1, max = 0.9, value = c(low_par$K, up_par$K), 
                    step = 0.01, pre = "K: "),
        # t_anchor
        sliderInput("t_anchor_range", "t_anchor", 
                    min = 0, max = 1, value = c(low_par$t_anchor, up_par$t_anchor), 
                    step = 0.1, pre = "t_anchor: "),
        # C
        sliderInput("C_range", "C", 
                    min = 0, max = 1, value = c(low_par$C, up_par$C), 
                    step = 0.1, pre = "C: "),
        # ts
        sliderInput("ts_range", "ts", 
                    min = 0, max = 1, value = c(low_par$ts, up_par$ts), 
                    step = 0.1, pre = "ts: ")
      ),
      
      # Configuración de agemax
      wellPanel(
        h4("Edad Máxima (agemax)"),
        selectInput("agemax", "Edad máxima:", choices = 1:30, selected = 20)
      ),
      
      # Botón para ejecutar ELEFAN_SA
      actionButton("run", "Ejecutar ELEFAN_SA")
    ),
    
    # Panel principal para mostrar resultados
    mainPanel(
      plotOutput("plotELEFAN_SA", height = "400px"),  # Gráfico de resultados de ELEFAN_SA
      gt_output("resultTable")  # Tabla de resultados con gt
    )
  )
)