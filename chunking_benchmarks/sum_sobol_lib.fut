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
