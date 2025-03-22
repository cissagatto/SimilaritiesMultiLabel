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
  
  setwd(FolderScripts)
  source("utils.R")
  
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
  
  cat("\n\n################################################################")
  cat("\n# RUN: Get the label space                                     #")
  cat("\n################################################################\n\n")
  timeLabelSpace = system.time(resLS <- labelSpace(parameters))
  parameters$LabelSpace = resLS
  
  cat("\n\n################################################################")
  cat("\n# RUN: Compute Measure                                         #")
  cat("\n################################################################\n\n")
  
  # DataFrame para armazenar os tempos
  timeData <- data.frame(user=c(0), system=c(0), elapsed=c(0))
  
  f = 1
  validateParalel <- foreach(f = 1:parameters$Number.Folds) %dopar%{
  # (f<=parameters$Number.Folds){
    
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
    
    cat("foldma")
    timeMA <- system.time(fold.ma <- compute.contingency.table(fold.label.space, 
                                                               ncol(fold.label.space), 
                                                               compute.a))
    names(fold.ma) = "ma"
    
    cat("foldmb")
    timeMB <- system.time(fold.mb <- compute.contingency.table(fold.label.space, 
                                                               ncol(fold.label.space), 
                                                               compute.b))
    names(fold.mb) = "mb"
    
    cat("foldmc")
    timeMC <- system.time(fold.mc <- compute.contingency.table(fold.label.space, 
                                                               ncol(fold.label.space), 
                                                               compute.c))
    names(fold.mc) = "mc"
    
    cat("foldmd")
    timeMD <- system.time(fold.md <- compute.contingency.table(fold.label.space, 
                                                               ncol(fold.label.space), 
                                                               compute.d))
    names(fold.md) = "md"
    
    cat("foldmab")
    timeMAB <- system.time(fold.mab <- compute.marginal.probabilities(labels =  fold.label.space, 
                                                                      number.labels = ncol(fold.label.space),
                                                                      m1 = fold.ma$ma, 
                                                                      m2 = fold.mb$mb, 
                                                                      FUN = compute.ab))
    cat("foldmac")
    timeMAC <- system.time(fold.mac <- compute.marginal.probabilities(fold.label.space,
                                                                      ncol(fold.label.space),
                                                                      fold.ma$ma, 
                                                                      fold.mc$mc, 
                                                                      compute.ac))
    cat("foldmad")
    timeMAD <- system.time(fold.mad <- compute.marginal.probabilities(fold.label.space, 
                                                                      ncol(fold.label.space),
                                                                      fold.ma$ma, 
                                                                      fold.md$md, 
                                                                      compute.ad))
    cat("foldmbc")
    timeMBC <- system.time(fold.mbc <- compute.marginal.probabilities(fold.label.space, 
                                                                      ncol(fold.label.space),
                                                                      fold.mb$mb, 
                                                                      fold.mc$mc, 
                                                                      compute.bc))
    cat("foldmbd")
    timeMBD <- system.time(fold.mbd <- compute.marginal.probabilities(fold.label.space, 
                                                                      ncol(fold.label.space),
                                                                      fold.mb$mb, 
                                                                      fold.md$md, 
                                                                      compute.bd))
    cat("foldmcd")
    timeMCD <- system.time(fold.mcd <- compute.marginal.probabilities(fold.label.space, 
                                                                      ncol(fold.label.space),
                                                                      fold.mc$mc, 
                                                                      fold.md$md, 
                                                                      compute.cd))
    cat("foldmn")
    timeMN <- system.time(fold.mn <- compute.mn(fold.label.space, 
                                                ncol(fold.label.space),
                                                fold.ma$ma, 
                                                fold.mb$mb, 
                                                fold.mc$mc, 
                                                fold.md$md))
    
    
    names.functions = getNamesListFunctions()
    #names.functions$names == parameters$similarity
    cat("jaccard")
    timeMeasure <- system.time(res <- compute.measure(eval(parse(text=parameters$similarity)),
                                                      a = as.matrix(fold.ma$ma), 
                                                      b = as.matrix(fold.mb$mb), 
                                                      c = as.matrix(fold.mc$mc),
                                                      d = as.matrix(fold.md$md)))
    cat("organize")
    res = data.frame(res)
    res = res %>% mutate_all(function(x) ifelse(is.infinite(x), 0, x))
    
    rownames(res) <- resLS$NamesLabels
    colnames(res) <- resLS$NamesLabels
    
    fold.ma = as.data.frame(fold.ma)
    rownames(fold.ma) <- resLS$NamesLabels
    colnames(fold.ma) <- resLS$NamesLabels
    
    fold.mb = as.data.frame(fold.mb)
    rownames(fold.mb) <- resLS$NamesLabels
    colnames(fold.mb) <- resLS$NamesLabels
    
    fold.mc = as.data.frame(fold.mc)
    rownames(fold.mc) <- resLS$NamesLabels
    colnames(fold.mc) <- resLS$NamesLabels
    
    fold.md = as.data.frame(fold.md)
    rownames(fold.md) <- resLS$NamesLabels
    colnames(fold.md) <- resLS$NamesLabels
    
    fold.mab = as.data.frame(fold.mab)
    rownames(fold.mab) <- resLS$NamesLabels
    colnames(fold.mab) <- resLS$NamesLabels
    
    fold.mac = as.data.frame(fold.mac)
    rownames(fold.mac) <- resLS$NamesLabels
    colnames(fold.mac) <- resLS$NamesLabels
    
    fold.mad = as.data.frame(fold.mad)
    rownames(fold.mad) <- resLS$NamesLabels
    colnames(fold.mad) <- resLS$NamesLabels
    
    fold.mbc = as.data.frame(fold.mbc)
    rownames(fold.mbc) <- resLS$NamesLabels
    colnames(fold.mbc) <- resLS$NamesLabels
    
    fold.mbd = as.data.frame(fold.mbd)
    rownames(fold.mbd) <- resLS$NamesLabels
    colnames(fold.mbd) <- resLS$NamesLabels
    
    fold.mcd = as.data.frame(fold.mcd)
    rownames(fold.mcd) <- resLS$NamesLabels
    colnames(fold.mcd) <- resLS$NamesLabels
    
    fold.mn = as.data.frame(fold.mn)
    rownames(fold.mn) <- resLS$NamesLabels
    colnames(fold.mn) <- resLS$NamesLabels
    
    # Salvar as tabelas marginalmente computadas
    if (parameters$Save.Csv.Files == 1) {
      setwd(Folder)
      write.csv(fold.ma, "contingency.table.a.csv")
      write.csv(fold.mb, "contingency.table.b.csv")
      write.csv(fold.mc, "contingency.table.c.csv")
      write.csv(fold.md, "contingency.table.d.csv")
      write.csv(fold.mab, "contingency.table.ab.csv")
      write.csv(fold.mac, "contingency.table.ac.csv")
      write.csv(fold.mad, "contingency.table.ad.csv")
      write.csv(fold.mbc, "contingency.table.bc.csv")
      write.csv(fold.mbd, "contingency.table.bd.csv")
      write.csv(fold.mcd, "contingency.table.cd.csv")
      write.csv(fold.mn, "contingency.table.mn.csv")
      
      nome = paste(Folder, "/", parameters$similarity, ".csv", sep="")
      write.csv(res, nome)
    } else {
      stop("Fail to save csv files.")
    }
    
    cat("organize time")
    timeMA <- as.data.frame(timeMA)
    timeMB <- as.data.frame(timeMB)
    timeMC <- as.data.frame(timeMC)
    timeMD <- as.data.frame(timeMD)
    
    timeMAB <- as.data.frame(timeMAB)
    timeMAC <- as.data.frame(timeMAC)
    timeMAD <- as.data.frame(timeMAD)
    
    timeMBC <- as.data.frame(timeMBC)
    timeMBD <- as.data.frame(timeMBD)
    
    timeMCD <- as.data.frame(timeMCD)
    timeMN <- as.data.frame(timeMN)
    timeMeasure <- as.data.frame(timeMeasure)
    
    timefinal = cbind(timeMA, timeMB, timeMC, timeMD, 
                      timeMAB, timeMAC, timeMAD, 
                      timeMBC, timeMBD, 
                      timeMCD, timeMN, timeMeasure)
    
    colnames(timefinal) = c("time.a", "time.b", "time.c", "time.d",
                            "time.ab", "time.ac", "time.ad", 
                            "time.bc", "time.bd", 
                            "time.cd", "time.mn", "time.measure")
    
    write.csv(timefinal, "fold-runtime.csv")
    
    retorno$runtime = timefinal
    retorno$a = fold.ma
    retorno$b = fold.mb
    retorno$c = fold.mc
    retorno$d = fold.md
    retorno$ab = fold.mab
    retorno$ac = fold.mac
    retorno$ad = fold.mad
    retorno$bc = fold.mbc
    retorno$bc = fold.mbd
    retorno$cd = fold.mcd
    retorno$mn = fold.mn
    retorno$measure = res
    # f = f + 1
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
