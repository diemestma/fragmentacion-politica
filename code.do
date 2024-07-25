**********************
**********************
* Code PARA:
* 1. Importar y limpiar base de datos de Elecciones Congresales (2006-2021)
* 2. Calcular inverso de HHI
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


* Congresal
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
	gen provincia_id     = string(ubigeo)
	replace provincia_id = ("0" + provincia_id) if length(provincia_id) == 5
	replace provincia_id = substr(provincia_id, 3, 2)

	gen departamento_id  = string(ubigeo)
	replace departamento_id = ("0" + departamento_id) if length(departamento_id) == 5
	replace departamento_id  = substr(departamento_id, 1, 2)
	
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
	
	replace provincia_id = departamento_id + provincia_id

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