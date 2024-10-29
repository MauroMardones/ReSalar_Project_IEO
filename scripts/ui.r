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
lfq <- read_excel(here::here("DATA",
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
  titlePanel("Estimación de parámetros de O. edulis en distintos escenarios condicionados a la edad max y otros"),
  tags$style(HTML("
    .sidebar-panel { font-size: 10px; padding: 10px; width: 250px !important; }
    .well-panel { font-size: 12px; padding: 5px; margin-bottom: 12px; width: 100% !important; }
    .btn { padding: 5px 10px; font-size: 12px; }
  ")),
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar-panel",
      width = 3,  # Ajustar el ancho del sidebar (de 2 a 4 es un rango pequeño)
      
      # Configuración de Parámetros Iniciales
      h4("Inicialización de Parámetros"),
      wellPanel(
        class = "well-panel",
        sliderInput("init_Linf", "Linf", min = 7.0, max = 8.0, value = init_par$Linf),
        sliderInput("init_K", "K", min = 0.1, max = 0.9, value = init_par$K),
        sliderInput("init_t_anchor", "t_anchor", min = 0, max = 1, value = init_par$t_anchor),
        sliderInput("init_C", "C", min = 0, max = 1, value = init_par$C),
        sliderInput("init_ts", "ts", min = 0, max = 1, value = init_par$ts)
      ),
      
      # Configuración de Límites Inferiores y Superiores
      h4("Límites Inferiores y Superiores"),
      wellPanel(
        class = "well-panel",
        sliderInput("Linf_range", "Linf", 
                    min = 7.0, max = 8.0, value = c(low_par$Linf, up_par$Linf)),
        sliderInput("K_range", "K", 
                    min = 0.1, max = 0.9, value = c(low_par$K, up_par$K)),
        sliderInput("t_anchor_range", "t_anchor", 
                    min = 0, max = 1, value = c(low_par$t_anchor, up_par$t_anchor)),
        sliderInput("C_range", "C", 
                    min = 0, max = 1, value = c(low_par$C, up_par$C)),
        sliderInput("ts_range", "ts", 
                    min = 0, max = 1, value = c(low_par$ts, up_par$ts))
      ),
      
      # Configuración de agemax
      h4("Edad Máxima (agemax)"),
      wellPanel(
        class = "well-panel",
        selectInput("agemax", "Edad máxima:", choices = 1:30, selected = 20)
      ),
      
      # Botón para ejecutar ELEFAN_SA
      actionButton("run", "Ejecutar ELEFAN_SA", class = "btn btn-primary")
    ),
    
    # Panel principal para mostrar resultados
    mainPanel(
      # Descripción del método
      tags$div(
        tags$h4("Descripción del Método ELEFAN con Simulated Annealing (SA)"),
        tags$p("Este método usa Simulated Annealing para ajustar los parámetros del modelo ELEFAN, 
               permitiendo estimar parámetros de crecimiento como Linf y K, junto con parámetros 
               estacionales C y ts. Es útil en estudios de dinámica poblacional para comprender 
               patrones de crecimiento en poblaciones marinas."),
        h5(p("Para acceder al codigo autocontenido de este análisis y mas, visitar " ,tags$a(href="https://mauromardones.github.io/ReSalar_Project_IEO/", "Link", target="_blank"))),
        h5(p("Para acceder al repositorio y datos utilizados, visitar " ,tags$a(href="https://github.com/MauroMardones/ReSalar_Project_IEO", "Repositorio", target="_blank"))),
        tags$hr()  # Línea divisoria para separar la descripción del contenido siguiente
      ),
      # Outputs
      plotOutput("freqPlot"), 
      plotOutput("plotELEFAN_SA"),
      plotOutput("growthCurve"),
      gt_output("resultTable")
    )
  )
)
