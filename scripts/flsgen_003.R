
options(
  java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx36g")
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

# r <- rast("LULC_2023_SUQUIA.tif")
# dem <- rast("20S_DEM.tif") |>
#   project("EPSG:22174")
# ext(dem) <- ext(r)

# writeRaster(dem, "dem.tif", overwrite = TRUE)
# writeRaster(r, "r.tif", overwrite = TRUE)

# r <- rast("r.tif")
# dem <- rast("dem.tif")

# dem2 <- project(dem, r)

# plot(r, axes = FALSE, legend = FALSE)
# plot(dem, axes = FALSE, legend = FALSE)

# dem1 <- mask(dem, r)
# r1 <- mask(r, dem)

# plot(dem1, legend = FALSE)
# plot(r2, legend = FALSE)

# writeRaster(dem1, "dem.tif", overwrite = TRUE)
# writeRaster(r1, "r.tif", overwrite = TRUE)

r <- rast("r.tif")
dem <- rast("dem.tif")

struct <- flsgen_extract_structure_from_raster(
  raster_file = r,
  focal_classes = c(1, 2), ##############################
  connectivity = 8
)

r2 <- flsgen_generate(
  struct,
  terrain_file = dem,
  terrain_dependency = 0.9,
  epsg = "EPSG:22174",
  connectivity = 8,
  resolution_x = 10,
  resolution_y = 10,
  x = ext(dem)$"xmin",
  y = ext(dem)$"ymax"
)

plot(r2)

shrubland <- flsgen_create_class_targets("shrubland",
  NP = 40, AREA = 500,
  PLAND = 20
)
forest <- flsgen_create_class_targets("forest",
  NP = 20, AREA = 500
  PLAND = 10
)
ls_targets <- flsgen_create_landscape_targets(500, 500, list(shrubland, savanna, forest))

structure <- flsgen_structure(targets_str = ls_targets)

r3 <- flsgen_generate(
  structure_str = structure,
  terrain_file = dem,
  terrain_dependency = 0.9,
  epsg = "EPSG:22174",
  connectivity = 8,
  resolution_x = 10,
  resolution_y = 10,
  x = ext(dem)$"xmin",
  y = ext(dem)$"ymax"
)

plot(landscape)
