suppressPackageStartupMessages(library(dplyr))
library(sf)

multiple_curvepolygons <-
  read_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs?service=WFS&request=GetFeature&typename=BWK%3ABwkhab&bbox=137000%2C193000%2C138000%2C194000")

geometrycollection_sf_with_id <-
  multiple_curvepolygons %>%  # 152 features
  st_cast("GEOMETRYCOLLECTION") %>%
  mutate(id = seq_along(SHAPE)) # 152 features

### sfc only:
#######################################
geometrycollection_sf_with_id %>% # 152 features
  st_collection_extract("LINESTRING") %>% # 159 features
  {st_cast(.$SHAPE, "POLYGON", ids = .$id)} # 152 features

### combining with attributes (sf):
#######################################
geometrycollection_sf_with_id %>% # 152 features
  {st_sf(st_drop_geometry(.),
         geometry =
           st_collection_extract(., "LINESTRING") %>%
           {st_cast(.$SHAPE, "POLYGON", ids = .$id)})} %>%
  select(-id) %>%
  as_tibble %>%
  st_as_sf  # 152 features

