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
    echo "Gathering Data for 1-period EMA run..."
    ## ---Updated Data to remove all years but 2020-----------------------------
    # biosupply
    ../../csv2gdx.exe ../Data/updated_data/EMA_biosupply_2020.csv output=../Data/output/biosupply_2020.gdx index=1..3 values=lastCol useHeader=Y id=biosupply

    # capcost
    ../../csv2gdx.exe ../Data/updated_data/EMA_capcost_2020.csv output=../Data/output/capcost_2020.gdx index=1..3 values=lastCol useHeader=Y id=capcost

    # dadj
    ../../csv2gdx.exe ../Data/updated_data/EMA_dadj_2020.csv output=../Data/output/dadj_2020.gdx index=1..2 values=lastCol useHeader=Y id=dadj

    # pbio
    ../../csv2gdx.exe ../Data/updated_data/EMA_pbio_2020.csv output=../Data/output/pbio_2020.gdx index=1..3 values=lastCol useHeader=Y id=pbio

    # peak
    ../../csv2gdx.exe ../Data/updated_data/EMA_peak_2020.csv output=../Data/output/peak_2020.gdx index=1..2 values=lastCol useHeader=Y id=peak

    # peak
    ../../csv2gdx.exe ../Data/updated_data/EMA_pele_2020.csv output=../Data/output/pele_2020.gdx index=1..2 values=lastCol useHeader=Y id=pele
else
    echo "Gathering Data for multi-period EMA run..."
    ## ---Updated Data to remove 2010,2015 years-----------------------------
    # biosupply
    ../../csv2gdx.exe ../Data/updated_data/EMA_biosupply.csv output=../Data/output/biosupply_2020.gdx index=1..3 values=lastCol useHeader=Y id=biosupply

    # capcost
    ../../csv2gdx.exe ../Data/updated_data/EMA_capcost.csv output=../Data/output/capcost_2020.gdx index=1..3 values=lastCol useHeader=Y id=capcost

    # dadj
    ../../csv2gdx.exe ../Data/updated_data/EMA_dadj.csv output=../Data/output/dadj_2020.gdx index=1..2 values=lastCol useHeader=Y id=dadj

    # pbio
    ../../csv2gdx.exe ../Data/updated_data/EMA_pbio.csv output=../Data/output/pbio_2020.gdx index=1..3 values=lastCol useHeader=Y id=pbio

    # peak
    ../../csv2gdx.exe ../Data/updated_data/EMA_peak.csv output=../Data/output/peak_2020.gdx index=1..2 values=lastCol useHeader=Y id=peak

    # peak
    ../../csv2gdx.exe ../Data/updated_data/EMA_pele.csv output=../Data/output/pele_2020.gdx index=1..2 values=lastCol useHeader=Y id=pele
fi

## These files have the same names regardless of the model run
# capacity
../../csv2gdx.exe ../Data/updated_data/EMA_capacity.csv output=../Data/output/MEEDE_capacity.gdx index=1..3 values=lastCol useHeader=Y id=capacity  

# count
../../csv2gdx.exe ../Data/updated_data/EMA_count.csv output=../Data/output/MEEDE_count.gdx index=1..2 values=lastCol useHeader=Y id=count

# heatrate
../../csv2gdx.exe ../Data/updated_data/EMA_heatrate.csv output=../Data/output/MEEDE_heatrate.gdx index=1..3 values=lastCol useHeader=Y id=heatrate

# vomcost
../../csv2gdx.exe ../Data/updated_data/EMA_vomcost.csv output=../Data/output/MEEDE_vomcost.gdx index=1..2 values=lastCol useHeader=Y id=vomcost

# fomcost
../../csv2gdx.exe ../Data/updated_data/EMA_fomcost.csv output=../Data/output/MEEDE_fomcost.gdx index=1..2 values=lastCol useHeader=Y id=fomcost

# size
../../csv2gdx.exe ../Data/updated_data/EMA_size.csv output=../Data/output/MEEDE_size.gdx index=1..3 values=lastCol useHeader=Y id=size

# dele
../../csv2gdx.exe ../Data/updated_data/EMA_dele.csv output=../Data/output/dele_2020.gdx index=1..2 values=lastCol useHeader=Y id=dele

# pf--fuel price
../../csv2gdx.exe ../Data/updated_data/EMA_pf.csv output=../Data/output/pf_2020.gdx index=1..3 values=lastCol useHeader=Y id=pf