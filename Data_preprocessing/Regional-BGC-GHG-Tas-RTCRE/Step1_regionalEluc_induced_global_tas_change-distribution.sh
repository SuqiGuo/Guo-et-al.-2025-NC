#!/bin/ksh
exp_id="ctl frst crop"
MODEL="mpiesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
CMOR_VAR_table="cLand" #ah cesm model output data used with cesm table
SIM1="frst" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="frst-ctl crop-ctl irri-crop harv-frst"
region_list="NAM CE CSAM CAF ESAM SAF SEAS GLOBAL"
#SCENARIO_COMBNATION="crop-ctl"
#, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
plotdir=/work/bm1147/b380949/web-monitoring/relative-error
for SCENARIO in ${SCENARIO_COMBNATION}; do
  for CMOR_VAR in ${CMOR_VAR_table}; do
	  SCRATCH="/work/bm1147/b380949/web-monitoring/MPI-PLOT/Lutdata"
#mv $SCRATCH/TCRE/GLOBAL/cLand_${SCENARIO}_mpiesm_Lut_last30mean_chname_GLOBAL_invertlat.nc $SCRATCH/TCRE/GLOBAL/cLand_${SCENARIO}_mpiesm_Lut_last30mean_chname_GLOBAL.nc
  	  for region in ${region_list}; do
dir=$SCRATCH/TCRE/perarea/$region
mkdir $dir
str_tmp=${CMOR_VAR}_${SCENARIO}_${MODEL}_Lut_last30mean_chname_$region.nc
cp $SCRATCH/TCRE/$region/$str_tmp $dir/
cdo mulc,-1.0e-3 -fldmean $dir/$str_tmp $dir/Eluc_${SCENARIO}_${MODEL}_Lut_last30mean_chname_$region.nc
#1kg/m^2 integrated over 100 million hectares(1 million km^2 that is 1.0e+6km^2)  1.0e+6km^2= 1.0e+12 m^2; 1Kg=1e+3g=1e-15 EgC= 1e-12 GtC
cdo mulc,1.65 $dir/Eluc_${SCENARIO}_${MODEL}_Lut_last30mean_chname_$region.nc $dir/GMT-tas_${SCENARIO}_${MODEL}_Lut_last30mean_chname_$region.nc 
#rm $dir/tas-*


cdo merge $dir/GMT-tas_${SCENARIO}_${MODEL}_Lut_last30mean_chname_$region.nc $SCRATCH/tcre_MPI-ESM1-2-LR.nc $dir/tas_${SCENARIO}_${MODEL}_Lut_last30mean_chname_tmp_$region.nc
cdo expr,'tas_nonlocal=slope*cLand_nonlocal;tas_local=slope*cLand_local;tas_total=slope*cLand_total' $dir/tas_${SCENARIO}_${MODEL}_Lut_last30mean_chname_tmp_$region.nc $dir/tas-distribution_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region}_tmp.nc
cdo chname,lat_2,lat,lon_2,lon $dir/tas-distribution_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region}_tmp.nc \
	$dir/tas-distribution_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region}_lonlat.nc
ncap2 -s 'defdim("bnds",2);lon_bnds=make_bounds(lon,$bnds);lat_bnds=make_bounds(lat,$bnds);' $dir/tas-distribution_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region}_lonlat.nc $dir/tas-distribution_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region}.nc

rm $dir/tas_${SCENARIO}_${MODEL}_Lut_last30mean_chname_tmp_$region.nc
rm $dir/tas-distribution_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region}_tmp.nc
rm $dir/tas-distribution_${SCENARIO}_${MODEL}_Lut_last30mean_chname_${region}_lonlat.nc
done
#cdo add $plotdir/cVeg_${SCENARIO}_${MODEL}_last30mean.nc $plotdir/cSoil_${SCENARIO}_${MODEL}_last30mean.nc \
#$plotdir/cLitter_${SCENARIO}_${MODEL}_last30mean.nc $plotdir/cProduct_${SCENARIO}_${MODEL}_last30mean.nc \
#$plotdir/cLand_${SCENARIO}_${MODEL}_last30mean.nc
done
done
