# ------------------------------------
#
# ------------------------------------

global env

# setup environment
do ../../../scripts/sim_env.do
set env(SIM_TARGET) fpga

radix -hexadecimal

make_lib work 1

sim_compile_lib $env(LIB_BASE_DIR) tb_packages
sim_compile_lib $env(LIB_BASE_DIR) bfm_packages
sim_compile_lib $env(LIB_BASE_DIR) qaz_lib
sim_compile_lib $env(LIB_BASE_DIR) sim

vlog -f ./files.f

# run the sim
sim_run_test


