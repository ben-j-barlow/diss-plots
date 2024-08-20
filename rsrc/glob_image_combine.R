library(ggplot2)
library(cowplot)
library(magick)
library(grid)


combine_images_from_paths <- function(image_paths, nrow = 1, ncol = NULL, labels = NULL, label_size = 14, label_colour = "black", font_family = "serif") {
  
  # Function to read and trim whitespace from images
  read_and_trim_image <- function(image_path) {
    img <- image_read(image_path)  # Read image using magick
    img <- image_trim(img)  # Trim whitespace using magick
    img <- as.raster(img)  # Convert trimmed image back to raster for plotting
    rasterGrob(img, interpolate=TRUE)  # Convert to grid object
  }
  
  # Load and trim the images
  image_grobs <- lapply(image_paths, read_and_trim_image)
  
  # Combine the images into a single plot
  combined_plot <- plot_grid(plotlist = image_grobs, nrow = nrow, ncol = ncol, labels = labels,
                             label_x = 0.47, label_size = TEXT_SIZE, label_colour = label_colour, label_fontfamily = font_family)
  
  # Add extra whitespace at the top for the titles
  final_plot <- ggdraw(combined_plot) +
    theme(plot.margin = margin(10, 10, 10, 10))  # Adjust the margins if needed
  
  return(final_plot)
}