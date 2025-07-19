#!/bin/ksh
exp_id="FRST_nourb HARV_nourb IRR_nourb CROP_nourb noWH"    
dir_orig=/work/bm1147/b380949/web-monitoring/CESM
dir=/work/bm1147/b380949/web-monitoring/CESM/cover
outdir=$dir/78PFTs
mkdir $outdir
for exp in ${exp_id}; do
#15-78
data=surfdata_0.9x1.25_hist_78pfts_CMIP6_simyr2014
ncks -v PCT_NATVEG,PCT_CROP,PCT_GLACIER,PCT_LAKE,PCT_URBAN ${dir_orig}/${data}_${exp}.nc  ${dir}/Lunit/Lunit_coverfrc_${exp}_orig.nc
cdo mulc,0.01 ${dir}/Lunit/Lunit_coverfrc_${exp}_orig.nc ${dir}/Lunit/Lunit_coverfrc_${exp}_decimal.nc 
done

cdo div -const,1.,${dir}/Lunit/Lunit_coverfrc_noWH_decimal.nc  ${dir}/Lunit/Lunit_coverfrc_noWH_decimal.nc  ${dir}/Lunit/div_Lunit_coverfrc_noWH.nc

