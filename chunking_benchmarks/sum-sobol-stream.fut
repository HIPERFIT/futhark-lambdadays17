-- ==
-- compiled input @ sum-sobol.in
-- output @ sum-sobol.out

include sum_sobol_lib

default (f32)

fun index_of_least_significant_0 (x: int): int =
  loop (i = 0) =
    while i < 32 && ((x>>i)&1) != 0 do
      i + 1
  in i

fun rec_m (dir_v: [n]int) (i: int): int =
  let bit = index_of_least_significant_0 i
  in unsafe dir_v[bit]

fun sobol_chunk (dir_v: [n]int) (x: int) (chunk: int): [chunk]f32 =
  let divisor = 2.0 ** f32 n
  let sob_beg = sobol_ind dir_v (x+1)
  let contrbs = map (fn i =>
                        if i==0 then sob_beg
                        else rec_m dir_v (i+x))
                    (iota chunk)
  let vct_ints= scan (^) 0 contrbs
  in map (fn y => f32 y / divisor) vct_ints

fun main (k: int,
          dir_v: [n]int): f32 =
  let sobol_nums = streamMap (fn (xs: [chunk]int): [chunk]f32  =>
                                sobol_chunk dir_v xs[0] chunk)
                             (iota k)
  in reduce (+) 0.0 sobol_nums
