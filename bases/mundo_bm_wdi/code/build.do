
cd "~/Downloads/mundo_bm_wdi"

//----------------------//
// data
//----------------------//

import delimited "input/WDI_csv/WDIData.csv", clear varn(1)

drop ïcountryname
drop v67

ren countrycode   country_id
ren indicatorname indicator_name
ren indicatorcode indicator_id

preserve
	keep indicator_id indicator_name
	duplicates drop
	order indicator_id indicator_name
	export excel "output/dicionario_indicators.xlsx", replace 
restore

drop indicator_name

reshape long v, i(country_id indicator_id) j(year)

ren v value
replace year = year + 1955

tempfile data
save `data'

!mkdir -p "output/data"

levelsof year, l(years)
foreach year in `years' {
	
	!mkdir -p "output/data/year=`year'"
	use `data' if year == `year', clear
	drop year
	export delimited "output/data/year=`year'/data.csv", replace datafmt
	
}

//----------------------//
// country
//----------------------//

import delimited "input/WDI_csv/WDICountry.csv", clear varn(1) bindquotes(strict)

drop ïcountryname
drop v67

ren countrycode   country_id_iso3
ren indicatorname indicator_name
ren indicatorcode indicator_id

preserve
	keep indicator_id indicator_name
	duplicates drop
	order indicator_id indicator_name
	export excel "dicionario_indicators.xlsx", replace 
restore

drop indicator_name

reshape long v, i(country_id_iso3 indicator_id) j(year)

ren v value
replace year = year + 1955

export delimited "country.csv", replace
