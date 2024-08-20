plot_intelligent_illustration <- function() {
  dir <- "/Users/benbarlow/dev/diss-plots/help_plots/illustrative/intelligent"
  
  init_paths <- list(
    file.path(dir, "0smooth_map.png"),
    file.path(dir, "0b.png"),
    file.path(dir, "0bstd.png"),
    file.path(dir, "0volume.png")
  )
  
  timestep_paths <- function(t) {
    list(
      file.path(dir, paste0(t, "trajectory.png")),
      file.path(dir, paste0(t, "b.png")),
      file.path(dir, paste0(t, "bstd.png")),
      file.path(dir, paste0(t, "volume.png"))
    )
  }
  
  # combine t = 0, t=20,t=25, t=35
  timesteps <- c(20, 25, 35)
  non_zero_paths <- unlist(lapply(timesteps, timestep_paths), recursive = TRUE)
  all_paths <- c(unlist(init_paths), non_zero_paths)
  
  p <- combine_images_from_paths(
    all_paths, 
    nrow=4, 
    ncol=4,
    labels=NULL,
    rel_widths = c(1,1,1,2)
  )
  return(p)
}
