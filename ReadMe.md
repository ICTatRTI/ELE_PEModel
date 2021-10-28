# Electricity Partial Equilibrium model

## RTI

### Updated by Shane Weisberg, October 2021

### Run Instructions:
Using the terminal, navigate to the "Shell" directory and run the shell script `run_pe.sh`
Add the flag `-o` to this command to run the original, unmodified optimization model
If bash is not installed on your system (windows users), you can download gitbash from https://git-scm.com/downloads and configure VS Code to run bash in its terminal

### Contents:

#### GAMS Files

* `model.gms`: This is the main script that will run the optimization problem. It contains the definition of the objective function and all constraints. It calls the other essential `.gms` files described below.
* `data.gms`: This is the script responsible for loading and preparing data. In the original version of the model, the user can set a carbon tax and other parameters in this script.
* `sets.gms`: This is the script responsible for defining all sets used by the optimization problem. 
* `findings.gms`: This script will produce reports and outputs.


#### Shell Scripts
The directory "Shell" contains the following two bash scripts:
* `run_pe.sh` - this script should be used to initiate model runs
* `csv_to_gdx_batch.sh` - this script is able to convert csv data input files to gdx files and must be run once any time the input data is updated

#### Data Files
The directory "Data" contains the following:
* In the "updated_data" directory there are csv files containing supporting data for the model. 
    * `PE_capacity.csv`, `PE_pf.csv`, `PE_dele.csv`, `PE_fomcost.csv`, `PE_vomcost.csv`, `PE_heatrate.csv`, `PE_count.csv` contain data that has been updated using the MEEDE dataset
    * `PE_capcost_2020.csv`, `PE_dadj_2020.csv`, `PE_pbio_2020.csv`, `PE_biosupply_2020.csv`, `PE_peak_2020.csv`, `PE_pele_2020.csv` contain original unedited data truncated to only contain data pertaining to the year 2020.

#### Output Files
The directories "Model/Output" and Model/Results" are set up to receive outputs from the model. "Model/Results" contains results in csv format on generation, capacity, and costs. These files can be read and processed by the included R scripts to allow for easy comparisons of model runs.
