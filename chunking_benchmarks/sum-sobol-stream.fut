-- ==
-- compiled input @ sum-sobol.in
-- output @ sum-sobol.out

include sum_sobol_lib

default (f32)

fun main (k: int,
          dir_v: [n]int): f32 =
  let sobol_nums = streamMap (fn (xs: [chunk]int): [chunk]f32  =>
                                sobol_chunk dir_v xs[0] chunk)
                             (iota k)
  in reduce (+) 0.0 sobol_nums
