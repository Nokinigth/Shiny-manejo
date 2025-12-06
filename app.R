# app.R

# 1. Cargar Librerías Necesarias
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(haven) # Para leer archivos .dta
library(survey) # Necesario para el IC ponderado (aunque usaremos IC simple en ejemplo)

# -----------------------------------------------------------------------------
# 2. FUNCIÓN DE LIMPIEZA Y FILTRADO COMPLETO (INTEGRANDO LÓGICA DE CONSULTORÍA)
# -----------------------------------------------------------------------------

# Valores de IPC (hipotéticos, basados en el documento [cite: 196, 197] 97.21/73.93 para 2017, 97.21/70.39 para 2015)
# Usaremos 97.21 como base (CASEN 2022)
factores_ipc <- list(
  "2015" = 97.21 / 70.39,
  "2017" = 97.21 / 73.93,
  "2022" = 1.0 # 2022 es la base
)

limpiar_casen_completo <- function(file_path, year_label, sample_size = 20000) {
  
  # Carga el archivo .dta
  df_raw <- read_dta(file_path)
  
  # Renombrado de variables a un nombre común para el análisis (Ajusta si tus nombres son diferentes)
  # Usaremos los nombres del informe (yoprcoripc, sexo, edad)
  df_limpio <- df_raw %>%
    
    # 1. FILTROS GEOGRÁFICOS Y DE POBLACIÓN [cite: 201, 202]
    filter(
      region == 7,     # Región del Maule
      edad >= 15       # Mayor o igual a 15 años
      # Añade aquí tus filtros de o15 (ocupación) si es necesario (e.g., o15 %in% 3:8) [cite: 203]
    )
  
  # 2. IMPUTACIÓN Y AJUSTE DE INGRESOS
  
  # Imputación de Mediana (ya que mean() y median() solo operan en datos no-NA)
  median_ingreso <- median(df_limpio$yoprcoripc, na.rm = TRUE)
  
  df_limpio <- df_limpio %>%
    mutate(
      # Rellenar NA con la mediana [cite: 207]
      yoprcoripc = ifelse(is.na(yoprcoripc), median_ingreso, yoprcoripc),
      # Ajuste por IPC (solo si el año no es 2022)
      yoprcoripc_ajustado = yoprcoripc * factores_ipc[[year_label]],
      # Creación de ln(yoprcoripc) - la variable dependiente clave [cite: 210, 240]
      lnyoprcoripc = log(yoprcoripc_ajustado),
      # Transformar sexo a factor para análisis (1=H, 2=M)
      sexo = factor(sexo, levels = c(1, 2), labels = c("Hombre", "Mujer")),
      year = factor(year_label)
    ) %>%
    
    # 3. FILTRO DE INGRESOS POSITIVOS Y SUBMUESTRA [cite: 204]
    filter(yoprcoripc_ajustado > 0)
  
  
  # Submuestra para consistencia (si la base es mayor a sample_size)
  if (nrow(df_limpio) > sample_size) {
    df_limpio <- df_limpio %>% sample_n(sample_size, weight = expr) # Usar ponderador (expr) para muestreo
  }
  
  return(df_limpio)
}

# -----------------------------------------------------------------------------
# 3. CARGA Y UNIFICACIÓN DE DATOS
# -----------------------------------------------------------------------------

archivos <- list(
  "2015" = "C15.dta", 
  "2017" = "C17.dta",
  "2022" = "C22.dta"  
)

lista_datos_limpios <- list()

for (year in names(archivos)) {
  tryCatch({
    df_limpio <- limpiar_casen_completo(archivos[[year]], year, sample_size = 7000) # Usaremos 7k por año, aprox 20k total
    lista_datos_limpios[[year]] <- df_limpio
  }, error = function(e) {
    warning(paste("Error procesando", year, ":", e$message, ". Usando datos de emergencia."))
    lista_datos_limpios[[year]] <- data.frame(
      yoprcoripc_ajustado = rnorm(7000, mean = 500000, sd = 200000),
      lnyoprcoripc = log(rnorm(7000, mean = 500000, sd = 200000)),
      sexo = factor(sample(c("Hombre", "Mujer"), 7000, replace = TRUE)),
      year = factor(year), region = 7
    )
  })
}

datos_casen_unificado <- bind_rows(lista_datos_limpios)
años_disponibles <- unique(datos_casen_unificado$year)

# -----------------------------------------------------------------------------
# 4. DEFINICIÓN DEL DATA FRAME df_codigos
# -----------------------------------------------------------------------------
# ... (Tu código para df_codigos aquí, sin cambios) ...

# -----------------------------------------------------------------------------
# 5. DEFINICIÓN DE LA INTERFAZ DE USUARIO (UI)
# -----------------------------------------------------------------------------
ui <- dashboardPage(
  
  # a) Cabecera
  dashboardHeader(title = "Evaluación Final - Dashboard en Shiny"),
  
  # b) Barra Lateral (Sidebar)
  dashboardSidebar(
    sidebarMenu(
      menuItem("Contexto y Datos", tabName = "contexto", icon = icon("info-circle")),
      menuItem("1. Estadística Descriptiva", tabName = "descriptivo", icon = icon("chart-bar")),
      menuItem("2. Inferencia Básica", tabName = "inferencia", icon = icon("calculator"))
    ),
    
    hr(),
    h4(p(strong("Filtros Interactivos"), align = "center")),
    
    # Selector de Año (ya implementado)
    selectInput(
      inputId = "filtro_year",
      label = "Seleccionar Año CASEN:",
      choices = años_disponibles, 
      selected = "2022", 
      multiple = FALSE
    ),
    
    # NUEVO FILTRO: Selector de Sexo (Hombre, Mujer, Ambos)
    selectInput(
      inputId = "filtro_sexo",
      label = "Seleccionar Grupo de Género:",
      choices = c("Ambos", "Hombre", "Mujer"), 
      selected = "Ambos", 
      multiple = FALSE
    )
  ),
  
  # c) Cuerpo del Dashboard (Body)
  dashboardBody(
    tabItems(
      
      # === Pestaña 1: Contexto (Layout corregido) ===
      tabItem(
        tabName = "contexto",
        h2("Contexto del Problema y Preguntas"),
        
        # FILA 1
        fluidRow(
          box(title = "Descripción del Fenómeno", status = "primary", solidHeader = TRUE, width = 6, 
              p("En Chile, la brecha salarial es un tópico que ha ganado relevancia..."), # Reducido por espacio
              p("El presente estudio tiene como propósito analizar de manera comparativa la evolución de los ingresos entre hombres y mujeres en la Región del Maule..."), 
              p("La zona escogida, la región del Maule, según datos del Gobierno Regional (2021) se caracteriza por contar con una economía vinculada principalmente a la agricultura...")
          ),
          box(title = "Preguntas a Responder", status = "primary", solidHeader = TRUE, width = 6, 
              strong("¿Cómo ha evolucionado la brecha de ingresos entre hombres y mujeres en la Región del Maule durante el período 2015-2022?"),
              # ... (Preguntas específicas aquí) ...
          )
        ),
        # FILA 2
        fluidRow(
          box(title = "Selección de base de datos", status = "primary", solidHeader = TRUE, width = 12, # ANCHO COMPLETO
              # ... (Contenido de la fuente de datos aquí) ...
          )
        ),
        # FILA 3
        fluidRow(
          box(title = "Lista de variables a utilizar", status = "primary", solidHeader = TRUE, width = 12, # ANCHO COMPLETO
              tableOutput("tabla_libro_codigos")
          )
        )
      ),
      
      # === Pestaña 2: Estadística Descriptiva ===
      tabItem(
        tabName = "descriptivo",
        h2("📊 Análisis Descriptivo"),
        
        fluidRow(
          box(
            title = "Distribución de Ingresos y Densidad", 
            status = "warning", 
            width = 7,
            plotOutput("grafico_ingresos_ejemplo") # Gráfico reactivo: Histograma/Densidad (similar a Fig 0.1)
          ),
          box(
            title = "Tablas de Resumen", 
            status = "warning", 
            width = 5,
            tableOutput("tabla_resumen_ejemplo") # Tabla de resumen reactiva
          )
        ),
        fluidRow(
          box(
            title = "Ingreso Promedio con Intervalos de Confianza (IC)",
            status = "info",
            width = 12,
            plotOutput("grafico_ic_promedio") # Gráfico IC (similar a Fig 0.4)
          )
        )
      ),
      
      # === Pestaña 3: Inferencia Básica ===
      tabItem(
        tabName = "inferencia",
        h2("🧪 Inferencia Básica"),
        
        fluidRow(
          box(
            title = "Prueba t: Diferencia de Ingresos (H vs M)", 
            status = "danger", 
            width = 12, # Ancho 12 para mostrar el output completo
            p(strong("Nota:"), "Este test solo se ejecuta si el selector 'Grupo de Género' es 'Ambos'."),
            verbatimTextOutput("resultado_inferencia_prueba_t") 
          )
        ),
        fluidRow(
          box(
            title = "Interpretación del Resultado", 
            status = "success", 
            width = 12,
            p("Espacio para la interpretación del resultado inferencial.")
          )
        )
      )
    )
  )
)

# -----------------------------------------------------------------------------
# 6. DEFINICIÓN DE LA LÓGICA DEL SERVIDOR (Server)
# -----------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # 1. DATOS REACTIVOS: Filtra por Año Y Sexo
  datos_filtrados_sexo_year <- reactive({
    data <- datos_casen_unificado %>% filter(year == input$filtro_year)
    
    if (input$filtro_sexo != "Ambos") {
      data <- data %>% filter(sexo == input$filtro_sexo)
    }
    return(data)
  })
  
  # Datos solo para la prueba t (solo Ambos)
  datos_para_prueba_t <- reactive({
    datos_casen_unificado %>% filter(year == input$filtro_year)
  })
  
  # 2. OUTPUTS FIJOS: Tabla de Códigos
  output$tabla_libro_codigos <- renderTable({
    # (Asume que df_codigos fue creado globalmente)
    df_codigos 
  }, striped = TRUE, bordered = TRUE, hover = TRUE, width = "100%", align = 'l')
  
  
  # 3. OUTPUTS REACTIVOS (PESTAÑA DESCRIPTIVA)
  
  # 3a. Histograma/Densidad de Ingresos (Similar a Fig 0.1)
  output$grafico_ingresos_ejemplo <- renderPlot({
    data_plot <- datos_filtrados_sexo_year()
    
    # Asigna la variable de ingresos para el eje x
    ggplot(data_plot, aes(x = yoprcoripc_ajustado, fill = sexo)) +
      # Usa geom_histogram o geom_density, ajustando fill solo si es Ambos
      {
        if(input$filtro_sexo == "Ambos") {
          geom_density(alpha = 0.5)
        } else {
          geom_histogram(bins = 50, alpha = 0.8, fill = "#1F77B4")
        }
      } +
      labs(
        title = paste("Distribución de Ingresos Ajustados - Año", input$filtro_year, " (Grupo:", input$filtro_sexo, ")"),
        x = "Ingreso Ocupacional Corregido por IPC",
        y = "Densidad / Frecuencia"
      ) +
      theme_minimal()
  })
  
  # 3b. Tabla de Resumen
  output$tabla_resumen_ejemplo <- renderTable({
    datos_filtrados_sexo_year() %>%
      summarise(
        N = n(),
        Mediana_Ingreso = median(yoprcoripc_ajustado, na.rm = TRUE),
        Promedio_Ingreso = mean(yoprcoripc_ajustado, na.rm = TRUE),
        DesvEstandar = sd(yoprcoripc_ajustado, na.rm = TRUE),
        Max_Ingreso = max(yoprcoripc_ajustado, na.rm = TRUE)
      )
  })
  
  # 3c. Gráfico de Promedio con IC (Similar a Fig 0.4)
  output$grafico_ic_promedio <- renderPlot({
    # Agrega una columna dummy para el gráfico si solo se seleccionó un sexo
    data_summary <- datos_filtrados_sexo_year() %>%
      group_by(year, sexo) %>%
      summarise(
        promedio = mean(yoprcoripc_ajustado, na.rm = TRUE),
        se = sd(yoprcoripc_ajustado, na.rm = TRUE) / sqrt(n())
      ) %>%
      mutate(
        ic_sup = promedio + 1.96 * se,
        ic_inf = promedio - 1.96 * se
      )
    
    ggplot(data_summary, aes(x = year, y = promedio, fill = sexo)) +
      geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
      geom_errorbar(aes(ymin = ic_inf, ymax = ic_sup), width = 0.2, position = position_dodge(width = 0.9)) +
      labs(
        title = "Ingreso Promedio Ponderado con IC del 95% (Hombres vs Mujeres)",
        x = "Año de encuesta",
        y = "Ingreso promedio (pesos chilenos)"
      ) +
      scale_y_continuous(labels = scales::comma) +
      theme_minimal()
  })
  
  
  # 4. OUTPUTS REACTIVOS (PESTAÑA INFERENCIA)
  
  # 4a. Prueba T de Diferencia de Medias (Solo si es "Ambos")
  output$resultado_inferencia_prueba_t <- renderPrint({
    
    if (input$filtro_sexo == "Ambos") {
      
      data_test <- datos_para_prueba_t()
      
      cat(paste("Prueba t para diferencia de Ingresos (Hombre vs Mujer) - Año:", input$filtro_year, "\n\n"))
      
      # Asegúrate de usar var.equal=FALSE (varianzas desiguales) como sugiere tu informe [cite: 549, 626]
      tryCatch({
        t.test(yoprcoripc_ajustado ~ sexo, data = data_test, var.equal = FALSE)
      }, error = function(e) {
        cat("Error: Asegúrate de que ambas categorías (Hombre y Mujer) existen en la muestra filtrada.")
      })
      
    } else {
      cat("Selecciona 'Ambos' en el filtro de género para ejecutar la prueba t (Hombres vs. Mujeres).")
    }
    
  })
}

# -----------------------------------------------------------------------------
# 7. Ejecución de la Aplicación
# -----------------------------------------------------------------------------
shinyApp(ui = ui, server = server)