get_mode_safe <- function(v, na.rm = TRUE) {
  if (na.rm) {
    v <- v[!is.na(v)]
  }
  if (length(v) == 0) {
    return(NA)
  }
  # Usar un vector temporal para encontrar la moda, especialmente si es factor
  v_temp <- as.character(v)
  uniqv <- unique(v_temp)
  # Retorna el primer valor más frecuente
  modas <- uniqv[which.max(tabulate(match(v_temp, uniqv)))]
  
  # Si la entrada original era un factor, devuelve el valor como factor
  if (is.factor(v)) {
    return(factor(modas, levels = levels(v)))
  } else {
    return(modas)
  }
}

library(haven)
library(tidyverse)
# ... (Otras librerías que usas) ...

# 1. Carga de datos (asumiendo que los archivos .dta están en el directorio de trabajo)
datos22 <- read_csv("Casen2015_filtrada.csv")
datos17 <- read_csv("Casen2017_filtrada.csv")
datos15 <- read_csv("Casen2022_filtrada.csv")

# 2. Corrección del Ingreso (IPC)
datos22 <- datos22 %>% mutate(yoprcoripc = yoprcor)
datos17 <- datos17 %>% mutate(yoprcoripc = yoprcor*(97.21/73.93))
datos15 <- datos15 %>% mutate(yoprcoripc = yoprcor*(97.21/70.39))

# ----------------------------------------------------------------------
# Imputación para Hombres 2022 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos22fH <- datos22 %>%
  select(sexo, region, edad, yoprcor,
         s31_1, s31_2, s31_3, s31_4, s31_5, s31_6, s31_7,
         area, e6a, o15) %>%
  mutate(
    s31 = case_when(
      s31_1 == 1 ~ 1, s31_2 == 1 ~ 2, s31_3 == 1 ~ 3, s31_4 == 1 ~ 4,
      s31_5 == 1 ~ 5, s31_6 == 1 ~ 6, s31_7 == 1 ~ 7,
      TRUE ~ NA_real_
    )
  ) %>%
  filter(sexo == 1, region == 7, edad >= 15, !is.na(o15)) %>%
  mutate(
    # Imputación numérica: reemplaza NA por la MEDIANA
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    # Imputación categórica: reemplaza NA por la MODA
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  ) %>% mutate(yoprcoripc = yoprcor)


# ----------------------------------------------------------------------
# Imputación para Mujeres 2022 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos22fM <- datos22 %>%
  select(sexo, region, edad, yoprcor,
         s31_1, s31_2, s31_3, s31_4, s31_5, s31_6, s31_7,
         area, e6a, o15) %>%
  mutate(
    s31 = case_when(
      s31_1 == 1 ~ 1, s31_2 == 1 ~ 2, s31_3 == 1 ~ 3, s31_4 == 1 ~ 4,
      s31_5 == 1 ~ 5, s31_6 == 1 ~ 6, s31_7 == 1 ~ 7,
      TRUE ~ NA_real_
    )
  ) %>%
  filter(sexo == 2, region == 7, edad >= 15, !is.na(o15)) %>%
  mutate(
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  ) %>% mutate(yoprcoripc = yoprcor)


# ----------------------------------------------------------------------
# Imputación para Hombres 2017 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos17fH <- datos17 %>%
  select(sexo, region, edad, yoprcor, s31a1, zona, e6a, o15) %>%
  filter(sexo == 1, region == 7, edad >= 15, !is.na(o15)) %>% 
  mutate(yoprcoripc = yoprcor*(97.21/73.93)) %>% 
  mutate(
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  )


# ----------------------------------------------------------------------
# Imputación para Mujeres 2017 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos17fM <- datos17 %>%
  select(sexo, region, edad, yoprcor, s31a1, zona, e6a, o15) %>%
  filter(sexo == 2, region == 7, edad >= 15, !is.na(o15)) %>% 
  mutate(yoprcoripc = yoprcor*(97.21/73.93)) %>% 
  mutate(
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  )


# ----------------------------------------------------------------------
# Imputación para Hombres 2015 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos15fH <- datos15 %>%
  select(sexo, region, edad, yoprcor, s31c1, zona, e6a, o15) %>%
  filter(sexo == 1, region == 7, edad >= 15, !is.na(o15)) %>% 
  mutate(yoprcoripc = yoprcor*(97.21/70.39)) %>% 
  mutate(
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  )


# ----------------------------------------------------------------------
# Imputación para Mujeres 2015 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos15fM <- datos15 %>%
  select(sexo, region, edad, yoprcor, s31c1, zona, e6a, o15) %>%
  filter(sexo == 2, region == 7, edad >= 15, !is.na(o15)) %>% 
  mutate(yoprcoripc = yoprcor*(97.21/70.39)) %>% 
  mutate(
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  )