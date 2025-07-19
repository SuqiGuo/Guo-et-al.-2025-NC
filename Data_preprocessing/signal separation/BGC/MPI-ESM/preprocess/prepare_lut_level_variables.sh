#!/bin/ksh
exp_id="CTL FRST HARV IRRI CROP"
MODEL="mpiesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
# CMOR_VACMOR_TABLER_LIST="cSoil cLitter cVeg cProduct"
# CMOR_VAR_LIST="gpp npp nbp ra rh"
# CMOR_VAR_LIST="mrsol nep"
# CMOR_VAR_LIST="TSA TG EFLX_LH_TOT FSH PRECC PRECL WIND Q2M" # cesm model output data used with cesm table
CMOR_VAR_LIST="cVegLut cSoilLut cLitterLut" # cesm model output data used with cesm table
# CMOR_VAR_LIST="PRECC PRECL" # still missing for frst-ctl and crop-ctl 
# CMOR_VAR_LIST="tas"
SIM1="frst" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="${SIM1}-${SIM2}" #, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
ctlfrac_dir=/work/bm1147/b380949/web-monitoring/cover/ctl/
root_dir=/work/bm1147/b380949/mpiesm-1.2.01-release/experiments/
sub_dir=archive/CMIP6/ScenarioMIP/MPI-M/MPI-ESM1-2-LR/ssp245/r1i1p1f1/
aim_dir=/work/bm1147/b380949/web-monitoring/MPI-ESM/Lutdata
for CMOR_VAR in ${CMOR_VAR_LIST}; do
for exp in ${exp_id}; do
	mkdir ${aim_dir}/${exp}
	destination=${aim_dir}/${exp}
    DIR=${root_dir}/${exp}/${sub_dir}/${CMOR_TABLE}/$CMOR_VAR/gn/v20190710/
if [ "$exp" == "FRST" ]; then
    cp ${DIR}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2130-2149.nc  ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2130-2149.nc
    cp ${DIR}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2150-2169.nc  ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2150-2169.nc
    cp ${DIR}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2170-2173.nc  ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2170-2173.nc
    cp ${DIR}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2174-2175.nc  ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2174-2175.nc
    FILES=`find ${destination}/* -name "${CMOR_VAR}*"`
    cdo mergetime ${FILES} ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2130-2175.nc
    ncks -O -d time,15,44 ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2130-2175.nc \
    ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2145-2174.nc   

    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2130-2149.nc
    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2150-2169.nc 
    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2170-2173.nc
    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2174-2175.nc
    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2130-2175.nc
else
    cp ${DIR}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2135-2154.nc  ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2135-2154.nc
    cp ${DIR}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2155-2174.nc  ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2155-2174.nc
    FILES=`find ${destination}/* -name "${CMOR_VAR}*"`
    cdo mergetime ${FILES} ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2135-2174.nc

    ncks -O -d time,10,39 ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2135-2174.nc \
    ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2145-2174.nc   
   
    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2135-2154.nc
    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2155-2174.nc
    rm ${destination}/${CMOR_VAR}_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2135-2174.nc

fi

done
done

