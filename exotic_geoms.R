suppressPackageStartupMessages(library(dplyr))
library(sf)

multiple_curvepolygons <-
  read_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/BWK/wfs?service=WFS&request=GetFeature&typename=BWK%3ABwkhab&bbox=137000%2C193000%2C138000%2C194000")

multiple_curvepolygons %>%  # 152 features
  st_cast("GEOMETRYCOLLECTION") %>%
  mutate(id = seq_along(SHAPE)) %>%
  st_collection_extract("LINESTRING") %>% # 159 features
  aggregate(list(.$id), first, do_union = FALSE) %>% # 152 features
  select(-id, -Group.1) %>%
  st_cast("POLYGON") %>%
  as_tibble %>%
  st_as_sf


