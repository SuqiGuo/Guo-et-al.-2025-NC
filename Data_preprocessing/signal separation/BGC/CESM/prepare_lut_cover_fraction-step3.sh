#!/bin/ksh
exp="fract_crop fract_frst fract_harv fract_irr div_fract_ctl"
#dir=/work/bm1147/b380949/web-monitoring/CESM/cover
outdir=/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/final
#mkdir $outdir
for exp_id in ${exp}; do

#cdo -duplicate,160 $outdir/fract_${exp_id}_pfts.nc $dir/final_yearly/${exp_id}_pfts_yearly.nc

cdo -duplicate,160 $outdir/${exp_id}_7lunits.nc $outdir/${exp_id}_7lunits_yearly.nc

done
