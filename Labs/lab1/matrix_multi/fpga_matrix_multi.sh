# Initial Setup
source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t A10DS

# Check Arria 10 PAC card connectivity
aocl diagnose
error_check

# Compiling OpenCL code for FPGA
# cd ~/EECE5510-HeterogeneousComputing-Labs/Labs/lab1/matrix_multi/fpga_matrix_multi.sh
aoc device/matrix_multi.cl -o bin/matrix_multi_fpga.aocx -board=pac_a10

# 3.4 Converting the 1.2.1 version of .aocx to an unsigned .aocx file
cd bin
yes | source $AOCL_BOARD_PACKAGE_ROOT/linux64/libexec/sign_aocx.sh -H openssl_manager -i matrix_multi_fpga.aocx -r NULL -k NULL -o matrix_multi_fpga_unsigned.aocx
error_check

# 3.6 Programming the Arria 10 GX PAC Card
aocl program acl0 matrix_multi_fpga_unsigned.aocx

# 3.7 Running the host code
make
./host
error_check