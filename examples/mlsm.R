rm(list=ls())

cat("\n\n##############################################################")
  cat("\n# START COMPUTING MULTI LABEL SIMILARITIES MEASURES          #")
  cat("\n##############################################################\n\n")

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
  cat("\n# MLSM: SET WORK SPACE                                  #")
  cat("\n##############################################################\n\n")
FolderRoot = "~/SimilaritiesMultiLabel"
FolderScripts = paste(FolderRoot, "/R", sep="")


cat("\n\n##############################################################")
  cat("\n# MLSM: LOAD SOURCES                                    #")
  cat("\n##############################################################\n\n")

setwd(FolderScripts)
source("libraries.R")

setwd(FolderScripts)
source("utils.R")

setwd(FolderScripts)
source("run.R")


cat("\n\n##############################################################")
  cat("\n# MLSM: OPTIONS CONFIGURATIONS                          #")
  cat("\n##############################################################\n\n")
options(java.parameters = "-Xmx64g")
options(show.error.messages = TRUE)
options(scipen=20)


cat("\n\n##############################################################")
  cat("\n# MLSM: READ DATASETS                                   #")
  cat("\n##############################################################\n\n")
setwd(FolderRoot)
datasets <- data.frame(read.csv("datasets-original.csv"))

# ncol(datasets)
# nrow(datasets)
# colnames(datasets)


cat("\n\n##############################################################")
  cat("\n# MLSM: GET THE ARGUMENTS COMMAND LINE                  #")
  cat("\n##############################################################\n\n")
args <- commandArgs(TRUE)



#############################################################################
# FIRST ARGUMENT: getting specific dataset information being processed      #
# from csv file                                                             #
#############################################################################

config_file <- args[1]
# config_file = "~/SimilaritiesMultiLabel/config-files/jaccard/smj-emotions.csv"

if(file.exists(config_file)==FALSE){
  cat("\n################################################################")
  cat("\n# Missing Config File! Verify the following path:              #")
  cat("\n# ", config_file, "                                            #")
  cat("\n################################################################\n\n")
  break
} else {
  cat("\n########################################")
  cat("\n# Properly loaded configuration file!  #")
  cat("\n########################################\n\n")
}


cat("\n########################################")
cat("\n# PARAMETERS READ                    #\n")
config = data.frame(read.csv(config_file))
print(config)
cat("\n########################################\n\n")

parameters = list()

# DATASET_PATH
dataset_path = toString(config$Value[1])
dataset_path = str_remove(dataset_path, pattern = " ")
parameters$Path.Dataset = dataset_path

# TEMPORARTY_PATH
folderResults = toString(config$Value[2])
folderResults = str_remove(folderResults, pattern = " ")
parameters$Folder.Results = folderResults

# SIMILARITIES_PATH
Similarities_Path = toString(config$Value[3])
Similarities_Path = str_remove(Similarities_Path, pattern = " ")
parameters$Path.Similarities = Similarities_Path

# SIMILARITY
similarity = toString(config$Value[4])
similarity = str_remove(similarity, pattern = " ")
parameters$similarity = similarity

# DATASET_NAME
dataset_name = toString(config$Value[5])
dataset_name = str_remove(dataset_name, pattern = " ")
parameters$Dataset.Name = dataset_name

# DATASET_NAME
number_dataset = as.numeric(config$Value[6])
parameters$Number.Dataset = number_dataset

# NUMBER_FOLDS
number_folds = as.numeric(config$Value[7])
parameters$Number.Folds = number_folds

# NUMBER_CORES
number_cores = as.numeric(config$Value[8])
parameters$Number.Cores = number_cores

# R CLONE
rclone = as.numeric(config$Value[9])
parameters$rclone = rclone

# DATASET_INFO
ds = datasets[number_dataset,]
parameters$Dataset.Info = ds


cat("\n################################################################\n")
print(ds)
cat("\n# DATASET PATH: \t", dataset_path)
cat("\n# TEMPORARY PATH: \t", folderResults)
cat("\n# SIMILARITIES PATH: \t", Similarities_Path)
cat("\n# SIMILARITY:  \t", similarity)
cat("\n# DATASET NAME:  \t", dataset_name)
cat("\n# NUMBER DATASET: \t", number_dataset)
cat("\n# NUMBER X-FOLDS CROSS-VALIDATION: \t", number_folds)
cat("\n# NUMBER CORES: \t", number_cores)
cat("\n# RCLONE: \t", rclone)
cat("\n################################################################\n\n")


###############################################################################
# Creating temporary processing folder                                        #
###############################################################################
if(dir.exists(folderResults) == FALSE) {dir.create(folderResults)}



###############################################################################
# Creating all directories that will be needed for code processing            #
###############################################################################
cat("\n######################")
cat("\n# Get directories    #")
cat("\n######################\n")
diretorios <- directories(parameters)
print(diretorios)
cat("\n\n")


#####################################
parameters$Folders = diretorios
#####################################


###############################################################################
# Copying datasets from ROOT folder on server                                 #
###############################################################################

cat("\n####################################################################")
cat("\n# Checking the dataset tar.gz file                                 #")
cat("\n####################################################################\n\n")
str00 = paste(dataset_path, "/", ds$Name,".tar.gz", sep = "")
str00 = str_remove(str00, pattern = " ")

if(file.exists(str00)==FALSE){

  cat("\n######################################################################")
  cat("\n# The tar.gz file for the dataset to be processed does not exist!    #")
  cat("\n# Please pass the path of the tar.gz file in the configuration file! #")
  cat("\n# The path entered was: ", str00, "                                  #")
  cat("\n######################################################################\n\n")
  break

} else {

  # COPIANDO
  str01 = paste("cp ", str00, " ", diretorios$folderDatasets, sep = "")
  res = system(str01)
  if (res != 0) {
    cat("\nError: ", str01)
    break
  }
  
  # DESCOMPACTANDO
  str02 = paste("tar xzf ", diretorios$folderDatasets, "/", ds$Name,
                ".tar.gz -C ", diretorios$folderDatasets, sep = "")
  res = system(str02)
  if (res != 0) {
    cat("\nError: ", str02)
    break
  }

  str29 = paste("cp -r ", diretorios$folderDatasets, "/", ds$Name,
                "/CrossValidation/* ", diretorios$folderResults,
                "/datasets/CrossValidation/", sep="")
  res=system(str29)
  #if(res!=0){break}else{cat("\ncopiou")}

  str30 = paste("cp -r ",diretorios$folderDatasets, "/", ds$Name,
                "/LabelSpace/* ", diretorios$folderResults,
                "/datasets/LabelSpace/", sep="")
  res=system(str30)
  #if(res!=0){break}else{cat("\ncopiou")}

  str31 = paste("cp -r ", diretorios$folderDatasets, "/", ds$Name,
                "/NamesLabels/* ", diretorios$folderResults,
                "/datasets/NamesLabels/", sep="")
  res=system(str31)
  #if(res!=0){break}else{cat("\ncopiou")}

  str32 = paste("rm -r ", diretorios$folderResults,
                "/datasets/", ds$Name, sep="")
  print(system(str32))
  #if(res!=0){break}else{cat("\napagou")}

  #APAGANDO
  str03 = paste("rm ", diretorios$folderDatasets, "/", ds$Name,
                ".tar.gz", sep = "")
  res = system(str03)

  cat("\n####################################################################")
  cat("\n# tar.gz file of the DATASET loaded correctly!                     #")
  cat("\n####################################################################\n\n")


}


cat("\n\n################################################################")
cat("\n# MLSM: EXECUTE                                                  #")
  cat("\n################################################################\n\n")
timeTCP = system.time(res <- execute(parameters))


cat("\n\n####################################################")
cat("\n# MLSM: SAVE RUNTIME                                     #")
  cat("\n####################################################\n\n")
result_set <- t(data.matrix(timeTCP))
setwd(parameters$Folders$folderSimilarities)
write.csv(result_set, "Runtime.csv")
print(timeTCP)
cat("\n")



cat("\n\n###################################################################")
cat("\n# MLSM: DELETING DATASET FOLDER                                         #")
  cat("\n###################################################################\n\n")
str2 = paste("rm -rf ", parameters$Folders$folderDatasets, sep="")
print(system(str2))
gc()

if(parameters$rclone==0){
  # saves to cloud
  
} else {
  # saves in the machine
  
}


pasta = paste(parameters$Folders$folderResults, "/",
              parameters$Dataset.Name, "-", similarity, sep="")
if(dir.exists(pasta)==FALSE){dir.create(pasta)}

system(paste("cp -r ", parameters$Folders$folderSimilarities, "/* ",
             parameters$Folders$folderResults, "/",
             parameters$Dataset.Name, "-", similarity, sep=""))

system(paste("rm -r ", parameters$Folders$folderSimilarities, sep=""))

setwd(parameters$Folders$folderResults)
system(paste("tar -zcf ", parameters$Folders$folderResults, "/",
             parameters$Dataset.Name, "-", similarity, ".tar.gz ",
             parameters$Folders$folderResults, "/",
             parameters$Dataset.Name, "-", similarity, 
             sep=""))

Folder = "~/SimilaritiesMultiLabel/Similarity-Matrices"
if(dir.exists(Folder)== FALSE){dir.create(Folder)}

FolderS = paste(Folder, "/", similarity, sep="")
if(dir.exists(FolderS)== FALSE){dir.create(FolderS)}

system(paste("cp -r ", parameters$Folders$folderResults,
             "/", parameters$Dataset.Name, "-", similarity, 
             ".tar.gz",
             " ", FolderS, "/", sep=""))

system(paste("rm -r ", parameters$Folders$folderResults, sep=""))

# cat("\n\n#######################################################")
# cat("\n# MLSM: COPY TEST TO GOOGLE DRIVE                           #")
#   cat("\n#######################################################\n\n")
# origem1 = parameters$ Folders$folderSimilarities
# destino1 = paste("nuvem:SimilaritiesMatrices/", similarity, 
#                  "/", dataset_name, sep="")
# comando1 = paste("rclone copy ", origem1, " ",
#                  destino1, sep="")
# cat("\n\n\n", comando1, "\n\n\n")
# a = print(system(comando1))
# a = as.numeric(a)
# if(a != 0){
#   stop("Erro RCLONE")
#   quit("yes")
# }
# cat("\n\n")



cat("\n\n#####################################################")
cat("\n# MLSM: CLEAN                                            #")
   cat("\n####################################################\n\n")
str2 = paste("rm -rf ", diretorios$folderResults, sep="")
print(system(str2))
gc()



cat("\n\n####################################################")
cat("\n# MLSM: END                                              #")
  cat("\n####################################################\n")

rm(list = ls())

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
