###############################################################################
# MULTI LABEL SIMILARITIES MEASURES
# Copyright (C) 2022
#
# This code is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version. This code is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# Elaine Cecilia Gatto | Prof. Dr. Ricardo Cerri | Prof. Dr. Mauri Ferrandin
# Federal University of Sao Carlos (UFSCar: https://www2.ufscar.br/) Campus
# Sao Carlos Computer Department (DC: https://site.dc.ufscar.br/)
# Program of Post Graduation in Computer Science
# (PPG-CC: http://ppgcc.dc.ufscar.br/)
# Bioinformatics and Machine Learning Group
# (BIOMAL: http://www.biomal.ufscar.br/)
#
###############################################################################


FolderRoot = "~/SimilaritiesMultiLabel"
FolderScripts = paste(FolderRoot, "/R", sep="")


##################################################################################################
# Runs for all datasets listed in the "datasets.csv" file                                        #
# n_dataset: number of the dataset in the "datasets.csv"                                         #
# number_cores: number of cores to paralell                                                      #
# number_folds: number of folds for cross validation                                             #
# delete: if you want, or not, to delete all folders and files generated                         #
##################################################################################################
execute <- function(parameters){
  
  FolderRoot = "~/SimilaritiesMultiLabel"
  FolderScripts = paste(FolderRoot, "/R", sep="")
  
  if(parameters$Number.Cores  == 0){
    cat("\n\n##################################################################################################")
      cat("\n# Zero is a disallowed value for number_cores. Please choose a value greater than or equal to 1. #")
      cat("\n##################################################################################################\n\n")
  } else {
    cl <- parallel::makeCluster(parameters$Number.Cores)
    doParallel::registerDoParallel(cl)
    print(cl)
    
    if(parameters$Number.Cores==1){
      cat("\n\n###########################################################")
        cat("\n# RUN: Running Sequentially!                              #")
        cat("\n###########################################################\n\n")
    } else {
      cat("\n\n######################################################################")
        cat("\n# RUN: Running in parallel with ", parameters$Number.Cores, " cores! #")
        cat("\n######################################################################\n\n")
    }
  }
  
  retorno = list()
  
  setwd(FolderScripts)
  source("libraries.R")
  
  setwd(FolderScripts)
  source("utils.R")
  
  setwd(FolderScripts)
  source("functions.R")
  
  setwd(FolderScripts)
  source("similarities.R")
  
  
  cat("\n\n################################################################")
    cat("\n# RUN: Get the label space                                     #")
    cat("\n################################################################\n\n")
  timeLabelSpace = system.time(resLS <- labelSpace(parameters))
  parameters$LabelSpace = resLS
  
  
  cat("\n\n################################################################")
    cat("\n# RUN: Compute Measure                                         #")
    cat("\n################################################################\n\n")
  
  f = 1
  validateParalel <- foreach(f = 1:parameters$Number.Folds) %dopar%{
  #while(f<=parameters$Number.Folds){
    
    cat("\nFold ", f)
    
    FolderRoot = "~/SimilaritiesMultiLabel"
    FolderScripts = paste(FolderRoot, "/R", sep="")
    
    setwd(FolderScripts)
    source("libraries.R")
    
    setwd(FolderScripts)
    source("utils.R")
    
    setwd(FolderScripts)
    source("functions.R")
    
    setwd(FolderScripts)
    source("similarities.R")
    
    Folder = paste(parameters$Folders$folderSimilarities, "/Split-", f, sep="")
    if(dir.exists(Folder)==FALSE){dir.create(Folder)}
    
    fold.label.space = data.frame(resLS$Classes[f])
    fold.ma = compute.contingency.table(fold.label.space, 
                                          ncol(fold.label.space), 
                                          compute.a)
    names(fold.ma) = "ma"
    
    fold.mb = compute.contingency.table(fold.label.space, 
                                          ncol(fold.label.space), 
                                          compute.b)
    names(fold.mb) = "mb"
    
    fold.mc = compute.contingency.table(fold.label.space, 
                                          ncol(fold.label.space), 
                                          compute.c)
    names(fold.mc) = "mc"
    
    fold.md = compute.contingency.table(fold.label.space, 
                                          ncol(fold.label.space),
                                          compute.d)  
    names(fold.md) = "md"
    
    setwd(Folder)
    write.csv(fold.ma, "contingency.table.a.csv")
    write.csv(fold.mb, "contingency.table.b.csv")
    write.csv(fold.mc, "contingency.table.c.csv")
    write.csv(fold.md, "contingency.table.d.csv")
    
    fold.mab = compute.marginal.probabilities(fold.label.space, 
                                              ncol(fold.label.space),
                                              fold.ma$ma, 
                                              fold.mb$mb, 
                                              compute.ab)
    
    fold.mac = compute.marginal.probabilities(fold.label.space,
                                              ncol(fold.label.space),
                                              fold.ma$ma, 
                                              fold.mc$mc, 
                                              compute.ac)
    
    fold.mad = compute.marginal.probabilities(fold.label.space, 
                                              ncol(fold.label.space),
                                              fold.ma$ma, 
                                              fold.md$md, 
                                              compute.ad)
    
    fold.mbc = compute.marginal.probabilities(fold.label.space, 
                                              ncol(fold.label.space),
                                              fold.mb$mb, 
                                              fold.mc$mc, 
                                              compute.bc)
    
    fold.mbd = compute.marginal.probabilities(fold.label.space, 
                                              ncol(fold.label.space),
                                              fold.mb$mb, 
                                              fold.md$md, 
                                              compute.bd)
    
    fold.mcd = compute.marginal.probabilities(fold.label.space, 
                                              ncol(fold.label.space),
                                              fold.mc$mc, 
                                              fold.md$md, 
                                              compute.cd)
    
    fold.mn = compute.mn(fold.label.space, 
                         ncol(fold.label.space),
                         fold.ma$ma, 
                         fold.mb$mb, 
                         fold.mc$mc, 
                         fold.md$md)
    
    setwd(Folder)
    write.csv(fold.mab, "contingency.table.ab.csv")
    write.csv(fold.mac, "contingency.table.ac.csv")
    write.csv(fold.mad, "contingency.table.ad.csv")
    write.csv(fold.mbc, "contingency.table.bc.csv")
    write.csv(fold.mbd, "contingency.table.bd.csv")
    write.csv(fold.mcd, "contingency.table.cd.csv")
    write.csv(fold.mn, "contingency.table.mn.csv")
    
    names.functions = getNamesListFunctions()
    names.functions$names == parameters$similarity
    
    res = compute.measure(eval(parse(text=parameters$similarity)),
                             a = as.matrix(fold.ma$ma), 
                             b = as.matrix(fold.mb$mb), 
                             c = as.matrix(fold.mc$mc),
                             d = as.matrix(fold.md$md))
    res = data.frame(res)
    res = res %>% mutate_all(function(x) ifelse(is.infinite(x), 0, x))
    
    setwd(Folder)
    nome = paste(parameters$similarity, ".csv", sep="")
    write.csv(res, nome)
    
    #f = f + 1
    gc()
  }
  
  
  cat("\n\n#############################################################")
    cat("\n# RUN: Stop Parallel                                        #")
    cat("\n#############################################################\n\n")
  on.exit(stopCluster(cl))
  
  cat("\n\n############################################################")
    cat("\n# RUN: END                                                 #")
    cat("\n############################################################\n\n")
  
  gc()
  
}

##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
