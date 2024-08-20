library(hash)

extract_value <- function(line, keyword) {
  pattern <- paste0(keyword, ":\\s*(.*)")
  match_result <- regmatches(line, regexec(pattern, line))
  
  if (length(match_result[[1]]) > 1) {
    return(match_result[[1]][2])
  } else {
    return(NULL)
  }
}

get_all_results_dict <- function(baseline=TRUE, dir=NULL) {
  # Initialize hash tables (equivalent to dictionaries in Julia) to store extracted values
  DIS_RETURN <- hash()
  ORES <- hash()
  N_FLY <- hash()
  FINAL_ACTION <- hash()
  MEAN <- hash()
  STD_DEV <- hash()
  EX_COST <- hash()
  
  if (is.null(dir)) {
    dir <- get_results_dir(baseline=baseline)
  }
  
  txt_files <- list.files(path=dir, pattern="*.txt", full.names=TRUE)
  
  for (file in txt_files) {
    current_seed <- NULL
    con <- file(file, "r")
    
    while (length(line <- readLines(con, n=1, warn=FALSE)) > 0) {
      if (grepl("Seed", line)) {
        current_seed <- as.integer(extract_value(line, "Seed"))
      } else if (grepl("Extraction cost", line)) {
        EX_COST[[as.character(current_seed)]] <- as.numeric(extract_value(line, "Extraction cost"))
      } else if (grepl("Mean", line)) {
        MEAN[[as.character(current_seed)]] <- as.numeric(extract_value(line, "Mean"))
      } else if (grepl("Std", line)) {
        STD_DEV[[as.character(current_seed)]] <- as.numeric(extract_value(line, "Std"))
      } else if (grepl("Massive", line)) {
        ORES[[as.character(current_seed)]] <- as.integer(extract_value(line, "Massive"))
      } else if (grepl("Fly", line)) {
        N_FLY[[as.character(current_seed)]] <- as.integer(extract_value(line, "Fly"))
      } else if (grepl("Decision", line)) {
        FINAL_ACTION[[as.character(current_seed)]] <- extract_value(line, "Decision")
      } else if (grepl("Reward", line)) {
        DIS_RETURN[[as.character(current_seed)]] <- as.numeric(extract_value(line, "Reward"))
      }
    }
    
    close(con)
  }
  
  return(list(DIS_RETURN=DIS_RETURN, ORES=ORES, N_FLY=N_FLY, FINAL_ACTION=FINAL_ACTION, MEAN=MEAN, STD_DEV=STD_DEV, EX_COST=EX_COST))
}

get_single_trial_info <- function(file) {
  lines <- readLines(file)
  
  # Initialize variables
  seed <- NA
  mean_val <- NA
  std_dev <- NA
  massive <- NA
  extraction_cost <- NA
  decision <- NA
  fly <- NA
  reward <- NA
  
  # Loop through each line and extract the information
  for (line in lines) {
    if (grepl("Seed:", line)) {
      seed <- as.integer(sub("Seed:\\s*", "", line))
    } else if (grepl("Mean:", line)) {
      mean_val <- as.numeric(sub("Mean:\\s*", "", line))
    } else if (grepl("Std:", line)) {
      std_dev <- as.numeric(sub("Std:\\s*", "", line))
    } else if (grepl("Massive:", line)) {
      massive <- as.integer(sub("Massive:\\s*", "", line))
    } else if (grepl("Extraction cost:", line)) {
      extraction_cost <- as.numeric(sub("Extraction cost:\\s*", "", line))
    } else if (grepl("Decision:", line)) {
      decision <- sub("Decision:\\s*", "", line)
    } else if (grepl("Fly:", line)) {
      fly <- as.integer(sub("Fly:\\s*", "", line))
    } else if (grepl("Reward:", line)) {
      reward <- as.numeric(sub("Reward:\\s*", "", line))
    }
  }
  
  # Return the extracted values as a list
  return(list(
    seed = seed,
    mean_val = mean_val,
    std_dev = std_dev,
    massive = massive,
    extraction_cost = extraction_cost,
    decision = decision,
    fly = fly,
    reward = reward
  ))
}

get_all_results <- function(baseline=TRUE, dir=NULL) {
  # Initialize vectors to store extracted values
  DIS_RETURN <- numeric()
  ORES <- integer()
  N_FLY <- integer()
  FINAL_ACTION <- character()
  MEAN <- numeric()
  STD_DEV <- numeric()
  EX_COST <- numeric()
  
  if (is.null(dir)) {
    dir <- get_results_dir(baseline=baseline)
  }
  
  txt_files <- list.files(path=dir, pattern="*.txt", full.names=TRUE)
  
  for (file in txt_files) {
    trial_info <- get_single_trial_info(file)
    
    # Append the extracted values to the respective vectors
    DIS_RETURN <- c(DIS_RETURN, trial_info$reward)
    ORES <- c(ORES, trial_info$massive)
    N_FLY <- c(N_FLY, trial_info$fly)
    FINAL_ACTION <- c(FINAL_ACTION, trial_info$decision)
    MEAN <- c(MEAN, trial_info$mean_val)
    STD_DEV <- c(STD_DEV, trial_info$std_dev)
    EX_COST <- c(EX_COST, trial_info$extraction_cost)
  }
  
  return(list(
    DIS_RETURN=DIS_RETURN,
    ORES=ORES,
    N_FLY=N_FLY,
    FINAL_ACTION=FINAL_ACTION,
    MEAN=MEAN,
    STD_DEV=STD_DEV,
    EX_COST=EX_COST
  ))
}

get_all_results_df <- function(baseline=TRUE, dir=NULL) {
  # Initialize an empty data frame
  results_df <- data.frame()
  
  if (is.null(dir)) {
    dir <- get_results_dir(baseline=baseline)
  }
  
  txt_files <- list.files(path=dir, pattern="*info.txt", full.names=TRUE)
  
  for (file in txt_files) {
    trial_info <- get_single_trial_info(file)
    
    # Create a new row with the extracted values
    new_row <- data.frame(
      DIS_RETURN = trial_info$reward,
      ORES = trial_info$massive,
      N_FLY = trial_info$fly,
      FINAL_ACTION = trial_info$decision,
      MEAN = trial_info$mean_val,
      STD_DEV = trial_info$std_dev,
      EX_COST = trial_info$extraction_cost,
      row.names = trial_info$seed
    )
    
    # Append the row to the data frame
    results_df <- rbind(results_df, new_row)
  }
  
  results_df <- results_df %>%
    # Create the CORRECT column
    mutate(
      CORRECT = (ORES >= EX_COST & FINAL_ACTION == "mine") | (ORES < EX_COST & FINAL_ACTION == "abandon"),
      # Create the Category column based on the conditions shown in your screenshot
      Category = case_when(
        ORES <= EX_COST - 20 ~ "Unprofitable (highly)",
        ORES > EX_COST - 20 & ORES <= EX_COST ~ "Unprofitable (borderline)",
        ORES > EX_COST & ORES <= EX_COST + 20 ~ "Profitable (borderline)",
        ORES > EX_COST + 20 ~ "Profitable (highly)"
      )
    )
  
  
  return(results_df)
}

extract_numbers <- function(s) {
  matches <- gregexpr("\\d+", s)
  return(as.integer(unlist(regmatches(s, matches))))
}

get_uncompleted_seeds <- function(baseline=TRUE) {
  seeds_done <- get_completed_seeds(baseline=baseline)
  all_seeds <- get_all_seeds()
  return(setdiff(all_seeds, seeds_done))
}

get_completed_seeds <- function(baseline=TRUE, dir=NULL) {
  dir <- get_results_dir(baseline=baseline)
  filenames <- list.files(dir)
  all_numbers <- integer()
  
  for (filename in filenames) {
    numbers <- extract_numbers(filename)
    all_numbers <- c(all_numbers, numbers)
  }
  
  return(unique(all_numbers))
}

get_results_dir <- function(baseline=TRUE) {
  if (baseline) {
    dir <- "/Users/benbarlow/dev/MineralExploration/data/experiments/baseline/"
  } else {
    dir <- "/Users/benbarlow/dev/MineralExploration/data/experiments/intelligent/"
  }
  return(dir)
}


get_files <- function(ptn, baseline=TRUE, dir=NULL) {
  if (is.null(dir)) {
    dir <- get_results_dir(baseline=baseline)
  }
  
  # List files in the directory matching the pattern
  files <- list.files(path=dir, pattern=ptn, full.names=TRUE)
  
  # order files
  files <- files[order(as.numeric(gsub("[^0-9]", "", files)))]
  return(files)
}

get_filepath <- function(dir, filename) {
  return(paste0(dir, filename))
}