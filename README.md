# fg_assign.r
The R function `fg_assign()` takes a fungal taxonomy table and assigns functional types based on the FUNGuild database.

This function was developed by Colin Averill and Johan van den Hoogen, using the FUNGuild database built by Nhu Nguyen and colleagues.

# When using this function to assign fungal functional types it is important to cite: Nguyen NH, Song Z, Bates ST, Branco S, Tedersoo L, Menke J, Schilling JS, Kennedy PG. 2016. FUNGuild: An open annotation tool for parsing fungal community datasets by ecological guild. Fungal Ecology, 20: 241-248. doi:10.1016/j.funeco.2015.06.006

`fg_assign()` take a taxonomy table with kingdom/phylum/class/order/family/genus/species as separate columns with those names in lower case.

`fg_assign()` returns the taxonomy table with FUNGuild assignments appended.

`fg_assign()` downloads the FUNGuild database from the internet, which therefore requires an internet connection and a url where the FUNGuild database can be found. This is currently default set to http://www.stbates.org/funguild_db.php.

`fg_assign()` depends on R packages `rvest`, `jsonlite` and `tidyverse`.

 This project also includes the function `fg_assign_parallel()` which is now slower than the non-parallel version, because Johan is a wizard. Its here because we might fix it later. Welcome to free software.

Example:
````
#load function
source("/path/to/fg_assign.r")

#generate a taxonomy table to assign function.
tax_table <- structure(list(kingdom = "Fungi", phylum = "Ascomycota", class = "Pezizomycetes", order = "Pezizales", family = "Tuberaceae", genus = "Tuber", species = "Tuber melosporum"), 
                            .Names = c("kingdom", "phylum", "class", "order", "family", "genus", "species"), 
                            row.names = 4L, class = "data.frame")

#Assign functional guilds.
fg_assign(tax_table)
````

Parallel assignment example:
````
#load function
source("/path/to/fg_assign_parallel.r")

#generate a taxonomy table to assign function.
k <- structure(list(kingdom = "Fungi", phylum = "Ascomycota", class = "Pezizomycetes", order = "Pezizales", family = "Tuberaceae", genus = "Tuber", species = "Tuber melosporum"), 
                             .Names = c("kingdom", "phylum", "class", "order", "family", "genus", "species"), 
                             row.names = 4L, class = "data.frame")
tax_table <- rbind(k,k,k,k,k,k,k,c('Fungi',NA,NA,NA,NA,NA,NA))

#Assign functional guilds.
fg_assign_parallel(tax_table)
````