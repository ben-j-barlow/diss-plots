source("~/dev/diss-plots/rsrc/glob_image_combine.R")
source("~/dev/diss-plots/rsrc/exper_map_summary.R")

DIR <- '/Users/benbarlow/dev/diss-plots/plots/methods/'


seed <- 15371
plot1 <- plot_seed_summary(seed = seed, baseline = FALSE)
path <- get_filepath(DIR, paste0("seed_", seed, "_summary.png"))
ggsave(plot1, filename = path, height = 2, width = 8, units = "in")

