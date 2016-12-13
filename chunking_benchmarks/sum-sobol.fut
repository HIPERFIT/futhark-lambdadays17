-- ==
-- compiled input @ sum-sobol.in
-- output @ sum-sobol.out

include sum_sobol_lib

default (f32)

fun sobol_ind_r(dir_v: [n]int) (x: int): f32 =
  let divisor = 2.0 ** f32 n
  in f32 (sobol_ind dir_v x) / divisor

fun main (k: int) (dir_v: [n]int): f32 =
  let sobol_nums = map  (sobol_ind_r dir_v) (map (+1) (iota k))
  in reduceComm (+) 0.0 sobol_nums
