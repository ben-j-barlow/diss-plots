library(ggplot2)
library(cowplot)
library(magick)
library(grid)

generate_labels <- function(image_paths) {
  # Automatically generate labels if labels are not provided
  labels <- letters[seq_along(image_paths)]  # Generate letters 'a', 'b', 'c', etc.
  labels <- paste0("(", labels, ")")  # Convert them to '(a)', '(b)', '(c)', etc.
  return(labels)
}

combine_images_from_paths <- function(image_paths, nrow = 1, ncol = NULL, labels = generate_labels(image_paths), label_colour = "white", font_family = "times", rel_widths = NULL) {
  if (is.null(rel_widths)) {
    rel_widths <- rep(1, ncol)
  }
  # Function to read and trim whitespace from images
  read_and_trim_image <- function(image_path) {
    img <- image_read(image_path)  # Read image using magick
    img <- image_trim(img)  # Trim whitespace using magick
    img <- image_border(img, "transparent", "5x5")  # Adding uniform padding
    img <- as.raster(img)  # Convert trimmed image back to raster for plotting
    
    rasterGrob(img, interpolate=TRUE)  # Convert to grid object
  }
  
  # Load and trim the images
  image_grobs <- lapply(image_paths, read_and_trim_image)
  
  # Combine the images into a single plot
  if (is.null(labels)) {
    combined_plot <- plot_grid(plotlist = image_grobs, nrow = nrow, ncol = ncol, rel_widths = rel_widths)
  } else {
    combined_plot <- plot_grid(plotlist = image_grobs, nrow = nrow, ncol = ncol, labels = labels, rel_widths = rel_widths,
                               label_x = 0.47, label_size = LABEL_SIZE, label_colour = label_colour, label_fontfamily = font_family)
    
  }
  
  # Add extra whitespace at the top for the titles
  final_plot <- ggdraw(combined_plot) +
    theme(plot.margin = margin(5, 5, 5, 5))  # Adjust the margins if needed
  
  return(final_plot)
}
