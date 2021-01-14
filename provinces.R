library(sf)
library(dplyr)
library(httr)
library(purrr)
library(ows4R)

"https://geoservices.informatievlaanderen.be/overdrachtdiensten/VRBG/wfs" %>%
    parse_url() %>%
    list_merge(query = list(request = "DescribeFeatureType",
                            typeName = "VRBG:Refprv")) %>%
    build_url() %>%
    GET()

"https://geoservices.informatievlaanderen.be/overdrachtdiensten/VRBG/wfs" %>%
    parse_url() %>%
    list_merge(query = list(request = "GetFeature",
                            typeName = "VRBG:Refprv",
                            cql_filter="NAAM='West-Vlaanderen'",
                            srsName = "EPSG:31370",
                            outputFormat = "text/xml; subtype=gml/3.1.1")) %>%
    build_url() %>%
    read_sf(crs = 31370)
