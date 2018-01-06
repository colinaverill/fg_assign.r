# fg_assign.r
An R function that takes a fungal taxonomy table and assigns functional types based on the FUNGuild database.

This function was developed by Colin Averill, using the FUNGuild database built by Nhu Nguyen and colleagues.

When using this function to assign fungal functional types **it is important to cite**
Nguyen NH, Song Z, Bates ST, Branco S, Tedersoo L, Menke J, Schilling JS, Kennedy PG. 2016. FUNGuild: An open annotation tool for parsing fungal community datasets by ecological guild. Fungal Ecology, 20: 241-248. doi:10.1016/j.funeco.2015.06.006

This function takes a taxonomy table with kingdom/phylum/class/order/family/genus/species as separate columns with those names in lower case.
This function returns the taxonomy table with FUNGuild assignments appended.
Requires a url path to the FUNGuild database. This is currently default set to http://www.stbates.org/funguild_db.php.
This function depends on R packages rvest, jsonlite.
I load this function at the top of a script using: `source("/path/to/fg_assign.r")`
