# gbif.R
# query species current data from gbif
# clean up the data
# save it to a csv file
# create a map to display species occurrence points 

#list of packages
packages<-c("tidyverse", "rgbif", "usethis", "CoordinateCleaner", "leaflet", "mapview")

# install packages not yet installed
installed_packages<-packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

#Packages loading, with library function
invisible(lapply(packages, library, character.only=TRUE))

#Restart R
usethis::edit_r_environ()

spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

occ_download(pred("taxonKey", speciesKey), format="SIMPLE_CSV")

#Your download is being processed by GBIF:
#https://www.gbif.org/occurrence/download/0012222-240202131308920
#Most downloads finish within 15 min.
#Check status with
#occ_download_wait('0012222-240202131308920')
#After it finishes, use

#to retrieve your download.
#Download Info:
#  Username: dianara-sagastizado
#E-mail: lc23-0475@lclark.edu
#Format: SIMPLE_CSV
#Download key: 0012222-240202131308920
#Created: 2024-02-13T20:19:04.097+00:00
#Citation Info:  
#  Please always cite the download DOI when using this data.
#https://www.gbif.org/citation-guidelines
#DOI: 10.15468/dl.gg8t3w
#Citation:
#  GBIF Occurrence Download https://doi.org/10.15468/dl.gg8t3w Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-02-13

d <- occ_download_get('0012222-240202131308920', path="data/") %>%
  occ_download_import()

write_csv(d, "data/rawData.csv")

#cleaning

fData<-d %>% 
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

fData<-fData %>% 
  filter(countryCode %in% c("US", "CA", "MX"))

#alternate code for above:
#fData<- fData %>%
# filter(countryCode=="US" | countryCode=="MX" | countryCode=="CA)

fData<-fData%>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))

fData<-fData%>%
  cc_sea(lon="decimalLongitude", lat="decimalLatitude")

#remove duplicates
fData<-fData%>%
  distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all=TRUE)

#steps above in one swoop
# cleanData<-d %>%
#   filter(countryCode %in% c("US", "CA", "MX"))%>%
#   filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))%>%
#   cc_sea(lon="decimalLongitude", lat="decimalLatitude") %>%
#   distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all=TRUE)








