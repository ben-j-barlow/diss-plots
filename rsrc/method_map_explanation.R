get_pb1_paths <- function() {
  dir <- "/Users/benbarlow/dev/diss-plots/help_plots/maps_to_combine/pb1/"
  
  # Define the file paths based on the seed
  image_paths <- list(
    file.path(dir, "map1.png"),
    file.path(dir, "map2.png"),
    file.path(dir, "map3.png"),
    file.path(dir, "mn.png")
  )
  
  return(image_paths)
}

get_pb3_paths <- function() {
  dir <- "/Users/benbarlow/dev/diss-plots/help_plots/maps_to_combine/pb3/"
  
  # Define the file paths based on the seed
  image_paths <- list(
    file.path(dir, "og.png"),
    file.path(dir, "perturb1.png"),
    file.path(dir, "perturb2.png"),
    file.path(dir, "perturb3.png")
  )
  
  return(image_paths)
}

visualize_pb1 <- function() {
  pb1_paths <- get_pb1_paths()
  pb1 <- combine_images_from_paths(pb1_paths)
  return(pb1)
}

visualize_pb3 <- function() {
  pb3_paths <- get_pb3_paths()
  pb3 <- combine_images_from_paths(pb3_paths)
  return(pb3)
}
