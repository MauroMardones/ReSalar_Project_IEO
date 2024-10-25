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


#  Definir el servidor
server <- function(input, output) {
  
  # Ejecutar ELEFAN_SA cuando se presiona el botón
  observeEvent(input$run, {
    
    # Obtener los parámetros configurados por el usuario
    init_par <- list(Linf = input$init_Linf, K = input$init_K, t_anchor = input$init_t_anchor, C = input$init_C, ts = input$init_ts)
    low_par <- list(Linf = input$Linf_range[1], K = input$K_range[1], t_anchor = input$t_anchor_range[1], C = input$C_range[1], ts = input$ts_range[1])
    up_par <- list(Linf = input$Linf_range[2], K = input$K_range[2], t_anchor = input$t_anchor_range[2], C = input$C_range[2], ts = input$ts_range[2])
    
    # Ejecutar ELEFAN_SA con los parámetros configurados por el usuario
    res_SA_5 <- ELEFAN_SA(
      lfq = lfq,              # Usar tus datos
      SA_time = 60 * 0.5,     # Duración de Simulated Annealing
      MA = 5,                 # Media móvil
      agemax = as.numeric(input$agemax), # Usar agemax seleccionado
      seasonalised = TRUE,    # Estacionalidad activada
      addl.sqrt = FALSE,
      init_par = init_par,    # Valores iniciales personalizados
      low_par = low_par,      # Límites inferiores personalizados
      up_par = up_par,        # Límites superiores personalizados
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