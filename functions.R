library(tidyverse)

# 1. Carga de datos (asumiendo que los archivos .dta están en el directorio de trabajo)
datos22 <- read_csv("data1/Casen2015_f.csv")
datos17 <- read_csv("data1/Casen2017_f.csv")
datos15 <- read_csv("data1/Casen2022_f.csv")
# ----------------------------------------------------------------------
# Imputación para 2022 (MEDIANA y MODA)
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
  filter(region == 7, edad >= 15, !is.na(o15)) %>%
  mutate(
    # Imputación numérica: reemplaza NA por la MEDIANA
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    # Imputación categórica: reemplaza NA por la MODA
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  ) %>% mutate(yoprcoripc = yoprcor)



# ----------------------------------------------------------------------
# Imputación para 2017 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos17fH <- datos17 %>%
  select(sexo, region, edad, yoprcor, s31a1, zona, e6a, o15) %>%
  filter(region == 7, edad >= 15, !is.na(o15)) %>% 
  mutate(yoprcoripc = yoprcor*(97.21/73.93)) %>% 
  mutate(
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  )


# ----------------------------------------------------------------------
# Imputación para 2015 (MEDIANA y MODA)
# ----------------------------------------------------------------------
datos15fH <- datos15 %>%
  select(sexo, region, edad, yoprcor, s31c1, zona, e6a, o15) %>%
  filter(region == 7, edad >= 15, !is.na(o15)) %>% 
  mutate(yoprcoripc = yoprcor*(97.21/70.39)) %>% 
  mutate(
    across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)),
    across(where(is.character), ~ ifelse(is.na(.), get_mode_safe(.), .)),
    across(where(is.factor), ~ ifelse(is.na(.), get_mode_safe(.), .))
  )