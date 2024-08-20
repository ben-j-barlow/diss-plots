get_baseline_timestep_multiplier <- function(n) {
  num_timesteps_baseline <- n
  num_timesteps_for_real_agent <- DISTANCE_FLOWN / VEL
  multiplier <- num_timesteps_for_real_agent / num_timesteps_baseline
  return(multiplier)
}


visualize_plot_1 <- function(ratio=TRUE) {
  p1_data <- get_plot1_data()
  
  p1_data <- get_plot1_data()
  
  if (ratio)
    p1_data <- p1_data / p1_data[1, ]
  
  row_means <- rowMeans(p1_data)
  row_sd <- apply(p1_data, 1, sd)
  
  multiplier <- get_baseline_timestep_multiplier(nrow(p1_data))  
  p1_data <- data.frame(
    LineNumber = seq(0, nrow(p1_data) * multiplier - 1, by=multiplier),
    Mean = row_means,
    SD = row_sd
  )
  n <- ncol(p1_data)
  
  p1_data$Upper <- p1_data$Mean + (p1_data$SD / sqrt(n))
  p1_data$Lower <- p1_data$Mean - (p1_data$SD / sqrt(n))
  
  title <- ifelse(ratio, "Belief std. ratio", "Belief std over time")
  max_x <- max(p1_data$LineNumber)
  

  p <- ggplot(p1_data, aes(x=LineNumber, y=Mean)) +
    geom_line(color=LINE_COLOR) +   # Plot the mean line
    geom_ribbon(aes(ymin=Lower, ymax=Upper), alpha=0.2, fill="lightblue") +  # Shaded area for SD
    theme_minimal() +
    labs(title=title, x="Timestep", y="Std.") +
    theme(
      plot.title = element_text(size=TITLE_SIZE, hjust = 0.5, family=FONT_FAMILY),  # Use constants for size and family
      text = element_text(family = FONT_FAMILY, size = TEXT_SIZE),  # Use the constant for font family in all text
    ) +
    ylim(0, NA) + # Set y-axis lower limit to 0, upper limit is automatically determined 
    geom_vline(xintercept=max_x/2, linetype = "dashed", color = DOTTED_LINE_COLOR,linewidth = 0.5)
  return(p)
}

visualize_plot_2 <- function() {
  p2_data <- get_plot2_data()
  
  row_means <- rowMeans(p2_data)
  row_sd <- apply(p2_data, 1, sd)
  
  multiplier <- get_baseline_timestep_multiplier(nrow(p2_data))
  
  p2_data <- data.frame(
    LineNumber = seq(0, nrow(p2_data) * multiplier - 1, by=multiplier),
    Mean = row_means,
    SD = row_sd
  )
  
  title <- "Belief volume RMAE"
  max_x <- max(p2_data$LineNumber)
  
  p <- ggplot(p2_data, aes(x=LineNumber, y=Mean)) +
    #geom_line(color="blue") +   # Plot the mean line
    geom_line(color=LINE_COLOR) +   # Plot the mean line
    theme_minimal() +
    labs(title=title, x="Timestep", y="RMAE") +
    theme(
      plot.title = element_text(size=TITLE_SIZE, hjust = 0.5, family=FONT_FAMILY),  # Use constants for size and family
      text = element_text(family = FONT_FAMILY, size = TEXT_SIZE),  # Use the constant for font family in all text
    ) +
    ylim(0, NA) +  # Set y-axis lower limit to 0, upper limit is automatically determined
    geom_vline(xintercept=max_x/2, linetype = "dashed", color = DOTTED_LINE_COLOR,linewidth = 0.5)
    
  return(p)
}

visualize_plot_3 <- function() {
  plot_data <- get_plot3_data()
  
  # Create the plot
  p <- ggplot(plot_data, aes(x = STD_DEV_binned, y = Count, fill = CORRECT)) +
    geom_bar(stat = "identity", position = "stack") +  # Stacked bar chart with counts as height
    facet_wrap(~ Category, ncol = 2) +  # Facet by Category with custom layout (2 columns)
    labs(
      x = "Std dev",
      y = "Count",
      title = "Accuracy split by std dev"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size=TITLE_SIZE, hjust = 0.5, family=FONT_FAMILY),  # Use constants for size and family
      text = element_text(family = FONT_FAMILY, size = TEXT_SIZE),  # Use the constant for font family in all text
      #strip.text = element_text(face = "bold"),  # Bold facet titles
      axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels for readability
      legend.position = "none"  # Remove the legend
    ) +
    scale_fill_viridis(discrete = TRUE) 
  return(p)
}


visualize_plot4 <- function() {
  plot_data <- get_plot4_data()
  
  # Create the plot
  p <- ggplot(plot_data, aes(x = N_FLY_binned, y = Count, fill = CORRECT)) +
    geom_bar(stat = "identity", position = "stack") +  # Stacked bar chart with counts as height
    facet_wrap(~ Category, ncol = 2) +  # Facet by Category with custom layout (2 columns)
    labs(
      x = "Timestep at termination",
      y = "Count",
      title = "Accuracy split by N_FLY"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = TITLE_SIZE, hjust = 0.5, family = FONT_FAMILY),  # Use constants for size and family
      text = element_text(family = FONT_FAMILY, size = TEXT_SIZE),  # Use the constant for font family in all text
      axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels for readability
      legend.position = "none"  # Remove the legend
    ) +
    scale_fill_viridis(discrete = TRUE) 
  
  return(p)
}

visualize_plot5 <- function() {
  plot_data <- get_plot5_data()
  
  # Create the plot
  p <- ggplot(plot_data, aes(x = Terminated_early, y = Count, fill = factor(CORRECT))) +
    geom_bar(stat = "identity", position = "stack") +  # Stacked bar chart with counts as height
    facet_wrap(~ Category, ncol = 2) +  # Facet by Category with custom layout (2 columns)
    labs(
      x = "Terminated early",
      y = "Count",
      title = "Accuracy split by early termination"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(size = TITLE_SIZE, hjust = 0.5, family = FONT_FAMILY),  # Use constants for size and family
      text = element_text(family = FONT_FAMILY, size = TEXT_SIZE),  # Use the constant for font family in all text
      axis.text.x = element_text(angle = 0, hjust = 1),  # Rotate x-axis labels for readability
      legend.position = "none"  # Remove the legend
    ) +
    scale_fill_viridis(discrete = TRUE) 
    
  return(p)
}


