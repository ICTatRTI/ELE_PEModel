#!/bin/bash

# script to convert rolled-up MEEDE data files (from R) to gdx data files
# Note: must use git bash (unix) to run this in the terminal

# Use option -o to look for data for the 1-period EMA run
ONLY2020="FALSE"

while getopts 'o' opt
do
    case $opt in 
        o) ONLY2020="TRUE"
    esac
done

## ---New data from MEEDE -----------------------------------------

if [ $ONLY2020 = "TRUE" ]
then
    echo "Gathering Data for 1-period PE run..."
    ## ---Updated Data to remove all years but 2020-----------------------------
    # biosupply
    ../../csv2gdx.exe ../Data/updated_data/PE_biosupply_2020.csv output=../Data/output/biosupply_2020.gdx index=1..3 values=lastCol useHeader=Y id=biosupply

    # capcost
    ../../csv2gdx.exe ../Data/updated_data/PE_capcost_2020.csv output=../Data/output/capcost_2020.gdx index=1..3 values=lastCol useHeader=Y id=capcost

    # dadj
    ../../csv2gdx.exe ../Data/updated_data/PE_dadj_2020.csv output=../Data/output/dadj_2020.gdx index=1..2 values=lastCol useHeader=Y id=dadj

    # pbio
    ../../csv2gdx.exe ../Data/updated_data/PE_pbio_2020.csv output=../Data/output/pbio_2020.gdx index=1..3 values=lastCol useHeader=Y id=pbio

    # peak
    ../../csv2gdx.exe ../Data/updated_data/PE_peak_2020.csv output=../Data/output/peak_2020.gdx index=1..2 values=lastCol useHeader=Y id=peak

    # peak
    ../../csv2gdx.exe ../Data/updated_data/PE_pele_2020.csv output=../Data/output/pele_2020.gdx index=1..2 values=lastCol useHeader=Y id=pele
else
    echo "Gathering Data for multi-period PE run..."
    ## ---Updated Data to remove 2010,2015 years-----------------------------
    # biosupply
    ../../csv2gdx.exe ../Data/updated_data/PE_biosupply.csv output=../Data/output/biosupply_2020.gdx index=1..3 values=lastCol useHeader=Y id=biosupply

    # capcost
    ../../csv2gdx.exe ../Data/updated_data/PE_capcost.csv output=../Data/output/capcost_2020.gdx index=1..3 values=lastCol useHeader=Y id=capcost

    # dadj
    ../../csv2gdx.exe ../Data/updated_data/PE_dadj.csv output=../Data/output/dadj_2020.gdx index=1..2 values=lastCol useHeader=Y id=dadj

    # pbio
    ../../csv2gdx.exe ../Data/updated_data/PE_pbio.csv output=../Data/output/pbio_2020.gdx index=1..3 values=lastCol useHeader=Y id=pbio

    # peak
    ../../csv2gdx.exe ../Data/updated_data/PE_peak.csv output=../Data/output/peak_2020.gdx index=1..2 values=lastCol useHeader=Y id=peak

    # peak
    ../../csv2gdx.exe ../Data/updated_data/PE_pele.csv output=../Data/output/pele_2020.gdx index=1..2 values=lastCol useHeader=Y id=pele
fi

## These files have the same names regardless of the model run
# capacity
../../csv2gdx.exe ../Data/updated_data/PE_capacity.csv output=../Data/output/MEEDE_capacity.gdx index=1..3 values=lastCol useHeader=Y id=capacity  

# count
../../csv2gdx.exe ../Data/updated_data/PE_count.csv output=../Data/output/MEEDE_count.gdx index=1..2 values=lastCol useHeader=Y id=count

# heatrate
../../csv2gdx.exe ../Data/updated_data/PE_heatrate.csv output=../Data/output/MEEDE_heatrate.gdx index=1..3 values=lastCol useHeader=Y id=heatrate

# vomcost
../../csv2gdx.exe ../Data/updated_data/PE_vomcost.csv output=../Data/output/MEEDE_vomcost.gdx index=1..2 values=lastCol useHeader=Y id=vomcost

# fomcost
../../csv2gdx.exe ../Data/updated_data/PE_fomcost.csv output=../Data/output/MEEDE_fomcost.gdx index=1..2 values=lastCol useHeader=Y id=fomcost

# size
../../csv2gdx.exe ../Data/updated_data/PE_size.csv output=../Data/output/MEEDE_size.gdx index=1..3 values=lastCol useHeader=Y id=size

# dele
../../csv2gdx.exe ../Data/updated_data/PE_dele.csv output=../Data/output/MEEDE_dele.gdx index=1..2 values=lastCol useHeader=Y id=dele

# pf--fuel price
../../csv2gdx.exe ../Data/updated_data/PE_pf.csv output=../Data/output/MEEDE_pf.gdx index=1..3 values=lastCol useHeader=Y id=pf