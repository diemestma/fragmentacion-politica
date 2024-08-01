**********************
**********************
* Code PARA:
* Importar y arreglar base de datos de códigos de ubigeo en base a INEI
* (2010, 2016 y 2021)
**********************                  
**********************

clear all
set more off
*************
* Carpetas
*************

** Diego

global o1 "**UBICACIÓN DE TU CARPETA PRINCIPAL**"

global o2 "$o1/Fragmentación/1 Datos/Originales"

global o3 "$o1/Fragmentación/1 Datos/Trabajadas"

*************
* Importar y preparar
*************
clear all
set more off

local years "2010 2016 2021"
foreach year of local years {
	import excel "$o2/Geodata/UBIGEO/rptUbigeo_`year'.xls", sheet("ubicacionGeografica") cellrange(A2) firstrow case(l) clear
	
	drop a c d g h i j

	* Eliminar filas sin datos y con titulos
	drop if departamento == ""
	drop if departamento == "DEPARTAMENTO"

	* Generar códigos de departamento, provincia y distritno

	gen departamento_id = substr(departamento, 1, 2)

	gen provincia_id     = departamento_id + substr(provincia, 1, 2) 
	replace provincia_id = "" if length(provincia_id) != 4

	gen distrito_id     = provincia_id + substr(distrito, 1, 2)
	replace distrito_id = "" if length(distrito_id) != 6

	* Arreglar nombres de departamento, provincia y distritno

	replace departamento = ustrupper(substr(departamento, 4, 100))
	
	replace provincia    = ustrupper(substr(provincia, 4, 100))
	replace provincia    = ustrto(ustrnormalize(provincia, "nfd"), "ascii", 2)
	replace provincia    = ustrtrim(provincia)
	
	
	replace distrito     = ustrupper(substr(distrito, 4, 100))
	replace distrito     = ustrto(ustrnormalize(distrito, "nfd"), "ascii", 2)
	replace distrito     = ustrtrim(distrito)
	
	save "$o2/Geodata/UBIGEO/ubigeo_`year'.dta", replace
}
