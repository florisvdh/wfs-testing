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
# MULTISURFACE
# solved using https://github.com/r-spatial/sf/issues/748#issuecomment-389811593
#########################
object1 <-
  getfeature_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/VRBG/wfs",
                "VRBG:Refprv",
                "NAAM='West-Vlaanderen'")
st_geometry_type(object1)
ggplot(object1) + geom_sf()
st_buffer(object1, 10)

object1 <-
  st_cast(object1, "GEOMETRYCOLLECTION")
st_geometry_type(object1)
st_buffer(object1, 10)


#########################
# COMPOUNDCURVE
#########################
object2 <-
  getfeature_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs",
                "BWK:Hab3260",
                "OBJ=2071")
st_geometry_type(object2)
ggplot(object2) + geom_sf()
st_buffer(object2, 10)
object2$SHAPE
st_cast(object2, "GEOMETRYCOLLECTION")
st_cast(object2, "GEOMETRY")
st_cast(object2, "LINESTRING")
st_collection_extract(object2, "LINESTRING")

#########################
# CURVEPOLYGON
#########################
object3 <-
  getfeature_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs",
                "BWK:Bwkhab",
                "TAG='000098_v2018'")
st_geometry_type(object3)
ggplot(object3) + geom_sf()
st_buffer(object3, 10)
object3$SHAPE
st_cast(object3, "GEOMETRYCOLLECTION")
st_cast(object3, "GEOMETRY")
st_cast(object3, "POLYGON")
st_cast(object3, "LINESTRING")
st_collection_extract(object3, "LINESTRING")




