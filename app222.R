# app.R

# 1. Cargar Librerías Necesarias
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(haven) 
library(survey)
library(plotly)
library(DT)
library(googledrive)
source("tabla variables.R")
# -----------------------------------------------------------------------------
#  Definición de la Interfaz de Usuario (UI)
# -----------------------------------------------------------------------------
ui <- dashboardPage(
  
  # Cabecera
  dashboardHeader(title = "Evaluación Final - Dashboard en Shiny"),
  
  # Barra Lateral (Sidebar)
  dashboardSidebar(
    sidebarMenu(
      # Pestañas de navegación
      menuItem("Contexto y Datos", tabName = "contexto", icon = icon("info-circle")),
      menuItem("1. Estadística Descriptiva", tabName = "descriptivo", icon = icon("chart-bar")),
      menuItem("2. Inferencia Básica", tabName = "inferencia", icon = icon("calculator"))
    ),
  hr(),
  # --- FILTRO GLOBAL POR AÑO ---
  selectInput("filtro_anio", "Seleccione Año (CASEN):", 
              choices = c("2015" = 2015, "2017" = 2017, "2022" = 2022),
              selected = 2022)
                        ),
  
  #Cuerpo del Dashboard (Body)
  dashboardBody(
    tabItems(
      
      # === Pestaña 1: ===
      tabItem(
        tabName = "contexto",
        h2("Contexto del Problema y Preguntas"),
        
        fluidRow(
          box(
            title = "Descripción del Fenómeno",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            p("En Chile, la brecha salarial es un tópico que ha ganado relevancia tanto en el ámbito económico como social, siendo considerada una de las principales causales de la desigualdad de género a nivel nacional. Si bien se han impulsado políticas orientadas a reducir estas diferencias, como por ejemplo la ley 20.328 que establece la igualdad salarial entre hombres y mujeres, y programas de fomento a la empleabilidad femenina como lo son el bono al trabajo de la mujer o el programa mujeres jefas de hogar, aún así, autores como Parada-Contzen & Jara (2025) avalan la conclusión sobre que la brecha salarial persiste y se manifiesta incluso en grupos de mujeres con mayores niveles de escolaridad que sus pares masculinos."),
            p("El presente estudio tiene como propósito analizar de manera comparativa la evolución de los ingresos entre hombres y mujeres en la Región del Maule, utilizando los datos de la Encuesta CASEN de 2015, 2017 y 2022. Se busca identificar si la brecha de género en ingresos ha mostrado variaciones en el período señalado y evaluar qué factores sociodemográficos y coyunturales contribuyen a su persistencia o reducción."),
            p("La zona escogida, la región del Maule, según datos del Gobierno Regional (2021) se caracteriza por contar con una economía vinculada principalmente a la agricultura, el sector forestal y la agroindustria, con una importante proporción de población rural, las cuales se caracterizan por una participación femenina que suele darse en forma de empleos temporales e informales, presentando condiciones que pueden amplificar las brechas de ingresos. Además, el período comprendido se ha visto marcado por transformaciones estructurales y eventos coyunturales como el estallido social de 2019 y la pandemia de la COVID-19 los cuales han afectado de manera diferenciada a hombres y mujeres, generando nuevas tensiones en el mercado laboral regional (CEPAL, 2019; Marcel, 2021).")
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
      
      # === Pestaña 2: Estadística Descriptiva ===
      tabItem(
        tabName = "descriptivo",
        h2("📊 Análisis Descriptivo"),
        
        fluidRow(
          # Cajas de resumen numérico
          valueBoxOutput("media_ingreso"),
          valueBoxOutput("total_casos"),
          valueBoxOutput("promedio_edad")
              ),
        fluidRow(
          # --- Caja Distribución de Ingresos ---
          box(
            title = "Distribución de Ingresos", status = "primary", solidHeader = TRUE, width = 6,
            plotOutput("plot_ingresos")
          ),
          box(
            title = "Ingreso por Sexo", status = "primary", solidHeader = TRUE, width = 6,
            p("Distribución comparativa (Zoom a ingresos < $2.000.000)"),
            plotOutput("plot_boxplot")
          )
        ),
        
        fluidRow(
          box(
            title = "Resultados", status = "success", width = 12,
            strong("Tabla 1. Resumen cuantitativo para mujeres"),
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/T1S.png", 
                style = "width: 350px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            br(),
            strong("Tabla 2. Resumen cuantitativo para mujeres"),
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/T2S.png", 
                style = "width: 350px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            br(),
            withMathJax("Para el caso de las variables cuantitativas, se expone el promedio junto a la desviación estándar (DE) de cada variable. Además, se realiza un análisis más detallado mediante histogramas y el cálculo de los valores de asimetría y curtosis, con el fin de evaluar su comportamiento en relación con la distribución normal. Por otro lado, para las variables cualitativas se señala la moda y la proporción en porcentaje con respecto al total de observaciones de cada variable."),
            br(),
            br(),
            withMathJax("En cuanto a los datos analizados, nos encontramos que para el caso de los hombres, la mayoría de los individuos que fueron encuestados tenían una edad que oscilaba entre los \\( 29 \\) a los \\( 45 \\) años. En las tres ediciones de la encuesta CASEN que son objeto de estudio, el promedio de nuestra muestra se ubicó en torno a los \\( 43 \\) años, con leves diferencias medidas en meses: en el año \\( 2015 \\) el promedio fue de \\( 43 \\) años, en el \\( 2017 \\), \\( 43 \\) años y \\( 8 \\) meses, y en el \\( 2022 \\) fue de \\( 43 \\) años y casi \\( 11 \\) meses. 
                En todas las ediciones analizadas de la encuesta, los \\( 15 \\) años figuran como la edad mínima registrada para los hombres, lo que se condice con el hecho de que para nuestra investigación, tomaremos como muestra las personas en edad legal para celebrar un contrato (\\( 15 \\) años en adelante).
                En lo que respecta al ingreso de los hombres tenemos  que para el año \\( 2015 \\) el promedio fue de \\( \\$514.703 \\), en tanto que la desviación estándar de la variable Ingreso Trabajo Principal Corregido para ese mismo año fue de \\( \\$675.771 \\). Para el año \\( 2017 \\) y \\( 2022 \\) el promedio del ingreso fue \\( \\$562.208 \\) y \\( \\$564.979 \\) respectivamente, y del mismo modo sus desviaciones estándar fueron \\( \\$804.457 \\) y \\( \\$446.461 \\)"),
            br(),
            br(),
            withMathJax("Al analizar en conjunto cada promedio con su desviación estándar correspondiente, podemos observar que para el caso de los años \\( 2015 \\) y \\( 2017 \\), la DE supera al promedio (siendo aún más evidente en el año \\( 2017 \\) ) lo que da cuenta de valores muy extremos y de una marcada desigualdad en los ingresos, pudiéndose constatar lo anterior al ver que los máximos observados están en torno a los \\( 20 \\) millones de pesos y los mínimos en torno a los \\( \\$11.000 \\). El año \\( 2022 \\) fue el único en el cual la desviación estándar resultó menor que el promedio, pudiendo explicarse en parte a la disminución de los valores extremos (nótese que el máximo registrado fue de \\( 7 \\) millones de pesos, muy menor a los otros años)."),
            br(),
            br(),
            withMathJax("Por contraparte, en el caso de las mujeres encuestadas, la mayoría encontráronse entre los \\( 28 \\) años (y \\( 6 \\) meses) y los \\( 53 \\) años (y \\( 8 \\) meses) de edad el año \\( 2015 \\); entre los \\( 28 \\) años (y \\( 10 \\) meses) y los \\( 54 \\) años (y \\( 10 \\) meses) de edad el año \\( 2017 \\); para el año \\( 2022 \\), la mayoría de las encuestadas tuvieron entre \\( 28 \\) años (y \\( 4 \\) meses) y \\( 52 \\) años (y \\( 11 \\) meses) de edad. La edad mínima registrada el año \\( 2015 \\) y \\( 2017 \\) fue \\( 15 \\) años, por la razón que ya se detalló para el caso de los hombres, que son los mayores a \\( 15 \\) quienes pueden  celebrar contratos (con la venia de los padres), en tanto el año \\( 2022 \\) la menor edad fueron los \\( 18 \\) años. En lo que se refiere a los ingresos, se observa la misma situación que en el caso de los hombres, siendo la desviación estándar mayor al promedio observado  los años \\( 2015 \\) y \\( 2017 \\), y el año \\( 2022 \\) resultó una DE menor al promedio. Sin embargo, se puede observar que en cada año, la diferencia es menor con respecto al caso de los varones, lo que podría explicarse en parte al hecho de que los salarios máximos fueron muy menores (con respecto a los hombres) los años \\( 2015 \\) y \\( 2022 \\), aunque el año \\( 2017 \\) la DE fue mayor al haber datos extremos mayores (nótese que fueron casi \\( 20 \\) millones el salario máximo )."),
            hr(),
            strong("Tabla 3. Razón de Varianzas del Ingreso Ponderado (Hombres / Mujeres)"),
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/T5S.png", 
                style = "width: 450px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            br(),
            br(),
            strong("Figura 1. Gráficos de caja y bigotes para la distribución del ingreso principal (ponderada) por sexo y año, ajustada al percentil 99."),
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/bxas.png", 
                style = "width: 450px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            withMathJax("Para comenzar con el análisis descriptivo, la Figura 1 muestra la distribución de los ingresos mediante diagramas de caja y bigotes (boxplots) ponderados separados por sexo y año. Al mirar los boxplots, nos percatamos que las cajas suben conforme pasan los años, esto indica que ha habido un aumento general en los ingresos desde \\( 2015 \\) a \\( 2022 \\)."),
            br(),
            br(),
            withMathJax("Por otro lado, sospechamos que la dispersión de los ingresos de los hombres es mayor que la de las mujeres en cada uno de los años, por lo que hemos calculado la relación de las varianzas entre hombres y mujeres, obteniendo los valores mostrados (ver Tabla 3). Al observar la relación entre las varianzas, notamos que siempre es mayor que \\( 1 \\), pero que con respecto pasa el tiempo, esta relación se ajusta cada vez más. Por ejemplo, de \\( 2015 \\) a \\( 2017 \\) para de \\( 2.21 \\) a \\( 2.16 \\), pero para \\( 2022 \\), baja hasta \\( 1.34 \\). Estos resultados indican que los ingresos de los hombres no tiende a ser fijo, sino que varía y es un poco más desbalanceado en comparación con la de las mujeres. Sin embargo, la variación en los ingresos de ambos sexos tiende a ser la misma conforma pasa el tiempo. Esto se tendrá en cuenta mas adelante en el análisis inferencial."), 
            br(),
            br(),
            withMathJax("Además, vimos que las cajas de los hombres siempre están por arriba de las cajas de las mujeres, lo cual nos señala que los hombres tienen mayores sueldos a pesar del paso del tiempo. Por ejemplo, en \\( 2015 \\), el Q1 (\\( 350.000 \\) aprox) Y Q3 (\\( 500.000 \\) aprox) de los hombres supera al Q1 (\\( 250.000 \\) aprox) y al Q3 (\\( 450.000 \\) aprox) de las mujeres. Esto se mantiene en \\( 2017 \\), donde, comparando los cuartiles terceros, los hombres pasan de \\( 500.000 \\) hasta \\( 600.000 \\) aproximadamente y, para las mujeres, pasan de \\( 450.000 \\) hasta \\( 500.000 \\)."),
            hr(),
            strong("Figura 2. Diagrama de barras para relación Q5/Q1 del ingreso principal (ponderada) por sexo y año."),
            br(),
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/qp.png", 
                style = "width: 450px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            withMathJax("El análisis de la dispersión de los datos usando quintiles (Figura 2) nos muestra varias cosas a destacar. Mucha gente puede pensar que porque la barra de las mujeres está mas arriba que la de los hombres es porque ganan más, pero esto no siempre es así. Los boxplots analizados anteriormente nos mostraron que los hombres ganan mas que las mujeres en todos los años, pero este gráfico de barras nos muestra que tan alejados están los sueldos del \\(20\\% \\) mas pobre del \\(20\\%\\) mas ricos."),
            br(),
            br(),
            withMathJax("Para \\( 2015 \\), notamos que el ingreso del quintil \\( 5 \\) (Q5) de los hombres era \\( 65 \\) veces mas grande que el del quintil \\( 1 \\) (Q1), es decir, que los ingresos eran mas desiguales que el de las mujeres. En cambio, para \\( 2017 \\) esto tomaría una vuelta drástica, ya que los ingresos de los hombres parecen ajustasrse un poco, pero el de las mujeres muestra una amplia desigualdad, indicando que el ingreso de su quintil \\( 5 \\) para ese año es casi \\( 80 \\) veces más que el de su quintil \\( 1 \\)."),
            br(),
            br(),
            withMathJax("Finalmente, surge un importante cambio de \\( 2017 \\) a \\( 2022 \\), ya que las barras bajan radicalmente en este periodo; esto nos dice que los quintiles inferiores aumentan más rápido que los superiores para ambos sexos. Esta drástica compresión de la desigualdad se atribuye principalmente al impacto de las transferencias directas del Estado durante la pandemia (como el IFE Universal), que elevaron significativamente el 'piso' de ingresos del quintil más bajo , reduciendo la brecha con el quintil más alto.")
          ),
        )
      ),
      
      # === Pestaña 3: Inferencia Básica ===
      tabItem(
        tabName = "inferencia",
        h2("Inferencia Básica"),
        
        fluidRow(
          box(
            title = "Justificación y Método",
            status = "danger",
            width = 12,
            p("Para realizar un análisis de carácter inferencial, se graficaron los ingresos promedios a través de gráficos de barras con un intervalo de confianza del 95%, separados por sexo y año. Lo primero que se desprende de los gráficos, es que en todos los años analizados el ingreso promedio de los hombres mayor y además, los intervalos de confianza (IC) representados por los bigotes indican que los ingresos promedios poblacionales de los hombres nunca se han de superponer con los de las mujeres. Que los intervalos presenten esto es una evidencia visual de que la diferencia observada no es producto del azar, sino que es estadísticamente significativa. Por lo tanto, podemos inferir que, con un 95% de confianza, en la población general los hombres tienen mayores ingresos que las mujeres en los tres periodos. Sin embargo, visualmente, se infiere que esta brecha ha disminuido con el paso de los años, pero no desaparece.
Antes de aplicar la prueba t, necesitábamos saber si las varianzas eran realmente desiguales, por lo que decidimos aplicar primero un test de Levene (Prueba F) para cada año, con el fin para estar completamente seguros de que estas eran distintas. Los resultados obtenidos confirman que las varianzas son en efecto, distintas, pues el valor p se ubicó entre 0,002 y 0,05 para el año 2015, entre 0,0001 y 0,05 para el año 2017 y entre aproximadamente 0 y 0,05 para el año 2022.
")
          ),
          box(
            title = "Resultados", status = "success", width = 12,
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/bart.png", 
                style = "width: 450px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            p("a"),
            hr(),
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/T3S.png", 
                style = "width: 450px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            br(),
            withMathJax("Antes de aplicar la prueba t, necesitabamos saber si las varianzas eran realmente desiguales, por lo que para complementar los boxplots graficados (Figura 1) y la Tabla 3, decidimos aplicar primero un test de Levene (Prueba F) para cada año, con el fin para estar completamente seguros de que estas eran distintas."),
            br(),
            br(),
            withMathJax("Los resultados obtenidos afirman completamente que las varianzas son, en efecto, distintas (Tabla 3), ya que con un nivel de significación del \\( 5\\% \\) y valores \\( p \\) menores a \\( 0.01 \\), tenemos suficiente ecidencia para afirmar que la varianza en los ingresos principales corregidos entre hombres y mujeres varía de forma distinta."),
            hr(),
            tags$div(
              style = "text-align: center;",
              img(
                src = "recursos/T4S.png", 
                style = "width: 450px; height: auto; display: block; margin: 0 auto;" 
              )
            ),
            br(),
            withMathJax("Al aplicar la prueba t a cada año, se evidencia una clara diferencia entre los ingresos promedios de los hombres y los de las mujeres. Al mirar los resultados de la Tabla 5, notamos que con un nivel de signifiación del \\( 5\\% \\) y valores \\( p \\) muy pequeños, tenemos suficiente evidencia para afirmar que existe una diferencia significativa entre los ingresos promedios entre hombres y mujeres."),
            br(),
            br(),
            withMathJax("Esta conclusión se puede complementar al analizar los intervalos de confianza para la diferencia de medias (\\(\\mu_{H} - \\mu_{M}\\)), en los cuales notamos que no se encuentra el \\( 0 \\) en ninguno de ellos, esto señala que los ingresos medios por parte de los hombres son mayores que los de las mujeres a nivel poblacional. Por ejemplo, para el año \\( 2022 \\), podemos afirmar que con un nivel de significación del \\( 5\\% \\), la diferencia de ingresos promedios entre hombres y mujeres se encuentra entre \\( \\$50496 \\) y \\( \\$95398 \\) aproximadamente."),
            br(),
            br(),
            withMathJax("Aunque estos resultados muestren una brecha a favor de la parte masculina, se puede presenciar una clara disminución en los IC no solo para los valores que presentan estos intervalos, sino que también para la diferencia de medias conforme pasan los años. Por ejemplo, se hace un salto de \\( \\$90760 \\) a \\( \\$72947 \\) aproximadamente de \\( 2015 \\) a \\( 2022 \\) en las diferencias de medias respectivamente."),
          ),
        )
      ),
      tabItem(
        tabName = "inferencia",
        h2("Inferencia Básica"),
        fluidRow(
          box(
            title = "Prueba de Hipótesis (T-Student)", width = 12, status = "warning",
            helpText("Objetivo: Determinar si existe una diferencia significativa en el ingreso medio entre Hombres y Mujeres para el año seleccionado."),
            verbatimTextOutput("resultado_ttest"),
            h4("Interpretación:"),
            textOutput("interpretacion_ttest")
          )
        ),
        fluidRow(
          box(
            title = "Tabla de Datos Filtrada", width = 12,
            DTOutput("tabla_completa")
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
  
  # Cargar datos reales
  datos_crudos <- reactive({
    req(file.exists("data1/datos_procesados.csv"))
    read.csv("data1/datos_procesados.csv", stringsAsFactors = FALSE)
  })
  
  # Convertir año a numérico si es necesario
  datos_procesados <- reactive({
    datos <- datos_crudos()
    # Asegurar que 'año' sea numérico para el filtrado
    if (!is.numeric(datos$año)) {
      datos$año <- as.numeric(datos$año)
    }
    datos
  })
  
  # Datos filtrados por año seleccionado
  datos_filtrados <- reactive({
    req(input$filtro_anio)
    datos <- datos_procesados()
    
    # Filtrar por año seleccionado
    datos_filt <- datos %>% 
      filter(año == as.numeric(input$filtro_anio))
    
    # Eliminar outliers extremos para mejor visualización
    # Usamos percentil 99 para limitar valores extremos
    limite_superior <- quantile(datos_filt$yoprcor, 0.99, na.rm = TRUE)
    
    datos_filt %>% 
      filter(yoprcor <= limite_superior & yoprcor > 0)
  })
  
  # Renderizar tabla de códigos
  output$tabla_libro_codigos <- renderTable({
    df_codigos  # Asumiendo que esto viene de "tabla variables.R"
  })
  
  # --- Value Boxes ---
  output$media_ingreso <- renderValueBox({
    datos <- datos_filtrados()
    promedio <- mean(datos$yoprcor, na.rm = TRUE)
    
    valueBox(
      paste0("$", format(round(promedio, 0), big.mark=".", decimal.mark = ",")),
      "Ingreso Promedio", 
      icon = icon("money-bill"), 
      color = "green"
    )
  })
  
  output$total_casos <- renderValueBox({
    datos <- datos_filtrados()
    valueBox(
      format(nrow(datos), big.mark="."),
      "Total Observaciones", 
      icon = icon("users"), 
      color = "blue"
    )
  })
  
  output$promedio_edad <- renderValueBox({
    datos <- datos_filtrados()
    if ("edad" %in% colnames(datos)) {
      promedio_edad <- mean(datos$edad, na.rm = TRUE)
    } else {
      promedio_edad <- NA
    }
    
    valueBox(
      ifelse(is.na(promedio_edad), "N/A", round(promedio_edad, 1)),
      "Edad Promedio", 
      icon = icon("calendar"), 
      color = "yellow"
    )
  })
  
  # --- Gráfico 1: Histograma ---
  output$plot_ingresos <- renderPlot({
    datos <- datos_filtrados()
    
    # Calcular límites para mejor visualización
    max_ingreso <- min(2000000, max(datos$yoprcor, na.rm = TRUE))
    
    ggplot(datos, aes(x = yoprcor)) +
      geom_histogram(fill = "steelblue", bins = 30, color = "white", alpha = 0.8) +
      theme_minimal() +
      labs(
        x = "Ingreso ($)", 
        y = "Frecuencia",
        title = paste("Distribución de Ingresos - Año", input$filtro_anio)
      ) +
      scale_x_continuous(
        labels = function(x) format(x, big.mark = ".", scientific = FALSE),
        limits = c(0, max_ingreso)
      ) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, face = "bold")
      )
  })
  
  # --- Gráfico 2: Boxplot comparativo por sexo ---
  output$plot_boxplot <- renderPlot({
    datos <- datos_filtrados()
    
    # Filtrar solo valores menores a 2,000,000 como indica el título
    datos_filt <- datos %>% 
      filter(yoprcor < 2000000, yoprcor > 0)
    
    # Convertir sexo a factor con etiquetas
    datos_filt <- datos_filt %>%
      mutate(
        sexo_factor = factor(sexo, 
                             levels = c(1, 2), 
                             labels = c("Hombres", "Mujeres"))
      )
    
    ggplot(datos_filt, aes(x = sexo_factor, y = yoprcor, fill = sexo_factor)) +
      geom_boxplot(alpha = 0.7, outlier.shape = 16, outlier.alpha = 0.5) +
      scale_fill_manual(values = c("Hombres" = "#3498db", "Mujeres" = "#e74c3c")) +
      theme_minimal() +
      labs(
        x = "Sexo", 
        y = "Ingreso ($)",
        title = paste("Comparación de Ingresos por Sexo - Año", input$filtro_anio),
        fill = "Sexo"
      ) +
      scale_y_continuous(
        labels = function(x) format(x, big.mark = ".", scientific = FALSE)
      ) +
      theme(
        legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text = element_text(size = 11)
      ) +
      coord_cartesian(ylim = c(0, 2000000))  # Zoom como se solicita
  })
  
  # --- Gráfico 3: Barras con intervalos (para inferencia) ---
  output$plot_barras_intervalos <- renderPlot({
    datos <- datos_filtrados()
    
    # Calcular estadísticas por grupo
    stats_grupo <- datos %>%
      group_by(sexo) %>%
      summarise(
        media = mean(yoprcor, na.rm = TRUE),
        sd = sd(yoprcor, na.rm = TRUE),
        n = n(),
        se = sd / sqrt(n),
        .groups = 'drop'
      ) %>%
      mutate(
        sexo_label = ifelse(sexo == 1, "Hombres", "Mujeres"),
        ic_inf = media - 1.96 * se,
        ic_sup = media + 1.96 * se
      )
    
    ggplot(stats_grupo, aes(x = sexo_label, y = media, fill = sexo_label)) +
      geom_bar(stat = "identity", alpha = 0.7) +
      geom_errorbar(aes(ymin = ic_inf, ymax = ic_sup), 
                    width = 0.2, 
                    color = "black", 
                    linewidth = 0.8) +
      scale_fill_manual(values = c("Hombres" = "#3498db", "Mujeres" = "#e74c3c")) +
      theme_minimal() +
      labs(
        x = "Sexo",
        y = "Ingreso Promedio ($)",
        title = paste("Ingreso Promedio con IC 95% - Año", input$filtro_anio),
        fill = "Sexo"
      ) +
      scale_y_continuous(
        labels = function(x) format(x, big.mark = ".", scientific = FALSE)
      ) +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold"),
        legend.position = "none"
      )
  })
  
  # --- Inferencia: test t ---
  test_result <- reactive({
    datos <- datos_filtrados()
    # Asegurar que sexo sea factor
    datos <- datos %>%
      mutate(sexo_factor = factor(sexo, levels = c(1, 2)))
    
    t.test(yoprcor ~ sexo_factor, data = datos)
  })
  
  output$resultado_ttest <- renderPrint({
    test_result()
  })
  
  output$interpretacion_ttest <- renderText({
    res <- test_result()
    p_val <- res$p.value
    
    if (p_val < 0.05) {
      paste("El valor P es", round(p_val, 4),
            "(< 0.05). Existe diferencia significativa entre los ingresos por sexo para el año", 
            input$filtro_anio, ".")
    } else {
      paste("El valor P es", round(p_val, 4),
            "(≥ 0.05). No existe evidencia suficiente para afirmar diferencia de ingresos para el año", 
            input$filtro_anio, ".")
    }
  })
}

# -----------------------------------------------------------------------------
# 4. Ejecución de la Aplicación
# -----------------------------------------------------------------------------
shinyApp(ui = ui, server = server)