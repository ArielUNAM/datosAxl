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
lyears = 2000:2020
lcontaminantes = c("CO","NOX","PM2.5","SO2")
lmeteorologicos = c("TMP")
path = "data/transfData"

print("Contaminantes")
for(year in lyears)
{
    print(year)
    for(contaminante in lcontaminantes)
    {
        print(contaminante)
        df <- read.csv(paste0("data/contaminantes_",year,".csv"),skip = 10, header = T)
        df2csv2(filtroNA(df,contaminante),lestaciones,year,contaminante,path)
    }
}
print("Temperatura")
for(year in lyears)
{
    print(year)
    for(meteorologico in lmeteorologicos)
    {
        df <- read.csv(paste0("data/meteorología_",year,".csv"),skip = 10, header = T)
        df2csv2(filtroNA(df,meteorologico),lestaciones,year,meteorologico,path)
    }
}




