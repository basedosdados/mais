
// program to clean string variables
// author: Ricardo Dahis
// last updated: 2021/02/10

cap program drop clean_string
program clean_string
	
	qui replace `1' = ustrlower(`1')
	
	//-------------------//
	// lower case
	//-------------------//
	
	foreach c in á à â ã ä {
		qui replace `1' = usubinstr(`1', "`c'", "a", .)
	}
	foreach c in é è ê ë {
		qui replace `1' = usubinstr(`1', "`c'", "e", .)
	}
	foreach c in í ì î ï {
		qui replace `1' = usubinstr(`1', "`c'", "i", .)
	}
	foreach c in ó ò ô õ ö {
		qui replace `1' = usubinstr(`1', "`c'", "o", .)
	}
	foreach c in ú ù ü {
		qui replace `1' = usubinstr(`1', "`c'", "u", .)
	}
	*
	
	qui replace `1' = usubinstr(`1', "ç", "c", .)
	qui replace `1' = usubinstr(`1', "ñ", "n", .)
	
	
	//-------------------//
	// upper case
	//-------------------//
	
	foreach C in Á À Â Ä Ã {
		qui replace `1' = usubinstr(`1', "`C'", "A", .)
	}
	foreach C in É È Ê Ë {
		qui replace `1' = usubinstr(`1', "`C'", "E", .)
	}
	foreach C in Í Ì Î Ï {
		qui replace `1' = usubinstr(`1', "`C'", "I", .)
	}
	foreach C in Ó Ò Ô Õ Ö {
		qui replace `1' = usubinstr(`1', "`C'", "O", .)
	}
	foreach C in Ú Ù Ü {
		qui replace `1' = usubinstr(`1', "`C'", "U", .)
	}
	*
	
	qui replace `1' = usubinstr(`1', "Ç", "C", .)
	qui replace `1' = usubinstr(`1', "Ñ", "N", .)
	
	
	//-------------------//
	// other characters
	//-------------------//
	
	qui replace `1' = usubinstr(`1', "_", " ", .)
	qui replace `1' = subinstr(`1', ".", "", .)
	qui replace `1' = subinstr(`1', ",", "", .)
	qui replace `1' = subinstr(`1', "  ", " ", .)
	qui replace `1' = subinstr(`1', "[", "", .)
	qui replace `1' = subinstr(`1', "]", "", .)
	qui replace `1' = subinstr(`1', "{", "", .)
	qui replace `1' = subinstr(`1', "}", "", .)
	qui replace `1' = subinstr(`1', "'", "", .)
	qui replace `1' = subinstr(`1', "`", "", .)
	
	
	//-------------------//
	// spacing
	//-------------------//
	
	qui replace `1' = subinstr(`1', "  ", " ", .)
	qui replace `1' = strtrim(`1')

end






