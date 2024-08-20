library(svglite)
library(viridis)
library(viridisLite)

BASELINE_NUM_LINES <- 10
GRID_DIM <- 48
GRID_LENGTH <- 50
DISTANCE_FLOWN <- BASELINE_NUM_LINES * GRID_LENGTH * GRID_DIM
VEL <- 60

DIR <- '/Users/benbarlow/dev/diss-plots/plots/experiments/'

source("~/dev/diss-plots/rsrc/exper_plots.R")
source("~/dev/diss-plots/rsrc/exper_intelligent.R")
source("~/dev/diss-plots/rsrc/exper_baseline.R")
source("~/dev/diss-plots/rsrc/glob_handle_info.R")
source("~/dev/diss-plots/rsrc/glob_config.R")

p1 <- visualize_plot_1()
ggsave(p1, filename = get_filepath(DIR, "plot1.svg"),height = 2.5, width = 3.5, units = "in")

p2 <- visualize_plot_2()
ggsave(p2, filename = get_filepath(DIR, "plot2.svg"),height = 2.5, width = 3.5, units = "in")

p3 <- visualize_plot_3()
ggsave(p3, filename = get_filepath(DIR, "plot3.svg"),height = 3, width = 3, units = "in")

p4 <- visualize_plot4()
ggsave(p4, filename = get_filepath(DIR, "plot4.svg"),height = 3, width = 3, units = "in")

p5 <- visualize_plot5()
ggsave(p5, filename = get_filepath(DIR, "plot5.svg"),height = 3, width = 2, units = "in")