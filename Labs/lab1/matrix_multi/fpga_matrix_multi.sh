# Initial Setup
source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t A10DS

cd ~/EECE5510-HeterogeneousComputing-Labs/Labs/lab1/matrix_multi

printf "\\n%s\\n" "================================================================================"
printf "\\n%s\\n" "Running in Emulation Mode"
printf "\\n%s\\n" "================================================================================"

aoc -march=emulator -v device/matrix_multi.cl -o bin/matrix_multi_emulation.aocx
ln -sf matrix_multi_emulation.aocx bin/matrix_multi.aocx
make
error_check

./bin/host -emulator

printf "\\n%s\\n" "================================================================================"
printf "\\n%s\\n" "Running in FPGA Mode"
printf "\\n%s\\n" "================================================================================"

# Check Arria 10 PAC card connectivity
aocl diagnose
error_check

# Compiling OpenCL code for FPGA
aoc device/matrix_multi.cl -o bin/matrix_multi_fpga.aocx -board=pac_a10

# Relink to hardware .aocx
ln -sf matrix_multi_fpga.aocx bin/matrix_multi.aocx
# Availavility of Acceleration cards
aoc -list-boards
error_check
# Get device name
aocl diagnose
error_check

# Converting to an unsigned .aocx file
cd bin
printf "\\n%s\\n" "Converting to unsigned .aocx:"
printf "Y\\nY\\n" | source $AOCL_BOARD_PACKAGE_ROOT/linux64/libexec/sign_aocx.sh -H openssl_manager -i matrix_multi_fpga.aocx -r NULL -k NULL -o matrix_multi_fpga_unsigned.aocx
error_check

# 3.6 Programming the Arria 10 GX PAC Card
aocl program acl0 matrix_multi_fpga_unsigned.aocx

printf "\\n%s\\n" "================================================================================"
ls
pwd

# 3.7 Running the host code
./host
error_check