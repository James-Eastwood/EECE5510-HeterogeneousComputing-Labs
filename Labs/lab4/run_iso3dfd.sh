#!/bin/bash
source /opt/intel/inteloneapi/setvars.sh > /dev/null 2>&1

icpx -fsycl src/iso3dfd.cpp src/utils.cpp src/iso3dfd_kernels.cpp -o iso3dfd

#TODO: EECE.5510
#TODO: uncomment the following to use shared local memory in the kernel function
#TODO: build and then run vtune again to observe the difference in performance profiling results
icpx -fsycl -DUSE_SHARED src/iso3dfd.cpp src/utils.cpp src/iso3dfd_kernels.cpp -o iso3dfd

./iso3dfd 256 256 256 8 8 8 20 sycl gpu

