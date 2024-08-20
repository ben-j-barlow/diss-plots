out_base <- get_all_results_df(baseline=TRUE)
hist(out_base$STD_DEV, breaks = 10, main = "Baseline STD_DEV Distribution", xlab = "STD_DEV")
visualize_plot_1(ratio=FALSE)