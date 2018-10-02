# fg_assign.r
The R function `fg_assign()` takes a fungal taxonomy table and assigns functional types based on the FUNGuild database. This project also includes the function `fg_assign_parallel()` allows for taxonomy assignment in a parallel environment on a multi-core processing node.

This function was developed by Colin Averill, using the FUNGuild database built by Nhu Nguyen and colleagues.

# When using this function to assign fungal functional types it is important to cite: Nguyen NH, Song Z, Bates ST, Branco S, Tedersoo L, Menke J, Schilling JS, Kennedy PG. 2016. FUNGuild: An open annotation tool for parsing fungal community datasets by ecological guild. Fungal Ecology, 20: 241-248. doi:10.1016/j.funeco.2015.06.006

Both functions take a taxonomy table with kingdom/phylum/class/order/family/genus/species as separate columns with those names in lower case.

Both functions return the taxonomy table with FUNGuild assignments appended.

Both functions download the FUNGuild database from the internet, which therefore requires an internet connection and a url where the FUNGuild database can be found. This is currently default set to http://www.stbates.org/funguild_db.php.

`fg_assign()` depends on R packages rvest, jsonlite. Additionally, `fg_assign_parallel()` depends on the R package doParallel.

Example:
````
#load function
source("/path/to/fg_assign.r")

#generate a taxonomy table to assign function.
tax_table <- structure(list(kingdom = "Fungi", phylum = "Ascomycota", class = "Pezizomycetes", order = "Pezizales", family = "Tuberaceae", genus = "Tuber", species = "Tuber melosporum"), 
                            .Names = c("kingdom", "phylum", "class", "order", "family", "genus", "species"), 
                            row.names = 4L, class = "data.frame")

#Assign functional guilds.
test <- fg_assign(tax_table)
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
test <- fg_assign(tax_table)
````