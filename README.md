Parallelization

###Purpose
To measure performance impacts from parallelization techniques

###To Build
```make
This creates two binaries: mm-omp and mm-simd

###Measurements
You can measure the runtime using:
    perf stat ./mm-omp > myout1
    perf stat ./mm-simd > myout2



