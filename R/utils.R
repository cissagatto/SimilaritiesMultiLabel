###############################################################################
# MULTI LABEL SIMILARITIES MEASURES - CATEGORIAL DATA - LABEL SPACE           #
# Copyright (C) 2025                                                          #
#                                                                             #
# This code is free software: you can redistribute it and/or modify it under  #
# the terms of the GNU General Public License as published by the Free        #
# Software Foundation, either version 3 of the License, or (at your option)   #
# any later version. This code is distributed in the hope that it will be     #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General    #
# Public License for more details.                                            #
#                                                                             #
# Profa. Dra. Elaine Cecilia Gatto                                            #
# Federal University of Lavras (UFLA) Campus Lavras - Minas Gerais            #
# Applied Computer Department (DAC)                                           #
#                                                                             #
# Prof. Dr. Ricardo Cerri                                                     #
#                                                                             #
# Prof. Dr. Mauri Ferrandin                                                   #
#                                                                             #
# Prof. Dr. Alan Demetrius                                                    #
# Federal University of Sao Carlos (UFSCar) Campus Sao Carlos - São Paulo     #
# Computer Department (DC)                                                    #
#
###############################################################################


FolderRoot = "~/SimilaritiesMultiLabel"
FolderScripts = paste(FolderRoot, "/R", sep="")


#' Set Global Options
#'
#' Configures global options, including Java memory allocation, error message display,
#' and scientific notation handling.
#'
#' @return None. Options are set globally in R.
set_options <- function() {
  options(java.parameters = "-Xmx64g")  # Allocate up to 64GB of memory for Java
  options(show.error.messages = TRUE)   # Ensure error messages are displayed
  options(scipen = 20)                  # Reduce scientific notation in numerical outputs
}


#' Load Datasets Information
#'
#' Reads the dataset metadata from a CSV file.
#'
#' @return A dataframe containing dataset information.
load_datasets <- function() {
  setwd(FolderRoot)  # Change working directory to root folder
  return(data.frame(read.csv("datasets-original.csv")))  # Read and return dataset metadata
}


#' Read Configuration File
#'
#' Reads a CSV configuration file and extracts necessary parameters for processing.
#'
#' @param config_file A character string specifying the path to the configuration file.
#' @param datasets A dataframe containing metadata of available datasets.
#' @return A list containing configuration parameters extracted from the file.
read_config_file <- function(config_file, datasets) {
  if (!file.exists(config_file)) {
    stop(paste("Missing Config File! Verify the following path: ", config_file))
  } else {
    cat("\n########################################")
    cat("\n# Properly loaded configuration file!  #")
    cat("\n########################################\n\n")
  }

  config <- data.frame(read.csv(config_file))  # Read config file into a dataframe
  parameters <- list()  # Initialize an empty list for parameters

  # Extract and trim configuration values
  parameters$Path.Dataset <- str_trim(config$Value[1])
  parameters$Folder.Results <- str_trim(config$Value[2])
  parameters$Path.Similarities <- str_trim(config$Value[3])
  parameters$similarity <- str_trim(config$Value[4])
  parameters$Dataset.Name <- str_trim(config$Value[5])
  parameters$Number.Dataset <- as.numeric(config$Value[6])
  parameters$Number.Folds <- as.numeric(config$Value[7])
  parameters$Number.Cores <- as.numeric(config$Value[8])
  parameters$rclone <- as.numeric(config$Value[9])
  parameters$Save.Csv.Files <- as.numeric(config$Value[10])

  # Retrieve dataset information based on the selected dataset number
  parameters$Dataset.Info <- datasets[parameters$Number.Dataset, ]

  # Print dataset info for verification
  cat("\n################################################################\n")
  print(parameters$Dataset.Info)
  cat("\n################################################################\n\n")

  return(parameters)
}


#' Create Folder if Not Exists
#'
#' This function creates a folder if it does not already exist.
#'
#' @param folderResults A character string specifying the folder path.
#' @return None. The folder is created if it does not exist.
create_folder <- function(folderResults) {
  if (!dir.exists(folderResults)) {
    dir.create(folderResults)
  }
}


#' Get Directories
#'
#' Retrieves and returns the directory structure based on given parameters.
#'
#' @param parameters A list containing configuration settings.
#' @return A list of directories.
get_directories <- function(parameters) {
  return(directories(parameters))
}


#' Process Dataset
#'
#' Checks if the dataset file exists, and if so, proceeds with copying and extracting it.
#'
#' @param datasets A dataframe containing dataset information.
#' @param parameters A list containing configuration settings, including paths.
#' @return None. Stops execution if the dataset file is missing.
process_dataset <- function(datasets, parameters) {

  str00 <- paste(parameters$Path.Dataset, "/",
                 parameters$Dataset.Name, ".tar.gz", sep = "")
  str00 <- str_remove(str00, pattern = " ")
  if (!file.exists(str00)) {
    stop(paste("The tar.gz file for the dataset to be processed does not exist! Path entered: ", str00))
  }

  str01 = paste("cp ", str00, " ", parameters$Folders$folderDatasets, sep = "")
  res01 = system(str01)
  if (res01 != 0) {
    cat("\nError: ", str01)
    break
  }

  str02 = paste("tar xzf ", parameters$Folders$folderDatasets, "/",
                parameters$Dataset.Info$Name,
                ".tar.gz -C ", parameters$Folders$folderDatasets, sep = "")
  res02 = system(str02)
  if (res02 != 0) {
    cat("\nError: ", str02)
    break
  }

  str03 = paste("cp -r ", parameters$Folders$folderDatasets, "/",
                parameters$Dataset.Info$Name,
                "/CrossValidation/* ", parameters$Folders$folderCV, sep="")
  res03 = system(str03)
  if (res03 != 0) {
    cat("\nError: ", str03)
    break
  }

  str04 = paste("cp -r ", parameters$Folders$folderDatasets, "/",
                parameters$Dataset.Info$Name,
                "/LabelSpace/* ", parameters$Folders$folderLabelSpace,
                sep="")
  res04 = system(str04)
  if (res04 != 0) {
    cat("\nError: ", str04)
    break
  }

  str05 = paste("cp -r ", parameters$Folders$folderDatasets, "/",
                parameters$Dataset.Info$Name,
                "/NamesLabels/* ", parameters$Folders$folderNamesLabels,
                sep="")
  res05 = system(str05)
  if (res04 != 0) {
    cat("\nError: ", str05)
    break
  }

  str06 = paste("rm -r ", parameters$Folders$folderDatasets,
                "/", parameters$Dataset.Info$Name, sep="")
  res06 = system(str06)
  if (res06 != 0) {
    cat("\nError: ", str06)
    break
  }

  str07 = paste("rm ",parameters$Folders$folderDatasets,
                "/", parameters$Dataset.Info$Name,
                ".tar.gz", sep = "")
  res07 = system(str07)
  if (res07 != 0) {
    cat("\nError: ", str07)
    break
  }

}

#' Save Runtime Information
#'
#' Saves the execution time of a process to a CSV file.
#'
#' @param timeTCP A system.time() object containing execution time.
#' @param parameters A list containing the folder path to save the file.
#' @return None. The runtime is saved to "Runtime.csv".
save_runtime <- function(timeTCP, parameters) {
  result_set <- t(data.matrix(timeTCP))
  setwd(parameters$Folders$folderSimilarities)
  write.csv(result_set, "Runtime.csv")
  print(timeTCP)
}


#' Clean Up Temporary Files
#'
#' Deletes temporary result folders and triggers garbage collection.
#'
#' @param directories A list containing folder paths.
#' @return None. Deletes specified directories.
clean_up <- function(parameters) {
  str2 <- paste("rm -rf ", parameters$Folders$folderDatasets, sep = "")
  print(system(str2))
  gc()
}


#' Save Results to Storage
#'
#' Saves results either to cloud storage or locally based on configuration.
#'
#' @param parameters A list containing storage configuration settings.
#' @return None. Executes appropriate storage-saving logic.
save_to_storage <- function(parameters) {
  if (parameters$rclone == 0) {
    # Save to cloud (e.g., Google Drive)
    # Implement cloud saving logic here
  } else {
    # Save locally
    save_locally(parameters)
  }
}


#' Save Locally
#'
#' Saves similarity results to a local folder and compresses them.
#'
#' @param parameters A list containing paths and similarity settings.
#' @return None. Saves the results locally and compresses them into a tar.gz file.
save_locally <- function(parameters) {

  pasta = paste(parameters$Folders$folderResults, "/",
                parameters$Dataset.Name, "-", parameters$similarity, sep="")
  if(dir.exists(pasta)==FALSE){dir.create(pasta)}

  system(paste("cp -r ", parameters$Folders$folderSimilarities, "/* ",
               parameters$Folders$folderResults, "/",
               parameters$Dataset.Name, "-",
               parameters$similarity, sep=""))

  setwd(parameters$Folders$folderResults)
  system(paste("tar -cjvf ", parameters$Folders$folderResults, "/",
               parameters$Dataset.Name, "-", parameters$similarity, ".tar.gz -C ",
               parameters$Folders$folderResults, "/",
               parameters$Dataset.Name, "-", parameters$similarity, " . ",sep=""))

  system(paste("cp -v ", parameters$Folders$folderResults, "/",
               parameters$Dataset.Info$Name,
               "-", parameters$similarity,
               ".tar.gz ",
               parameters$Folders$folderHomeSimilarities, sep=""))

  system(paste("rm -r ", parameters$Folders$folderResults, sep=""))

}


#' Final Cleanup
#'
#' Removes result folders and runs garbage collection.
#'
#' @param directories A list containing folder paths to be deleted.
#' @return None. Deletes specified directories.
final_cleanup <- function(directories) {
  str2 <- paste("rm -rf ", directories$folderResults, sep="")
  print(system(str2))
  gc()
}


#' Create Necessary Directories for the Project
#'
#' This function creates and manages all required directories for the project, ensuring that
#' the necessary folder structure exists before running further processes.
#'
#' @param parameters A list containing the key `Folder.Results`, which is the root directory for saving results.
#'
#' @return A list with paths to all created directories.
#'
#' @examples
#' params <- list(Folder.Results = "/tmp/birds")
#' directories(params)
#'
#' @export

directories <- function(parameters) {
  retorno <- list()

  # Define root directories
  FolderRoot <- "~/SimilaritiesMultiLabel"
  retorno$FolderScripts <- file.path(FolderRoot, "R")

  # Define results directory
  folderResults <- parameters$Folder.Results
  retorno$folderResults <- folderResults

  # Function to create a directory if it does not exist
  create_if_missing <- function(folder) {
    if (!dir.exists(folder)) dir.create(folder, recursive = TRUE)
    return(folder)
  }

  # Create and store dataset-related directories
  retorno$folderDatasets <- create_if_missing(file.path(folderResults, "datasets"))
  retorno$folderLabelSpace <- create_if_missing(file.path(retorno$folderDatasets, "LabelSpace"))
  retorno$folderNamesLabels <- create_if_missing(file.path(retorno$folderDatasets, "NamesLabels"))
  retorno$folderCV <- create_if_missing(file.path(retorno$folderDatasets, "CrossValidation"))
  retorno$folderCVTR <- create_if_missing(file.path(retorno$folderCV, "Tr"))
  retorno$folderCVTS <- create_if_missing(file.path(retorno$folderCV, "Ts"))
  retorno$folderCVVL <- create_if_missing(file.path(retorno$folderCV, "Vl"))
  retorno$folderSimilarities <- create_if_missing(file.path(folderResults, "Similarities"))
  retorno$folderHomeSimilarities <- create_if_missing(file.path(FolderRoot, "Similarities"))

  return(retorno)
}


#' Label Space Function
#'
#' This function separates the label space from the rest of the data to be used for calculating correlations.
#'
#' @param parameters A list containing:
#' \itemize{
#'   \item \code{Folders$folderCVTR}: Folder path containing the training data.
#'   \item \code{ds$LabelStart, ds$LabelEnd}: Column indices specifying the range of labels.
#'   \item \code{dataset_name}: Name of the dataset (used to create file names).
#'   \item \code{number_folds}: Number of folds for cross-validation.
#'   \item \code{folderResults}: Folder path where results will be saved.
#' }
#' @return A list with two elements:
#' \itemize{
#'   \item \code{NamesLabels}: Names of the label columns.
#'   \item \code{Classes}: A list containing the label spaces for each fold.
#' }
#' @examples
#' # Example usage:
#' parameters <- list(Folders = list(folderCVTR = "path/to/folder"), ds = list(LabelStart = 1, LabelEnd = 2),
#'                    dataset_name = "dataset", number_folds = 5, folderResults = "path/to/results")
#' result <- labelSpace(parameters)
#' result$NamesLabels
#' result$Classes
#'
#' @export
labelSpace <- function(parameters){

  result = list()  # Initialize the result list to store output

  # Initialize a list to store labels for each fold
  classes = list()

  # Loop through each fold (from the first to the last)
  k = 1
  while(k <= parameters$Number.Folds){

    # Change the working directory to the folder containing the training data
    setwd(parameters$Folders$folderCVTR)

    # Construct the filename for the current fold (e.g., "dataset_name-Split-Tr-1.csv")
    file_name = paste(parameters$Dataset.Name, "-Split-Tr-", k, ".csv", sep="")

    # Read the dataset corresponding to the current fold into a dataframe
    data_file = data.frame(read.csv(file_name))

    # Separate the label space from the input space
    classes[[k]] = data_file[, parameters$Dataset.Info$LabelStart:parameters$Dataset.Info$LabelEnd]

    # Get the names of the labels (column names of the label space)
    label_names = c(colnames(classes[[k]]))

    # Increment the fold counter
    k = k + 1

    # Perform garbage collection to free memory (optional but can be helpful for large datasets)
    gc()

  }  # End of the loop over the folds

  # Store the result in the return list
  result$NamesLabels = label_names
  result$Classes = classes

  # Return the final result
  return(result)

  # Perform garbage collection again before finishing (optional)
  gc()

  # Print ending message (for debugging/logging)
  cat("\n################################################################")
  cat("\n# FUNCTION LABEL SPACE: END                                    #")
  cat("\n################################################################")
  cat("\n\n\n\n")
}


#' Info Data Set Function
#'
#' This function retrieves specific information from a dataset, typically stored in a "datasets-hpmlk.csv" file.
#'
#' @param dataset A dataset object containing various attributes. The dataset should have the following columns:
#' \itemize{
#'   \item \code{ID}: Identifier for the dataset.
#'   \item \code{Name}: Name of the dataset.
#'   \item \code{Domain}: Domain of the dataset.
#'   \item \code{Instances}: Number of instances in the dataset.
#'   \item \code{Attributes}: Total number of attributes in the dataset (input + output).
#'   \item \code{Labels}: Number of labels in the dataset.
#'   \item \code{Inputs}: Number of input attributes in the dataset.
#'   \item \code{Cardinality}: The label cardinality of the dataset.
#'   \item \code{Density}: Label Density of the dataset.
#'   \item \code{LabelsSets}: The sets of labels associated with the dataset.
#'   \item \code{Single}: Boolean indicating if the dataset is single.
#'   \item \code{MaxFreq}: Maximum frequency of the dataset.
#'   \item \code{MeanIR}: The average imbalance ratio (MeanIR) of the dataset, which measures how imbalanced the dataset is.
#'   \item \code{Scumble}: Some specific metric related to the dataset.
#'   \item \code{TCS}: The TCS value of the dataset.
#'   \item \code{AttStart}: Starting index for the attributes.
#'   \item \code{AttEnd}: Ending index for the attributes.
#'   \item \code{LabelStart}: Starting index for the labels.
#'   \item \code{LabelEnd}: Ending index for the labels.
#'   \item \code{Distinct}: Distinct labels in the dataset.
#'   \item \code{xn}: xdim for Kohonen.
#'   \item \code{yn}: ydim for Kohonen.
#'   \item \code{gridn}: Grid value for Kohonen.
#'   \item \code{max.neighbor}: The maximum number of neighbors for the dataset.
#'   \item \code{LabelDependency}: Dependency between labels in the dataset.
#' }
#'
#' @return A list containing all the relevant information from the dataset, including IDs, names, attributes, and various dataset-specific metrics.
#'
#' @examples
#' # Example usage:
#' dataset <- list(ID = "1", Name = "Dataset1", Domain = "text",
#'                 Instances = 100, Attributes = "23", Labels = 3,
#'                 Inputs = 20, Cardinality = 5, Density = 0.9,
#'                 LabelsSets = 5, Single = TRUE, MaxFreq = 10,
#'                 MeanIR = 0.75, Scumble = 1.2, TCS = 2.3,
#'                 AttStart = 1, AttEnd = 20, LabelStart = 21,
#'                 LabelEnd = 23, Distinct = 10,
#'                 xn = 4, yn = 4, gridn = 16,
#'                 max.neighbor = 22, LabelDependency = 0.89)
#' result <- infoDataSet(dataset)
#' result$ID
#' result$Name
#' result$max.neighbor
#' result$LabelDependency
#'
#' @export
infoDataSet <- function(dataset) {

  # Initialize the result list
  result = list()

  # Assign each relevant dataset field to the result
  result$id = dataset$ID
  result$name = dataset$Name
  result$domain = dataset$Domain
  result$instances = dataset$Instances
  result$attributes = dataset$Attributes
  result$labels = dataset$Labels
  result$inputs = dataset$Inputs
  result$cardinality = dataset$Cardinality
  result$density = dataset$Density
  result$labelsSets = dataset$LabelsSets
  result$single = dataset$Single
  result$maxfreq = dataset$MaxFreq
  result$meanIR = dataset$MeanIR  # The average imbalance ratio
  result$scumble = dataset$Scumble
  result$tcs = dataset$TCS
  result$attStart = dataset$AttStart
  result$attEnd = dataset$AttEnd
  result$labStart = dataset$LabelStart
  result$labEnd = dataset$LabelEnd
  result$distinct = dataset$Distinct
  result$xn = dataset$xn
  result$yn = dataset$yn
  result$gridn = dataset$gridn
  result$max.neighbor = dataset$max.neighbor  # Maximum number of neighbors
  result$labelDependency = dataset$LabelDependency  # Dependency between labels

  # Return the result list
  return(result)

  # Optional garbage collection after function execution
  gc()
}

#############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com
# Thank you very much!
#############################################################################
