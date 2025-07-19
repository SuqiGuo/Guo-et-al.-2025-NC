#!/bin/ksh
ctl_div_dir=/work/bm1147/b380949/web-monitoring/cover/ctl
ctl_dir=/work/bm1147/b380949/web-monitoring/cover/ctl_year
ctl_lunit_dir=/work/bm1147/b380949/web-monitoring/cover/ctl_lunit
for YEAR in $(seq 2015 2176);do
cdo -O -f nc -setname,box_cover_fract ${ctl_dir}/box_cover_fract_mon_${YEAR} \
${ctl_lunit_dir}/original/box_cover_fract_mon_${YEAR}.nc

cdo -O -f nc -setname,box_cover_fract ${ctl_dir}/box_cover_fract_yr_${YEAR} \
${ctl_lunit_dir}/original/box_cover_fract_yr_${YEAR}.nc
done 
 FILES1=`find ${ctl_lunit_dir}/original/* -name "box_cover_fract_mon_*"`
 FILES2=`find ${ctl_lunit_dir}/original/* -name "box_cover_fract_yr_*"`  

 cdo mergetime ${FILES1} ${ctl_lunit_dir}/box_cover_fract_mon.nc
 cdo mergetime ${FILES2} ${ctl_lunit_dir}/box_cover_fract_yr.nc 

