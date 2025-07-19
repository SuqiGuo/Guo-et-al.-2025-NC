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
# CMOR_VAR_LIST="cSoil cLitter cVeg cProduct"
# CMOR_VAR_LIST="gpp npp nbp ra rh"
# CMOR_VAR_LIST="mrsol nep"
# CMOR_VAR_LIST="TSA TG EFLX_LH_TOT FSH PRECC PRECL WIND Q2M" # cesm model output data used with cesm table
CMOR_VAR_LIST="cVegLut cLitterLut cSoilLut" # cesm model output data used with cesm table
# CMOR_VAR_LIST="PRECC PRECL" # still missing for frst-ctl and crop-ctl 
# CMOR_VAR_LIST="tas"
SIM1="crop" # "frst" "crop" "irr" "harv"
SIM2="ctl" # "ctl" "crop" "frst"
SCENARIO_COMBNATION="${SIM1}-${SIM2}" #, "irr-crop" "irr-ctl" "frst-ctl" "harv-frst" "harv-ctl"
ctlfrac_dir=/work/bm1147/b380949/web-monitoring/cover/ctl/

for CMOR_VAR in ${CMOR_VAR_LIST}; do
if  [ "${MODEL}" == "mpiesm" ]; then
    DIR1=/work/bm1147/b380949/web-monitoring/rawdata_Lut/${SIM1}/${CMOR_VAR}
    DIR2=/work/bm1147/b380949/web-monitoring/rawdata_Lut/${SIM2}/${CMOR_VAR}
elif [ "$SCENARIO_COMBNATION" == "crop-ctl" ] && [ "${MODEL}" == "cesm" ]; then
    DIR1=/scratch/b/b380948/signal_separation/cesm_output/crop
    DIR2=/scratch/b/b380948/signal_separation/cesm_output/ctl
elif [ "$SCENARIO_COMBNATION" == "frst-ctl" ] && [ "${MODEL}" == "cesm" ]; then
    DIR1=/scratch/b/b380948/signal_separation/cesm_output/frst
    DIR2=/scratch/b/b380948/signal_separation/cesm_output/ctl
fi
SCRATCH="/work/bm1147/b380949/web-monitoring"
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
  cp ${DIR1}/${CMOR_VAR}_${SIM1}_final.nc ${CMOR_VAR}_${SIM1}.nc
  cp ${DIR2}/${CMOR_VAR}_${SIM2}_final.nc ${CMOR_VAR}_${SIM2}.nc
elif [ "${MODEL}" == "cesm" ] && [ "${SIM1}" == "crop"  ]; then
  cp ${DIR1}/${CMOR_VAR}_CROP_LAMACLIMA.e211.B2000cmip6.f09_g17.crop-i308.CROP.clm2.h0.nc ${CMOR_VAR}_${SIM1}.nc
  cp ${DIR2}/${CMOR_VAR}_CTL_LAMACLIMA.e211.B2000cmip6.f09_g17.control-i196.clm2.h0.nc ${CMOR_VAR}_${SIM2}.nc
elif [ "${MODEL}" == "cesm" ] && [ "${SIM1}" == "frst"  ]; then
  cp ${DIR1}/${CMOR_VAR}_FRST_LAMACLIMA.e211.B2000cmip6.f09_g17.forest-i308.clm2.h0.nc ${CMOR_VAR}_${SIM1}.nc
  cp ${DIR2}/${CMOR_VAR}_CTL_LAMACLIMA.e211.B2000cmip6.f09_g17.control-i196.clm2.h0.nc ${CMOR_VAR}_${SIM2}.nc
fi    
#for mpi-esm
if [ "$SCENARIO_COMBNATION" == "crop-ctl" ] && [ "${CMOR_TABLE}" == "Lmon" ]; then
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_mon.nc
elif [ "$SCENARIO_COMBNATION" == "crop-ctl" ] && [ "${CMOR_TABLE}" == "Eyr" ]; then
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_yr_lunit.nc
elif [ "$SCENARIO_COMBNATION" == "frst-ctl" ] && [ "${CMOR_TABLE}" == "Lmon" ]; then
    ncks -O -d time,120,1931 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc  #Lmon
    ncks -O -d time,120,1931 ${ctlfrac_dir}/divbox_cover_fract_mon.nc ${ctlfrac_dir}/divbox_cover_fract_mon_frst.nc
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_mon_frst.nc
elif [ "$SCENARIO_COMBNATION" == "frst-ctl" ] && [ "${CMOR_TABLE}" == "Eyr" ]; then
    ncks -O -d time,10,160 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc   #Eyr
    ncks -O -d time,10,160 ${ctlfrac_dir}/divbox_cover_fract_yr_lunit.nc ${ctlfrac_dir}/divbox_cover_fract_yr_lunit_frst.nc   #Eyr
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_yr_lunit_frst.nc
elif [ "$SCENARIO_COMBNATION" == "harv-ctl" ] && [ "${CMOR_TABLE}" == "Lmon" ]; then
    ncks  -O -d time,480,1919 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc
    ncks -O -d time,480,1919 ${ctlfrac_dir}/divbox_cover_fract_mon.nc ${ctlfrac_dir}/divbox_cover_fract_mon_harv.nc
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_mon_harv.nc
elif [ "$SCENARIO_COMBNATION" == "harv-ctl" ] && [ "${CMOR_TABLE}" == "Eyr" ]; then
    ncks  -O -d time,40,159 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc
    ncks -O -d time,40,159 ${ctlfrac_dir}/divbox_cover_fract_yr_lunit.nc ${ctlfrac_dir}/divbox_cover_fract_yr_lunit_harv.nc   #Eyr
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_yr_lunit_harv.nc
elif [ "$SCENARIO_COMBNATION" == "harv-frst" ] && [ "${CMOR_TABLE}" == "Lmon" ]; then
    ncks  -O -d time,360,1799 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc
    ncks -O -d time,480,1919 ${ctlfrac_dir}/divbox_cover_fract_mon.nc ${ctlfrac_dir}/divbox_cover_fract_mon_harv.nc
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_mon_harv.nc
elif [ "$SCENARIO_COMBNATION" == "harv-frst" ] && [ "${CMOR_TABLE}" == "Eyr" ]; then
    ncks  -O -d time,30,149 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc
    ncks -O -d time,40,159 ${ctlfrac_dir}/divbox_cover_fract_yr_lunit.nc ${ctlfrac_dir}/divbox_cover_fract_yr_lunit_harv.nc   #Eyr
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_yr_lunit_harv.nc
elif [ "$SIM1" == "irri" ] && [ "${CMOR_TABLE}" == "Lmon" ]; then
    ncks -O -d time,0,1919 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc  #Lmon
    ncks -O -d time,0,1919 ${ctlfrac_dir}/divbox_cover_fract_mon.nc ${ctlfrac_dir}/divbox_cover_fract_mon_irri.nc
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_mon_irri.nc
elif [ "$SIM1" == "irri" ] && [ "${CMOR_TABLE}" == "Eyr" ]; then
    ncks -O -d time,0,159 ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM2}.nc   #Eyr
    ncks -O -d time,0,159 ${ctlfrac_dir}/divbox_cover_fract_yr_lunit.nc ${ctlfrac_dir}/divbox_cover_fract_yr_lunit_irri.nc   #Eyr
    DIVNC=${ctlfrac_dir}/divbox_cover_fract_yr_lunit_irri.nc
  fi

# COPY ALL MODEL OUTPUT FILES, MERGE AND CREATE DIFFERENCE FILES
cdo sub ${CMOR_VAR}_${SIM1}.nc ${CMOR_VAR}_${SIM2}.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc
#cdo yearmonmean ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_new.nc
#at some point espacially tile=3 {CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_new.nc=0 as a result{CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc=0
cdo mul -selname,${CMOR_VAR} ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc ${DIVNC} \
${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}.nc
cdo ifthen ${DIVNC} ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}.nc \
${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_t1.nc
#cdo setmisstoc,0 ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_new.nc \
#${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc

#cp ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc
#NC_FILE=${SCRATCH}/${SCENARIO_COMBNATION}/${CMOR_TABLE}/${CMOR_VAR}/${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}.nc
NC_FILE=${SCRATCH}/${SCENARIO_COMBNATION}/${CMOR_TABLE}/${CMOR_VAR}/${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_${CMOR_TABLE}_t1.nc

echo "Calculate signal separation for variable ${CMOR_VAR} in file ${NC_FILE}"
python /home/b/b380949/separation/nonlocalrevised_org.py ${NC_FILE} ${CMOR_VAR}

#cdo setrtomiss,5e+19,2e+20 -selname,${CMOR_VAR}_nonlocal ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal.nc ${CMOR_VAR}_${SIM1}-${SIM2}_${MODEL}_signal-separated_nonlocal_new.nc

done

