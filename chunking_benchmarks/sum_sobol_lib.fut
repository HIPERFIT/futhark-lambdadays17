-- ==
-- tags { nobench }

default (f32)

fun gray_code (x: int): int = (x >> 1) ^ x

fun test_bit (x: int) (ind: int): bool =
  let t = (1 << ind) in (x & t) == t

fun sobol_ind (dir_v: [n]int) (x: int): int =
  let reldv_vals =
    map (fn dv i =>
           if test_bit (gray_code x) i
           then dv else 0)
        dir_v (iota n)
  in reduce (^) 0 reldv_vals

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
