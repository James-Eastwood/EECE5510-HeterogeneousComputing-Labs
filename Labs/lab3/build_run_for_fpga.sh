# Initial Setup
source /data/intel_fpga/devcloudLoginToolSetup.sh
tools_setup -t A10DS

cd ~/EECE5510-HeterogeneousComputing-Labs/Labs/lab3/MonteCarloPi/build

printf "\\n%s\\n" "================================================================================"
printf "\\n%s\\n" "Building and running for fpga"
printf "\\n%s\\n" "================================================================================"

make run