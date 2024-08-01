**********************
**********************
* Code PARA:
* Importar, preparar y calcular HHI de Elecciones
* Congresales (2006-2021) y Presidenciales (2006-2016)
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


* 1. Congresal
forv year = 2006(5)2021 {
	
	* Importar

	import delimited "$o2/Elecciones `year'/`year'_PRIMERA_Congresal.csv", case(l) clear

	* Eliminar actas no contabilizadas
	if (`year' == 2021) drop if descrip_estado_acta != "CONTABILIZADA"
	if (`year' == 2016 | `year' == 2011) drop if descrip_estado_acta != "ACTA ELECTORAL NORMAL"
	if (`year' == 2006) drop if descrip_estado_acta != "CONTABILIZADAS NORMALES"

	* Eliminar votos de otros países
	drop if departamento == "AFRICA"
	drop if departamento == "AMERICA"
	drop if departamento == "ASIA"
	drop if departamento == "EUROPA"
	drop if departamento == "OCEANIA"

	* Eliminar votos nulos/blancos/impugnados
	replace descripcion_op = "VOTOS EN BLANCO" if descripcion_op == "VOTOS BLANCOS"
	
	drop if descripcion_op == "VOTOS EN BLANCO"
	drop if descripcion_op == "VOTOS IMPUGNADOS"
	drop if descripcion_op == "VOTOS NULOS"

	* Generar codigo de provincia y departamento
	gen provincia_id_onpe     = string(ubigeo)
	replace provincia_id_onpe = ("0" + provincia_id_onpe) if length(provincia_id_onpe) == 5
	replace provincia_id_onpe = substr(provincia_id_onpe, 3, 2)

	gen departamento_id  = string(ubigeo)
	replace departamento_id = ("0" + departamento_id) if length(departamento_id) == 5
	replace departamento_id  = substr(departamento_id, 1, 2)
	
	* Arreglar códigos de departamento
	replace departamento_id = "07" if departamento == "CALLAO"
	replace departamento_id = "08" if departamento == "CUSCO"
	replace departamento_id = "09" if departamento == "HUANCAVELICA"
	replace departamento_id = "10" if departamento == "HUANUCO"
	replace departamento_id = "11" if departamento == "ICA"
	replace departamento_id = "12" if departamento == "JUNIN"
	replace departamento_id = "13" if departamento == "LA LIBERTAD"
	replace departamento_id = "14" if departamento == "LAMBAYEQUE"
	replace departamento_id = "15" if departamento == "LIMA"
	replace departamento_id = "16" if departamento == "LORETO"
	replace departamento_id = "17" if departamento == "MADRE DE DIOS"
	replace departamento_id = "18" if departamento == "MOQUEGUA"
	replace departamento_id = "19" if departamento == "PASCO"
	replace departamento_id = "20" if departamento == "PIURA"
	replace departamento_id = "21" if departamento == "PUNO"
	replace departamento_id = "22" if departamento == "SAN MARTIN"
	replace departamento_id = "23" if departamento == "TACNA"	
	replace departamento_id = "24" if departamento == "TUMBES"
	
	replace provincia_id_onpe = departamento_id + provincia_id_onpe
	
	* Arreglar códigos de provincia
	replace provincia = "ANTONIO RAYMONDI" if provincia == "ANTONIO RAIMONDI"
	replace provincia = "MARAÑON" if provincia == "MARAÃON"
	replace provincia = "NASCA" if provincia == "NAZCA"
	replace provincia = "FERREÑAFE" if provincia == "FERREÃAFE"
	replace provincia = "CAÑETE" if provincia == "CAÃETE"
	replace provincia = "DATEM DEL MARAÑON" if provincia == "DATEM DEL MARAÃON"
	replace provincia = "DANIEL ALCIDES CARRION" if provincia == "DANIEL CARRION" 
	replace provincia = "PROV. CONST. DEL CALLAO" if provincia == "CALLAO" 

	replace provincia = ustrto(ustrnormalize(provincia, "nfd"), "ascii", 2)
	
	if (`year' == 2006 | `year' == 2011) local y_merge = 2010
	if (`year' == 2016) local y_merge = 2016
	if (`year' == 2021) local y_merge = 2021
	
	merge m:m provincia using "$o2/Geodata/UBIGEO/ubigeo_`y_merge'.dta", keepusing(provincia_id)
	drop if _merge == 2
	drop _merge
	
	* Calcular hhi por provincia
	preserve

	collapse (sum) n_total_votos, by(descripcion_op provincia provincia_id)

	hhi5 n_total_votos, by(provincia)

	collapse (mean) hhi_n_total_votos, by(provincia provincia_id)

	gen hhi_provincia = 1/hhi_n_total_votos

	drop hhi_n_total_votos
	
	gen year = `year'
	
	save "$o3/Elecciones/`year'_hhi_provincia_c.dta", replace

	restore

	* Calcular hhi por departamento
	collapse (sum) n_total_votos, by(descripcion_op departamento departamento_id)

	hhi5 n_total_votos, by(departamento)

	collapse (mean) hhi_n_total_votos, by(departamento departamento_id)

	gen hhi_departamento = 1/hhi_n_total_votos 

	drop hhi_n_total_votos

	gen year = `year'
	
	save "$o3/Elecciones/`year'_hhi_departamento_c.dta", replace
}

* Append Provincia

use "$o3/Elecciones/2021_hhi_provincia_c.dta", clear
append using "$o3/Elecciones/2016_hhi_provincia_c.dta"
append using "$o3/Elecciones/2011_hhi_provincia_c.dta"
append using "$o3/Elecciones/2006_hhi_provincia_c.dta"

save "$o3/Elecciones/hhi_provincia_c.dta", replace

* Append Departamento

use "$o3/Elecciones/2021_hhi_departamento_c.dta", clear
append using "$o3/Elecciones/2016_hhi_departamento_c.dta"
append using "$o3/Elecciones/2011_hhi_departamento_c.dta"
append using "$o3/Elecciones/2006_hhi_departamento_c.dta"

save "$o3/Elecciones/hhi_departamento_c.dta", replace
