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

# Definir parámetros iniciales para Simulated Annealing (SA)
low_par <- list(Linf = 7.0, K = 0.1, t_anchor = 0, C = 0, ts = 0)
up_par <- list(Linf = 8.0, K = 0.9, t_anchor = 1, C = 1, ts = 1)
init_par <- list(Linf = 7.5, K = 0.5, t_anchor = 0.5, C = 0.5, ts = 0.5)


# Definir el servidor
server <- function(input, output) {
  
  # Ejecutar ELEFAN_SA cuando se presiona el botón
  observeEvent(input$run, {
    
    # Ejecutar ELEFAN_SA con el agemax que selecciona el usuario
    res_SA_5 <- ELEFAN_SA(
      lfq = lfq,
      SA_time = 60 * 0.5,   # Duración de Simulated Annealing
      MA = 5,               # Media móvil
      agemax = input$agemax, # Usar el valor de entrada
      seasonalised = TRUE,   # Estacionalidad activada
      addl.sqrt = FALSE,
      init_par = init_par,   # Valores iniciales
      low_par = low_par,     # Límites inferiores
      up_par = up_par,       # Límites superiores
      plot = FALSE,
      plot.score = TRUE
    )
    
    # Mostrar gráfico de resultados de ELEFAN_SA
    output$plotELEFAN_SA <- renderPlot({
      plot(res_SA_5)
    })
    
    # Crear tabla con gt
    output$resultTable <- render_gt({
      result_data <- data.frame(
        Metric = c("ncohort", "agemax", "Linf", "K", "t_anchor", "C", "ts", "phiL", "fESP", "Rn_max"),
        Value = c(
          res_SA_5$ncohort,
          res_SA_5$agemax,
          res_SA_5$par$Linf,
          res_SA_5$par$K,
          res_SA_5$par$t_anchor,
          res_SA_5$par$C,
          res_SA_5$par$ts,
          res_SA_5$par$phiL,
          res_SA_5$fESP,
          res_SA_5$Rn_max
        )
      )
      
      # Generar la tabla con gt
      gt(result_data) %>%
        tab_header(
          title = "Resultados de ELEFAN_SA"
        ) %>%
        cols_label(
          Metric = "Métrica",
          Value = "Valor"
        )
    })
  })
}
