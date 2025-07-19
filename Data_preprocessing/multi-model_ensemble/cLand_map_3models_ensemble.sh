#!/bin/ksh
#In the multimodel ensemble mean, EC-Earth results are excluded for the FRST simulation due to a large discrepancy in afforestation fraction compared to the other two models. For the IRR simulation, EC-Earth results are also excluded from the assessment of nonlocal and total effects, as the water cycle is not fully coupled between the land and atmosphere in this model. This prevents the direct influence of irrigation on surface energy fluxes from being represented, thereby obstructing the evaluation of nonlocal BGP and the subsequent nonlocal BGC effects.

exp_id="ctl frst crop"    
MODEL="mpiesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
CMOR_VAR_table="cVeg cSoil cLitter" #ah cesm model output data used with cesm table
SIM1="frst" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="frst-ctl crop-ctl irri-crop"
#, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
dir_mpiesm=/work/bm1147/b380949/web-monitoring/MPI-PLOT/Lutdata
dir_cesm=/work/bm1147/b380949/web-monitoring/CESM/plot/final_Lunit/RTCRE_regional/GLOBAL
dir_ecearth=/work/bm1147/b380949/web-monitoring/ecearth_plot/RTCRE_regional/GLOBAL
dir=/scratch/b/b380949/secP/cLand_ecearthcorrection
#/work/bm1147/b380949/web-monitoring/secP/cLand_ensemble/ensemble_selmod
echo $dir
for SCENARIO in ${SCENARIO_COMBNATION}; do
        data_mpiesm=${dir_mpiesm}/cLand_${SCENARIO}_mpiesm_Lut_last30mean_chname_remapbil.nc
        data_cesm=${dir_cesm}/cLand_${SCENARIO}_cesm_last30mean_GLOBAL.nc
        data_ecearth=${dir_ecearth}/cLand_${SCENARIO}_ecearth_last30mean_gridlevelsep_GLOBAL.nc
echo $data_mpi
for model in mpiesm cesm ecearth; do
	eval destination=\$dir  #_$model
	eval data=\$data_$model
        cdo selname,cLand_local $data $destination/cLand_local_${SCENARIO}_$model.nc
	cdo selname,cLand_nonlocal $data $destination/cLand_nonlocal_${SCENARIO}_$model.nc
        cdo selname,cLand_total $data $destination/cLand_total_${SCENARIO}_$model.nc
#rm $destination/cLand_local_${SCENARIO}_$model.nc
#rm $destination/cLand_nonlocal_${SCENARIO}_$model.nc
#rm $destination/cLand_total_${SCENARIO}_$model.nc
done
for signal in local nonlocal total; do
#	if [[ "$SCENARIO" == "frst-ctl" || "$SCENARIO" == "irri-crop" ]]; then
	if [[ "$SCENARIO" == "frst-ctl" || ( "$SCENARIO" == "irri-crop" && ( "$signal" == "nonlocal" || "$signal" == "total" ) ) ]]; then
                echo $SCENARIO
                echo $signal
                cdo ensmean \
                -selname,cLand_${signal} ${dir}/cLand_${signal}_${SCENARIO}_mpiesm.nc \
                -selname,cLand_${signal} ${dir}/cLand_${signal}_${SCENARIO}_cesm.nc \
                $dir/cLand_${signal}_${SCENARIO}.nc
        else
                echo $SCENARIO
                echo $signal
	      	cdo ensmean ${dir}/cLand_${signal}_${SCENARIO}_mpiesm.nc ${dir}/cLand_${signal}_${SCENARIO}_cesm.nc \
                ${dir}/cLand_${signal}_${SCENARIO}_ecearth.nc $dir/cLand_${signal}_${SCENARIO}.nc

	fi
		#rm $dir/cLand_${signal}_${SCENARIO}.nc
done
cdo merge $dir/cLand_local_${SCENARIO}.nc $dir/cLand_nonlocal_${SCENARIO}.nc $dir/cLand_total_${SCENARIO}.nc\
       	$dir/cLand_${SCENARIO}_last30mean_models-ensemble_exclecearth.nc


done
