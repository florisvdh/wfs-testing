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
    paste0("WFS:", .) %>%
    read_sf()
}

#########################
# CURVEPOLYGON
#########################
object3 <-
  getfeature_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs",
                "BWK:Bwkhab",
                "TAG='183657_v2020'")

nrow(object3)
st_geometry_type(object3)

# following gives 3 polygons, not 1:
###########################
st_cast(object3$SHAPE, "GEOMETRYCOLLECTION") %>%
  st_collection_extract("LINESTRING") %>%
  st_cast("POLYGON")

# alternative based on https://github.com/rsbivand/rgrass7/issues/30#issuecomment-866756908:
###########################"
st_write(object3$SHAPE, file.path(tempdir(), "object3.gpkg"))

gdal_utils("vectortranslate",
           file.path(tempdir(), "object3.gpkg"),
           file.path(tempdir(), "object3_1.gpkg"),
           options=c("-nlt", "CONVERT_TO_LINEAR"))

read_sf(file.path(tempdir(), "object3_1.gpkg"))
