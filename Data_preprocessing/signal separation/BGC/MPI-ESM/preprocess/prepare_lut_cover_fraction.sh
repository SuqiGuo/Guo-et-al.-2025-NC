#!/bin/ksh
exp_id="irri frst crop harv"
ctl_div_dir=/work/bm1147/b380949/web-monitoring/cover/ctl
ctl_dir=/work/bm1147/b380949/web-monitoring/cover/ctl_year
ctl_lunit_dir=/work/bm1147/b380949/web-monitoring/cover/ctl_lunit
cdo vertsum -sellevel,1,2,3,4,5,6,7,8 ${ctl_lunit_dir}/box_cover_fract_mon.nc ${ctl_lunit_dir}/box_cover_fract_mon_lunit_nat.nc
cdo vertsum -sellevel,1,2,3,4,5,6,7,8 ${ctl_lunit_dir}/box_cover_fract_yr.nc ${ctl_lunit_dir}/box_cover_fract_yr_lunit_nat.nc
cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_mon_lunit_nat.nc ${ctl_lunit_dir}/box_cover_fract_mon_lunit_nat.nc \
${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_nat.nc
cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_yr_lunit_nat.nc ${ctl_lunit_dir}/box_cover_fract_yr_lunit_nat.nc \
${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_nat.nc

cdo sellevel,11 ${ctl_lunit_dir}/box_cover_fract_mon.nc ${ctl_lunit_dir}/box_cover_fract_mon_lunit_11.nc
cdo sellevel,11 ${ctl_lunit_dir}/box_cover_fract_yr.nc ${ctl_lunit_dir}/box_cover_fract_yr_lunit_11.nc
cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_mon_lunit_11.nc ${ctl_lunit_dir}/box_cover_fract_mon_lunit_11.nc \
${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_11.nc
cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_yr_lunit_11.nc ${ctl_lunit_dir}/box_cover_fract_yr_lunit_11.nc \
${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_11.nc

cdo mulc,0 ${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_11.nc ${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_urban.nc
cdo mulc,0 ${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_11.nc ${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_urban.nc

cdo vertsum -sellevel,9,10 ${ctl_lunit_dir}/box_cover_fract_mon.nc ${ctl_lunit_dir}/box_cover_fract_mon_lunit_pst.nc
cdo vertsum -sellevel,9,10 ${ctl_lunit_dir}/box_cover_fract_yr.nc ${ctl_lunit_dir}/box_cover_fract_yr_lunit_pst.nc
cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_mon_lunit_pst.nc ${ctl_lunit_dir}/box_cover_fract_mon_lunit_pst.nc \
${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_pst.nc
cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_yr_lunit_pst.nc ${ctl_lunit_dir}/box_cover_fract_yr_lunit_pst.nc \
${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_pst.nc


 #FILES11=`find ${ctl_lunit_dir}/* -name "divbox_cover_fract_mon_lunit_*.nc"`
 #FILES21=`find ${ctl_lunit_dir}/* -name "divbox_cover_fract_yr_lunit_*.nc"`  
 cdo merge ${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_nat.nc ${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_11.nc \
 ${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_pst.nc ${ctl_lunit_dir}/divbox_cover_fract_mon_lunit_urban.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit.nc
 cdo merge ${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_nat.nc ${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_11.nc \
 ${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_pst.nc ${ctl_lunit_dir}/divbox_cover_fract_yr_lunit_urban.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit.nc

cdo invertlat ${ctl_div_dir}/divbox_cover_fract_mon_lunit.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit_invertlat.nc
cdo invertlat ${ctl_div_dir}/divbox_cover_fract_yr_lunit.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_invertlat.nc

ncks -O -d time,130,159 ${ctl_div_dir}/divbox_cover_fract_yr_lunit_invertlat.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_invertlat_2145-2174.nc

#cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_mon_lunit.nc ${ctl_lunit_dir}/box_cover_fract_mon_lunit.nc \
#${ctl_div_dir}/divbox_cover_fract_mon_lunit.nc
#cdo div -const,1.,${ctl_lunit_dir}/box_cover_fract_yr_lunit.nc ${ctl_lunit_dir}/box_cover_fract_yr_lunit.nc \
#${ctl_div_dir}/divbox_cover_fract_yr_lunit.nc
ncks -O -d time,0,1931 ${ctl_div_dir}/divbox_cover_fract_mon_lunit.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit_frst.nc
ncks -O -d time,0,160 ${ctl_div_dir}/divbox_cover_fract_yr_lunit.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_frst.nc
cdo invertlat ${ctl_div_dir}/divbox_cover_fract_mon_lunit_frst.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit_frst_invertlat.nc
cdo invertlat ${ctl_div_dir}/divbox_cover_fract_yr_lunit_frst.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_frst_invertlat.nc

ncks -O -d time,480,1919 ${ctl_div_dir}/divbox_cover_fract_mon_lunit.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit_harv.nc
ncks -O -d time,40,159 ${ctl_div_dir}/divbox_cover_fract_yr_lunit.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_harv.nc
cdo invertlat ${ctl_div_dir}/divbox_cover_fract_mon_lunit_harv.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit_harv_invertlat.nc
cdo invertlat ${ctl_div_dir}/divbox_cover_fract_yr_lunit_harv.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_harv_invertlat.nc

ncks -O -d time,0,1919 ${ctl_div_dir}/divbox_cover_fract_mon_lunit.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit_irri.nc
ncks -O -d time,0,159 ${ctl_div_dir}/divbox_cover_fract_yr_lunit.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_irri.nc
cdo invertlat ${ctl_div_dir}/divbox_cover_fract_mon_lunit_irri.nc ${ctl_div_dir}/divbox_cover_fract_mon_lunit_irri_invertlat.nc
cdo invertlat ${ctl_div_dir}/divbox_cover_fract_yr_lunit_irri.nc ${ctl_div_dir}/divbox_cover_fract_yr_lunit_irri_invertlat.nc



exp_dir=/work/bm1147/b380949/web-monitoring/cover

for exp in ${exp_id}; do
cdo vertsum -sellevel,1,2,3,4,5,6,7,8 ${exp_dir}/${exp}/box_cover_fract_mon.nc ${exp_dir}/${exp}/box_cover_fract_mon_lunit_nat.nc
cdo vertsum -sellevel,1,2,3,4,5,6,7,8 ${exp_dir}/${exp}/box_cover_fract_yr.nc ${exp_dir}/${exp}/box_cover_fract_yr_lunit_nat.nc

cdo sellevel,11 ${exp_dir}/${exp}/box_cover_fract_mon.nc ${exp_dir}/${exp}/box_cover_fract_mon_lunit_11.nc
cdo sellevel,11 ${exp_dir}/${exp}/box_cover_fract_yr.nc ${exp_dir}/${exp}/box_cover_fract_yr_lunit_11.nc

cdo mulc,0 ${exp_dir}/${exp}/box_cover_fract_mon_lunit_11.nc ${exp_dir}/${exp}/box_cover_fract_mon_lunit_urban.nc
cdo mulc,0 ${exp_dir}/${exp}/box_cover_fract_yr_lunit_11.nc ${exp_dir}/${exp}/box_cover_fract_yr_lunit_urban.nc

cdo vertsum -sellevel,9,10 ${exp_dir}/${exp}/box_cover_fract_mon.nc ${exp_dir}/${exp}/box_cover_fract_mon_lunit_pst.nc
cdo vertsum -sellevel,9,10 ${exp_dir}/${exp}/box_cover_fract_yr.nc ${exp_dir}/${exp}/box_cover_fract_yr_lunit_pst.nc

 cdo merge ${exp_dir}/${exp}/box_cover_fract_mon_lunit_nat.nc ${exp_dir}/${exp}/box_cover_fract_mon_lunit_11.nc \
 ${exp_dir}/${exp}/box_cover_fract_mon_lunit_pst.nc ${exp_dir}/${exp}/box_cover_fract_mon_lunit_urban.nc ${exp_dir}/${exp}/box_cover_fract_mon_lunit.nc
 cdo merge ${exp_dir}/${exp}/box_cover_fract_yr_lunit_nat.nc ${exp_dir}/${exp}/box_cover_fract_yr_lunit_11.nc \
 ${exp_dir}/${exp}/box_cover_fract_yr_lunit_pst.nc ${exp_dir}/${exp}/box_cover_fract_yr_lunit_urban.nc ${exp_dir}/${exp}/box_cover_fract_yr_lunit.nc

if [ "$exp" == "harv" ]; then
    ncks -O -d time,90,119 ${exp_dir}/${exp}/box_cover_fract_yr_lunit.nc  \
    ${exp_dir}/${exp}/box_cover_fract_yr_lunit_2145-2174.nc 
else
    ncks -O -d time,130,159 ${exp_dir}/${exp}/box_cover_fract_yr_lunit.nc  \
    ${exp_dir}/${exp}/box_cover_fract_yr_lunit_2145-2174.nc
fi

done

