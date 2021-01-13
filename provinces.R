library(sf)
library(dplyr)
library(httr)
library(purrr)
library(ows4R)
"https://geoservices.informatievlaanderen.be/overdrachtdiensten/VRBG/wfs" %>% 
    parse_url %>% 
    list_merge(query = list(service = "wfs",
                            version = "1.1.0",
                            request = "GetFeature",
                            typeName = "VRBG:Refprv",
                            srsName = "EPSG:31370",
                            outputFormat = "text/xml; subtype=gml/3.1.1")) %>% 
    build_url() %>% 
    read_sf(crs = 31370)
