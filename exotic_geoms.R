suppressPackageStartupMessages(library(dplyr))
library(sf)

multiple_multisurfaces <-
  read_sf("https://geoservices.informatievlaanderen.be/overdrachtdiensten/VRBG/wfs?service=wfs&request=GetFeature&typeName=VRBG%3ARefprv")

multiple_multisurfaces %>%  # 5 features
  st_cast("GEOMETRYCOLLECTION") %>%
  mutate(id = seq_along(SHAPE)) %>%
  st_collection_extract("POLYGON") %>% # 28 features
  aggregate(list(.$id), first, do_union = FALSE) %>% # 5 features
  select(-id, -Group.1) %>%
  as_tibble %>%
  st_as_sf

