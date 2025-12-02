# Libro de códigos como un Data Frame para el Dashboard

df_codigos <- data.frame(
  "Código" = c("yoprcoripc", "sexo", "e6a", "expp", "expp2", "zona", "s31c", "ecivilc", "region", "edad", "o15", "expr", "varstrat", "varunit"),
  "Descripción" = c(
    "Ingreso ocupacional principal, corregido por la encuesta y ajustado por IPC (base 2022).",
    "Sexo de la persona.",
    "Nivel educativo máximo alcanzado.",
    "Experiencia potencial. Calculada como: (Edad - Años de Escolaridad - 6)",
    "Experiencia potencial al cuadrado. (expp * expp)",
    "Área de residencia (variable area en 2022).",
    "Condición permanente (homologada de s31/s31a1/s31c1).",
    "Estado Civil (Casado/Convive).",
    "Región de residencia.",
    "Edad en años.",
    "¿En su trabajo principal trabaja cómo?",
    "Factor de expansión regional.",
    "estrato.",
    "conglomerado."
  ),
  "Valores_Naturaleza" = c(
    "Numérico (pesos chilenos de 2022)", 
    "1 = Hombre; 2 = Mujer", 
    "1 = Nunca asistió;...; 15 = Doctorado", 
    "Numérico", 
    "Numérico", 
    "1 = Rural; 0 = Urbano", 
    "1 = Sí tiene alguna condición; 0 = No tiene", 
    "1 = Casado(a) o Conviviente; 0 = Otro", 
    "7 = Maule", 
    "15 a 120 años aprox.", 
    "1 = Patrón(a);...; 9 = Familiar no remunerado.", 
    "Numérico (ponderador)", 
    "Categórico (ID de estrato)", 
    "Categórico (ID de conglomerado)"
  ),
  "Rol_en_Estudio" = c(
    "Variable Dependiente", 
    "Variable de Agrupación", 
    "Variable Independiente", 
    "Variable Independiente", 
    "Variable Independiente", 
    "Variable Dummy", 
    "Variable Dummy", 
    "Variable Dummy", 
    "Variable de Filtro", 
    "Variable de Filtro", 
    "Variable de Filtro", 
    "Diseño Muestral", 
    "Diseño Muestral", 
    "Diseño Muestral"
  )
)
