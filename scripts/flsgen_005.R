
options(
  java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx36g")
)
gc()

# paquetes ---------------------------------------------------------------

library(tidyverse)
library(landscapemetrics)
library(NLMR)
library(rflsgen)
library(terra)

# Suquía -----------------------------------------------------------------

# https://dimitri-justeau.github.io/rflsgen/articles/UseCase3.html

# LULC
r <- rast("datos/r.tif")

# leo categorías de LULC y agrego colores
d <- read_delim(
  file = "datos/LULCcode.txt",
  delim = "$ ",
  col_names = c("value"),
  show_col_types = FALSE
) |>
  separate_wider_delim(
    delim = " ",
    cols = value,
    names = c("value", "tipo"),
    too_many = "merge"
  ) |>
  mutate(value = as.integer(value)) |>
  filter(value != 0) |>
  mutate(col = viridis::viridis(7))

col_df <- d |>
  select(-tipo) |>
  as.data.frame()

# incorporo categorías y colores
levels(r) <- d
coltab(r) <- col_df

# figura
plot(
  r, axes = FALSE, mar = c(1, 1, 1, 8)
)

# DEM
dem <- rast("datos/dem.tif")

# elijo las clases del LULC
struct <- flsgen_extract_structure_from_raster(
  raster_file = r,
  focal_classes = c(10), # 10 20 30 40 50 60 80
  connectivity = 4
)

r2 <- flsgen_generate(
  struct,
  terrain_file = dem,
  terrain_dependency = .9,
  epsg = "EPSG:22174",
  connectivity = 4,
  resolution_x = res(r)[1],
  resolution_y = res(r)[2],
  x = ext(dem)$"xmin",
  y = ext(dem)$"ymax"
)

# OK
# focal_classes = 10, 20
# connectivity = 4

# OK
# focal_classes = 10, 20, 30
# connectivity = 4

# OK
# focal_classes = 10, 20, 30, 40
# connectivity = 4

# XXXX
# focal_classes = 10, 20, 30, 40, 50
# connectivity = 4

# XXXX
# focal_classes = 10, 20, 30, 40, 50
# connectivity = 8

# Error en flsgen_generate(struct, terrain_file = dem, terrain_dependency = 0.9, :
# Could not generate a raster satisfying the input landscape structure

plot(r2)

r3 <- r2
plot(r3)
