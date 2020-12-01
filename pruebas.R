######
#
#   Analisis de datos Atomosféricos de la Ciudad de México
#
######

library(dplyr)
library(lubridate)
library(rlang)

source("main.R")


#parametros <- read.csv('data/cat_parametros.csv')
#unidades <- read.csv('data/cat_unidades.csv')
estaciones <- read.csv('data/cat_estacion.csv')
lestaciones <- as.character(estaciones$Catalogo.de.estaciones[-1])

dm1 <- read.csv('data/meteorología_2020.csv',skip = 10, header = T)
df2csv(filtroNA(dm1,'TMP'),lestaciones,2020)
dm2 <- read.csv('data/meteorología_2000.csv',skip = 10, header = T)
df2csv(filtroNA(dm2,'TMP'),lestaciones,2000)

