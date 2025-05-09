% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{read_config_file}
\alias{read_config_file}
\title{Read Configuration File}
\usage{
read_config_file(config_file, datasets)
}
\arguments{
\item{config_file}{A character string specifying the path to the configuration file.}

\item{datasets}{A dataframe containing metadata of available datasets.}
}
\value{
A list containing configuration parameters extracted from the file.
}
\description{
Reads a CSV configuration file and extracts necessary parameters for processing.
}
