library(dplyr)
library(ggplot2)





get_plot3_data <- function() {
  results_df <- get_all_results_df(baseline=FALSE)
  # Define custom bins
  plot_data <- results_df %>%
    mutate(
      # Manually define the bins using cut() with custom breakpoints
      STD_DEV_binned = cut(STD_DEV, breaks = c(-Inf, 25, 45, 65, Inf), 
                           labels = c("< 25", "< 45", "< 65", "> 65"))
    ) %>%
    group_by(STD_DEV_binned, Category, CORRECT) %>%
    summarise(Count = n(), .groups = "drop") %>%
    # Order the Category levels for desired facet order
    mutate(Category = factor(Category, levels = c(
      "Profitable (highly)", "Profitable (borderline)", 
      "Unprofitable (borderline)", "Unprofitable (highly)"
    )))
  return(plot_data)
}

get_plot4_data <- function() {
  results_df <- get_all_results_df(baseline=FALSE)
  
  # Define custom bins for N_FLY
  plot_data <- results_df %>%
    mutate(
      # Manually define the bins using cut() with adjusted breakpoints
      N_FLY_binned = cut(N_FLY, breaks = c(-Inf, 100, 150, 200, 250, 251), 
                         labels = c("< 100", "< 150", "< 200", "< 251", "= 251"), right = TRUE)
    ) %>%
    group_by(N_FLY_binned, Category, CORRECT) %>%
    summarise(Count = n(), .groups = "drop") %>%
    # Order the Category levels for desired facet order
    mutate(Category = factor(Category, levels = c(
      "Profitable (highly)", "Profitable (borderline)", 
      "Unprofitable (borderline)", "Unprofitable (highly)"
    )))
  
  return(plot_data)
}

get_plot5_data <- function() {
  results_df <- get_all_results_df(baseline=FALSE)
  
  # Define a new column 'Terminated_early' based on N_FLY values
  plot_data <- results_df %>%
    mutate(
      Terminated_early = ifelse(N_FLY < 251, "No", "Yes")
    ) %>%
    group_by(Terminated_early, Category, CORRECT) %>%
    summarise(Count = n(), .groups = "drop") %>%
    # Order the Category levels for desired facet order
    mutate(Category = factor(Category, levels = c(
      "Profitable (highly)", "Profitable (borderline)", 
      "Unprofitable (borderline)", "Unprofitable (highly)"
    )))
  
  return(plot_data)
}
