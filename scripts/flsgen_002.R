
options(
  java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx30g")
)
gc()

library(terra)
library(rflsgen)

# ejemplo ----------------------------------------------------------------

path <- system.file(
  "extdata",
  "copernicus_nc_grande_terre_closed_and_open_forests_200m.tif",
  package = "rflsgen"
)
existing_landscape <- rast(path)
plot(existing_landscape)

struct <- flsgen_extract_structure_from_raster(
  path,
  c(0, 1),
  connectivity = 8
)

dem_path <- system.file(
  "extdata",
  "dem_nc_grande_terre_200m.tif",
  package = "rflsgen"
)

r <- flsgen_generate(
  struct,
  terrain_file = dem_path,
  terrain_dependency = 0.9,
  epsg = "EPSG:3163",
  connectivity = 8,
  resolution_x = 105.4308639672429422,
  resolution_y = 105.4037645741556588,
  x = 159615,
  y = 467655
)
plot(r)

dem <- rast(dem_path)
values(dem) <- -values(dem)
r <- flsgen_generate(
  struct,
  terrain_file = dem,
  terrain_dependency = 0.9,
  epsg = "EPSG:3163",
  connectivity = 8,
  resolution_x = 105.4308639672429422,
  resolution_y = 105.4037645741556588,
  x = 159615,
  y = 467655
)
plot(r)

# Suquía -----------------------------------------------------------------

# https://dimitri-justeau.github.io/rflsgen/articles/UseCase3.html

# path <- "LULC_2023_SUQUIA.tif"
dem_path <- "20S_DEM.tif"

dem <- rast(dem_path)
# r <- rast(path) |>
#   project("EPSG:32720")
# writeRaster(r, "r.tif")

dem2 <- dem |>
  project("EPSG:32720")


r <- rast("r.tif")

struct <- flsgen_extract_structure_from_raster(
  r, 1:22,
  connectivity = 8
)

r2 <- flsgen_generate(struct,
  terrain_file = dem,
  terrain_dependency = 0.9,
  epsg = "EPSG:32720",
  connectivity = 8,
  # resolution_x = 105.4308639672429422,
  # resolution_y = 105.4037645741556588,
  # x = 159615, y = 467655
)

