pacman::p_load(
    rgeoboundaries,
    rstac, sf, terra,
    tidyverse, elevatr,
    ggtern, ggspatial,
    rayshader
)

# 2. Define Country Boundaries
# Get U.S. states data
country_sf <- rgeoboundaries::gb_adm0(
  "GHA"
)

country_bbox <- sf::st_bbox(
  country_sf
)

# 3. Query ESA Land Cover Data
ms_query <- rstac::stac(
  "https://planetarycomputer.microsoft.com/api/stac/v1"
)

ms_collections <- ms_query |>
  rstac::collections() |>
  rstac::get_request()

print(ms_collections, n = 123)

collections <- "esa-worldcover"

ms_esa_query <- rstac::stac_search(
  q = ms_query,
  collections = collections,
  datetime = 
    "2021-01-01T00:00:00Z/2021-12-31T23:59:59Z",
  bbox = country_bbox
) |>
  rstac::get_request()

# 4. Download ESA Land Cover Data
ms_query_signin <- rstac::items_sign(
  ms_esa_query, rstac::sign_planetary_computer()
)

main_dir <- getwd()

rstac::assets_download(
  items = ms_query_signin,
  asset_names = "map",
  output_dir = main_dir, overwrite = TRUE
)


# 5. Load and Crop ESA Land Cover Data
version <- "v200"
year <- "2021"
asset_name <- "map"

data_dr <- file.path(
  main_dir, collections,
  version, year, asset_name
)

raster_files <- list.files(
  data_dir, full.names = TRUE
)