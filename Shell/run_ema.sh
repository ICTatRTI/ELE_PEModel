#!/bin/bash

# a script to run the EMA model
# use the flag -o to run the original, unedited EMA model
ORIGINAL="FALSE"

while getopts 'o' opt
do
    case $opt in 
        o) ORIGINAL="TRUE"
    esac
done

if [ $ORIGINAL = "TRUE" ]
then
    echo "Running Original EMA model..."
    ../../gams.exe ../Model/model_OG.gms
else
    echo "Running Updated EMA model..."
    ../../gams.exe ../Model/model.gms
fi

# dump marginal prices to csv
../../gdxdump.exe ../Model/Output/pivot.gdx output=../Model/Results/EMA_output_wholesaleprice.csv format=csv symb=chk_price header="load_segment,region,year,value"