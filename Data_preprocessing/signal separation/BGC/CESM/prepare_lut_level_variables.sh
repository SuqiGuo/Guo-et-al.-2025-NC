#!/bin/ksh
exp_id="ctl frst crop harv irr"    
dir=/work/bm1147/b380949/CESM
out_dir=/work/bm1147/b380949/CESM/lunit
for exp in ${exp_id}; do
exp_dir=$dir/${exp} 
ncks  -d time,0,159 ${exp_dir}/${exp}_TOTECOSYSC_yr_lunit_rs.nc  ${out_dir}/${exp}_TOTECOSYSC_yr_lunit_160yrs.nc
cdo sellevel,1,2,4,5,7,8,9 ${out_dir}/${exp}_TOTECOSYSC_yr_lunit_160yrs.nc ${out_dir}/${exp}_TOTECOSYSC_yr_lunit_160yrs_7lunits.nc
done
