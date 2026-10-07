#!/bin/bash
#---------------Script SBATCH - NLHPC ----------------
#SBATCH --job-name="relax_2dm"
#SBATCH --partition="main"
#SBATCH -n 20
#SBATCH --ntasks-per-node=20
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=72:00:00
#SBATCH --array=1-81%10
#SBATCH -o array_%A_%a.out
#SBATCH -e array_%A_%a.err

#-----------------Toolchain---------------------------
module purge
ml intel/2018.04
# ----------------Modulos----------------------------
ml VASP/5.4.4

# ----------------Variables de Entorno---------------
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export LC_ALL=C

EXEC=vasp_std
BINVASP="${EXEC}"

# ----------------Comandos--------------------------
# 1. Identificar la carpeta correspondiente a esta tarea del array
# Usamos ls -d para listar solo directorios y sed para sacar la línea exacta
folder=$(ls -d 2dm-* | sed -n ${SLURM_ARRAY_TASK_ID}p)

# 2. Entrar a la carpeta (si falla, el script se detiene)
cd "$folder" || exit 1

# 3. Ejecutar los comandos de VASP (no es necesario script individual)
srun $BINVASP

cp POSCAR POSCAR-1
cp OUTCAR OUTCAR-1
cp CONTCAR CONTCAR-1
rm OUTCAR
rm POSCAR
mv CONTCAR POSCAR

srun $BINVASP

cp OUTCAR OUTCAR-2
cp CONTCAR CONTCAR-2
rm CHG WAVECAR PCDAT XDATCAR REPORT
