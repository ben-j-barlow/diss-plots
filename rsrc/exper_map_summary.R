get_seed_summary_paths <- function(seed, baseline) {
  dir <- get_results_dir(baseline=baseline)
  
  # Define the file paths based on the seed
  image_paths <- list(
    file.path(dir, paste0("trial_", seed, "_smooth_trajectory_no_title.png")),
    file.path(dir, paste0("trial_", seed, "_ore_map.png")),
    file.path(dir, paste0("trial_", seed, "_beliefmn.png")),
    file.path(dir, paste0("trial_", seed, "_beliefstd.png"))
  )
  
  return(image_paths)
}

plot_seed_summary <- function(seed, baseline) {
  image_paths <- get_seed_summary_paths(seed, baseline)
  
  # Use the general function to combine these images
  combined_plot <- combine_images_from_paths(
    image_paths = image_paths,
    nrow = 1,  # 1 row
    ncol = 4,  # 4 columns
    labels = c("(a)", "(b)", "(c)", "(d)"),
    label_size = LABEL_SIZE,
    label_colour = "white",
    font_family = "Times New Roman"
  )
  
  return(combined_plot)
}