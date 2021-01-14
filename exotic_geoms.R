suppressPackageStartupMessages(library(dplyr))
library(sf)
library(ggplot2)

getfeature_sf <- function(wfs, typename, cql_filter) {
  httr::parse_url(wfs) %>%
    purrr::list_merge(query = list(service = "wfs",
                                   request = "GetFeature",
                                   typeName = typename,
                                   cql_filter = cql_filter)) %>%
    httr::build_url() %>%
    read_sf()
}

#########################
# COMPOUNDCURVE
#########################
object2 <-
  getfeature_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs",
                "BWK:Hab3260",
                "OBJ=2071")
st_geometry_type(object2)
st_cast(object2, "GEOMETRYCOLLECTION") %>%
  st_collection_extract("LINESTRING")

#########################
# CURVEPOLYGON
#########################
object3 <-
  getfeature_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs",
                "BWK:Bwkhab",
                "TAG='000098_v2018'")
st_geometry_type(object3)
st_cast(object3$SHAPE, "GEOMETRYCOLLECTION") %>%
  st_collection_extract("LINESTRING") %>%
  st_cast("POLYGON")





