rm(list=ls())

cat("\n\n##############################################################")
cat("  \n# START COMPUTING MULTI LABEL SIMILARITIES MEASURES          #")
cat("  \n##############################################################\n\n")

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

cat("\n\n##############################################################")
cat("  \n# SML: SET WORK SPACE                                  #")
cat("  \n##############################################################\n\n")
FolderRoot = "~/SimilaritiesMultiLabel"
FolderScripts = paste(FolderRoot, "/R", sep="")

setwd(FolderScripts)
source("libraries.R")

setwd(FolderScripts)
source("utils.R")

setwd(FolderScripts)
source("run.R")

cat("\n\n######################################################")
cat("  \n# SML: OPTIONS CONFIGURATIONS                        #")
cat("  \n######################################################\n\n")
set_options()


cat("\n\n########################################################")
cat("  \n# SML: READ DATASETS                                   #")
cat("  \n########################################################\n\n")
datasets <- load_datasets()


cat("\n\n########################################################")
cat("  \n# SML: GET THE ARGUMENTS COMMAND LINE                  #")
cat("  \n########################################################\n\n")
args <- commandArgs(TRUE)

# Read config file
config_file <- args[1]

# config_file = "~/SimilaritiesMultiLabel/config-files/jaccard/smj-emotions.csv"
parameters <- read_config_file(config_file, datasets)

# Ensure the results folder exists
create_folder(parameters$Folder.Results)

cat("\n######################")
cat("\n# Get directories    #")
cat("\n######################\n")
directories <- get_directories(parameters)
parameters$Folders <- directories

cat("\n####################################################################")
cat("\n# Checking the dataset tar.gz file                                 #")
cat("\n####################################################################\n\n")
process_dataset(datasets, parameters)

cat("\n\n################################################################")
cat("  \n# SML: EXECUTE                                                 #")
cat("  \n################################################################\n\n")
timeTCP <- system.time(res <- execute(parameters))

cat("\n\n####################################################")
cat("   \n# SML: SAVE RUNTIME                               #")
cat("   \n####################################################\n\n")
save_runtime(timeTCP, parameters)

cat("\n\n##################################################################")
cat("  \n# SML: DELETING DATASET FOLDER                                  #")
cat("  \n##################################################################\n\n")
clean_up(parameters)

cat("\n\n###################################################################")
cat("   \n# SML: Save to appropriate location (cloud or machine)          #")
cat("   \n##################################################################\n\n")
save_to_storage(parameters)

cat("\n\n####################################################")
cat("  \n# SML: END                                         #")
cat("  \n####################################################\n")

rm(list = ls())

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
