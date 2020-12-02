######
#
#   Analisis de datos Atomosféricos de la Ciudad de México
#   Script de métodos, funciones y objetos}
#   El escript se alimenta de dataframes, por lo que se recomienda importar este archivo a su script 
#   de trabajo e importar este script de funciones
#           source("main.R")
#   para que desde ahí use las funciones con su df
#
######

library(dplyr)
library(lubridate)
library(rlang)


#' @title Filtrar valores NAN
#' @description Función que elimina valores NA de una variable contenida en el CSV de meteorología de los datos de la Ciudad de México.
#' @param df Es un dataframe que se obtiene de la lectura del CSV
#' @param var Es la variable que se quiere estudiar: TMP, HR, CO, NOX, etc.
#' @details Para facilitar la extracción de información se creo esta funció que nos otorga un dataframe alterno al original que eleimina los elementos NAN que se encuentran en los datos, además de perminirnos filtrar la información de una cierta variale que se desee estudiar
#' @examples
#' filtroNA(dm)
#' @export
filtroNA <- function(df,var){
    #En cierto año se modifico el nombre de la columna que almacena los datos y las estaciones
    aux <- tryCatch(
        filter(df,cve_parameter == var),
        error = function(e){
            filter(df,id_parameter == var)
        }
    )
    aux <- filter(aux,!is.na(aux$value))
    row.names(aux) <- NULL
    return(aux)
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
df2csv <- function(df,lestaciones,year,var)
{
    df <- mutate(df,date = dmy_hms(as.character(date)))%>%mutate(month=month(date),day=day(date))
    if(colnames(df)[2] == "cve_station"){flag = TRUE}
    else{flag=FALSE}
    for(station in lestaciones)
    {
        aux <- hour2day(df,flag,station)
        aux <- day2month(aux)
        aux <- month2year(aux$df)

        if(aux$flag)
        {
          write.csv(aux$df,file=paste0("data/transfData/",station,"_",year,"_",var,".csv"))
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
        aux <- df%>%filter(cve_station==station)%>%group_by(month,day)%>%summarise(mean=mean(value),var=var(value),max=max(value),min=min(value))
    }
    else {
       aux <- d%>%filter(id_station==station)%>%group_by(month,day)%>%summarise(mean=mean(value),var=var(value),max=max(value),min=min(value))
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

#' @title Transformación de dias a meses
#' @description Regresa un dataframe del promedio mensual
#' @param df Es un dataframe que se obtiene de la lectura del CSV
#' @param flag Dependiendo del año se modifica el identificador del archivo
#' @details Para minimizar las funciones se uso programación funcional 
#' @examples
#' day2month(df)
#' @export
month2year <- function(df)
{
    if(nrow(df) == 0 || df == FALSE)
    {
        output = list("flag"=FALSE,"df"=FALSE)
        return(output)
    }
    else {
        aux <- df %>% summarize(mean=mean(avg),var=var(avg),max=max(avg),min = min(avg))
        output = list("flag"=TRUE,"df"=as.data.frame(aux))
        return(output)
    }
    
}

