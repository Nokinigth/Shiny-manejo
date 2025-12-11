# Libro de códigos como un Data Frame para el Dashboard

df_codigos <- data.frame(
  "Código" = c("yoprcoripc", "sexo", "e6a", "zona", "s31c", "region", "edad", "o15"),
  "Descripción" = c(
    "Ingreso ocupacional principal, corregido por la encuesta y ajustado por IPC (base 2022).",
    "Sexo de la persona.",
    "Nivel educativo máximo alcanzado.",
    "Área de residencia (variable area en 2022).",
    "Condición permanente (homologada de s31/s31a1/s31c1).",
    "Región de residencia.",
    "Edad en años.",
    "¿En su trabajo principal trabaja cómo?"
  ),
  "Valores_Naturaleza" = c(
    "Numérico (pesos chilenos de 2022)", 
    "1 = Hombre; 2 = Mujer", 
    "1 = Nunca asistió;...; 15 = Doctorado",
    "1 = Rural; 0 = Urbano", 
    "1 = Sí tiene alguna condición; 0 = No tiene",
    "7 = Maule", 
    "15 a 120 años aprox.", 
    "1 = Patrón(a);...; 9 = Familiar no remunerado."
  ),
  "Rol_en_Estudio" = c(
    "Variable Dependiente", 
    "Variable de Agrupación", 
    "Variable Independiente", 
    "Variable Independiente", 
    "Variable Independiente",
    "Variable de Filtro", 
    "Variable de Filtro", 
    "Variable de Independiente"
  )
)
