
options(
  java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx36g")
)
gc()

# paquetes ---------------------------------------------------------------

t1 <- Sys.time()

library(landscapemetrics)
library(NLMR)
library(rflsgen)
library(terra)

# Suquía -----------------------------------------------------------------

# https://dimitri-justeau.github.io/rflsgen/articles/UseCase3.html

# LULC
r <- rast("rasters/r.tif")
d <- data.frame(
  id = 1:22, cover = LETTERS[1:22]
)
levels(r) <- d
plot(r, axes = FALSE, col = rainbow(22))

# DEM
dem <- rast("rasters/dem.tif")

# elijo las clases del LULC
struct <- flsgen_extract_structure_from_raster(
  raster_file = r,
  focal_classes = c(1, 2, 3),
  connectivity = 4
)

r2 <- flsgen_generate(
  struct,
  terrain_file = dem,
  terrain_dependency = 0.9,
  epsg = "EPSG:22174",
  connectivity = 8,
  resolution_x = res(r)[1],
  resolution_y = res(r)[2],
  x = ext(dem)$"xmin",
  y = ext(dem)$"ymax"
)

plot(r2, axes = FALSE, col = c("black", rainbow(21)))
writeRaster(r2, "rasters/r2.tif", overwrite = TRUE)

dependencia_terr <- c(.25, .5, .75, 1)

l <- purrr::map(
  dependencia_terr,
  \(x) {
    print(x)
    flsgen_generate(
      struct,
      terrain_file = dem,
      terrain_dependency = x,
      epsg = "EPSG:22174",
      connectivity = 8,
      resolution_x = res(r)[1],
      resolution_y = res(r)[2],
      x = ext(dem)$"xmin",
      y = ext(dem)$"ymax"
    )
  }
)

l

purrr::walk2(
  dependencia_terr,
  l,
  \(x, y) {
    writeRaster(
      y,
      file = paste0("rasters/l_", format(round(x, 2), nsamll = 2), ".tif"),
      overwrite = TRUE
    )
  }
)

# métricas del paisaje
# todos iguales

ll <- purrr::map(
  list.files(
    path = "rasters/",
    pattern = "l_",
    full.names = TRUE
  ),
  rast
)

# Number of patches (Aggregation metric)
np_landscape_1 <- lsm_c_np(ll[[1]])
dplyr::filter(np_landscape_1, class != -1)

np_landscape_2 <- lsm_c_np(ll[[2]])
dplyr::filter(np_landscape_2, class != -1)

np_landscape_3 <- lsm_c_np(ll[[3]])
dplyr::filter(np_landscape_3, class != -1)

np_landscape_4 <- lsm_c_np(ll[[4]])
dplyr::filter(np_landscape_4, class != -1)

# neutral landscape models (NLM) ------------------------------------------

# "https://dimitri-justeau.github.io/rflsgen/articles/UseCase1.html#using-external-raster-continuous-raster-gradients"

# Simulates an edge-gradient neutral landscape model.
edg <- nlm_edgegradient(dim(r)[2], dim(r)[1])
plot(edg)

edg_r <- flsgen_generate(
  structure_str = struct,
  terrain_file = edg,
  terrain_dependency = 0.8,
  epsg = "EPSG:22174",
  min_distance = 4,
  resolution_x = res(r)[1],
  resolution_y = res(r)[2],
  x = ext(dem)$"xmin",
  y = ext(dem)$"ymax"
)
plot(edg_r)

edg_landscape <- lsm_c_np(edg_r)
dplyr::filter(edg_landscape, class != -1)

# Simulates a spatially random neutral landscape model with values drawn a uniform distribution.
rand <- nlm_random(dim(r)[2], dim(r)[1])
plot(rand)

rand_r <- flsgen_generate(
  structure_str = struct,
  terrain_file = rand,
  terrain_dependency = 0.8,
  epsg = "EPSG:22174",
  min_distance = 4,
  resolution_x = res(r)[1],
  resolution_y = res(r)[2],
  x = ext(dem)$"xmin",
  y = ext(dem)$"ymax"
)
plot(rand_r)

rand_landscape <- lsm_c_np(rand_r)
dplyr::filter(rand_landscape, class != -1)

writeRaster(edg_r, "edg_r.tif", overwrite = TRUE)
writeRaster(rand_r, "rand_r.tif", overwrite = TRUE)

# tiempo ------------------------------------------------------------------

t2 <- Sys.time()
tiempo <- t2 - t1
# Time difference of 28.0138 mins
