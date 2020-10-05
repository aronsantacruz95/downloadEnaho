/*=========================================================================
Objetivo:		Descargar TODOS los módulos de la ENAHO anual (metodologia
				actualizada) desde el año 2004 hasta el 2019 de la página
				del Instituto Nacional Estadística e Informática del Perú
Autor: 			Aron Santa Cruz (aronsantacruz95@gmail.com)
---------------------------------------------------------------------------
Fecha:			04/10/2020
Requerimiento:	Para correr este do debe tener conexión a internet
Producto:		ArchivoS .ZIP
=========================================================================*/

clear all
set more off
set timeout1 5
set timeout2 5

*Ruta donde se descargarán los módulos ordenados en carpetas por años*
*vvv LÍNEA MODIFICABLE vvv*
global a "C:\Users\ARON SANTA CRUZ\Documents\Bases\Originales\ENAHO\Anual\"
*^^^ LÍNEA MODIFICABLE ^^^*

* ENAHO 2004-2019 (frecuencia anual)
* [ 280  281  282  283  284  285  279  291  324  404  440  498  546  603  634  687]
* [2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019]

local year=2004
foreach z of numlist 280 281 282 283 284 285 279 291 324 404 440 498 546 603 634 687 {
	cd "$a"
	cap mkdir `year', public
	if _rc!=0 {
		di in red "La carpeta " `year' " ya existía, no fue necesaria crearla..."
	}
	cd "$a\`year'"
	foreach x of numlist 101/105 107/113 115/118 122/128 134 137 177 178 184 185 {
		local y=substr("`x'",-2,.)
		di in red "`year'" "Modulo`y'"
		cap confirm file "`z'-Modulo`y'.zip"
		if (_rc!=0) {
			di in red "Intento de descarga nro: 1"
			cap copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`z'-Modulo`y'.zip" "`z'-Modulo`y'.zip", public replace
			local x=2
			while (_rc!=0) {
				di in red "Intento de descarga nro: " `x'
				cap copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`z'-Modulo`y'.zip" "`z'-Modulo`y'.zip", public replace
				local ++x
			}
		}
		else {
			di in red "El módulo " `y' " ya estaba descargado..."
		}
	}
	local ++year
}