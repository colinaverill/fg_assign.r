fg_assign <- function(tax){
  # Check if dependencies are installed
  if (!require('rvest'   ,character.only = TRUE)){
    stop("please install the rvest package.")
  }
  if (!require('jsonlite',character.only = TRUE)){
    stop("please install the jsonlite package.")
  }
  if(!require('tidyverse', character.only = TRUE)){
    stop('please install the tidyverse package.')
  }
  
  # Check that the input data is a data frame
  if (!is.data.frame(tax)){
    stop('Your taxonomy table needs to be a data.frame. Try again.')
  }
  
  # Column names to lower case
  tax <- tax %>% rename_all(tolower)
  
  fg <- "http://www.stbates.org/funguild_db.php" %>% 
    xml2::read_html() %>%
    rvest::html_text() 
  fg <- jsonlite::fromJSON(gsub("funguild_db_2", "", fg)) %>% 
    mutate(taxonomicLevel = as.numeric(taxonomicLevel))
  
  # Define operator
  `%notin%` <- Negate(`%in%`)
  
  # Match on species level
  spp_match <- tax %>% 
    mutate(species = str_c(genus, species, sep = " ")) %>% 
    left_join(., fg %>% select(taxon, guild), by = c('species' = 'taxon')) %>% 
    filter(!is.na(guild))
  
  # Match on genus level
  genus_match <- tax %>% 
    filter(otu %notin% spp_match$otu) %>% 
    left_join(., fg %>% select(taxon, guild), by = c('genus' = 'taxon')) %>% 
    filter(!is.na(guild))
  
  # Match on family level
  family_match <- tax %>%
    filter(otu %notin% spp_match$otu) %>% 
    filter(otu %notin% genus_match$otu) %>% 
    left_join(., fg %>% select(taxon, guild), by = c('family' = 'taxon')) %>% 
    filter(!is.na(guild))
  
  # Match on order level
  order_match <- tax %>% 
    filter(otu %notin% spp_match$otu) %>% 
    filter(otu %notin% genus_match$otu) %>% 
    filter(otu %notin% family_match$otu) %>% 
    left_join(., fg %>% select(taxon, guild), by = c('order' = 'taxon')) %>% 
    filter(!is.na(guild))
  
  # Match on phylum level
  phylum_match <- tax %>% 
    filter(otu %notin% spp_match$otu) %>% 
    filter(otu %notin% genus_match$otu) %>% 
    filter(otu %notin% family_match$otu) %>% 
    filter(otu %notin% order_match$otu) %>% 
    left_join(., fg %>% select(taxon, guild), by = c('phylum' = 'taxon')) %>% 
    filter(!is.na(guild))
  
  # Combine data, assign mycorrhizal status
  out <- bind_rows(spp_match, genus_match, family_match, order_match, phylum_match) %>% 
    mutate(myc_status = case_when( str_detect(guild, 'Arbuscular Mycorrhizal') ~ 'Arbuscular Mycorrhizal', 
                                   str_detect(guild, 'Ectomycorrhizal') & str_detect(guild, 'Ericoid Mycorrhizal') ~ 'Ectomycorrhizal - Ericoid Mycorrhizal', 
                                   str_detect(guild, 'Ectomycorrhizal') ~ 'Ectomycorrhizal', 
                                   str_detect(guild, 'Ericoid Mycorrhizal') ~ 'Ericoid Mycorrhizal', 
                                   TRUE ~ 'Non Mycorrhizal'))
  
  # Print stats
  cat(sum(!is.na(out$guild))/(nrow(tax))*100,'% of taxa assigned a functional guild.', sep = '')
  
  return(out)
}
