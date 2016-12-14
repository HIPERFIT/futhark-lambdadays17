#!/bin/sh

set -e

if ! [ -f cluster-means.in ]; then
    echo "Generating cluster_means.in (this may take a while)..."
    futhark-dataset --i32-bounds 2000000:2000000 -g [5]int -g [10000000][3]f32 --i32-bounds 0:4 -g [10000000]int > cluster-means.in
fi

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
