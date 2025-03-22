# Compute Similarities Matrices for MultiLabel Classification

This code is part of my PhD research at **PPG-CC/DC/UFSCar**. The goal is to compute similarity measures for multi-label classification using only the label space. 🤖

## How to Cite

Gatto, E. C. (2023). **Compute Similarities Measures for Multi-Label Classification**. GitHub repository. Available at: [https://github.com/cissagatto/SimilaritiesMultiLabel](https://github.com/cissagatto/SimilaritiesMultiLabel).

## Source Code

This code is written in **R** and is designed to run in the **RStudio IDE**. The project consists of the following scripts:

1. **libraries.R**
2. **utils.R**
3. **functions.R**
4. **similarities.R**
5. **run.R**
6. **sml.R**
7. **config_files.R**

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

### **STEP 4**: Package Installation
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
This code was developed with **RStudio Version 1.4.1106** (Ubuntu Bionic) and **R version 4.1.0**.

## Hardware Requirements
This code may or may not run in parallel, but it is highly recommended to run it in parallel. The number of cores can be configured via the command line (**number_cores** argument). For reproducibility, it is recommended to use 10 cores. In our experiments, we used 10 cores.

## Results
The results will be stored in the **SIMILARITIES** folder and will be used in the next phase: **BuildDataFrameGraphMLC**.

## How to Run
Open the terminal, navigate to the `~/SimilaritiesMultiLabel/R` folder, and run:

```bash
Rscript slm.R [absolute_path_to_config_file]
```

Example:

```bash
Rscript slm.R "~/SimilaritiesMultiLabel/config-files/jaccard/smj-emotions.csv"
```

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


# Contact
elainececiliagatto@gmail.com

## Links

| [Site](https://sites.google.com/view/professor-cissa-gatto) | [Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br) | [Computer Department](https://site.dc.ufscar.br/) |  [Biomal](http://www.biomal.ufscar.br/) | [CNPQ](https://www.gov.br/cnpq/pt-br) | [Ku Leuven](https://kulak.kuleuven.be/) | [Embarcados](https://www.embarcados.com.br/author/cissa/) | [Read Prensa](https://prensa.li/@cissa.gatto/) | [Linkedin Company](https://www.linkedin.com/company/27241216) | [Linkedin Profile](https://www.linkedin.com/in/elainececiliagatto/) | [Instagram](https://www.instagram.com/cissagatto) | [Facebook](https://www.facebook.com/cissagatto) | [Twitter](https://twitter.com/cissagatto) | [Twitch](https://www.twitch.tv/cissagatto) | [Youtube](https://www.youtube.com/CissaGatto) |

# Thanks
