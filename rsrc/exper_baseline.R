library(ggplot2)


get_plot1_data <- function(baseline=TRUE, dir=NULL, ratio=FALSE) {
  # List files in the directory matching the pattern
  files <- get_files(ptn="*_std_history.txt", dir=dir, baseline=baseline)
  data <- read_mn_std_files(files)
  return(data)
}



read_mn_std_files <- function(files) {
  # Initialize a list to store all the values by line
  all_values <- list()
  
  # Loop through each file to read the data
  for (file in files) {
    # Read the lines and parse them as numeric
    values <- as.numeric(readLines(file))
    
    # Append the values to the respective line index in the all_values list
    for (i in seq_along(values)) {
      if (length(all_values) < i) {
        all_values[[i]] <- numeric(0)  # Initialize as an empty numeric vector
      }
      all_values[[i]] <- c(all_values[[i]], values[i])
    }
  }
  
  # Return dataframe of values
  to_return <- t(data.frame(all_values)) # rows are timesteps, trials are columns
  
  rownames(to_return) <- seq_along(to_return[, 1])
  
  return(to_return)
}

get_plot2_data <- function() {
  seeds <- get_completed_seeds(baseline=TRUE)
  
  all_r_massive <- list()
  all_means <- list()
  
  i <- 1
  
  for (seed in seeds) {
    # get r massive from info
    name <- paste0("trial_", seed, "_info.txt")
    file <- get_files(ptn=name, baseline=TRUE)[1]
    trial_info <- get_single_trial_info(file)
    r_mass <- trial_info$massive
    all_r_massive[[i]] <- r_mass
    
    # get means
    name <- paste0("trial_", seed, "_mn_history.txt")
    file <- get_files(ptn=name, baseline=TRUE)[1]
    data <- read_mn_std_files(file)
    
    # push to list
    all_means[[i]] <- data
    
    # increment
    i <- i + 1
  }
  
  all_means <- as.matrix(as.data.frame(all_means)) # convert to df
  all_r_massive <- unlist(all_r_massive) # convert to vector
  
  relative_mean_abs_error <- all_means
  
  # Loop through each row and normalize it
  for (j in 1:ncol(all_means)) {
    relative_mean_abs_error[,j] <- abs((all_means[,j] - all_r_massive[j]) / all_r_massive[j])
  }
  return(relative_mean_abs_error)
}