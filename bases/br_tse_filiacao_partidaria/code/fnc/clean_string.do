
// program to clean string variables
// author: Ricardo Dahis
// last updated: 2020/10/01

cap program drop clean_string
program clean_string
	
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
	
	//-------------------//
	// lower
	//-------------------//
	
	qui replace `1' = ustrlower(`1')
	
end

/* PROBLEM: Stata's proper function capitalizes letters after non-ASCII letters

cap program drop clean_string_proper
program clean_string_proper
	
	//-------------------//
	// proper
	//-------------------//
	
	qui replace `1' = proper(`1')
	
	//-------------------//
	// upper case
	//-------------------//
	
	qui replace `1' = usubinstr(`1', "Á", "á", .)
	qui replace `1' = usubinstr(`1', "À", "à", .)
	qui replace `1' = usubinstr(`1', "Â", "â", .)
	qui replace `1' = usubinstr(`1', "Ä", "ä", .)
	qui replace `1' = usubinstr(`1', "Ã", "ã", .)
	qui replace `1' = usubinstr(`1', "É", "é", .)
	qui replace `1' = usubinstr(`1', "È", "è", .)
	qui replace `1' = usubinstr(`1', "Ê", "ê", .)
	qui replace `1' = usubinstr(`1', "Ë", "ë", .)
	qui replace `1' = usubinstr(`1', "Í", "í", .)
	qui replace `1' = usubinstr(`1', "Ì", "ì", .)
	qui replace `1' = usubinstr(`1', "Î", "î", .)
	qui replace `1' = usubinstr(`1', "Ï", "ï", .)
	qui replace `1' = usubinstr(`1', "Ó", "ó", .)
	qui replace `1' = usubinstr(`1', "Ò", "ò", .)
	qui replace `1' = usubinstr(`1', "Ô", "ô", .)
	qui replace `1' = usubinstr(`1', "Õ", "õ", .)
	qui replace `1' = usubinstr(`1', "Ö", "ö", .)
	qui replace `1' = usubinstr(`1', "Ú", "ú", .)
	qui replace `1' = usubinstr(`1', "Ù", "ù", .)
	qui replace `1' = usubinstr(`1', "Ü", "ü", .)
	
	qui replace `1' = usubinstr(`1', "Ç", "ç", .)
	qui replace `1' = usubinstr(`1', "Ñ", "ñ", .)
	
	//-------------------//
	// other characters
	//-------------------//
	
	qui replace `1' = usubinstr(`1', "_", " ", .)
	qui replace `1' = usubinstr(`1', ".", "", .)
	qui replace `1' = usubinstr(`1', ",", "", .)
	qui replace `1' = usubinstr(`1', "  ", " ", .)
	qui replace `1' = usubinstr(`1', "[", "", .)
	qui replace `1' = usubinstr(`1', "]", "", .)
	qui replace `1' = usubinstr(`1', "{", "", .)
	qui replace `1' = usubinstr(`1', "}", "", .)
	qui replace `1' = usubinstr(`1', "'", "", .)
	qui replace `1' = usubinstr(`1', "`", "", .)
	
	//-------------------//
	// spacing
	//-------------------//
	
	qui replace `1' = subinstr(`1', "  ", " ", .)
	qui replace `1' = strtrim(`1')
	
	
end
*/


