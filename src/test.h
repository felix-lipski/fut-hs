#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <stdio.h>
#include <float.h>

#define CL_TARGET_OPENCL_VERSION 120
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#ifdef __APPLE__
#define CL_SILENCE_DEPRECATION
#include <OpenCL/cl.h>
#else
#include <CL/cl.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif


int entry_id_c(int32_t *out, int32_t *in);

int entry_times_two_c(int32_t *out, int32_t *in);
