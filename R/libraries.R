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

# Definir os pacotes necessários
required_packages <- c("progress", "tidyverse", "dplyr", "parallel", "doParallel")

# Verificar e instalar pacotes ausentes
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Aplicar a verificação para todos os pacotes necessários
sapply(required_packages, install_if_missing)


library(progress)
library(tidyverse)
library(dplyr)
library(parallel)
library(doParallel)


###############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                #
# Thank you very much!                                                        #                                #
###############################################################################
