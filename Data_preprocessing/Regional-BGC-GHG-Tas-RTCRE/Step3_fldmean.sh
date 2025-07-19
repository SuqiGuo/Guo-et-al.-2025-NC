#!/bin/ksh
exp_id="ctl frst crop"
MODEL="mpiesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
CMOR_VAR_table="tas-distribution" #ah cesm model output data used with cesm table
SIM1="frst" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="frst-ctl crop-ctl irri-crop harv-frst"
region_list="NAM CE CSAM CAF ESAM SAF SEAS GLOBAL"
#SCENARIO_COMBNATION="crop-ctl"
#, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
plotdir=/work/bm1147/b380949/web-monitoring/relative-error
for SCENARIO in ${SCENARIO_COMBNATION}; do
  for CMOR_VAR in ${CMOR_VAR_table}; do
#mv $SCRATCH/TCRE/GLOBAL/cLand_${SCENARIO}_mpiesm_Lut_last30mean_chname_GLOBAL_invertlat.nc $SCRATCH/TCRE/GLOBAL/cLand_${SCENARIO}_mpiesm_Lut_last30mean_chname_GLOBAL.nc
 for region_source in ${region_list}; do
	  SCRATCH="/work/bm1147/b380949/web-monitoring/MPI-PLOT/Lutdata"
str_tmp=${CMOR_VAR}_${SCENARIO}_${MODEL}_Lut_last30mean_chname_$region_source.nc
dir=${SCRATCH}/TCRE/perarea/${region_source}
mv $dir/$str_tmp $dir/${CMOR_VAR}_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region_source}_GLOBAL.nc
#mkdir $dir
#mv $SCRATCH/$str_tmp $dir/
for region in ${region_list}; do
str=${CMOR_VAR}_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region_source}_${region}.nc
ncatted -a bounds,lat,c,c,"lat_bnds"   $dir/$str
ncatted -a bounds,lon,c,c,"lon_bnds"   $dir/$str
ncatted -a CDI_grid_type,tas_local,c,c,"gaussian"   $dir/$str
ncatted -a CDI_grid_num_LPE,tas_local,c,d,48   $dir/$str

ncatted -a CDI_grid_type,tas_nonlocal,c,c,"gaussian"   $dir/$str
ncatted -a CDI_grid_num_LPE,tas_nonlocal,c,d,48   $dir/$str

ncatted -a CDI_grid_type,tas_total,c,c,"gaussian"   $dir/$str
ncatted -a CDI_grid_num_LPE,tas_total,c,d,48   $dir/$str

rm $dir/tas_fldmean_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region_source}_$region.nc
cdo -fldmean $dir/$str $dir/tas_fldmean_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region_source}_$region.nc
done
#cdo add $plotdir/cVeg_${SCENARIO}_${MODEL}_last30mean.nc $plotdir/cSoil_${SCENARIO}_${MODEL}_last30mean.nc \
#$plotdir/cLitter_${SCENARIO}_${MODEL}_last30mean.nc $plotdir/cProduct_${SCENARIO}_${MODEL}_last30mean.nc \
#$plotdir/cLand_${SCENARIO}_${MODEL}_last30mean.nc
done
done
done
