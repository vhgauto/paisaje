
r2 <- project(r, "EPSG:22174")
ext(r2) <- ext(dem)

plot(r2, legend = FALSE)
plot(dem, legend = FALSE)


r3 <- project(r2, dem)

r3
dem

dim(r3)
dim(dem)

plot(r3, legend = FALSE)
plot(dem, legend = FALSE)

ext(r3)
ext(dem)

r4 <- crop(r3, dem, mask = TRUE)

plot(r4, legend = FALSE)
plot(dem, legend = FALSE)

levels(r4) <- d
coltab(r4) <- col_df

plot(r4)

writeRaster(r4, "datos/r.tif", overwrite = TRUE)
