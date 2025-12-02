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
        h2("Contexto del Problema y Preguntas"),
        
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
            strong("¿Cómo ha evolucionado la brecha de ingresos entre hombres y mujeres en la Región del Maule durante el período 2015-2022?"),
            hr(),
            tags$ol(
            tags$li(p("¿Qué porcentaje de la brecha salarial total observada en el período de estudio es atribuible al componente explicado (características observables como el nivel de estudios, la ubicación geográfica de residencia, el estado civil, el género, o la ocupación) y al componente no explicado (diferencia en los retornos salariales debidas a sesgos implícitos en la contratación, diferencias en la calidad de la educación recibida o redes de contacto disímiles), según la metodología de descomposición de Oaxaca-Blinder?")),
            tags$li(p("¿Qué variables observables, tales como el nivel de estudios, la experiencia potencial, el estado civil o la ubicación geográfica, ejercen la mayor contribución absoluta a la brecha salarial a través de las diferencias en sus dotaciones y retornos durante el periodo analizado?")),
            tags$li(p("¿Cuál es la tendencia de los componentes explicado y no explicado a lo largo del periodo de estudio (2015-2022)? ¿La brecha salarial total, impulsada por estos componentes, muestra signos de aumentar o disminuir con el tiempo?")),
            ),
          ),
          box(
           title = "Selección de base de datos",
           status = "primary",
           solidHeader = TRUE,
           width = 12,
           strong("Fuente de datos"),
           p("Como fuente de datos para esta investigación, se han elegido los resultados de la encuesta CASEN en los años 2015, 2017 y 2022. Esta fuente es útil para este estudio gracias a su fácil acceso, además de su gran representatividad nacional y regional, siendo uno de los instrumentos de medición más relevantes del Estado utilizados para orientar la formulación, seguimiento y evaluación de políticas públicas de carácter social desde 1987 (CASEN, 2024)."),
           br(),
           strong("¿Quienes la realizan?"),
           p("La encuesta CASEN es realizada por el Ministerio de Desarrollo Social y Familia (MDSF) en conjunto con un proveedor externo, el Instituto Nacional de Estadística (INE), la Comisión Económica para América Latina y el Caribe (CEPAL), el Programa de las Naciones Unidas para el Desarrollo (PNUD) y un panel de expertos; instituciones y entes importantes para una alta confiabilidad y precisión en los resultados finales obtenidos. A pesar de que esta se efectúe cada 2 o 3 años, nos brinda información relevante para analizar los cambios entre períodos, y comparar los resultados de cada año entre sí (MDSF, 2024)."),
           br(),  
           strong("Cobertura"),
           p("En cuanto a su cobertura, la CASEN es representativa a nivel nacional y regional, y permite desagregaciones por zona urbana y rural, lo cual es relevante en el caso de la Región del Maule, conocida por su alta proporción de población rural, y para el análisis estadístico de la investigación. Con respecto a su cobertura poblacional, la encuesta considera a la población residente en hogares particulares en todo el territorio nacional, excluyendo a las personas que viven en instituciones colectivas (como cárceles, hogares de ancianos u hospitales). Finalmente, su cobertura temática incluye información detallada sobre ingresos, educación, salud, empleo, vivienda y otras dimensiones sociodemográficas, lo que permite abordar integralmente el análisis de la brecha de ingresos entre hombres y mujeres."),
           ),
          box(
            title = "Lista de variables a utilizar",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            tableOutput("tabla_libro_codigos")
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
  output$tabla_libro_codigos <- renderTable({
    df_codigos 
  })
}

# -----------------------------------------------------------------------------
# 4. Ejecución de la Aplicación
# -----------------------------------------------------------------------------
shinyApp(ui = ui, server = server)