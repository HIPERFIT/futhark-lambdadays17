RODINIA_URL=http://www.cs.virginia.edu/~kw5na/lava/Rodinia/Packages/Current/rodinia_3.1.tar.bz2
RODINIA_MD5=047d983e62107972f217921aa0027b05  rodinia_3.1.tar.bz2

# Parboil insists on some click-through license, so you'll have to get
# it on your own.
PARBOIL_LOCATION=$(HOME)/parboil

RUNS=10

RODINIA_BENCHMARKS=srad hotspot nn backprop cfd kmeans lavaMD pathfinder myocyte
ACCELERATE_BENCHMARKS=fluid mandelbrot nbody crystal
FINPAR_BENCHMARKS=LocVolCalib_small LocVolCalib_medium LocVolCalib_large OptionPricing_small OptionPricing_medium OptionPricing_large
PARBOIL_BENCHMARKS=mri-q tpacf sgemm

.SECONDARY:

all: benchmark_rodinia benchmark_accelerate benchmark_finpar benchmark_parboil

benchmark_rodinia: $(RODINIA_BENCHMARKS:%=runtimes/%.speedup)

benchmark_accelerate: $(ACCELERATE_BENCHMARKS:%=runtimes/%.speedup)

benchmark_finpar: $(FINPAR_BENCHMARKS:%=runtimes/%.speedup)

benchmark_parboil: $(PARBOIL_BENCHMARKS:%=runtimes/%.speedup)

speedup.pdf: benchmark_rodinia benchmark_accelerate benchmark_finpar benchmark_parboil
	python tools/plot.py $@

runtimes.tex: benchmark_rodinia benchmark_accelerate benchmark_finpar benchmark_parboil
	python tools/table.py > $@ || rm -f $@

runtimes/%.speedup: runtimes/%-futhark.avgtime runtimes/%-rodinia.avgtime
	@echo "scale=2; $(shell cat runtimes/$*-rodinia.avgtime) / $(shell cat runtimes/$*-futhark.avgtime)" | bc > $@

runtimes/%.speedup: runtimes/%-futhark.avgtime runtimes/%-accelerate.avgtime
	@echo "scale=2; $(shell cat runtimes/$*-accelerate.avgtime) / $(shell cat runtimes/$*-futhark.avgtime)" | bc > $@

runtimes/%.speedup: runtimes/%-futhark.avgtime runtimes/%-finpar.avgtime
	@echo "scale=2; $(shell cat runtimes/$*-finpar.avgtime) / $(shell cat runtimes/$*-futhark.avgtime)" | bc > $@

runtimes/%.speedup: runtimes/%-futhark.avgtime runtimes/%-parboil.avgtime
	@echo "scale=2; $(shell cat runtimes/$*-parboil.avgtime) / $(shell cat runtimes/$*-futhark.avgtime)" | bc > $@


runtimes/%.avgtime: runtimes/%.runtimes
	@awk '{sum += strtonum($$0) / 1000.0} END{print sum/NR}' < $< > $@

runtimes/%-accelerate.avgtime: runtimes/%-accelerate.csv
	@tail -n 1 $< | cut -d',' -f2 | awk '{print $$1*1000}' > $@

runtimes/srad-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/srad && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/srad/runtimes $@

runtimes/srad-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/srad/srad.fut
	$</rodinia/srad/srad -r $(RUNS) -t $@ < $</rodinia/srad/data/image.in > /dev/null

runtimes/hotspot-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/hotspot && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/hotspot/runtimes $@

runtimes/hotspot-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/hotspot/hotspot.fut
	$</rodinia/hotspot/hotspot -r $(RUNS) -t $@ < $</rodinia/hotspot/data/1024.in > /dev/null

runtimes/nn-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/nn && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/nn/runtimes $@

runtimes/nn-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/nn/nn.fut
	$</rodinia/nn/nn -r $(RUNS) -t $@ < $</rodinia/nn/data/medium.in > /dev/null

runtimes/backprop-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/backprop && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/backprop/runtimes $@

runtimes/backprop-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/backprop/backprop.fut
	$</rodinia/backprop/backprop -r $(RUNS) -t $@ < $</rodinia/backprop/data/medium.in > /dev/null

runtimes/cfd-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/cfd && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/cfd/runtimes $@

runtimes/cfd-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/cfd/cfd.fut
	$</rodinia/cfd/cfd -r $(RUNS) -t $@ < $</rodinia/cfd/data/fvcorr.domn.193K.toa > /dev/null

runtimes/kmeans-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/kmeans && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/kmeans/runtimes $@

runtimes/kmeans-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/kmeans/kmeans.fut
	$</rodinia/kmeans/kmeans -r $(RUNS) -t $@ < $</rodinia/kmeans/data/kdd_cup.in > /dev/null

runtimes/lavaMD-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/lavaMD && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/lavaMD/runtimes $@

runtimes/lavaMD-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/lavaMD/lavaMD.fut
	$</rodinia/lavaMD/lavaMD -r $(RUNS) -t $@ < $</rodinia/lavaMD/data/10_boxes.in > /dev/null

runtimes/pathfinder-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</opencl/pathfinder && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</opencl/pathfinder/runtimes $@

runtimes/pathfinder-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/pathfinder/pathfinder.fut
	$</rodinia/pathfinder/pathfinder -r $(RUNS) -t $@ < $</rodinia/pathfinder/data/medium.in > /dev/null

# Myocyte uses the CUDA version, because the OpenCL one does not
# support the workload>1 case efficiently.
runtimes/myocyte-rodinia.runtimes: rodinia_3.1-patched
	@mkdir -p runtimes
	(cd $</cuda/myocyte && make clean && make && RODINIA_RUNS=$(RUNS) ./run)
	cp $</cuda/myocyte/runtimes $@

runtimes/myocyte-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl $</rodinia/myocyte/myocyte.fut
	$</rodinia/myocyte/myocyte -r $(RUNS) -t $@ < $</rodinia/myocyte/data/medium.in > /dev/null

# Accelerate uses its own internal benchmarking and computes its own
# averages.  Hack: Some of these benchmarks terminate incorrectly with
# 'Not a valid Unicode code point!', so we ignore their exit code.

# The following constants define the work size for fluid.
FLUID_N_STEPS=1
FLUID_RESOLUTION=3000 # ends up squared
FLUID_N_SOLVER_STEPS=20
runtimes/fluid-accelerate.csv:
	@mkdir -p runtimes
	accelerate-fluid --cuda --benchmark --csv=$@ \
	--iterations=$(FLUID_N_SOLVER_STEPS) \
	--width=$(FLUID_RESOLUTION) \
	--height=$(FLUID_RESOLUTION) || true

input/fluid.input:
	@mkdir -p input
	futhark-benchmarks/accelerate/fluid/fluid-generate-random-input.py \
	$(FLUID_N_STEPS) $(FLUID_RESOLUTION) $(FLUID_N_SOLVER_STEPS) futhark none > $@

runtimes/fluid-futhark.runtimes: futhark-benchmarks input/fluid.input
	@mkdir -p runtimes
	futhark-opencl futhark-benchmarks/accelerate/fluid/src-futhark/fluid-benchmark.fut
	futhark-benchmarks/accelerate/fluid/src-futhark/fluid-benchmark -r $(RUNS) -t $@ < input/fluid.input > /dev/null

MANDELBROT_RESOLUTION=4000
MANDELBROT_LIMIT=255
runtimes/mandelbrot-accelerate.csv:
	@mkdir -p runtimes
	accelerate-mandelbrot --cuda --benchmark --csv=$@ \
	--width $(MANDELBROT_RESOLUTION) --height $(MANDELBROT_RESOLUTION) --limit $(MANDELBROT_LIMIT) || true

runtimes/mandelbrot-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl futhark-benchmarks/accelerate/mandelbrot/mandelbrot.fut
	echo $(MANDELBROT_RESOLUTION) $(MANDELBROT_RESOLUTION) $(MANDELBROT_LIMIT) -2.23 -1.15 0.83 1.15 | \
	  futhark-benchmarks/accelerate/mandelbrot/mandelbrot -r $(RUNS) -t $@ > /dev/null

NBODY_N=100000
runtimes/nbody-accelerate.csv:
	@mkdir -p runtimes
	accelerate-nbody --cuda --benchmark -n $(NBODY_N) --csv=$@ || true

runtimes/nbody-futhark.runtimes: futhark-benchmarks
	@mkdir -p runtimes
	futhark-opencl futhark-benchmarks/accelerate/nbody/nbody.fut
	cat futhark-benchmarks/accelerate/nbody/nbody-n_steps=1-n_bodies=$(NBODY_N)-timestep=1.0-epsilon=50.0.in | \
	  futhark-benchmarks/accelerate/nbody/nbody -r $(RUNS) -t $@ > /dev/null

CRYSTAL_SIZE=2000
CRYSTAL_DEGREE=50
runtimes/crystal-accelerate.csv:
	@mkdir -p runtimes
	accelerate-crystal --cuda --benchmark --size $(CRYSTAL_SIZE) --degree $(CRYSTAL_DEGREE) --csv=$@ || true

runtimes/crystal-futhark.runtimes: futhark-benchmarks
	futhark-opencl futhark-benchmarks/accelerate/crystal/crystal.fut
	echo $(CRYSTAL_SIZE) 30.0 $(CRYSTAL_DEGREE) 1 1.0 | \
	  futhark-benchmarks/accelerate/crystal/crystal -r $(RUNS) -t $@ > /dev/null

runtimes/LocVolCalib_%-finpar.runtimes: finpar
	@mkdir -p runtimes
	(cd finpar/LocVolCalib/OutParOpenCLMP; \
	 make; \
	 for i in `seq $(RUNS)`; do make run_$* | grep Runtime | cut -f1; done > ../../../$@)

futhark-benchmarks/finpar/LocVolCalib: futhark-benchmarks
	futhark-opencl futhark-benchmarks/finpar/LocVolCalib.fut

runtimes/LocVolCalib_%-futhark.runtimes: futhark-benchmarks/finpar/LocVolCalib
	@mkdir -p runtimes
	cat futhark-benchmarks/finpar/LocVolCalib-data/$*.in | \
	 futhark-benchmarks/finpar/LocVolCalib -r $(RUNS) -t $@ > /dev/null

runtimes/OptionPricing_%-finpar.runtimes: finpar
	@mkdir -p runtimes
	(cd finpar/OptionPricing/CppOpenCL; \
	 make; \
	 for i in `seq $(RUNS)`; do make run_$* | grep Runtime | cut -f1; done > ../../../$@)

futhark-benchmarks/finpar/OptionPricing: futhark-benchmarks
	futhark-opencl futhark-benchmarks/finpar/OptionPricing.fut

runtimes/OptionPricing_%-futhark.runtimes: futhark-benchmarks/finpar/OptionPricing
	@mkdir -p runtimes
	cat futhark-benchmarks/finpar/OptionPricing-data/$*.in | \
	 futhark-benchmarks/finpar/OptionPricing -r $(RUNS) -t $@ > /dev/null

runtimes/mri-q-parboil.runtimes:
	@mkdir -p runtimes
	(cd $(PARBOIL_LOCATION); \
	for i in `seq $(RUNS)`; do \
	 ./parboil run mri-q opencl large | awk '/^Kernel/{print int($$3*1000000)}'; \
        done) > $@

runtimes/mri-q-futhark.runtimes:
	@mkdir -p runtimes
	futhark-opencl futhark-benchmarks/parboil/mri-q/mri-q.fut
	cat futhark-benchmarks/parboil/mri-q/data/large.in | futhark-benchmarks/parboil/mri-q/mri-q -r $(RUNS) -t $@ > /dev/null

runtimes/sgemm-parboil.runtimes:
	@mkdir -p runtimes
	(cd $(PARBOIL_LOCATION); \
	for i in `seq $(RUNS)`; do \
	 ./parboil run sgemm opencl_nvidia medium | awk '/^Kernel/{print int($$3*1000000)}'; \
        done) > $@

runtimes/sgemm-futhark.runtimes:
	@mkdir -p runtimes
	futhark-opencl futhark-benchmarks/parboil/sgemm/sgemm.fut
	cat futhark-benchmarks/parboil/sgemm/data/medium.in | futhark-benchmarks/parboil/sgemm/sgemm -r $(RUNS) -t $@ > /dev/null

runtimes/tpacf-parboil.runtimes:
	@mkdir -p runtimes
	(cd $(PARBOIL_LOCATION); \
	for i in `seq $(RUNS)`; do \
	 ./parboil run tpacf opencl_base large | awk '/^Kernel/{print int($$3*1000000)}'; \
        done) > $@

runtimes/tpacf-futhark.runtimes:
	@mkdir -p runtimes
	futhark-opencl futhark-benchmarks/parboil/tpacf/tpacf.fut
	cat futhark-benchmarks/parboil/tpacf/data/large.in | futhark-benchmarks/parboil/tpacf/tpacf -r $(RUNS) -t $@ > /dev/null


futhark-benchmarks:
	git clone --depth 1 https://github.com/HIPERFIT/futhark-benchmarks.git

finpar:
	git clone https://github.com/HIPERFIT/finpar.git

rodinia_3.1-patched: rodinia_3.1.tar.bz2
	@if ! md5sum --quiet -c rodinia_3.1.tar.bz2.md5; then \
          echo "Your rodinia_3.1.tar.bz2 has the wrong MD5-sum - delete it and try again."; exit 1; fi
	tar jxf rodinia_3.1.tar.bz2
	mv rodinia_3.1 rodinia_3.1-patched
	patch -p0 < rodinia_3.1-some-instrumentation.patch

rodinia_3.1.tar.bz2:
	wget http://www.cs.virginia.edu/~kw5na/lava/Rodinia/Packages/Current/rodinia_3.1.tar.bz2

clean:
	rm -rf rodinia_3.1
	rm -f rodinia_3.1.tar.bz2
	rm -rf futhark-benchmarks
	rm -rf runtimes
	rm -rf input
