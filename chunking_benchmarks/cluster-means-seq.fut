-- ==
-- compiled input @ cluster-means.in
-- output @ cluster-means.out

include cluster_means_lib

default (f32)

fun main(cluster_sizes: [k]int) (points: [n][d]f32) (membership: [n]int): [k][d]f32 =
  cluster_sums_seq cluster_sizes points membership
