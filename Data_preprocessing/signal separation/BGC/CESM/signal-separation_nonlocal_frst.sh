#!/bin/bash

# THIS SCRIPT DOES THE PREPROCESSING AND EXECUTES THE PYTHON SCRIPT TO
# SEPARATE LOCAL, NON-LOCAL AND TOTAL IMPACTS OF LCLM CHANGE FOR
# LAMACLIMA WP1 SIMULATIONS: CTL, CROP, IRR, FRST, HARV

# BEFORE EXECUTING THE SCRIPT DEFINE THE FOLLOWING VARIABLES BELOW :
# 1. CMOR TABLE ID (--> TEMPORAL RESOLUTION)
# 2. CMORvar
# 3. SCENARIO COMBINATION

# EXECUTE THIS SCRIPT VIA: sbatch signal_seperation.sh

#SBATCH --job-name=frst_lunit_nonlocal      # Specify job name
#SBATCH --partition=shared              # Specify partition name
#SBATCH --ntasks=2                        # Specify max. number of tasks to be invoked
#SBATCH --exclude=l10060,l10063,l10066,l10069,l10358              #Exclude specified nodes from job allocation
#SBATCH --cpus-per-task=16                # Specify number of CPUs per task
#SBATCH --time=30:00:00                   # Set a limit on the total run time
#SBATCH --account=bm1147                  # Charge resources on this project account
#SBATCH --output=frst_lunit_nonlocal.out    # File name for standard output
#SBATCH --error=frst_lunit_nonlocal.out     # File name for standard error output

# Bind your OpenMP threads --> I have to admit I have no idea if that's needed or what is happening here....
export OMP_NUM_THREADS=8
export KMP_AFFINITY=verbose,granularity=core,compact,1
export KMP_STACKSIZE=64m

module unload python
module load python/3.5.2

MODEL="cesm" #, "cesm" "ecearth" "mpiesem"
CMOR_TABLE="Eyr"  # "Lmon" "LImon" "Emon" "Lmon" "Eyr" "Lmon"; choose "cesm" for all cesm variables as they are currently stored in /scratch/b/b380948/signal_separation/cesm_output/
# CMOR_VAR_LIST="cSoil cLitter cVeg cProduct"
# CMOR_VAR_LIST="gpp npp nbp ra rh"
# CMOR_VAR_LIST="mrsol nep"
# CMOR_VAR_LIST="TSA TG EFLX_LH_TOT FSH PRECC PRECL WIND Q2M" # cesm model output data used with cesm table
CMOR_VAR_LIST="TOTECOSYSC" # cesm model output data used with cesm table
# CMOR_VAR_LIST="PRECC PRECL" # still missing for frst-ctl and crop-ctl 
# CMOR_VAR_LIST="tas"
SIM1="frst" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="${SIM1}-${SIM2}" #, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
ctlfrac_dir=/work/bm1147/b380949/web-monitoring/CESM/cover/Lunit/final/
for CMOR_VAR in ${CMOR_VAR_LIST}; do
  var=${CMOR_VAR}_lunit
if [ "$SCENARIO_COMBNATION" == "crop-ctl" ] && [ "${MODEL}" == "mpiesm" ]; then
    DIR1=/work/bm1147/b380949/web-monitoring/rawdata_tiles/jsbach/${SIM1}/$CMOR_VAR
    DIR2=/work/bm1147/b380949/web-monitoring/rawdata_tiles/jsbach/${SIM2}/$CMOR_VAR
    #??????????????
elif [ "${MODEL}" == "cesm" ]; then
    DIR1=/work/bm1147/b380949/CESM/lunit/${CMOR_VAR}_lunit
    DIR2=/work/bm1147/b380949/CESM/lunit/${CMOR_VAR}_lunit
fi
SCRATCH="/work/bm1147/b380949/web-monitoring/CESM/subgrid/lunit/"
# CREATE TEMPORARY FOLDERS ON SCRATCH TO SAFE THE DATA
if [ ! -d "${SCRATCH}" ]; then
  echo "Folder ${SCRATCH} does not exist and will be made."
  mkdir $SCRATCH
fi  
cd $SCRATCH
if [ ! -d "${SCENARIO_COMBNATION}" ]; then
  echo "Folder ${SCRATCH}/${SCENARIO_COMBNATION} does not exist and will be made."
  mkdir ${SCENARIO_COMBNATION}
else
  echo "Folder ${SCRATCH}/${SCENARIO_COMBNATION} already exists."
fi
cd ${SCENARIO_COMBNATION}

if [ ! -d "${CMOR_TABLE}" ]; then
  echo "Folder ${CMOR_TABLE} does not exist and will be made."
  mkdir ${CMOR_TABLE}
else 
  echo "Folder ${CMOR_TABLE} already exists."  
fi
cd ${CMOR_TABLE}

if [ ! -d "${CMOR_VAR}" ]; then
  echo "Folder ${CMOR_VAR} does not exist and will be made."
  mkdir ${CMOR_VAR}
else
  echo "Folder ${CMOR_VAR} already exists."
fi
cd ${CMOR_VAR}

if [ "${MODEL}" == "mpiesm" ]; then
  FILES1=`find ${DIR1}/* -name "${CMOR_VAR}*"`
  FILES2=`find ${DIR2}/* -name "${CMOR_VAR}*"`  
  cdo mergetime ${FILES1} ${CMOR_VAR}_${SIM1}.nc
  cdo mergetime ${FILES2} ${CMOR_VAR}_${SIM2}.nc 
  #??????????????
elif [ "${MODEL}" == "cesm" ]; then
  cp ${DIR1}/${SIM1}_${CMOR_VAR}_yr_lunit_160yrs_7lunits.nc  ${CMOR_VAR}_${SIM1}.nc
  cp ${DIR2}/${SIM2}_${CMOR_VAR}_yr_lunit_160yrs_7lunits.nc  ${CMOR_VAR}_${SIM2}.nc
fi 
#for mpi-esm
#    DIVNC=${ctlfrac_dir}/div_fract_ctl_7lunits_yearly.nc

    DIVNC_tmp=${ctlfrac_dir}/div_fract_ctl_7lunits_yearly.nc
    
cdo setvrange,1,200 ${DIVNC_tmp} ${ctlfrac_dir}/div_fract_ctl_7lunits_yearly_mask200.nc

    DIVNC=${ctlfrac_dir}/div_fract_ctl_7lunits_yearly_mask200.nc


# COPY ALL MODEL OUTPUT FILES, MERGE AND CREATE DIFFERENCE FILES
cdo sub ${CMOR_VAR}_${SIM1}.nc ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc
#cdo yearmonmean ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_new.nc
#at some point espacially tile=3 {CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_new.nc=0 as a result{CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc=0
<<COMMENT 
cdo mul -selname,${CMOR_VAR}_lunit ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc ${DIVNC} \
${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_mask200.nc
cdo ifthen ${DIVNC} ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_mask200.nc \
${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_t1_mask200.nc
COMMENT
#cdo setmisstoc,0 ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_new.nc \
#${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc

#cp ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc
cp ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_t1.nc

#NC_FILE=${SCRATCH}/${SCENARIO_COMBNATION}/${CMOR_TABLE}/${CMOR_VAR}/${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc
NC_FILE=${SCRATCH}/${SCENARIO_COMBNATION}/${CMOR_TABLE}/${CMOR_VAR}/${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_t1.nc

echo "Calculate signal separation for variable ${CMOR_VAR} in file ${NC_FILE}"
python /home/b/b380949/separation/nonlocalrevised.py ${NC_FILE} ${CMOR_VAR}_lunit> 7lunits_cesm.txt

#python /home/b/b380949/separation/nonlocalrevised.py ${NC_FILE} ${CMOR_VAR} >cesm_nonlocal_interpolation.txt
#cdo setrtomiss,5e+19,2e+20 -selname,${CMOR_VAR}_nonlocal ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_new.nc

done




