#!/bin/sh

set -e

echo "Executing sequentially"
echo "----------------------"
futhark-bench sum-sobol-seq.fut
futhark-bench sum-sobol-stream.fut
futhark-bench cluster-means-seq.fut
futhark-bench cluster-means-stream.fut
echo

echo "Executing parallelly"
echo "--------------------"
futhark-bench --compiler=futhark-opencl sum-sobol.fut
futhark-bench --compiler=futhark-opencl sum-sobol-stream.fut
futhark-bench --compiler=futhark-opencl cluster-means.fut
futhark-bench --compiler=futhark-opencl cluster-means-stream.fut
echo
