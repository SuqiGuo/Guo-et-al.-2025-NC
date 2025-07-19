#!/bin/bash

# THIS SCRIPT DOES THE PREPROCESSING AND EXECUTES THE PYTHON SCRIPT TO
# SEPARATE LOCAL, NON-LOCAL AND TOTAL IMPACTS OF LCLM CHANGE FOR
# LAMACLIMA WP1 SIMULATIONS: CTL, CROP, IRR, FRST, HARV

# BEFORE EXECUTING THE SCRIPT DEFINE THE FOLLOWING VARIABLES BELOW :
# 1. CMOR TABLE ID (--> TEMPORAL RESOLUTION)
# 2. CMORvar
# 3. SCENARIO COMBINATION

# EXECUTE THIS SCRIPT VIA: sbatch signal_seperation.sh

#SBATCH --job-name=signal_separation      # Specify job name
#SBATCH --partition=shared                # Specify partition name
#SBATCH --ntasks=2                        # Specify max. number of tasks to be invoked
#SBATCH --cpus-per-task=16                # Specify number of CPUs per task
#SBATCH --time=02:00:00                   # Set a limit on the total run time
#SBATCH --account=bm1147                  # Charge resources on this project account
#SBATCH --output=signal_separation.out    # File name for standard output
#SBATCH --error=signal_separation.out     # File name for standard error output

# Bind your OpenMP threads --> I have to admit I have no idea if that's needed or what is happening here....
export OMP_NUM_THREADS=8
export KMP_AFFINITY=verbose,granularity=core,compact,1
export KMP_STACKSIZE=64m

module unload python
module load python/3.5.2
MODEL="mpiesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
CMOR_VAR_LIST="cVeg cLitter cSoil" #ah cesm model output data used with cesm table
#CMOR_VAR_LIST="cVeg" #ah cesm model output data used with cesm table
SIM1="crop" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
#SCENARIO_COMBNATION="frst-ctl harv-frst crop-ctl irri-crop" #, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
SCENARIO_COMBNATION="crop-ctl"
cover_dir=/work/bm1147/b380949/web-monitoring/cover
#signal_dir=/work/bm1147/b380949/web-monitoring/${scenario}/Eyr/   #nonlocal:vartiles;total:var
ctlfrac_dir=$cover_dir/ctl/
senfrac_dir=$cover_dir/$SIM1/

SENFRAC=${senfrac_dir}fracLut_Eyr_MPI-ESM1-2-LR_ssp245_r1i1p1f1_gn_2145-2174

for scenario in ${SCENARIO_COMBNATION}; do
signal_dir2=/work/bm1147/b380949/web-monitoring/${scenario}/${CMOR_TABLE}/   #nonlocal:vartiles;total:var
for CMOR_VAR in ${CMOR_VAR_LIST}; do
var=${CMOR_VAR}Lut
if [ "$scenario" == "harv-frst" ]; then
    ncks -O -d time,90,119 ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}.nc \
    ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_2145-2174.nc 
    ncks -O -d time,90,119 ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_signal-separated.nc \
    ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_signal-separated_2145-2174.nc
else
    ncks -O -d time,130,159 ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}.nc \
    ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_2145-2174.nc   
    ncks -O -d time,130,159 ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_signal-separated.nc \
    ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_signal-separated_2145-2174.nc
fi
cdo setmissval,1.e+20 ${SENFRAC}.nc ${SENFRAC}_missV.nc
cdo mul -selname,${var}_nonlocal -setmissval,1.e+20 ${signal_dir2}${var}/${var}_${scenario}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_t1.nc \
${SENFRAC}_missV.nc ${signal_dir2}${var}/nonlocal_tmp.nc
#<<COMMENT
cdo setrtomiss,10,1.e+22 ${signal_dir2}${var}/nonlocal_tmp.nc ${signal_dir2}${var}/nonlocal_tmp2.nc
#############################
cdo vertsum ${signal_dir2}${var}/nonlocal_tmp2.nc ${signal_dir2}${var}/nonlocal.nc
#cdo invertlat ${signal_dir2}${var}/nonlocal.nc  ${signal_dir2}${var}/nonlocal_invert.nc
#cdo yearmonmean ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${SIM1}-ctl_${MODEL}.nc ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${SIM1}-ctl_${MODEL}_new.nc 

cdo setname,${CMOR_VAR}_local_raw -sub -selname,${CMOR_VAR} ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_2145-2174.nc \
${signal_dir2}${var}/nonlocal.nc ${signal_dir2}${CMOR_VAR}/local_raw_Lut.nc
#cdo setname,npp_local_raw -sub -selname,npp npp_crop-ctl_mpiesm.nc ../npptiles/nonlocal_invert.nc ./local_raw_test2
#cdo setname,${CMOR_VAR}_local_raw ${signal_dir2}${CMOR_VAR}/local_raw.nc ${signal_dir2}${CMOR_VAR}/local_raw.nc
cdo merge ${signal_dir2}${CMOR_VAR}/local_raw_Lut.nc ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_2145-2174.nc \
${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_new_Lut.nc
cdo invertlat ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_new_Lut.nc \
${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_invert_Lut.nc

rm  ${signal_dir2}${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_new_Lut.nc
rm  ${signal_dir2}${CMOR_VAR}/local_raw_Lut.nc
rm  ${signal_dir2}${var}/nonlocal_tmp.nc
rm  ${signal_dir2}${var}/nonlocal_tmp2.nc
done
done

for scenario in ${SCENARIO_COMBNATION}; do
for CMOR_VAR in ${CMOR_VAR_LIST}; do
SCRATCH="/work/bm1147/b380949/web-monitoring"
cd $SCRATCH/${scenario}/${CMOR_TABLE}/${CMOR_VAR}
#NC_FILE=${SCRATCH}/${SCENARIO_COMBNATION}/${CMOR_TABLE}/${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}.nc
NC_FILE=${SCRATCH}/${scenario}/${CMOR_TABLE}/${CMOR_VAR}/${CMOR_VAR}_${scenario}_${MODEL}_invert_Lut.nc
echo "Calculate signal separation for variable ${CMOR_VAR} in file ${NC_FILE}"
python /home/b/b380949/separation/local_total.py ${NC_FILE} ${CMOR_VAR}
##########################
str=${CMOR_VAR}_${scenario}_${MODEL}_signal-separated_2145-2174
cdo invertlat -selname,${CMOR_VAR}_nonlocal ${str}.nc t1.nc 
#cdo setrtomiss,10,1.e+40 -setname,${CMOR_VAR}_nonlocal_yr -yearmonmean t1.nc 1.nc 
cdo setrtomiss,10,1.e+40 t1.nc 1.nc 
#cdo selname,${CMOR_VAR}_total_yr ${CMOR_VAR}_${scenario}_${MODEL}_invert.nc 2.nc 
#cdo selname,${CMOR_VAR}_local_yr ${CMOR_VAR}_${scenario}_${MODEL}_invert.nc 3.nc 
cdo selname,${CMOR_VAR}_total ${CMOR_VAR}_${scenario}_${MODEL}_invert_Lut.nc 2.nc 
cdo selname,${CMOR_VAR}_local ${CMOR_VAR}_${scenario}_${MODEL}_invert_Lut.nc 3.nc
rm ${str}_revised_Lut.nc
cdo merge 1.nc 2.nc 3.nc ${str}_revised_Lut.nc
rm 1.nc
rm 2.nc
rm 3.nc
rm t1.nc
#COMMENT
done
done


