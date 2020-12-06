######
#
#   Analisis de datos Atomosféricos de la Ciudad de México
#   
#   A partir de los archivos CSV que pueden ser obtenidos de la pagina 
#   de datos abiertos de la Ciudad de México (datos.cdmx.gob.mx/).
#   Los dato son almacenados en una carpeta de nombre /data y los
#   archivos generados dentro del directorio data, en un subdirectorio
#   de nombre transfData.
#
#   Ni el nombre ni los archivos fueron modificados.
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

#Considerando que tiene los archivos csv puede poner acá la dirección donde quiere colocar los archivos generados
path2data = "./data/"
path2save = "./data/transfData/"
vmax = max(c(length(lcontaminantes),length(lmeteorologicos)))

print("Almacenando valores")
for(year in lyears)
{
    j <- 0
    #for(contaminante in lcontaminantes)
    for( i in 1:vmax)
    {
        if(j <= i)
        {
            j <- j + 1
            print(lcontaminantes[j])
            print(year)
            df <- read.csv(paste0(path2data,"contaminantes_",year,".csv"),skip = 10, header = T)
            df2csv2(filtroNA(df,lcontaminantes[j]),lestaciones,year,lcontaminantes[j],path2save)
            print(lmeteorologicos[j])
            print(year)
            df <- read.csv(paste0(path2data,"meteorología_",year,".csv"),skip = 10, header = T)
            df2csv2(filtroNA(df,lmeteorologicos[j]),lestaciones,year,lmeteorologicos[j],path2save)
        }
        else 
        {
            print(lcontaminantes[j])
            print(year)
            df <- read.csv(paste0(path2data,"contaminantes_",year,".csv"),skip = 10, header = T)
            df2csv2(filtroNA(df,lcontaminantes[i]),lestaciones,year,lcontaminantes[i],path2save)
        }
    }
        
}



