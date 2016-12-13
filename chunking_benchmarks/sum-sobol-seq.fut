-- ==
-- compiled input @ sum-sobol.in
-- output @ sum-sobol.out

include sum_sobol_lib

default (f32)

fun main (k: int, dir_v: [n]int): f32 =
  let sobol_nums = sobol_chunk dir_v 0 k
  in reduce (+) 0.0 sobol_nums
