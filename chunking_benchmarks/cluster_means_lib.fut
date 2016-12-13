-- ==
-- tags { nobench }

default (f32)

fun cluster_sums_acc (acc: *[k][d]f32) (cluster_sizes: [k]int)
                     (points: [n][d]f32) (membership: [n]int): *[k][d]f32 =
  loop (acc) = for i < n do
    unsafe
    let p = points[i]
    let c = membership[i]
    let p' = map (/f32(unsafe cluster_sizes[c])) p
    let acc[c] = add_centroids acc[c] p'
    in acc
  in acc

fun cluster_sums_seq(cluster_sizes: [k]int) (points: [n][d]f32) (membership: [n]int): *[k][d]f32 =
  cluster_sums_acc (replicate k (replicate d 0.0)) cluster_sizes points membership

fun add_centroids(x: [d]f32) (y: [d]f32): *[d]f32 =
  map (+) x y
