# Datos de la Ciudad de México

Los  [datos abiertos](https://datos.cdmx.gob.mx/pages/home/) de la Ciudad de México son una base de datos extensa sobre diversas variables atmosféricas, calidad del aire, zonas verdes, etc; la información se encuentra almacenada en diversos formatos que pueden ser útiles para diferentes aplicaciones.

El script presentado toma información contenida en un data.frame, por lo que se recomienda descargar el archivo en formato CSV y después usar el siguiente método

```R
read.csv(path/to/file,skip = 10, header = T)
```

El código anterior omite el encabezado del archivo, que contiene información sobre los datos presentados, y obtiene unicamente los datos almacenados.

El script **main.R** contiene diversas funciones, sin embargo las más útiles son:

* *filtrarNA* 
* *df2csv*
* *df2csv2*

La primera función elimina los datos que tengan como valor un dato NAN, las siguientes dos funciones almacenan datos estadísticos (media, varianza, minimos,maximos) de las estaciones de forma anual, la diferencia principal es que la función **df2csv** crea un csv para cada estación mientras que **df2csv2** crea un csv para cada año.

La combinación de ambas funciones permite facilitar el preprocesamiento de los datos para un análisis estadístico simple, usando los csv creados.

-----------------------

Es importante 
