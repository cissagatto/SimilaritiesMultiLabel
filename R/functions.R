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


#' Build Similarity Matrix
#'
#' This function initializes an empty similarity matrix for a given number of labels.
#'
#' @param labels A data frame representing the label space.
#' @param number.labels An integer specifying the number of labels.
#'
#' @return A matrix initialized with zeros and with proper row and column names.
#' @export
#'
#' @examples
#' labels <- data.frame(matrix(sample(0:1, 100, replace = TRUE), ncol = 10))
#' build.similarity.matrix(labels, ncol(labels))
build.similarity.matrix <- function(labels, number.labels) {
  similarity.matrix <- matrix(0, nrow = number.labels, ncol = number.labels)
  dimnames(similarity.matrix) <- list(colnames(labels), colnames(labels))
  return(similarity.matrix)
}


#' Compute A: Shared Positive Matches
#'
#' Computes the number of positions where both vectors have a value of 1.
#'
#' @param x A numeric vector (binary values).
#' @param y A numeric vector (binary values).
#'
#' @return The count of positions where both x and y equal 1.
#' @export
compute.a <- function(x, y) {
  return(sum(x == 1 & y == 1))
}


#' Compute B: X Absent, Y Present
#'
#' Computes the number of positions where x is 0 and y is 1.
#'
#' @param x A numeric vector (binary values).
#' @param y A numeric vector (binary values).
#'
#' @return The count of positions where x is 0 and y is 1.
#' @export
compute.b <- function(x, y) {
  return(sum(x == 0 & y == 1))
}


#' Compute C: Y Absent, X Present
#'
#' Computes the number of positions where x is 1 and y is 0.
#'
#' @param x A numeric vector (binary values).
#' @param y A numeric vector (binary values).
#'
#' @return The count of positions where x is 1 and y is 0.
#' @export
compute.c <- function(x, y) {
  return(sum(x == 1 & y == 0))
}


#' Compute D: Shared Negative Matches
#'
#' Computes the number of positions where both vectors have a value of 0.
#'
#' @param x A numeric vector (binary values).
#' @param y A numeric vector (binary values).
#'
#' @return The count of positions where both x and y equal 0.
#' @export
compute.d <- function(x, y) {
  return(sum(x == 0 & y == 0))
}


#' Compute AB: Sum of A and B
#'
#' Computes the sum of A (shared 1s) and B (x absent, y present).
#'
#' @param a Numeric value representing shared 1s.
#' @param b Numeric value representing x absent, y present.
#'
#' @return The sum of A and B.
#' @export
compute.ab <- function(a, b) {
  return(a + b)
}


#' Compute AC: Sum of A and C
#'
#' Computes the sum of A (shared 1s) and C (y absent, x present).
#'
#' @param a Numeric value representing shared 1s.
#' @param c Numeric value representing y absent, x present.
#'
#' @return The sum of A and C.
#' @export
compute.ac <- function(a, c) {
  return(a + c)
}


#' Compute AD: Sum of A and D
#'
#' Computes the sum of A (shared 1s) and D (shared 0s).
#'
#' @param a Numeric value representing shared 1s.
#' @param d Numeric value representing shared 0s.
#'
#' @return The sum of A and D.
#' @export
compute.ad <- function(a, d) {
  return(a + d)
}


#' Compute BC: Sum of B and C
#'
#' Computes the sum of B (x absent, y present) and C (y absent, x present).
#'
#' @param b Numeric value representing x absent, y present.
#' @param c Numeric value representing y absent, x present.
#'
#' @return The sum of B and C.
#' @export
compute.bc <- function(b, c) {
  return(b + c)
}


#' Compute BD: Sum of B and D
#'
#' Computes the sum of B (x absent, y present) and D (shared 0s).
#'
#' @param b Numeric value representing x absent, y present.
#' @param d Numeric value representing shared 0s.
#'
#' @return The sum of B and D.
#' @export
compute.bd <- function(b, d) {
  return(b + d)
}


#' Compute CD: Sum of C and D
#'
#' Computes the sum of C (y absent, x present) and D (shared 0s).
#'
#' @param c Numeric value representing y absent, x present.
#' @param d Numeric value representing shared 0s.
#'
#' @return The sum of C and D.
#' @export
compute.cd <- function(c, d) {
  return(c + d)
}


#' Compute N: Total Elements
#'
#' Computes the total number of elements in the dataset.
#'
#' @param a Numeric value representing shared 1s.
#' @param b Numeric value representing x absent, y present.
#' @param c Numeric value representing y absent, x present.
#' @param d Numeric value representing shared 0s.
#'
#' @return The total sum of all elements (A, B, C, and D).
#' @export
compute.n <- function(a, b, c, d) {
  return(a + b + c + d)
}


#' Compute MN Matrix
#'
#' Computes the MN matrix using four input matrices (`ma`, `mb`, `mc`, `md`).
#'
#' @param labels A data frame representing the label space.
#' @param number.labels An integer representing the number of labels.
#' @param ma A numeric matrix representing computed values of `compute.a`.
#' @param mb A numeric matrix representing computed values of `compute.b`.
#' @param mc A numeric matrix representing computed values of `compute.c`.
#' @param md A numeric matrix representing computed values of `compute.d`.
#'
#' @return A list containing the computed MN matrix.
#' @export
#'
#' @examples
#' labels <- matrix(sample(0:1, 100, replace = TRUE), ncol = 10)
#' ma <- matrix(runif(100), ncol = 10)
#' mb <- matrix(runif(100), ncol = 10)
#' mc <- matrix(runif(100), ncol = 10)
#' md <- matrix(runif(100), ncol = 10)
#' compute.mn(labels, ncol(labels), ma, mb, mc, md)
compute.mn <- function(labels, number.labels, ma, mb, mc, md) {
  # Inicializa matriz de similaridade
  mn <- build.similarity.matrix(labels, number.labels)
  
  # Processamento paralelo para evitar loops aninhados
  result_list <- mclapply(1:number.labels, function(i) {
    sapply(1:number.labels, function(j) compute.n(ma[i, j], mb[i, j], mc[i, j], md[i, j]))
  }, mc.cores = detectCores() - 1)  # Usa todos os núcleos menos 1
  
  # Converte lista em matriz
  mn <- do.call(cbind, result_list)
  
  return(list(mn = mn))
}



#' Compute Contingency Table (Optimized)
#'
#' This function calculates a contingency table based on a given function.
#' It uses parallel computing to improve efficiency.
#'
#' @param labels A data frame containing the label space.
#' @param number.labels An integer representing the number of labels.
#' @param FUN A function that computes a similarity or contingency measure between two vectors.
#' 
#' @return A list containing the contingency table as a matrix.
#' @import parallel
#' @export
#'
#' @examples
#' labels <- data.frame(matrix(sample(0:1, 100, replace = TRUE), ncol = 10))
#' compute.contingency.table(labels, ncol(labels), function(x, y) sum(x == y))
compute.contingency.table <- function(labels, number.labels, FUN) {
  m <- build.similarity.matrix(labels, number.labels)
  
  # Parallel computation of similarity measures
  result_list <- mclapply(1:number.labels, function(i) {
    sapply(1:number.labels, function(j) FUN(labels[, i], labels[, j]))
  }, mc.cores = detectCores() - 1)  # Use all cores except one to avoid system overload
  
  # Convert list to matrix
  m <- do.call(cbind, result_list)
  
  return(list(contingency.table = m))
}


#' Compute Marginal Probabilities
#'
#' Computes marginal probabilities between two matrices using a given function.
#'
#' @param labels A data frame representing the label space.
#' @param number.labels An integer representing the number of labels.
#' @param m1 A numeric matrix (first input matrix).
#' @param m2 A numeric matrix (second input matrix).
#' @param FUN A function to apply element-wise to m1 and m2.
#'
#' @return A list containing the matrix of computed marginal probabilities.
#' @export
#'
#' @examples
#' labels <- matrix(sample(0:1, 100, replace = TRUE), ncol = 10)
#' m1 <- matrix(runif(100), ncol = 10)
#' m2 <- matrix(runif(100), ncol = 10)
#' compute.marginal.probabilities(labels, ncol(labels), m1, m2, function(a, b) a + b)
compute.marginal.probabilities <- function(labels, number.labels, 
                                           m1, m2, FUN) {
  # Inicializa matriz de similaridade
  m <- build.similarity.matrix(labels, number.labels)
  
  
  # Processamento paralelo para evitar loops aninhados
  result_list <- mclapply(1:number.labels, function(i) {
    sapply(1:number.labels, function(j) FUN(m1[i, j], m2[i, j]))
  }, mc.cores = detectCores() - 1)  # Usa todos os núcleos menos 1
  
  # Converte lista em matriz
  m <- do.call(cbind, result_list)
  
  return(list(prob.marg = m))
}



#############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com
# Thank you very much!
#############################################################################
