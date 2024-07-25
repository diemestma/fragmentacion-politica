**********************
**********************
* Code PARA:
* Crear mapas del inverso del HHI, a partir del output de code.do
**********************                  
**********************

clear all
set more off
*************
* Carpetas
*************

global o1 "**UBICACIÓN DE TU CARPETA PRINCIPAL**"

global o2 "$o1/Fragmentación/1 Datos/Originales"

global o3 "$o1/Fragmentación/1 Datos/Trabajadas"

*************
* Procedimiento
*************

clear all
set more off


* 1. DEPARTAMENTOS

* shp2dta 

shp2dta using "$o2/Geodata/DEPARTAMENTOS/DEPARTAMENTOS_inei_geogpsperu_suyopomalia", database("$o2/Geodata/DEPARTAMENTOS/DEPARTAMENTOS.dta") coordinates("$o2/Geodata/DEPARTAMENTOS/DEPARTAMENTOScoord.dta") genid(departamento_id) replace

* Generar mapa
use "$o3/Elecciones/hhi_departamento_c.dta", clear
destring departamento_id, replace

forv year = 2006(5)2021 {
	
	preserve
	keep if year ==  `year'

	replace hhi_departamento = round(hhi_departamento, 0.1)
	spmap hhi_departamento using "$o2/Geodata/DEPARTAMENTOS/DEPARTAMENTOScoord", id(departamento_id) fcolor(Blues) graphregion(color(white)) bgcolor(white)  ///
	legend(pos(6) row(3) ring(1) size(*1.5) symx(*.75) symy(*.75) forcesize )

	graph export "$o1/Fragmentación/Figuras/Fragmentacion_depart_`year'.png", replace

	restore	
}

* 2. PROVINCIAS

* shp2dta 

shp2dta using "$o2/Geodata/PROVINCIAS/PROVINCIAS_inei_geogpsperu_suyopomalia", database("$o2/Geodata/PROVINCIAS/PROVINCIAS.dta") coordinates("$o2/Geodata/PROVINCIAS/PROVINCIAScoord.dta") genid(provincia_id) replace

* Generar mapa
use "$o3/Elecciones/hhi_provincia_c.dta", clear

* Obtener ID
rename provincia_id IDPROV
merge m:1 IDPROV using "$o2/Geodata/PROVINCIAS/PROVINCIAS.dta", keepusing(OBJECTID NOMBPROV)

rename OBJECTID provincia_id

forv year = 2006(5)2021 {
	
	preserve
	keep if year ==  `year'

	replace hhi_provincia = round(hhi_provincia, 0.1)
	spmap hhi_provincia using "$o2/Geodata/PROVINCIAS/PROVINCIAScoord", id(provincia_id) fcolor(Blues) graphregion(color(white)) bgcolor(white)  ///
	legend(pos(6) row(3) ring(1) size(*1.5) symx(*.75) symy(*.75) forcesize )

	graph export "$o1/Fragmentación/Figuras/Fragmentacion_prov_`year'.png", replace

	restore	
}
