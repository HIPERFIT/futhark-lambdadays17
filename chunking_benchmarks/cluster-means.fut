-- ==
-- compiled input @ cluster-means.in
-- output @ cluster-means.out

include cluster_means_lib

default (f32)

fun main(cluster_sizes: [k]int) (points: [n][d]f32) (membership: [n]int): [k][d]f32 =
  let increments = map (fn p c =>
                          unsafe
                          let a = replicate k (replicate d 0.0)
                          let a[c] = map (/(f32(cluster_sizes[c]))) p
                          in a)
                       points membership
  in map (fn x => map (fn y => reduce (+) 0.0 y) x) (rearrange (1,2,0) increments)
