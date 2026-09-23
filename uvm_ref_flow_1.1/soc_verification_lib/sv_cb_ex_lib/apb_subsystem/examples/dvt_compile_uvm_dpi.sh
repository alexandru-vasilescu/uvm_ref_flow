#!/bin/sh

GCC=gcc
PROJECT_LOC=$1
LIB_NAME=uvm_dpi
LIB_DIR=$PROJECT_LOC/soc_verification_lib/sv_cb_ex_lib/apb_subsystem/bin
UVM_HOME=$DVT_HOME/predefined_projects/libs/uvm-1.1b

args=("$@")
argCount=${#args[@]}

if (( argCount < 2 )); then
	exit -1
fi

GCC_ARGUMENTS=("${args[@]:1:argCount-1}")

mkdir -p $LIB_DIR

COMMAND="$GCC \
$GCC_ARGUMENTS \
$UVM_HOME/src/dpi/uvm_dpi.cc \
-g \
-W \
-I $DVT_HOME/predefined_projects/libs/IEEE_1364-2001/include \
-I $DVT_HOME/predefined_projects/libs/IEEE_1800-2012/include \
-shared \
-o $LIB_DIR/$LIB_NAME.so"

echo Executing: $COMMAND

$COMMAND
