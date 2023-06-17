//==============================================================
// Copyright © Intel Corporation
//
// SPDX-License-Identifier: MIT
// =============================================================
#include <sycl/sycl.hpp>
using namespace sycl;

static constexpr size_t N = 1024; // global size
static constexpr size_t B = 256;  // work-group size
static constexpr size_t S = 32;  // sub-group size

int main() {
  queue q;
  std::cout << "Device : " << q.get_device().get_info<info::device::name>() << "\n";

  //# allocate USM shared allocation for input data array and sg_data array
  int *data = malloc_shared<int>(N, q);
  int *sg_data = malloc_shared<int>(N/S, q);
    
  //# initialize input data array
  for (int i = 0; i < N; i++) data[i] = i;
  for (int i = 0; i < N; i++) std::cout << data[i] << " ";
  std::cout << "\n\n";

  //# Kernel task to compute sub-group sum and save to sg_data array
    
  //# STEP 1 : set fixed sub_group size of value S in the kernel below (Complete)
  q.parallel_for(nd_range<1>(N, B), [=](nd_item<1> item)[[intel::reqd_sub_group_size(S)]] {
    auto sg = item.get_sub_group();
    auto i = item.get_global_id(0);

    //# STEP 2: Add all elements in sub_group using sub_group reduce (Complete)
      int result = reduce_over_group(sg, data[i], plus<>());

    //# write sub_group sum in first location for each sub_group
    if (sg.get_local_id()[0] == 0) 
    {
      int idx = (item.get_group(0) * (B/S)) + sg.get_group_id();
      sg_data[idx] = result;
    }      
  }).wait();

  //# print sg_data array
  for (int i = 0; i < N/S; i++) std::cout << sg_data[i] << " ";
  std::cout << "\n";
    
  //# STEP 4: compute sum of all elements in sg_data array
  int sum = 0;
  for (int i = 0; i < (N/S); i++)
  {
      sum += sg_data[i];
  }

  std::cout << "\nSum = " << sum << "\n";
  
  //# free USM allocations
  free(data, q);
  free(sg_data, q);

  return 0;
}
