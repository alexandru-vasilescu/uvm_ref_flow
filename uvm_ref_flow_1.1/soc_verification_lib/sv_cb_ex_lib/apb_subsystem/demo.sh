#!/bin/sh -e
#
# Script for running the UVM SystemVerilog Cluster Level demo
# 
# (See the usage message below for options)
#
# =============================================================================
#   Copyright 1999-2010 Cadence Design Systems, Inc.
#   All Rights Reserved Worldwide
#
#   Licensed under the Apache License, Version 2.0 (the
#   "License"); you may not use this file except in
#   compliance with the License.  You may obtain a copy of
#   the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in
#   writing, software distributed under the License is
#   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied.  See
#   the License for the specific language governing
#   permissions and limitations under the License.
# =============================================================================


if [ ! -n "$UVM_REF_HOME" ]; then
   echo "UVM_REF_HOME is not set."
   echo "Please set it to your installation"
   exit
fi

if [ ! -n "$UVM_HOME" ]; then
   echo "UVM_HOME is not set."
   echo "Please set it to your UVM Library installation "
   echo "Please refer $UVM_REF_HOME/README.txt for Installation "
   exit
fi

usage() {
    echo "Usage:  demo.sh [-test <test_name>]"
    echo "                [-seed <value>]"
    echo "                [-v[erbosity] <verbosity>]"
    echo "                [-r[un_mode]  { test | test_gui }]"
    echo "                [-generate_wave]"
    echo "                [-log  { console | file }]"
    echo ""
    echo "        demo.sh -h[elp]"
    echo ""
    echo "Where:"
    echo "  <verbosity> is one of: { NONE | LOW | MEDIUM | HIGH | FULL }"
    echo "  <test_name> is one of the classes defined in: `/bin/ls $UVM_REF_HOME/soc_verification_lib/sv_cb_ex_lib/apb_subsystem/tb/tests` "
   
}

# =============================================================================
# Get args
# =============================================================================
test="";
gui="";
seed="";
run_mode="test";
severity="";
verbosity="";
cov_enabled=1;
cov_commands="";
log_mode="console";
generate_wave=0;
while [ $# -gt 0 ]; do
   case `echo $1 | tr "[A-Z]" "[a-z]"` in
      -h|-help)
                        usage
                        exit 1
                        ;;
      -test)
                        test=" TEST_NAME=$2"
                        shift
                        ;;
      -seed)
                        seed=" SVSEED=$2"
                        shift
                        ;;
      -r|-run_mode)
                        run_mode=$2
                        shift
                        ;;
      -v|-verbosity)
                        verbosity=" VERBOSITY=$2"
                        shift
                        ;;
      -log)
                        log_mode=$2
                        shift
                        ;;
      -generate_wave)
                        generate_wave=1
                        ;;
     esac
    shift       
done

# =============================================================================
# Handle run mode mutual exclusivity
# =============================================================================
if [ "$generate_wave" = "1" ] && [ "$run_mode" = "test" ]; then
   run_mode="test_wave"
fi

# =============================================================================
# Setup log redirection
# =============================================================================
LOG_FILE=""
if [ "$log_mode" = "file" ]; then
   LOG_DIR="${UVM_REF_HOME}/dvt_log"
   mkdir -p "$LOG_DIR"
   # Extract test name from TEST_NAME= if set, otherwise use "simulation"
   CURRENT_TEST=$(echo $test | sed 's/TEST_NAME=//')
   if [ -z "$CURRENT_TEST" ]; then
      CURRENT_TEST="simulation"
   fi
   LOG_FILE="${LOG_DIR}/${CURRENT_TEST}.log"
fi

# =============================================================================
# Run simulation
# =============================================================================
if [ "$run_mode" = "test_wave" ]; then
   CURRENT_TEST=$(echo $test | sed 's/TEST_NAME=//')
   if [ -z "$CURRENT_TEST" ]; then
      CURRENT_TEST="simulation"
   fi
   WAVE_DIR="${UVM_REF_HOME}/dvt_waveform/${CURRENT_TEST}"
   mkdir -p "$WAVE_DIR"
   export TEST_NAME="$CURRENT_TEST"
fi

if [ -n "$LOG_FILE" ]; then
   gmake -f ${UVM_REF_HOME}/soc_verification_lib/sv_cb_ex_lib/apb_subsystem/tb/scripts/Makefile $seed $run_mode $verbosity $test BITS=$(uname -a | grep -q x86_64 && echo 64 || echo 32) > "$LOG_FILE" 2>&1
   echo "Log generated at: $LOG_FILE"
else
   gmake -f ${UVM_REF_HOME}/soc_verification_lib/sv_cb_ex_lib/apb_subsystem/tb/scripts/Makefile $seed $run_mode $verbosity $test BITS=$(uname -a | grep -q x86_64 && echo 64 || echo 32)
fi

if [ "$run_mode" = "test_wave" ]; then
   echo "Waveform generated at: $WAVE_DIR/waves.shm"
fi
