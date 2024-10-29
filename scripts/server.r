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
  # Gráfico de frecuencias de tallas por fechas
  output$freqPlot <- renderPlot({
    ggplot(lfq, aes(x = size, y = factor(Date))) +
      geom_density_ridges(stat = "binline", bins = 30, 
                          scale = 1.2, 
                          draw_baseline = TRUE,
                          alpha = 0.5,
                          fill = "blue") + 
      theme_few() +
      theme(
        legend.position = "none",
        axis.text = element_text(angle = 90)
      ) +
      labs(title = "Distribuciones de Tallas durante el periodo analizado") +
      xlab("Length (mm.)") +
      ylab("") +
      coord_flip()
  })
  
  # Ejecutar ELEFAN_SA cuando se presiona el botón
  observeEvent(input$run, {
    # Obtener los parámetros configurados por el usuario
    init_par <- list(Linf = input$init_Linf, 
                     K = input$init_K, 
                     t_anchor = input$init_t_anchor, 
                     C = input$init_C, 
                     ts = input$init_ts)
    low_par <- list(Linf = input$Linf_range[1],
                    K = input$K_range[1], 
                    t_anchor = input$t_anchor_range[1], 
                    C = input$C_range[1], 
                    ts = input$ts_range[1])
    up_par <- list(Linf = input$Linf_range[2], 
                   K = input$K_range[2], 
                   t_anchor = input$t_anchor_range[2],
                   C = input$C_range[2], 
                   ts = input$ts_range[2])
    
    # Ejecutar ELEFAN_SA con los parámetros configurados por el usuario
    res_SA <- ELEFAN_SA(
      lfq = lfq1,
      SA_time = 60 * 0.5,
      MA = 5,
      agemax = as.numeric(input$agemax),
      seasonalised = TRUE,
      addl.sqrt = FALSE,
      init_par = init_par,
      low_par = low_par,
      up_par = up_par,
      plot = FALSE,
      plot.score = TRUE
    )
    
    # Mostrar gráfico de resultados de ELEFAN_SA
    output$plotELEFAN_SA <- renderPlot({
      plot(res_SA)
    })
    
    # Crear curva de crecimiento de Von Bertalanffy con ggplot2
    output$growthCurve <- renderPlot({
      ages <- seq(0, as.numeric(input$agemax), length.out = 50)
      Linf <- res_SA$par$Linf
      K <- res_SA$par$K
      t0 <- res_SA$par$t_anchor
      lengths <- Linf * (1 - exp(-K * (ages - t0)))
      
      growth_data <- data.frame(Age = ages, Length = lengths)
      
      ggplot(growth_data, aes(x = Age, y = Length)) +
        geom_line(color = "blue", size = 1) +
        labs(title = "Curva de Crecimiento de Von Bertalanffy",
             x = "Edad",
             y = "Longitud") +
        theme_minimal()
    })
    
    # Crear tabla con gt
    output$resultTable <- render_gt({
      result_data <- data.frame(
        Metric = c("ncohort", "agemax", "Linf", "K", "t_anchor", "C", "ts", "phiL", "fESP", "Rn_max"),
        Value = c(
          res_SA$ncohort,
          res_SA$agemax,
          res_SA$par$Linf,
          res_SA$par$K,
          res_SA$par$t_anchor,
          res_SA$par$C,
          res_SA$par$ts,
          res_SA$par$phiL,
          res_SA$fESP,
          res_SA$Rn_max
        )
      )
      
      # Generar la tabla con gt
      gt(result_data) %>%
        tab_header(
          title = "Resultados de ELEFAN_SA"
        ) %>%
        cols_label(
          Metric = "Parámetro",
          Value = "Estimado"
        )
    })
    
    # Guardar los resultados en una variable reactiva
    resultados_csv <- reactive({
      result_data %>% mutate(agemax = input$agemax)
    })
    
    # Descargar tabla de resultados como CSV
    output$downloadCSV <- downloadHandler(
      filename = function() {
        paste("resultados_agemax_", input$agemax, ".csv", sep = "")
      },
      content = function(file) {
        # Datos para el archivo CSV, en este caso obtenidos de resultTable
        result_data <- data.frame(
          Metric = c("ncohort", "agemax", "Linf", "K", "t_anchor", "C", "ts", "phiL", "fESP", "Rn_max"),
          Value = c(
            res_SA$ncohort,
            res_SA$agemax,
            res_SA$par$Linf,
            res_SA$par$K,
            res_SA$par$t_anchor,
            res_SA$par$C,
            res_SA$par$ts,
            res_SA$par$phiL,
            res_SA$fESP,
            res_SA$Rn_max
          )
        )
        # Guardar en el archivo CSV
        write.csv(result_data, file, row.names = FALSE)
      },
      contentType = "text/csv"
    )
  })
}