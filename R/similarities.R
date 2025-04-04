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

# nomes das funções
getNamesListFunctions <- function(){
  retorno = list()
  names_function = c("ample",
                     "anderberg",
                     "baroni.urbani.buser.1",
                     "baroni.urbani.buser.2",
                     "braun.blanquet",
                     "bray.curtis",
                     "canberra",
                     "chord",
                     "cityblock",
                     "clement",
                     "cohen",
                     "cole.1",
                     "cole.2",
                     "cole.3",
                     "cosine", 
                     "czekanowski",
                     "dennis", 
                     "dibby",
                     "dice.1",
                     "dice.2",
                     "dice.3",
                     "disperson",
                     "doolittle",
                     "driver.kroeber.1",
                     "driver.kroeber.2",
                     "euclidean",
                     "eyraud",
                     "fager.mcgowan.1",
                     "fager.mcgowan.2",
                     "faith",
                     "fleiss",
                     "forbes.1",
                     "forbes.2",
                     "forbesi",
                     "fossum",
                     "gilbert.well",
                     "goodman.kruskal.1",
                     "goodman.kruskal.2",
                     "gower",
                     "gower.legendre", 
                     "hamann.1",
                     "hamann.2",
                     "hamann.3",
                     "hamming",
                     "harris",
                     "hawkins.dotson",
                     "hellinger", 
                     "inner.product", 
                     "intersection",
                     "jaccard",
                     "jonhson",
                     "kent.foster.1",
                     "kent.foster.2",
                     "kuder.richardson",
                     "kulczynski.1",
                     "kulczynski.2",
                     "kulczynski.3",
                     "kulczynski.4",
                     "lance.williams",
                     "loevinger",
                     "manhattan",
                     "maxwell.pilliner",
                     "mcconnaughey",
                     "mean.manhattan",
                     "michael",
                     "minowski",
                     "mountford.1",
                     "mountford.2",
                     "neili",
                     "ochiai.1",
                     "ochiai.2",
                     "ochiai.3",
                     "otsuka",
                     "pattern.difference",
                     "pearson.1",
                     "pearson.2",
                     "pearson.3",
                     "pearson.heron.1",
                     "pearson.heron.2",
                     "pearson.heron.3",
                     "peirce.1",
                     "peirce.2",
                     "peirce.3",
                     "rogers.tanimoto",
                     "rogot.goldberd",
                     "russel.rao",
                     "scott",
                     "shape.difference",
                     "simpson",
                     "size.difference",
                     "sokal.michener",
                     "sokal.sneath.1",
                     "sokal.sneath.2",
                     "sokal.sneath.3",
                     "sokal.sneath.4a",
                     "sokal.sneath.4b",
                     "sokal.sneath.5a",
                     "sokal.sneath.5b",
                     "sorgenfrei",
                     "square.euclidean",
                     "stiles",
                     "tanimoto",
                     "tarantula",
                     "tarwid",
                     "three.w.jaccard",
                     "vari",
                     "yuleq.1",
                     "yule.2",
                     "yulew")
  retorno$names = names_function
  retorno$length = length(names_function)
  return(retorno)
  gc()
}


#########################################################
# função abstraída
#########################################################
compute.measure <- function(FUN, ...) {
  Args <- list(...)
  Args <- lapply(Args, function(M) apply(X = M, MARGIN = c(1,2), 
                                         FUN = as.numeric))
  FUN(Args)
}


#####################################################################
#
#####################################################################
ample <- function(l){
  return(abs((l$a*(l$c+l$d))/(l$c*(l$a+l$b))))
} 


#####################################################################
#
#####################################################################
anderberg <- function(l){
  delta_1 = max(l$a,l$b) + max(l$c,l$d) + max(l$a,l$c) + max(l$b,l$d) 
  delta_2 = max((l$a+l$c),(l$b+l$d)) + max((l$a+l$b),(l$c+l$d))
  delta = ((delta_1-delta_2)/(2*l$n))
  return(delta)
}


#####################################################################
#
#####################################################################
baroni.urbani.buser.1 <- function(l){
  return(((sqrt(abs(l$a*l$d))) + l$a) / ((sqrt(abs(l$a*l$d))) + a + l$b + l$c))
}


#####################################################################
#
#####################################################################
baroni.urbani.buser.2 <- function(l){
  return((sqrt(abs(l$a*l$d)) + l$a - (l$b+l$c)) / (sqrt(abs(l$a*l$d)) + l$a + l$b + l$c))
}


#####################################################################
#
#####################################################################
braun.blanquet <- function(l){
  return(l$a/(max((l$a+l$b),(l$a+l$c))))
}


#####################################################################
#
#####################################################################
bray.curtis <- function(l){
  return((l$b+l$c)/((2*l$a)+l$b+l$c))
}


#####################################################################
#
#####################################################################
canberra <- function(l){
  return((l$b+l$c)^(2/2))
}


#####################################################################
#
#####################################################################
cohen <- function(l){
  d1 = 2 * ((l$a*l$d) - (l$b*l$c))
  d2 = ((l$a+l$b)*(l$b+l$d)) + ((l$a+l$c)*(l$c+l$d))
  d3 = d1/d2  
  return(d3)
}


#####################################################################
#
#####################################################################
chord <- function(l){
  return(sqrt(abs(1-(l$a/(sqrt(abs((l$a+l$b)) + abs((l$a+l$c))))))))
}


#####################################################################
#
#####################################################################
cityblock <- function(l){
  return(l$b+l$c)
}


#####################################################################
#
#####################################################################
clement <- function(l){
  return(((l$a*(l$c+l$d))/(l$a+l$b))+((l$d*(l$a+l$b))/(l$c+l$d)))
}


#####################################################################
#
#####################################################################
cole.1 <- function(l){
  d1 = sqrt(2) * ((l$a*l$d)-(l$b*l$c))
  d2 = (((l$a*l$d)-(l$b*l$c))^2)
  d3 = ((l$a+l$b)*(l$a+l$c)*(l$b+l$d)*(l$c+l$d))
  d4 = d2 - d3
  d5 = sqrt(abs(d4))
  return(d5)
}


#####################################################################
#
#####################################################################
cole.2 <- function(l){
  return(((l$a*l$d)-(l$b*l$c))/((l$a+l$b)*(l$b+l$d)))
}


#####################################################################
#
#####################################################################
cole.3 <- function(l){
  return(((l$a*l$d)-(l$b*l$c))/((l$a+l$c)*(l$c+l$d)))
}


#####################################################################
#
#####################################################################
cosine <- function(l){
  return(l$a/sqrt(abs((((l$a+l$b)*(l$a+l$c))))^2))
}


#####################################################################
#
#####################################################################
czekanowski <- function(l){
  return((2*l$a)/((2*l$a)+l$b+l$c))
}


#####################################################################
#
#####################################################################
dennis <- function(l){
  return(((l$a*l$d)-(l$b*l$c))/sqrt(abs(l$n*((l$a+l$b)*(l$a+l$c)))))
}


#####################################################################
#
#####################################################################
digby <- function(l){
  return(((l$a*l$d)^(3/4) - (l$b*l$c)^(3/4)) / ((l$a*l$d)^(3/4) - (l$b*l$c)^(3/4)))
}


#####################################################################
#
#####################################################################
dice.1 <- function(l){
  return((2*l$a)/((2*l$a)+l$b+l$c))
}


#####################################################################
#
#####################################################################
dice.2 <- function(l){
  return(l$a/l$a+l$b)
}


#####################################################################
#
#####################################################################
dice.3 <- function(l){
  return(l$a/l$a+l$c)
}


#####################################################################
#
#####################################################################
doolittle <- function(l){
  d1 = ((l$a*l$d) - (l$b*l$c))^2
  d2 = (l$a+l$b)*(l$a+l$c)*(l$c+l$d)*(l$b+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
disperson <- function(l){
  return(((l$a*l$d)-(l$b*l$c))/((l$a+l$b+l$c+l$d)^2))
}


#####################################################################
#
#####################################################################
driver.kroeber.1 <- function(l){
  return((l$a/2)*((1/(l$a+l$b))+(1/(l$a+l$c))))
}


#####################################################################
#
#####################################################################
driver.kroeber.2 <- function(l){
  return(l$a/(sqrt(abs((l$a+l$b)*(l$a+l$c)))))
}


#####################################################################
#
#####################################################################
euclidean <- function(l){
  return(l$b+l$c)
}


#####################################################################
#
#####################################################################
eyraud <- function(l){
  d1 = (l$n^2) * ((l$n*l$a) - ((l$a+l$b) * (l$a+l$c)) )
  d2 = (l$a+l$b) * (l$a+l$c) * (l$b+l$d) * (l$c+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
fager.mcgowan.1 <- function(l){
  return((l$a/(sqrt(abs((l$a+l$b)*(l$a+l$c))))) - (max((l$a+l$b),(l$a+l$c))/2))
}


#####################################################################
#
#####################################################################
fager.mcgowan.2 <- function(l){
  d1 = l$a/sqrt(abs((l$a+l$b)*(l$a+l$c)))
  d2 = 1/ (2 * sqrt(abs(max((l$a+l$b),(l$a+l$c)))))
  d3 = d1-d2
  return(d3)
}


#####################################################################
#
#####################################################################
faith <- function(l){
  return((l$a+(0.5*l$d))/(l$a+l$b+l$c+l$d))
}


#####################################################################
#
#####################################################################
fleiss <- function(l){
  d1 = ((l$a*l$d) - (l$b*l$c)) * ((l$a+l$b)*(l$b+l$d)) + ((l$a+l$c)*(l$c+l$d))
  d2 = 2 * (l$a+l$b)*(l$a+l$c)*(l$c+l$d)*(l$b+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
forbes.1 <- function(l){
  d1 = (l$n*l$a) - ((l$a+l$b) * (l$a+l$c))
  d2 = l$n * ( (min((l$a+l$b),(l$a+l$c))) - ((l$a+l$b) * (l$a+l$c)) )
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
forbes.2 <- function(l){
  return((l$n*l$a)/ (l$a+l$b) * (l$a+l$c))
}


#####################################################################
#
#####################################################################
forbesi <- function(l){
  return((l$n*l$a)/((l$a+l$b)*(l$a+l$c)))
}


#####################################################################
#
#####################################################################
fossum <- function(l){
  return((l$n*(l$a-0.5)^2)/(l$a+l$b)*(l$a+l$c))
}


#####################################################################
#
#####################################################################
gilbert.well <- function(l){
  return(log(l$a)-log(l$n)-log((l$a+l$b)/l$n)-log((l$a+l$c)/l$n))
}


#####################################################################
#
#####################################################################
goodman.kruskal.1 <- function(l){
  z = max(l$a,l$b)+max(l$c,l$d)+max(l$a,l$c)+max(l$b,l$c)
  w = max((l$a+l$c),(l$b+l$d))+max((l$a+l$b),(l$c+l$d))
  p = (z-w)/((2*l$n)-w)
  return(p)
}


#####################################################################
#
#####################################################################
goodman.kruskal.2 <- function(l){
  d1 = 2* min(l$a,l$d) - l$b - l$c
  d2= 2* min(l$a,l$d) + l$b + l$c
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
gower <- function(l){
  return((l$a+l$d) / (sqrt(abs((l$a+l$b) + (l$a+l$c) + (l$b+l$d) + (l$c+l$d))) ))
}


#####################################################################
#
#####################################################################
gower.legendre <- function(l){
  return((l$a+l$d)/(l$a+(0.5*(l$b+l$c))+l$d))
}


#####################################################################
#
#####################################################################
hamann.1 <- function(l){
  return(((l$a+l$d)-(l$b+l$c))/(l$a+l$b+l$c+l$d))
}


#####################################################################
#
#####################################################################
hamann.2 <- function(l){
  return((l$a-l$b-l$c+l$d)/(l$a+l$b+l$c+l$d))
}


#####################################################################
#
#####################################################################
harris <- function(l){
  d1 = (l$a * (l$c+l$d) + (l$b+l$d) ) / (2 * (l$a+l$b+l$c))
  d2 = (l$d * (l$a+l$b) + (l$a+l$c)) / (2 * (l$b+l$c+l$d))
  d3 = d1+d2
  return(d3)
}

#####################################################################
#
#####################################################################
hamming <- function(l){
  return(l$b+l$c)
}


#####################################################################
#
#####################################################################
hawkins.dotson <- function(l){
  return((1/2) * ((l$a/l$a+l$b+l$c) + (l$d/l$b+l$c+l$d)))
}


#####################################################################
#
#####################################################################
hellinger <- function(l){
  d1 = l$a / sqrt(abs((l$a+l$b) * (l$a+l$c)))
  d2 = 1 - d1
  d3 = sqrt(abs(d2))
  d4 = 2*d3
  return(d4)
}


#####################################################################
#
#####################################################################
inner.product <- function(l){
  return(l$a+l$d)
}


#####################################################################
#
#####################################################################
intersection <- function(l){
  return(l$a)
}


#####################################################################
#
#####################################################################
jaccard <- function(l){
  return(l$a/(l$a+l$b+l$c))
}


#####################################################################
#
#####################################################################
jonhson <- function(l){
  return((l$a/(l$a+l$b)) + (l$a/(l$a+l$c)))
}


#####################################################################
#
#####################################################################
kent.foster.1 <- function(l){
  d1 = -(l$b*l$c)
  d2 = (l$b*(l$a+l$b)) + (l$c*(l$a+l$c)) + (l$b*l$c)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
kent.foster.2 <- function(l){
  d1 = -(l$b*l$c)
  d2 = (l$b*(l$c+l$d)) + (l$c*(l$b+l$d)) + (l$b*l$c)
  d3 = d1/d2
  return(d3) 
}


#####################################################################
#
#####################################################################
kulczynski.1 <- function(l){
  return(l$a/(l$b+l$c))
}


#####################################################################
#
#####################################################################
kulczynski.2 <- function(l){
  d1 = (l$a/2) * ((2*l$a)+l$b+l$c)
  d2 = (l$a+l$b) * (l$a+l$c)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
kulczynski.3 <- function(l){
  return((1/2) * ((l$a/l$a+l$b) + (l$a/l$a+l$c)))
}


#####################################################################
#
#####################################################################
kulczynski.4 <- function(l){
  return(l$a/l$b+l$c)
}


#####################################################################
#
#####################################################################
kuder.richardson <- function(l){
  d1 = 4 * ((l$a*l$d) - (l$b*l$c))
  d2 = ((l$a+l$b)*(l$c+l$d)) + ((l$a+l$c)*(l$b+l$d)) + (2 *((l$a*l$d)-(l$b*l$c)))
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
lance.williams <- function(l){
  return((l$b+l$c)/((2*l$a)+l$b+l$c))
}


#####################################################################
#
#####################################################################
loevinger <- function(l){
  d1 = (l$a*l$d) - (l$b*l$c)
  d2 = min(((l$a+l$b)*(l$b+l$d)),((l$a+l$c)*(l$c+l$d)))
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
maxwell.pilliner <- function(l){
  d1 = 2 * ((l$a*l$d) - (l$b*l$c))
  d2 = (l$a+l$b)*(l$c+l$d) + (l$c+l$d)*(l$b+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
manhattan <- function(l){
  return(l$b+l$c)
}


#####################################################################
#
#####################################################################
mcconnaughey <- function(l){
  return( ((l$a^2) - (l$b*l$c)) / ((l$a+l$b)*(l$a+l$c)) )
}


#####################################################################
#
#####################################################################
mean.manhattan <- function(l){
  return((l$b+l$c)/(l$a+l$b+l$c+l$d))
}


#####################################################################
#
#####################################################################
michael <- function(l){
  return(4*((l$a*l$d)-(l$b*l$c))/(((l$a+l$d)^2)+((l$b+l$c)^2)))
}



#####################################################################
#
#####################################################################
minowski <- function(l){
  return((l$b+l$c)^(1/1))
}


#####################################################################
#
#####################################################################
mountford.1 <- function(l){
  return(l$a/(0.5*(((l$a*l$b)+(l$a*l$c))+(l$b*l$c))))
}


#####################################################################
#
#####################################################################
mountford.2 <- function(l){
  return((2*l$a) / (a*(l$a+l$c) + 2*l$b*l$c))
}


#####################################################################
#
#####################################################################
neili <- function(l){
  return((2*l$a)/((l$a+l$b)+(l$a+l$c)))
}


#####################################################################
#
#####################################################################
ochiai.1 <- function(l){
  return(l$a/sqrt(abs((l$a+l$b)*(l$a+l$c))))
}


#####################################################################
#
#####################################################################
ochiai.2 <- function(l){
  return((l$a*l$d)/sqrt(abs((l$a+l$d)*(l$a+l$c)*(l$d+l$b)*(l$d+l$c))))
}


#####################################################################
#
#####################################################################
ochiai.3 <- function(l){
  return((l$a*l$d)/sqrt(abs((l$a+l$b)*(l$a+l$c)*(l$b+l$d)*(l$c+l$d))))
}


#####################################################################
#
#####################################################################
otsuka <- function(l){
  return(l$a/(((l$a+l$b)*(l$a+l$c))^0.5))
}


#####################################################################
#
#####################################################################
pattern.difference <- function(l){
  return((4*l$b*l$c)/((l$a+l$b+l$c+l$d)^2))
}


#####################################################################
#
#####################################################################
pearson.1 <- function(l){
  d1 = l$n * (((l$a*l$d) - (l$b*l$c))^2)
  d2 = (l$a+l$b) * (l$a+l$c) * (l$c+l$d) * (l$b+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
pearson.2 <- function(l){
  d1 = l$n * (((l$a*l$d) - (l$b*l$c))^2)
  d2 = (l$a+l$b) * (l$a+l$c) * (l$c+l$d) * (l$b+l$d)
  d3 = d1/d2
  d4 = (d3/n+d3)^(1/2)
  return(d4)
}


#####################################################################
#
#####################################################################
pearson.3 <- function(l){
  d1 = (l$a*l$d) - (l$b*l$c)
  d2 = sqrt( abs( (l$a+l$b)*(l$a+l$c)*(l$b+l$c)*(l$c+l$d) ) )
  d3 = d1/d2
  d4 = (d3/b+d3)^(1/2)
  return(d4)
}


#####################################################################
#
#####################################################################
pearson.heron.1 <- function(l){
  d1 = (l$a*l$d) - (l$b*l$c)
  d2 = (l$a+l$b) * (l$a+l$c) * (l$b+l$d) * (l$c+l$d)
  d3 = sqrt(abs(d2))
  d4 = d1/d2
  return(d4)
}


#####################################################################
#
#####################################################################
pearson.heron.2 <- function(l){
  d1 = pi * sqrt(abs(l$b*l$c))
  d2  = sqrt(abs(l$a*l$d)) + sqrt(abs(l$b*l$c))
  d3 = d1/d2
  d4 = cos(d3)
  return(d4)
}


#####################################################################
#
#####################################################################
peirce.1 <- function(l){
  d1 = (l$a*l$b) + (l$b*l$c)
  d2 = (l$a*l$b) + (2*l$b*l$c) + (l$c*l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
peirce.2 <- function(l){
  d1 = (l$a*l$d) - (l$b*l$c)
  d2 = (l$a+l$b) * (l$c+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
peirce.3 <- function(l){
  d1 = (l$a*l$d) - (l$b*l$c)
  d2 = (l$a+l$c) * (l$b+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
rogers.tanimoto <- function(l){
  return((l$a + l$d) / (l$a + (2*(l$b+l$c)) + l$d))
}


#####################################################################
#
#####################################################################
rogot.goldberd <- function(l){
  d1 = l$a/(l$a+l$b)+(l$a+l$c)
  d2 = l$d/(l$c+l$d)+(l$b+l$d)
  d3 = d1+d2
  return(d3)
}


#####################################################################
#
#####################################################################
russel.rao <- function(l){
  return(l$a/(l$a+l$b+l$c+l$d))
}


#####################################################################
#
#####################################################################
shape.difference <- function(l){
  d1 = l$n * ((l$b+l$c) - ((l$b-l$c)^2))
  d2 = (l$a + l$b + l$c + l$d)^2
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
simpson <- function(l){
  return(l$a/min((l$a+l$b),(l$a+l$c)))
}


#####################################################################
#
#####################################################################
size.difference <- function(l){
  d1 = (l$b+l$c)^2
  d2 = (l$a+l$b+l$c+l$d)^2
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
scott <- function(l){
  d1 = 4*l$a*l$d - ((l$b+l$c)^2)
  d2 = ((l$a+l$b) + (l$a+l$c)) * ((l$c+l$d)+(l$b+l$d))
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
sokal.michener <- function(l){
  return((l$a+l$d)/(l$a+l$b+l$c+l$d))
}


#####################################################################
#
#####################################################################
sokal.sneath.1 <- function(l){
  return(l$a/(l$a+(2*l$b)+(2*l$c)))
}


#####################################################################
#
#####################################################################
sokal.sneath.2 <- function(l){
  return(2*(l$a+l$d)/((2*l$a)+l$b+l$c+(2*l$d)))
}


#####################################################################
#
#####################################################################
sokal.sneath.3 <- function(l){
  return((l$a+l$d)/(l$b+l$c))
}


#####################################################################
#
#####################################################################
sokal.sneath.4a <- function(l){
  d1 = 1/4
  d2 = (l$a/l$a+l$b) * (l$a/l$a+l$c) * (l$a/l$c+l$d) * (l$a/l$b+l$d)
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
sokal.sneath.4b <- function(l){
  return((l$a/l$a+l$b) * (l$a/l$a+l$c) * (l$d/l$b+l$c) * (l$d/l$b+l$d))
}


#####################################################################
#
#####################################################################
sokal.sneath.5a <- function(l){
  d1 = l$a*l$d
  d2 = ((l$a+l$d) * (l$a+l$c) * (l$b+l$d) * (l$c+l$d))^0.5
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
sokal.sneath.5b <- function(l){
  d1 = l$a*l$d
  d2 = sqrt(abs((l$a+l$d) * (l$a+l$c) * (l$b+l$d) * (l$c+l$d)))
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
sorgenfrei <- function(l){
  return((l$a^2)/((l$a+l$b) * (l$a+l$c)))
}


#####################################################################
#
#####################################################################
square.euclidean <- function(l){
  return(sqrt(abs((l$b+l$c)^2)))
}


#####################################################################
#
#####################################################################
stiles <- function(l){
  d1 = n * ((abs((a*d)-(b*c)) - (n/2))^2)
  d2 = (l$a+l$b) * (l$a+l$c) * (l$b+l$d) * (l$c+l$d)
  d3 = d1/d2
  d4 = log10(d3)
  return(d4)
}


#####################################################################
#
#####################################################################
tanimoto <- function(l){
  d1 = l$a
  d2 = (l$a+l$b) + (l$a+l$c) - l$a
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
tarantula <- function(l){
  return((l$a* (l$c+l$d)) / (l$c * (l$a+l$d)))
}


#####################################################################
#
#####################################################################
tarwid <- function(l){
  d1 = (l$n*l$a) - ((l$a+l$b) * (l$a+l$c))
  d2 = (l$n*l$a) + ((l$a+l$b) * (l$a+l$c))
  d3 = d1/d2
  return(d3)
}


#####################################################################
#
#####################################################################
three.w.jaccard <- function(l){
  return((3 * l$a) / (3 * l$a + l$b + l$c))
}


#####################################################################
#
#####################################################################
vari <- function(l){
  return( (l$b+l$c)  / (4 * (l$a + l$b + l$c + l$d)))
}


#####################################################################
#
#####################################################################
yuleq.1 <- function(l){
  return(((l$a*l$d) - (l$b*l$c)) / ((l$a*l$d) - (l$b*l$c)))
}


#####################################################################
#
#####################################################################
yuleq.2 <- function(l){
  return((2*l$b*l$c) / ((l$a*l$d) + (l$b*l$c)))
}


#####################################################################
#
#####################################################################
yulew <- function(l){
  d1 = sqrt(abs(l$a*l$d)) - sqrt(abs(l$b*l$c))
  d2 = sqrt(abs(l$a*l$d)) - sqrt(abs(l$b*l$c))
  d3 = d1/d2
  return(d3)
}



#############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com
# Thank you very much!
#############################################################################
