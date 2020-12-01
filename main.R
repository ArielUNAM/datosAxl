######
#
#   Analisis de datos Atomosféricos de la Ciudad de México
#   Script de métodos, funciones y objetos
######

library(dplyr)
library(lubridate)
library(rlang)


#' @title Filtrar valores NAN
#' @description Función que elimina valores NA de una variable contenida en el CSV de meteorología de los datos de la Ciudad de México.
#' @param df Es un dataframe que se obtiene de la lectura del CSV
#' @param var Es la variable que se quiere estudiar
#' @details Para facilitar la extracción de información se creo esta funció que nos otorga un dataframe alterno al original que eleimina los elementos NAN que se encuentran en los datos, además de perminirnos filtrar la información de una cierta variale que se desee estudiar
#' @examples
#' filtroNA(dm)
#' @export
filtroNA <- function(df,var){
    #En cierto año se modifico el nombre de la columna que almacena los datos y las estaciones
    aux <- tryCatch(
        return(df[df['cve_parameter'] == var,]),
        error = function(e){
            return(df[df['id_parameter'] == var,])
        }
    )
    aux <- aux[!is.na(aux$value),]
    aux
}


#' @title Transforma un dataframe a CSV
#' @description Función que crea un CSV para cada estación que contenga el dataframe de entrada
#' @param df Es un dataframe que contiene una columna de valores y una columnda de datos, los datos no deben tener NAN
#' @param lestaciones Lista de estaciones que contiene el dataframe
#' @param year Argumento que acompañara al nombre del archivo
#' @details Para facilitar el preprocesamiento se realizo una función que será introducida a un for para mejorar el funcionamieno
#' @examples
#' df2csv(df,['MER','LAA','CCA'],2020)
#' @export
df2csv <- function(df,lestaciones,year)
{
    if(colnames(df)[2] == "cve_station"){flag = TRUE}
    else{flag=FALSE}
    for(station in lestaciones)
    {
        aux <- hour2day(df,flag,station)
        aux <- day2month(aux)

        print("Aux-")
        print(aux)
        print("--------------")
        if(aux$flag)
        {
          write.csv(aux$df,file=paste0("data/transfData/",station,"_",year,"_tmp",".csv"))
        }
        else {
           print("pass")
        }
    }
    
}

#' @title Transformación de horas a dias
#' @description Regresa un dataframe del promedio diario
#' @param df Es un dataframe que se obtiene de la lectura del CSV
#' @param flag Dependiendo del año se modifica el identificador del archivo
#' @details Para minimizar las funciones se uso programación funcional 
#' @examples
#' hour2day(df,TRUE,'MER')
#' @export
hour2day <- function(df,flag,station) 
{
    if(flag)
    {
        aux <- mutate(df,date = dmy_hms(as.character(date))) %>% mutate(month=month(date),day=day(date)) %>% group_by(month,day)%>%filter(cve_station==station) %>% summarise(mean=mean(value),var=var(value),max=max(value),min=min(value))
    }
    else {
       aux <- mutate(df,date = dmy_hms(as.character(date))) %>% mutate(month=month(date),day=day(date)) %>% group_by(month,day)%>%filter(id_station==station) %>% summarise(mean=mean(value),var=var(value),max=max(value),min=min(value))
    }
    return(as.data.frame(aux))
}

#' @title Transformación de dias a meses
#' @description Regresa un dataframe del promedio mensual
#' @param df Es un dataframe que se obtiene de la lectura del CSV
#' @param flag Dependiendo del año se modifica el identificador del archivo
#' @details Para minimizar las funciones se uso programación funcional 
#' @examples
#' day2month(df)
#' @export
day2month <- function(df)
{
    if(nrow(df) != 0)
    {
        aux <- df %>% group_by(month) %>% summarize(avg=mean(mean),var=var(mean),max=max(mean),min = min(mean))
        output = list("flag"=TRUE,"df"=as.data.frame(aux))
        return(output)
    }
    else {
        output = list("flag"=FALSE,"df"=FALSE)
        return(output)
    }
    
}


