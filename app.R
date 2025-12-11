# -----------------------------------------------------------------------------
# Archivo: app.R
# -----------------------------------------------------------------------------

# 1. Cargar Librerías
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(haven) 
library(readr) # Necesario para leer CSV
library(survey)
library(plotly)
library(DT)

# 2. Cargar recursos externos
source("tabla variables.R")
source("functions.R")
# =============================================================================
#  INTERFAZ DE USUARIO (UI)
# =============================================================================
ui <- dashboardPage(
  
  dashboardHeader(title = "Evaluación Final - Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Contexto y Datos", tabName = "contexto", icon = icon("info-circle")),
      menuItem("1. Estadística Descriptiva", tabName = "descriptivo", icon = icon("chart-bar")),
      menuItem("2. Inferencia Básica", tabName = "inferencia", icon = icon("calculator"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # === Pestaña 1: Contexto ===
      tabItem(
        tabName = "contexto",
        h2("Contexto del Problema y Preguntas"),
        fluidRow(
          box(
            title = "Descripción del Fenómeno", status = "primary", solidHeader = TRUE, width = 6,
            p("En Chile, la brecha salarial es un tópico que ha ganado relevancia...")
            # (He resumido el texto por espacio, pero aquí va tu texto original completo)
          ),
          box(
            title = "Preguntas a Responder", status = "primary", solidHeader = TRUE, width = 6,
            strong("¿Cómo ha evolucionado la brecha de ingresos...?")
          ),
          box(
            title = "Lista de variables a utilizar", status = "primary", solidHeader = TRUE, width = 12,
            tableOutput("tabla_libro_codigos")
          )
        )
      ),
      
      # === Pestaña 2: Descriptiva ===
      tabItem(
        tabName = "descriptivo",
        h2("📊 Análisis Descriptivo"),
        fluidRow(
          box(
            title = "Gráficos Exploratorios Interactivos", status = "warning", width = 8,
            plotlyOutput("grafico_principal", height = "450px") # <--- AQUI LA MAGIA
          ),
          box(
            title = "Filtros y Resumen", status = "warning", width = 4,
            selectInput("filtro_sexo", "Seleccionar Sexo:", choices = c("Ambos", "Hombre", "Mujer")),
            p("Tabla resumen de datos cargados:"),
            tableOutput("resumen_datos")
          )
        ),
        fluidRow(
          box(title = "Resultados Estáticos (Imágenes)", width = 12, collapsed = TRUE, collapsible = TRUE,
              p("Tus imágenes originales..."),
              tags$div(style = "text-align: center;", img(src = "recursos/T1S.png", width = "50%"))
          )
        )
      ),
      
      # === Pestaña 3: Inferencia ===
      tabItem(tabName = "inferencia", h2("Inferencia Básica"))
    )
  )
)

# =============================================================================
# 5. SERVIDOR (SERVER)
# =============================================================================
server <- function(input, output, session) {
  
  # Añadir ruta de recursos para imágenes
  addResourcePath(prefix = 'recursos', directoryPath = 'www')
  
  # Renderizar tabla de códigos
  output$tabla_libro_codigos <- renderTable({
    df_codigos
  })
  
  # Renderizar Gráfico Interactivo usando la base unificada 'df_final'
  output$grafico_principal <- renderPlotly({
    
    # Filtrar datos según input (si es necesario)
    data_plot <- df_final
    if(input$filtro_sexo != "Ambos") {
      data_plot <- data_plot %>% filter(sexo == input$filtro_sexo)
    }
    
    # Crear gráfico
    g <- ggplot(data_plot, aes(x = anio, y = yoprcoripc, fill = sexo)) +
      geom_boxplot() +
      scale_y_continuous(labels = scales::dollar_format()) +
      coord_cartesian(ylim = c(0, quantile(df_final$yoprcoripc, 0.95, na.rm=TRUE))) +
      labs(title = "Evolución del Ingreso Corregido", x = "Año", y = "Ingreso ($)") +
      theme_minimal()
    
    ggplotly(g) %>% layout(boxmode = "group")
  })
  
  # Tabla resumen simple
  output$resumen_datos <- renderTable({
    df_final %>% 
      group_by(anio, sexo) %>% 
      summarise(Media_Ingreso = mean(yoprcoripc, na.rm = TRUE), .groups = 'drop')
  })
}

# 6. Ejecutar App
shinyApp(ui = ui, server = server)