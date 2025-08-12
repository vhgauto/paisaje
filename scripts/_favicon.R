p <- terra::vect(data.frame(x = 0, y = 0), geom = c("x", "y"))
b <- terra::buffer(p, width = 100, quadsegs = 2500)

png(
  filename = "extras/favicon.png",
  width = 1000,
  height = 1000,
  units = "px",
  res = 300
)

par(mar = c(0, 0, 0, 0), mai = c(0, 0, 0, 0), bg = "transparent")

terra::plot(b, border = NA, col = "#8E063B", axes = FALSE)

dev.off()
