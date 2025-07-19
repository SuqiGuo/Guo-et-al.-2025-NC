#!/bin/ksh
exp_id="ctl frst crop"
MODEL="mpiesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
CMOR_VAR_table="tas-distribution" #ah cesm model output data used with cesm table
SIM1="frst" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="frst-ctl crop-ctl irri-crop harv-frst"
region_list="NAM CE CSAM CAF ESAM SAF SEAS GLOBAL"
region=(NAM CE CSAM CAF ESAM SAF SEAS)
lat_lbnd=(29.0 43.0 -11.0 -9.0 -24.0 -23.0 24.0)
lat_ubnd=(54.0 60.0 5.0 8.0 -3.0 -9.0 41.0)
lon_lbnd=(-116.0 35.0 -76.0 11.0 -55.0 14.0 94.0)
lon_ubnd=(-93.0 92.0 -55.0 32.0 -39.0 35.0 120.0)

#lon_lbnd=(244.0 35.0 284.0 11.0 305.0 14.0 94.0)
#lon_ubnd=(267.0 92.0 305.0 32.0 321.0 35.0 120.0)
#SCENARIO_COMBNATION="crop-ctl"
#, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"




for SCENARIO in ${SCENARIO_COMBNATION}; do
  for CMOR_VAR in ${CMOR_VAR_table}; do
	            for region_source in ${region_list}; do
          SCRATCH="/work/bm1147/b380949/web-monitoring/MPI-PLOT/Lutdata"
str_tmp=${CMOR_VAR}_${SCENARIO}_${MODEL}_Lut_last30mean_chname_$region_source.nc
dir=${SCRATCH}/TCRE/perarea/${region_source}
for i in $(seq 0 6); do
        region_intercpt=${CMOR_VAR}_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region_source}_${region[$i]}.nc
        ncks  -d lon,${lon_lbnd[$i]},${lon_ubnd[$i]} -d lat,${lat_lbnd[$i]},${lat_ubnd[$i]} $dir/$str_tmp  $dir/$region_intercpt
done
done
done
done



