# Fragmentación Política
Este repositorio contiene el procedimiento para el cálculo del nivel de fragmentación política de las provincias y regiones de Perú. A partir de datos de los votos en las Elecciones Congresales 2006, 2011, 2016 y 2021, se calcula la fragmentación como el inverso del Índice de Herfindahl e Hirschman (HHI). Un mayor valor del inverso del HHI indicada un mayor nivel de fragmentación. 

## Contenido
- [code.do](/code.do). En este Do File se realiza lo siguiente:
   1. Limpieza de las bases de datos de votos por acta electoral de las Elecciones Congresales.[^1] Principalmente, se elimina los votos blancos, nulos e impugnados; se elimina los votos de peruanos en el extranjero; se eliminan las actas no contabilizadas; y se arreglan los códigos de las regiones y provincias en base a la codificación del INEI.[^2]
   2. Cálculo del nivel de fragmentación, a partir de datos de votos de las Elecciones Congresales. La formula es la siguiente: $Fragmentación_{d} = {(\sum_{N} x_{id}^2)}^{-1}$, en donde $N$ es la cantidad de partidos políticos y $x_{id}$ es la participación del partido $i$ en el total de votos dentro de la región o provincia $d$. Este indicador se utiliza para calcular el nivel de fragmentación política por, entre otros, Sanz et al. (2022) y por Riera (2023).[^3][^4]
- [code_figuras.do](/code_figuras.do). En este Do File se grafica el indicador $Fragmentación_{d}$, por provincia y región.[^5] Para el 2021, estos son los resultados:
  
  ![Alt text](/Fragmentacion_prov_2021.png)
  ![Alt text](/Fragmentacion_depart_2021.png) 

Cualquier sugerencia de mejora (tal vez haya algún pequeño error en la recodificación de los códigos de las provincias) me puedes escribir un correo a dffjs98@gmail.com.

[^1]: Los datos originales se pueden descargar desde el portal Datos Abiertos.
[^2]: Los çódigos de las provincias en base al INEI se pueden descargar desde [aquí](https://webapp.inei.gob.pe:8443/sisconcode/main.htm#). El código para importar y arreglar esos archivos se encuentra en [code_ubigeo.do](/fragmentacion-politica/code_ubigeo.do).
[^3]: Sanz, C., Solé-Ollé, A., & Sorribas-Navarro, P. (2022). Betrayed by the Elites: How Corruption Amplifies the Political Effects of Recessions. Comparative Political Studies, 55(7), 1095-1129. https://doi.org/10.1177/00104140211047415 
[^4]: Riera, P. (2020). Socioeconomic heterogeneity and party system fragmentation. Journal of Elections, Public Opinion and Parties, 33(3), 377–397. https://doi.org/10.1080/17457289.2020.1784181
[^5]: Los datos georeferenciados se pueden descargar desde [aquí](https://www.geogpsperu.com/2014/03/base-de-datos-peru-shapefile-shp-minam.html).
