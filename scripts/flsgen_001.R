# java
# https://www.oracle.com/java/technologies/downloads/#jdk24-windows

# install.packages("rJava")

# https://dimitri-justeau.github.io/rflsgen/

library(rflsgen)

terrain <- flsgen_terrain(200, 200)
plot(terrain)

cls_a <- flsgen_create_class_targets(
  "Class A",
  NP = c(1, 10),
  AREA = c(300, 4000),
  CA = c(1000, 5000),
  MESH = c(225, 225)
)
cls_b <- flsgen_create_class_targets(
  "Class B",
  NP = c(2, 8),
  AREA = c(200, 4000),
  PLAND = c(40, 40)
)
cls_c <- flsgen_create_class_targets(
  "Class C",
  NP = c(5, 7),
  AREA = c(800, 1200)
)
ls_targets <- flsgen_create_landscape_targets(
  nb_rows = 200,
  nb_cols = 200,
  classes = list(cls_a, cls_b, cls_c)
)

structure <- flsgen_structure(ls_targets)

landscape <- flsgen_generate(structure_str = structure)

plot(landscape)

cls_a <- flsgen_create_class_targets(
  "Class A",
  NP = c(2, 30),
  AREA = c(200, 4000),
  PLAND = c(40, 40)
)
ls_targets <- flsgen_create_landscape_targets(
  mask_raster = "mask.tif",
  classes = list(cls_a)
)



# use case 1 -------------------------------------------------------------

# https://dimitri-justeau.github.io/rflsgen/articles/UseCase1.html

shrubland <- flsgen_create_class_targets("shrubland",
  NP = c(40, 40), AREA = c(500, 3000),
  PLAND = c(20, 20)
)
savanna <- flsgen_create_class_targets("savanna",
  NP = c(30, 30), AREA = c(500, 3000),
  PLAND = c(10, 10)
)
forest <- flsgen_create_class_targets("forest",
  NP = c(20, 20), AREA = c(500, 3000),
  PLAND = c(10, 10)
)
ls_targets <- flsgen_create_landscape_targets(500, 500, list(shrubland, savanna, forest))

structure <- flsgen_structure(ls_targets)

structure_df <- jsonlite::fromJSON(structure)
for (i in 1:nrow(structure_df$classes)) {
  cat(paste(
    structure_df$classes[i, ]$name, ":",
    "\n\t number of patches", structure_df$classes[i, ]$NP,
    "\n\t smallest patch size", structure_df$classes[i, ]$SPI,
    "\n\t largest patch size", structure_df$classes[i, ]$LPI, "\n\n"
  ))
}

landscape <- flsgen_generate(structure, verbose = FALSE)
plot(landscape)

td_seq <- seq(0, 1, by = 0.1)
landscapes <- lapply(td_seq, function(td) {
  flsgen_generate(structure,
    roughness = 0.2, terrain_dependency = td,
    min_distance = 4, verbose = FALSE
  )
})

plot(landscapes[[1]])

# install.packages("landscapemetrics")
library(landscapemetrics)


# Number of patches for landscape 2 (td=0.1)
np_landscape_2 <- lsm_c_np(landscapes[[2]])
np_landscape_2[np_landscape_2$class > -1, ]

# Number of patches for landscape 10 (td=0.9)
np_landscape_10 <- lsm_c_np(landscapes[[10]])
np_landscape_10[np_landscape_10$class > -1, ]

# Proportion of landscape for landscape 3 (td=0.2)
pland_landscape_3 <- lsm_c_pland(landscapes[[3]])
pland_landscape_3[pland_landscape_3$class > -1, ]

# Proportion of landscape for landscape 9 (td=0.8)
pland_landscape_9 <- lsm_c_pland(landscapes[[9]])
pland_landscape_9[pland_landscape_9$class > -1, ]

library(NLMR)
mrf <- nlm_mosaicfield(500, 500)
plg <- nlm_planargradient(500, 500)
edg <- nlm_edgegradient(500, 500)
dg <- nlm_distancegradient(500, 500, origin = c(20, 20, 20, 20))
rand <- nlm_random(500, 500)
fbm <- nlm_fbm(500, 500)
terrains <- c(mrf, plg, edg, dg, rand, fbm)
landscapes <- lapply(terrains, function(t) {
  flsgen_generate(structure,
    terrain_file = t, terrain_dependency = 0.8,
    min_distance = 4
  )
})

# remotes::install_github("cran/RandomFieldsUtils")
# remotes::install_github("cran/RandomFields")

# options(timeout=1000)
# remotes::install_github("ropensci/NLMR")
# devtools::install_github("ropensci/landscapetools")

library(NLMR)
mrf <- nlm_mosaicfield(500, 500)
plg <- nlm_planargradient(500, 500)
edg <- nlm_edgegradient(500, 500)
dg <- nlm_distancegradient(500, 500, origin = c(20, 20, 20, 20))
rand <- nlm_random(500, 500)
fbm <- nlm_fbm(500, 500)
terrains <- c(mrf, plg, edg, dg, rand, fbm)
landscapes <- lapply(terrains, function(t) {
  flsgen_generate(structure,
    terrain_file = t, terrain_dependency = 0.8,
    min_distance = 4
  )
})

landscapes

plot(landscapes[[2]])

# puede ser --------------------------------------------------------------

# https://docs.ropensci.org/landscapetools/
# https://docs.ropensci.org/NLMR/
