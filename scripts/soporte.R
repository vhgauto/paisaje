
# tamaño ------------------------------------------------------------------

asp <- dim(r)[2]/dim(r)[1]
ancho <- 3000
alto <- round(ancho/asp)

# figura r2 ---------------------------------------------------------------

png(filename = "r2.png", width = ancho, height = alto, res = 300)
plot(r2, axes = FALSE, col = c("grey70", rainbow(21)))
dev.off()

# dependencias del terreno ------------------------------------------------

lX <- purrr::map(
  list.files(pattern = "l_", full.names = TRUE),
  rast
)

f_png <- function(x) {
  main <- paste0(
    "Dependencia del terreno: ",
    gsub("l_|\\.tif", "", basename(sources(x)))
  )
  png(
    filename = paste0("mapa_", basename(sources(x)), ".png"), width = ancho,
    height = alto, res = 300
  )
  plot(x, axes = FALSE, col = c("grey70", rainbow(21)), main = main)
  dev.off()
  print(paste0("mapa ", basename(sources(x)), " generado"))
}

purrr::walk(lX, f_png)

plot(lX[[1]], grid = TRUE, pax = list(lwd = .01))
add_grid()
