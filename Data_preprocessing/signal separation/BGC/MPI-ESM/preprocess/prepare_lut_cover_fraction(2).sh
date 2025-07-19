#!/bin/ksh
exp_id="irri frst crop harv ctl"
CMOR_VAR_LIST="cVeg cSoil cLitter" # cesm model output data used with cesm table Lut; cLitter tiles
aim_dir=/work/bm1147/b380949/web-monitoring/rawdata_Lut

for CMOR_VAR in ${CMOR_VAR_LIST}; do
for exp in ${exp_id}; do

	mid_dir=$aim_dir/${exp}/${CMOR_VAR}Lut

if [ ! -d "$mid_dir" ]; then
  echo "Folder $mid_dir does not exist and will be made."
  mkdir -p $mid_dir
else 
  echo "Folder $mid_dir already exists."  
fi
exp_dir=/work/bm1147/b380949/web-monitoring/rawdata_tiles/jsbach/${exp}/${CMOR_VAR}tiles

FILES1=`find ${exp_dir}/* -name "${CMOR_VAR}tiles*"`
cdo yearmonmean -mergetime ${FILES1}  $mid_dir/${CMOR_VAR}tiles_${exp}.nc

cdo vertsum -sellevel,1,2,3,4,5,6,7,8 $mid_dir/${CMOR_VAR}tiles_${exp}.nc $mid_dir/${CMOR_VAR}_${exp}_lunit_nat.nc

cdo sellevel,11 $mid_dir/${CMOR_VAR}tiles_${exp}.nc $mid_dir/${CMOR_VAR}_${exp}_lunit_11.nc

cdo mulc,0 $mid_dir/${CMOR_VAR}_${exp}_lunit_11.nc $mid_dir/${CMOR_VAR}_${exp}_lunit_urban.nc

cdo vertsum -sellevel,9,10 $mid_dir/${CMOR_VAR}tiles_${exp}.nc $mid_dir/${CMOR_VAR}_${exp}_lunit_pst.nc

cdo merge $mid_dir/${CMOR_VAR}_${exp}_lunit_nat.nc $mid_dir/${CMOR_VAR}_${exp}_lunit_11.nc \
 $mid_dir/${CMOR_VAR}_${exp}_lunit_pst.nc $mid_dir/${CMOR_VAR}_${exp}_lunit_urban.nc $mid_dir/${CMOR_VAR}Lut_${exp}.nc

done
done

