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


FolderRoot = "~/SimilaritiesMeasuresMultiLabel"
FolderScripts = paste(FolderRoot, "/R", sep="")

# proporção de 1s que ambas as variáveis compartilham nas mesmas posições
# correspondências positivas entre x e y (x e y == 1)
compute.a <- function(x, y){
  return(sum(x == 1 & y == 1))
}

# proporção de 0s em x e de 1s em y nas mesmas posições
# x ausente (x == 0 e y == 1 )
compute.b <- function(x, y){
  return(sum(x == 0 & y == 1))
}

# proporção de 1s em x e de 0s em y nas mesmas posições
# y ausente (x == 1 e y == 0)
compute.c <- function(x, y){
  return(sum(x == 1 & y == 0))
}

# proporção de 0s que ambas as variáveis compartilham
# correspondências negativas entre x e y (x e y == 0)
compute.d <- function(x,y){
  return(sum(x == 0 & y == 0))
}

# p1 = a + b --> proporção de 1s em a
compute.ab <- function(a, b){
  return(a+b)
}

# p2 = a + c --> proporção de 1s em c
compute.ac <- function(a, c){
  return(a+c)
}

# p3 = a + d --> diagonal (11) (00)
compute.ad <- function(a, d){
  return(a+d)
}

# p4 = b + c --> diagonal (10) (01)
compute.bc <- function(b, c){
  return(b+c)
}

# p5 = b + d --> proporção de 0s em d
compute.bd <- function(b, d){
  return(b+d)
}

# p6 = c + d --> proporção de 0s em c
compute.cd <- function(c, d){
  return(c+d)
}

# todos
compute.n <- function(a,b,c,d){
  return(a+b+c+d)
}

#################################################################
# CONSTRÓI A MATRIZ DE SIMILARIDADE
#     numbereroero.labels  = número de rótulos do espaço de rótulos
#     labels         = espaço de rótulos
#################################################################
build.similarity.matrix <- function(labels, number.labels){
  similarity.matrix <- matrix(nrow=number.labels, 
                                ncol=number.labels, data=0)
  colnames(similarity.matrix) <- colnames(labels)
  rownames(similarity.matrix) <- colnames(labels)
  return(similarity.matrix)
  gc()
}

#################################################################
# TABELA DE CONTINGÊNCIA
#     numbereroero.labels  = número de rótulos do espaço de rótulos
#     labels         = espaço de rótulos
#     fun             = função que deverá ser executada
#################################################################
compute.contingency.table <- function(labels,
                                      number.labels,
                                      FUN){
  retorno = list()
  m <- build.similarity.matrix(labels,number.labels)
  
  
  i = 1
  j = 1
  for (i in 1:number.labels){
    for (j in 1:number.labels){
      m[i,j] = FUN(labels[,i],labels[,j])
      gc()
    }
    gc()
  }
  
  retorno$contingency.table = m
  return(retorno)
  gc()
}


#################################################################
# PROBABILIDADES MARGINAIS
#     numbereroero.labels  = número de rótulos do espaço de rótulos
#     labels            = espaço de rótulos
#     m1                 = primeira matriz
#     m2                 = segunda matriz
#     fun                = função que deverá ser executada
#################################################################
compute.marginal.probabilities <- function(labels,
                                             number.labels, 
                                             m1, 
                                             m2, 
                                             FUN){
  retorno = list()
  m <- build.similarity.matrix(labels, number.labels)
  u = (number.labels*number.labels)
  #pb <- progress_bar$new(total = u)
  for (i in 1:number.labels){
    for (j in 1:number.labels){
      m[i,j] = FUN(m1[i,j], m2[i,j])
      #pb$tick()       
      #Sys.sleep(1/u)  
      gc()
    } 
    gc()
  }
  retorno$prob.marg = m
  return(retorno)
  gc()
}


#################################################################
# compute MN
#     numbereroero.labels  = número de rótulos do espaço de rótulos
#     labels            = espaço de rótulos
#     m1                 = primeira matriz
#     m2                 = segunda matriz
#     fun                = função que deverá ser executada
#################################################################
compute.mn <- function(labels, number.labels, ma, mb, mc, md){
  retorno = list()
  mn <- build.similarity.matrix(labels, number.labels)
  u = (number.labels*number.labels)
  #pb <- progress_bar$new(total = u)
  for (i in 1:number.labels){
    for (j in 1:number.labels){
      mn[i,j] = compute.n(ma[i,j], mb[i,j], mc[i,j], md[i,j])
      #pb$tick()       
      #Sys.sleep(1/u)  
      gc()
    } 
    gc()
  }
  retorno$mn = mn
  return(retorno)
  gc()
}



