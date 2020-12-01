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


