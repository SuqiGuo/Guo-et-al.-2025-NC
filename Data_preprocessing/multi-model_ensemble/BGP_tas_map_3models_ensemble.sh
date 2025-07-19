#!/bin/ksh
exp_id="ctl frst crop"    
MODEL="mpiesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
CMOR_VAR_table="cVeg cSoil cLitter" #ah cesm model output data used with cesm table
SIM1="frst" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="frst-ctl crop-ctl irr-crop"
#, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
dir_source=/work/bm1147/b380949/web-monitoring/secP/ensemble/tas_ensemble
dir=/work/bm1147/b380949/web-monitoring/secP/ensemble/tas_ensemble/model_ens
echo $dir
for SCENARIO in ${SCENARIO_COMBNATION}; do
        data_mpiesm=${dir_source}/tas_${SCENARIO}_mpiesm_ensmean_signal-separated_GLOBAL_remapbil.nc
        data_cesm=${dir_source}/tas_${SCENARIO}_cesm.nc
        data_ecearth=${dir_source}/tas_${SCENARIO}_ecearth_remapbil.nc
echo $data_mpiesm
for model in mpiesm cesm ecearth; do
	#eval dir=\$dir_$model
	#echo $dir
	#mkdir $dir
#	echo $\
	eval data=\$data_$model
        cdo selname,tas_local $data $dir/tas_local_${SCENARIO}_$model.nc
        cdo selname,tas_nonlocal $data $dir/tas_nonlocal_${SCENARIO}_$model.nc
        cdo selname,tas_total $data $dir/tas_total_${SCENARIO}_$model.nc
# rm $dir/tas_local_${SCENARIO}_$model.nc
# rm $dir/tas_nonlocal_${SCENARIO}_$model.nc
# rm $dir/tas_total_${SCENARIO}_$model.nc
done
for signal in local nonlocal total; do
        if [[ "$SCENARIO" == "frst-ctl" || "$SCENARIO" == "irr-crop" ]]; then
		echo $SCENARIO
		echo $signal
        	cdo ensmean \
                -selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_mpiesm.nc \
                -selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_cesm.nc \
                $dir/tas_${signal}_${SCENARIO}.nc
        else
		echo $SCENARIO
                echo $signal
            cdo ensmean \
                -selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_mpiesm.nc \
                -selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_cesm.nc \
                -selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_ecearth.nc \
                $dir/tas_${signal}_${SCENARIO}.nc
        fi
done
#for signal in local nonlocal total; do
       # cdo ensmean -selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_mpiesm.nc -selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_cesm.nc \
#		-selname,tas_${signal} ${dir}/tas_${signal}_${SCENARIO}_ecearth.nc $dir/tas_${signal}_${SCENARIO}.nc
#	rm $dir/tas_${signal}_${SCENARIO}.nc

#done
 cdo merge $dir/tas_local_${SCENARIO}.nc $dir/tas_nonlocal_${SCENARIO}.nc $dir/tas_total_${SCENARIO}.nc $dir/tas_${SCENARIO}_3models-ensemble.nc
done

