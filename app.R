# app.R

# 1. Cargar Librerías (¡Necesarias para usar dashboard!)
library(shiny)
library(shinydashboard)

# -----------------------------------------------------------------------------
# 2. Definición de la Interfaz de Usuario (UI)
# -----------------------------------------------------------------------------
ui <- dashboardPage(
  
  # a) Cabecera
  dashboardHeader(title = "Evaluación Final - Dashboard en Shiny"),
  
  # b) Barra Lateral (Sidebar)
  dashboardSidebar(
    sidebarMenu(
      # Pestañas de navegación
      menuItem("Contexto y Datos", tabName = "contexto", icon = icon("info-circle")),
      menuItem("1. Estadística Descriptiva", tabName = "descriptivo", icon = icon("chart-bar")),
      menuItem("2. Inferencia Básica", tabName = "inferencia", icon = icon("calculator"))
    )
    # Aquí puedes añadir los 'selectInput', 'sliderInput', etc.
  ),
  
  # c) Cuerpo del Dashboard (Body)
  dashboardBody(
    tabItems(
      
      # === Pestaña 1: Contexto (Requerimiento 2) ===
      tabItem(
        tabName = "contexto",
        h2("📖 Contexto del Problema y Preguntas"),
        
        fluidRow(
          box(
            title = "Descripción del Fenómeno", 
            status = "primary", 
            solidHeader = TRUE, 
            width = 6,
            p("Aquí va la explicación del fenómeno estudiado y el origen de los datos. [cite: 16, 17]")
          ),
          box(
            title = "Preguntas a Responder", 
            status = "primary", 
            solidHeader = TRUE, 
            width = 6,
            p("Aquí van las preguntas que se buscan responder con el análisis. [cite: 18]")
          )
        )
      ),
      
      # === Pestaña 2: Estadística Descriptiva (Requerimiento 3.a) ===
      tabItem(
        tabName = "descriptivo",
        h2("📊 Análisis Descriptivo"),
        
        fluidRow(
          box(
            title = "Gráficos Exploratorios", 
            status = "warning", 
            width = 7,
            # Aquí irá el 'plotOutput' de tus gráficos. [cite: 24]
            p("Espacio para Gráficos. ¡Recuerda que deben ser interactivos!")
          ),
          box(
            title = "Tablas de Resumen", 
            status = "warning", 
            width = 5,
            # Aquí irá el 'tableOutput' o 'DT::dataTableOutput' de tus tablas. [cite: 23]
            p("Espacio para Tablas.")
          )
        ),
        fluidRow(
          box(
            title = "Interpretación", 
            status = "success", 
            width = 12,
            p("Espacio para las Interpretaciones claras. [cite: 25]")
          )
        )
      ),
      
      # === Pestaña 3: Inferencia Básica (Requerimiento 3.b) ===
      tabItem(
        tabName = "inferencia",
        h2("🧪 Inferencia Básica"),
        
        fluidRow(
          box(
            title = "Justificación y Método", 
            status = "danger", 
            width = 4,
            p("Justificación del método (Prueba de Hipótesis o Intervalo de Confianza). [cite: 27, 28]")
          ),
          box(
            title = "Resultado (Output)", 
            status = "danger", 
            width = 8,
            # Aquí irá el 'verbatimTextOutput' del resultado de tu prueba (ej. t.test).
            p("Espacio para el resultado del test inferencial.")
          )
        ),
        fluidRow(
          box(
            title = "Interpretación del Resultado", 
            status = "success", 
            width = 12,
            p("Espacio para la interpretación del resultado inferencial. [cite: 29]")
          )
        )
      )
    )
  )
)

# -----------------------------------------------------------------------------
# 3. Definición de la Lógica del Servidor (Server)
# -----------------------------------------------------------------------------
server <- function(input, output, session) {
  # Por ahora, dejamos la lógica vacía. 
  # Aquí es donde se conectarán los datos y se generarán los outputs (gráficos y tablas).
}

# -----------------------------------------------------------------------------
# 4. Ejecución de la Aplicación
# -----------------------------------------------------------------------------
shinyApp(ui = ui, server = server)