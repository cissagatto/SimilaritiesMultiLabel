# Compute Similarities Matrices for MultiLabel Classification
This code is part of my PhD research at PPG-CC/DC/UFSCar. The aim is to compute similarities measures for multilabel classification using only the label space!

## How to cite 
```plaintext
@misc{Gatto2023, 
author = {Gatto, E. C.}, 
title = {Compute Similarities Measures for Multi-Label Classification}, 
year = {2023}, 
publisher = {GitHub}, 
journal = {GitHub repository}, 
howpublished = {\url{https://github.com/cissagatto/SimilaritiesMultiLabel}}}
```


## Objectives

The main objective of this project is to provide tools for computing and analyzing similarity measures between labels in multi-label classification problems. By focusing solely on the label space, the project offers a unique perspective on label relationships, independent of the attributes of the data instances.

## Code Features

    Multiple Similarity Measures: Implements several well-known similarity measures for categorical data, such as Jaccard and Rogers.

    Flexible: Easily add or remove similarity measures to customize the analysis for your specific needs.

    Similarity Matrices: The results are stored in similarity matrices, which can be used for further analysis or as inputs for other tasks.

    Documentation: Detailed roxygen documentation to help users understand the functionality and easily modify the code to suit their needs.


### Documentation

For more detailed documentation on each function, check out the `~/SimilaritiesMultiLabel/docs`folder

A complete example is available in `~/SimilaritiesMultiLabel/examples` folder


## Instalation


```r
# install.packages("devtools")
library("devtools")
devtools::install_github("https://github.com/cissagatto/SimilaritiesMultiLabel")
library(SimilaritiesMultiLabel)
```


# Source Code
This source code is part of an R project to be used in the RStudio IDE and includes the following R scripts:

1. **libraries.R** – Loads the required R packages.  
2. **utils.R** – Contains helper functions for processing.  
3. **functions.R** – Defines various functions used across the project to handle data and generate results.  
4. **similarities.R** – Contains functions for calculating similarity measures between datasets or labels.  
5. **run.R** – The main execution script that runs the core logic of the project.  
6. **sml.R** – Used to run the script via the terminal.
7. **config_files.R** – Generates the configuration file needed to run the code.  
8. **jobs.R** – If running on a cluster, this script can be used to generate the necessary `.sh` files to run the job in parallel.


## Preparing your experiment

## Preparing Your Experiment

### **STEP 1**: File `datasets-original.csv`
A file called `datasets-original.csv` must be located in the **root project directory**. This file contains information about the datasets used by the code. It includes 90 multi-label datasets. To add a new dataset, include the following information in the file:

| Parameter   | Status    | Description                                                          |
|-------------|-----------|--------------------------------------------------------------------|
| **Id**      | mandatory | Integer ID to identify the dataset                                  |
| **Name**    | mandatory | Dataset name (must follow the benchmark)                             |
| **Domain**  | optional  | Dataset domain                                                      |
| **Instances**  | mandatory | Total number of dataset instances                                    |
| **Attributes**   | mandatory | Total number of dataset attributes                                   |
| **Labels**     | mandatory | Total number of labels in the label space                             |
| **Inputs**    | mandatory | Total number of input attributes                                      |
| **Cardinality** | optional  | **                                                               |
| **Density**   | optional  | **                                                               |
| **Labelsets**   | optional  | **                                                               |
| **Single**      | optional  | **                                                               |
| **Max.freq**    | optional  | **                                                               |
| **Mean.IR**     | optional  | **                                                               |
| **Scumble**     | optional  | **                                                               |
| **TCS**         | optional  | **                                                               |
| **AttStart**    | mandatory | Column number where the attribute space begins * 1                   |
| **AttEnd**      | mandatory | Column number where the attribute space ends                        |
| **LabelStart**  | mandatory | Column number where the label space begins                           |
| **LabelEnd**    | mandatory | Column number where the label space ends                             |
| **Distinct**    | optional  | **                                                               |
| **xn**          | mandatory | Value for Dimension X of the Kohonen map                            |
| **yn**          | mandatory | Value for Dimension Y of the Kohonen map                            |
| **gridn**       | mandatory | X times Y. Kohonen's map must be square                             |
| **max.neighbors** | mandatory | The maximum number of neighbors (given by LABELS - 1)                |
| **Label Dependency** | optional | The dependency between labels in all dataset |

1 - Since it is the first column, the number is always 1.

2 - [Click here](https://link.springer.com/book/10.1007/978-3-319-41111-8) for explanations of each property.

3 - Label Dependency can be calculated like in this paper: Luaces 2012

### **STEP 2**: X-Fold Cross-Validation Files
You need **X-Fold Cross-Validation** files in **tar.gz** format. You can download the pre-made 10-fold files for multi-label datasets [here](https://www.4shared.com/directory/ypgzwzjq/datasets-cross-validation.html). For a new dataset, in addition to adding it to the **datasets-original.csv** file, you must run this code [here](https://github.com/cissagatto/crossvalidationmultilabel) to generate the necessary cross-validation files. The **tar.gz** file can be placed in any directory on your computer or server. The absolute path of the file must be passed as a parameter in the configuration file, which will be read by the **mlsm.R** script.


### **STEP 3**: Environment
You need to install all required **Java**, **Python**, and **R** packages to run this code on your machine or server. The code does not automatically install the packages.

You can use the **Conda Environment** I created to run the experiment. To install it, use the following command to extract the environment to your machine:

```bash
conda env create -file AmbienteTeste.yaml
```

For more information about Conda environments, visit the official [Conda documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

Alternatively, you can run the code using the **AppTainer** [container](https://1drv.ms/u/s!Aq6SGcf6js1mw4hcVuz_IN8_Bh1oFQ?e=5NuyxX) I use for running the code on a SLURM cluster. Check this [tutorial](https://rpubs.com/cissagatto/apptainer-slurm-r) (in Portuguese) for more details.

### **STEP 5**: Configuration File
You need a configuration file saved in **csv** format containing the following information:

| Config          | Value                                                                      |
|-----------------|----------------------------------------------------------------------------|
| **Dataset_Path**    | Absolute path to the directory where the dataset tar.gz is stored          |
| **Temporary_Path**  | Absolute path to the directory where temporary processing will be done    |
| **Similarity_Path** | Absolute path to the directory where similarity matrices will be stored   |
| **Similarity**      | "jaccard", "rogers", or another similarity measure                        |
| **Dataset_Name**    | Dataset name according to the **datasets-original.csv** file              |
| **Number_Dataset**  | Dataset number according to the **datasets-original.csv** file            |
| **Number_Folds**    | Number of folds used in cross-validation                                  |
| **Number_Cores**    | Number of cores for parallel processing                                    |
| **R_clone**         | If you want to upload the results to your nuvem                            |
| **Save_csv_files**  | If you want to save the resulting csv files in your machine                 |

You can save the configuration file anywhere you want and pass the absolute path as a command-line argument.


## Software Requirements
This code was develop in RStudio Version 1.4.1106 © 2009-2021 RStudio, PBC "Tiger Daylily" (2389bc24, 2021-02-11) for Ubuntu Bionic Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.12.8 Chrome/69.0.3497.128 Safari/537.36. The R Language version was: R version 4.1.0 (2021-05-18) -- "Camp Pontanezen" Copyright (C) 2021 The R Foundation for Statistical Computing Platform: x86_64-pc-linux-gnu (64-bit).

## Hardware Requirements
This code may or may not be executed in parallel, however, it is highly recommended that you run it in parallel. The number of cores can be configured via the command line (number_cores). If number_cores = 1 the code will run sequentially. In our experiments, we used 10 cores. For reproducibility, we recommend that you also use ten cores. This code was tested with the birds dataset in the following machine:

*System:*

Host: bionote | Kernel: 5.8.0-53-generic | x86_64 bits: 64 | Desktop: Gnome 3.36.7 | Distro: Ubuntu 20.04.2 LTS (Focal Fossa)

*CPU:*

Topology: 6-Core | model: Intel Core i7-10750H | bits: 64 | type: MT MCP | L2 cache: 12.0 MiB | Speed: 800 MHz | min/max: 800/5000 MHz Core speeds (MHz): | 1: 800 | 2: 800 | 3: 800 | 4: 800 | 5: 800 | 6: 800 | 7: 800 | 8: 800 | 9: 800 | 10: 800 | 11: 800 | 12: 800 |

Then the experiment was executed in a cluster at UFSCar.

## Results
The results stored in the folder _Similarities_ it will be used in the next phase: *BuildDataFrameGraphMLC*. The result for a dataset must be put in the folder *Similarities* in the respective code. Also, must be in "tar.gz" format.

## RUN
To run the code, open the terminal, enter the *~/SimilaritiesMultiLabel/examples* folder, and type

```
Rscript sml.R [absolute_path_to_config_file]
```

Example:

```
Rscript slm.R "~/SimilaritiesMultiLabel/config-files/jaccard/smj-emotions.csv"
```

## DOWNLOAD RESULTS
[Click here]


## 📧 **Contact**

For any questions or support, please contact:
- **Prof. Elaine Cecilia Gatto** (elainececiliagatto@gmail.com)


## Download Results
[Click here]

## Acknowledgments
- **CAPES** - Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brazil (Finance Code 001) 💼
- **CNPq** - Conselho Nacional de Desenvolvimento Científico e Tecnológico - Brazil (Process number 200371/2022-3) 💡
- **FAPESP** - Financial support 💰
- Special thanks to **UFSCar** and other institutions for their support! 🙏

## How Can I Help? 🤝

I’m looking for help to improve and optimize this code. The areas where I need assistance include:

- **Add or remove similarity measures**: If you know of other similarity measures that could be relevant to this work, your contribution would be greatly appreciated! 🌟
- **Check if all 109 categorical data similarity measures are correctly implemented**: I need to verify if all measures have been implemented properly and efficiently, with minimal processing and memory usage. 📊
- **Documentation**: Write **roxygen** documentation for all functions to make the code more understandable and easier to use. 📚
- **Code Optimization**: Explore if the code can be further optimized for performance and readability. ⚙️

If you're interested in collaborating, please feel free to reach out! ✉️
## Links

| [Site](https://sites.google.com/view/professor-cissa-gatto) | [Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br) | [Computer Department](https://site.dc.ufscar.br/) |  [Biomal](http://www.biomal.ufscar.br/) | [CNPQ](https://www.gov.br/cnpq/pt-br) | [Ku Leuven](https://kulak.kuleuven.be/) | [Embarcados](https://www.embarcados.com.br/author/cissa/) | [Read Prensa](https://prensa.li/@cissa.gatto/) | [Linkedin Company](https://www.linkedin.com/company/27241216) | [Linkedin Profile](https://www.linkedin.com/in/elainececiliagatto/) | [Instagram](https://www.instagram.com/cissagatto) | [Facebook](https://www.facebook.com/cissagatto) | [Twitter](https://twitter.com/cissagatto) | [Twitch](https://www.twitch.tv/cissagatto) | [Youtube](https://www.youtube.com/CissaGatto) |

# Thanks


